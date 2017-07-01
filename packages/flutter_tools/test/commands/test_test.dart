// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;

import 'package:flutter_tools/src/base/file_system.dart';
import 'package:flutter_tools/src/base/io.dart';
import 'package:flutter_tools/src/cache.dart';
import 'package:flutter_tools/src/dart/sdk.dart';
import 'package:test/test.dart';

import '../src/context.dart';

// This test depends on some files in ///dev/automated_tests/flutter_test/*

Future<Null> _testExclusionLock;

void main() {
  group('flutter test should', () {

    final String automatedTestsDirectory = fs.path.join('..', '..', 'dev', 'automated_tests');
    final String flutterTestDirectory = fs.path.join(automatedTestsDirectory, 'flutter_test');

    testUsingContext('report nice errors for exceptions thrown within testWidgets()', () async {
      Cache.flutterRoot = '../..';
      return _testFile('exception_handling', automatedTestsDirectory, flutterTestDirectory);
    });

    testUsingContext('report a nice error when a guarded function was called without await', () async {
      Cache.flutterRoot = '../..';
      return _testFile('test_async_utils_guarded', automatedTestsDirectory, flutterTestDirectory);
    });

    testUsingContext('report a nice error when an async function was called without await', () async {
      Cache.flutterRoot = '../..';
      return _testFile('test_async_utils_unguarded', automatedTestsDirectory, flutterTestDirectory);
    });

    testUsingContext('report a nice error when a pubspec.yaml is missing a flutter_test dependency', () async {
      final String missingDependencyTests = fs.path.join('..', '..', 'dev', 'missing_dependency_tests');
      Cache.flutterRoot = '../..';
      return _testFile('trivial', missingDependencyTests, missingDependencyTests);
    });

    testUsingContext('run a test when its name matches a regexp', () async {
      Cache.flutterRoot = '../..';
      final ProcessResult result = await _runFlutterTest('filtering', automatedTestsDirectory, flutterTestDirectory,
        extraArgs: const <String>["--name", "inc.*de"]);
      if (!result.stdout.contains("+1: All tests passed"))
        fail("unexpected output from test:\n\n${result.stdout}\n-- end stdout --\n\n");        
      expect(result.exitCode, 0);
    });

    testUsingContext('run a test when its name contains a string', () async {
      Cache.flutterRoot = '../..';
      final ProcessResult result = await _runFlutterTest('filtering', automatedTestsDirectory, flutterTestDirectory,
        extraArgs: const <String>["--plain-name", "include"]);
      if (!result.stdout.contains("+1: All tests passed"))
        fail("unexpected output from test:\n\n${result.stdout}\n-- end stdout --\n\n");        
      expect(result.exitCode, 0);
    });

  }, skip: io.Platform.isWindows); // TODO(goderbauer): enable when sky_shell is available
}

Future<Null> _testFile(String testName, String workingDirectory, String testDirectory) async {
  final String fullTestExpectation = fs.path.join(testDirectory, '${testName}_expectation.txt');
  final File expectationFile = fs.file(fullTestExpectation);
  if (!expectationFile.existsSync())
    fail("missing expectation file: $expectationFile");

  while (_testExclusionLock != null)
    await _testExclusionLock;

  final ProcessResult exec = await _runFlutterTest(testName, workingDirectory, testDirectory);

  expect(exec.exitCode, isNonZero);
  final List<String> output = exec.stdout.split('\n');
  if (output.first == 'Waiting for another flutter command to release the startup lock...')
    output.removeAt(0);
  output.add('<<stderr>>');
  output.addAll(exec.stderr.split('\n'));
  final List<String> expectations = fs.file(fullTestExpectation).readAsLinesSync();
  bool allowSkip = false;
  int expectationLineNumber = 0;
  int outputLineNumber = 0;
  bool haveSeenStdErrMarker = false;
  while (expectationLineNumber < expectations.length) {
    expect(output, hasLength(greaterThan(outputLineNumber)));
    final String expectationLine = expectations[expectationLineNumber];
    final String outputLine = output[outputLineNumber];
    if (expectationLine == '<<skip until matching line>>') {
      allowSkip = true;
      expectationLineNumber += 1;
      continue;
    }
    if (allowSkip) {
      if (!new RegExp(expectationLine).hasMatch(outputLine)) {
        outputLineNumber += 1;
        continue;
      }
      allowSkip = false;
    }
    if (expectationLine == '<<stderr>>') {
      expect(haveSeenStdErrMarker, isFalse);
      haveSeenStdErrMarker = true;
    }
    expect(outputLine, matches(expectationLine), reason: 'Full output:\n- - - -----8<----- - - -\n${output.join("\n")}\n- - - -----8<----- - - -');
    expectationLineNumber += 1;
    outputLineNumber += 1;
  }
  expect(allowSkip, isFalse);
  if (!haveSeenStdErrMarker)
    expect(exec.stderr, '');
}

Future<ProcessResult> _runFlutterTest(String testName, String workingDirectory, String testDirectory,
  {List<String> extraArgs = const <String>[]}) async {
    
  final String testFilePath = fs.path.join(testDirectory, '${testName}_test.dart');
  final File testFile = fs.file(testFilePath);
  if (!testFile.existsSync())
    fail("missing test file: $testFile");

  final List<String> args = <String>[
    fs.path.absolute(fs.path.join('bin', 'flutter_tools.dart')),
    'test',
    '--no-color'
  ]..addAll(extraArgs)..add(testFilePath);

  while (_testExclusionLock != null)
    await _testExclusionLock;

  final Completer<Null> testExclusionCompleter = new Completer<Null>();
  _testExclusionLock = testExclusionCompleter.future;
  try {
    return await Process.run(
      fs.path.join(dartSdkPath, 'bin', 'dart'),
      args,
      workingDirectory: workingDirectory,
    );
  } finally {
    _testExclusionLock = null;
    testExclusionCompleter.complete();
  }
}
