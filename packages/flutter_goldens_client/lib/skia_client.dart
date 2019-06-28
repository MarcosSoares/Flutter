// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as path;
import 'package:platform/platform.dart';

import 'package:flutter_goldens_client/client.dart';

// If you are here trying to figure out how to use golden files in the Flutter
// repo itself, consider reading this wiki page:
// https://github.com/flutter/flutter/wiki/Writing-a-golden-file-test-for-package%3Aflutter

// TODO(Piinks): This file will replace ./client.dart when transition to Skia
// Gold testing is complete
const String _kFlutterRootKey = 'FLUTTER_ROOT';
const String _kGoldctlKey = 'GOLDCTL';
const String _kServiceAccountKey = 'GOLD_SERVICE_ACCOUNT';

/// A class that represents the Skia Gold client for golden file testing.
class SkiaGoldClient {
  /// Creates a handle to a local workspace for the Skia Gold Client
  SkiaGoldClient({
    this.fs = const LocalFileSystem(),
    this.platform = const LocalPlatform(),
    //this.hasBeenAuthorized = false,
    // TODO(Piinks): just pre-authorize
  });

  /// The file system to use for storing local files for running image tests.
  ///
  /// This is useful in tests, where a local file system (the default) can be
  /// replaced by a memory file system.
  final FileSystem fs;

  /// A wrapper for the [dart:io.Platform] API.
  ///
  /// This is only for use in tests, where the system platform (the default) can
  /// be replaced by a mock platform instance.
  final Platform platform;

  /// The local [Directory] where the Flutter repository is hosted.
  ///
  /// Uses the [fs] file system.
  Directory get flutterRoot => fs.directory(platform.environment[_kFlutterRootKey]);

  /// The local [Directory] root of all image tests.
  ///
  /// Uses the [fs] file system.
  Directory get comparisonRoot => flutterRoot.childDirectory(fs.path.join('bin', 'cache', 'pkg', 'goldens'));

  /// The local [Directory] within the [comparisonRoot] for the current test
  /// context. In this directory, the client will create image and json files
  /// for the goldctl tool to use.
  ///
  /// This is provided by the [FlutterGoldenFileComparator] to the [auth]
  /// method. It cannot be null.
  Directory _workDirectory;

  /// The path to the local [Directory] where the goldctl tool is hosted.
  ///
  /// Uses the [platform] environment in this iteration.
  String get _goldctl => platform.environment[_kGoldctlKey];

  /// The path to the local [Directory] where the service account key is
  /// hosted.
  ///
  /// Uses the [platform] environment in this iteration.
  String get _serviceAccount => platform.environment[_kServiceAccountKey];

  /// Prepares the local work space for golden file testing and calls the
  /// goldctl `auth` command, will return a Future of true if successful, or
  /// throw an error.
  ///
  /// This ensures that the goldctl tool is authorized and ready for testing.
  Future<bool> auth(Directory workDirectory) async {
    _workDirectory = workDirectory;
    assert(_workDirectory != null);

    if (_serviceAccount == null)
      return false;

    final File authorization = _workDirectory.childFile('serviceAccount.json');
    await authorization.writeAsString(_serviceAccount);

    final List<String> authArguments = <String>[
      'auth',
      '--service-account', authorization.path,
      '--work-dir', _workDirectory.childDirectory('temp').path,
    ];

    final io.ProcessResult authResults = await io.Process.run(
      _goldctl,
      authArguments,
    );

    if (authResults.exitCode != 0) {
      final StringBuffer buf = StringBuffer()
        ..writeln('Flutter + Skia Gold auth failed.')
        ..writeln('stdout: ${authResults.stdout}')
        ..writeln('stderr: ${authResults.stderr}');
      throw NonZeroExitCode(authResults.exitCode, buf.toString());
    }
    return true;
  }

  /// Executes the `imgtest init` command in the goldctl tool.
  ///
  /// The `imgtest` command collects and uploads test results to the Skia Gold
  /// backend, the `init` argument initializes the testing environment.
  Future<void> imgtestInit() async {
    final String commitHash = await _getCommitHash();
    final File keys = _workDirectory.childFile('keys.json');
    final File failures = _workDirectory.childFile('failures.json');

    await keys.writeAsString(_getKeysJSON());
    await failures.create();

    final List<String> imgtestInitArguments = <String>[
      'imgtest', 'init',
      '--instance', 'flutter',
      '--work-dir', _workDirectory.childDirectory('temp').path,
      '--commit', commitHash,
      '--keys-file', keys.path,
      '--failure-file', failures.path,
      '--passfail',
    ];

    if (imgtestInitArguments.contains(null)) {
      final StringBuffer buf = StringBuffer();
      buf.writeln('Null argument for Skia Gold imgtest init:');
      imgtestInitArguments.forEach(buf.writeln);
      throw NonZeroExitCode(1, buf.toString());
    }

    final io.ProcessResult imgtestInitResult = await io.Process.run(
      _goldctl,
      imgtestInitArguments,
    );

    if (imgtestInitResult.exitCode != 0) {
      final StringBuffer buf = StringBuffer()
        ..writeln('Flutter + Skia Gold imgtest init failed.')
        ..writeln('stdout: ${imgtestInitResult.stdout}')
        ..writeln('stderr: ${imgtestInitResult.stderr}');
      throw NonZeroExitCode(imgtestInitResult.exitCode, buf.toString());
    }
  }

  /// Executes the `imgtest add` command in the goldctl tool.
  ///
  /// The `imgtest` command collects and uploads test results to the Skia Gold
  /// backend, the `add` argument uploads the current image test. A response is
  /// returned from the invocation of this command that indicates a pass or fail
  /// result.
  Future<bool> imgtestAdd(String testName, File goldenFile) async {
    assert(testName != null);
    assert(goldenFile != null);

    final List<String> imgtestArguments = <String>[
      'imgtest', 'add',
      '--work-dir', _workDirectory.childDirectory('temp').path,
      // TODO(Piinks) Needs further cleaning ',' and '='
      '--test-name', testName.split(path.extension(testName.toString()))[0],
      '--png-file', goldenFile.path,
    ];

//    if (imgtestArguments.contains(null)) {
//      final StringBuffer buf = StringBuffer();
//      buf.writeln('Null argument for Skia Gold imgtest add:');
//      imgtestArguments.forEach(buf.writeln);
//      throw NonZeroExitCode(1, buf.toString());
//    }

    await io.Process.run(
      _goldctl,
      imgtestArguments,
    );

    // TODO(Piinks): Comment on PR if triage is needed, https://github.com/flutter/flutter/issues/34673
    // Will not turn the tree red in this implementation.
    return true;
  }

  Future<String> _getCommitHash() async {
    if (!flutterRoot.existsSync()) {
      return null;
    }
    final io.ProcessResult revParse = await io.Process.run(
      'git',
      <String>['rev-parse', 'HEAD'],
      workingDirectory: flutterRoot.path,
    );
    return revParse.exitCode == 0 ? revParse.stdout.trim() : null;
  }

  String _getKeysJSON() {
    return json.encode(
      <String, dynamic>{
        'Platform' : platform.operatingSystem,
      }
    );
  }
}
