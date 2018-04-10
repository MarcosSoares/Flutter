// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import '../base/file_system.dart';
import '../runner/flutter_command.dart';
import 'analyze_continuously.dart';
import 'analyze_once.dart';

class AnalyzeCommand extends FlutterCommand {
  AnalyzeCommand({bool verboseHelp: false, this.workingDirectory}) {
    argParser.addFlag('flutter-repo',
        negatable: false,
        help: 'Include all the examples and tests from the Flutter repository.',
        defaultsTo: false);
    argParser.addFlag('current-package',
        help: 'Analyze the current project, if applicable.', defaultsTo: true);
    argParser.addFlag('dartdocs',
        negatable: false,
        help:
            'List every public member that is lacking documentation (only works with --flutter-repo).',
        hide: !verboseHelp);
    argParser.addFlag('watch',
        help: 'Run analysis continuously, watching the filesystem for changes.',
        negatable: false);
    argParser.addFlag('preview-dart-2',
        defaultsTo: true, help: 'Preview Dart 2.0 functionality.');
    argParser.addOption('write',
        valueHelp: 'file',
        help:
            'Also output the results to a file. This is useful with --watch if you want a file to always contain the latest results.');

    // Hidden option to enable a benchmarking mode.
    argParser.addFlag('benchmark',
        negatable: false,
        hide: !verboseHelp,
        help: 'Also output the analysis time.');

    usesPubOption();

    // Not used by analyze --watch
    argParser.addFlag('congratulate',
        help:
            'When analyzing the flutter repository, show output even when there are no errors, warnings, hints, or lints.',
        defaultsTo: true);
    argParser.addFlag('preamble',
        defaultsTo: true,
        help:
            'When analyzing the flutter repository, display the number of files that will be analyzed.');
  }

  /// The working directory for testing analysis using dartanalyzer.
  final Directory workingDirectory;

  @override
  String get name => 'analyze';

  @override
  String get description => "Analyze the project's Dart code.";

  @override
  bool get shouldRunPub {
    // If they're not analyzing the current project.
    if (!argResults['current-package']) {
      return false;
    }

    // Or we're not in a project directory.
    if (!fs.file('pubspec.yaml').existsSync()) {
      return false;
    }

    return super.shouldRunPub;
  }

  @override
  Future<Null> runCommand() {
    if (argResults['watch']) {
      return new AnalyzeContinuously(
        argResults,
        runner.getRepoRoots(),
        runner.getRepoPackages(),
        previewDart2: argResults['preview-dart-2'],
      ).analyze();
    } else {
      return new AnalyzeOnce(
        argResults,
        runner.getRepoRoots(),
        runner.getRepoPackages(),
        workingDirectory: workingDirectory,
        previewDart2: argResults['preview-dart-2'],
      ).analyze();
    }
  }
}
