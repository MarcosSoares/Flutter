// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;


import 'application_package.dart';

import 'base/file_system.dart';
import 'base/io.dart';

import 'asset.dart';

import 'base/logger.dart';
import 'build_info.dart';
import 'dart/dependencies.dart';
import 'dart/package_map.dart';
import 'dependency_checker.dart';
import 'device.dart';
import 'globals.dart';
import 'vmservice.dart';

// Shared code between different resident application runners.
abstract class ResidentRunner {
  ResidentRunner(this.device, {
    this.target,
    this.debuggingOptions,
    this.usesTerminalUI: true,
    String projectRootPath,
    String packagesFilePath,
    String projectAssets,
  }) {
    _mainPath = findMainDartFile(target);
    _projectRootPath = projectRootPath ?? fs.currentDirectory.toString();
    _packagesFilePath =
        packagesFilePath ?? path.absolute(PackageMap.globalPackagesPath);
    if (projectAssets != null)
      _assetBundle = new AssetBundle.fixed(_projectRootPath, projectAssets);
    else
      _assetBundle = new AssetBundle();
  }

  final Device device;
  final String target;
  final DebuggingOptions debuggingOptions;
  final bool usesTerminalUI;
  final Completer<int> _finished = new Completer<int>();
  String _packagesFilePath;
  String get packagesFilePath => _packagesFilePath;
  String _projectRootPath;
  String get projectRootPath => _projectRootPath;
  String _mainPath;
  String get mainPath => _mainPath;
  AssetBundle _assetBundle;
  AssetBundle get assetBundle => _assetBundle;
  ApplicationPackage package;

  bool get isRunningDebug => debuggingOptions.buildMode == BuildMode.debug;
  bool get isRunningProfile => debuggingOptions.buildMode == BuildMode.profile;
  bool get isRunningRelease => debuggingOptions.buildMode == BuildMode.release;
  bool get supportsServiceProtocol => isRunningDebug || isRunningProfile;

  VMService vmService;
  FlutterView currentView;
  StreamSubscription<String> _loggingSubscription;

  /// Start the app and keep the process running during its lifetime.
  Future<int> run({
    Completer<DebugConnectionInfo> connectionInfoCompleter,
    Completer<Null> appStartedCompleter,
    String route,
    bool shouldBuild: true
  });

  bool get supportsRestart => false;

  Future<OperationResult> restart({ bool fullRestart: false, bool pauseAfterRestart: false }) {
    throw 'unsupported';
  }

  Future<Null> stop() async {
    await stopEchoingDeviceLog();
    await preStop();
    return stopApp();
  }

  Future<Null> _debugDumpApp() async {
    if (vmService != null)
      await vmService.vm.refreshViews();
    await currentView.uiIsolate.flutterDebugDumpApp();
  }

  Future<Null> _debugDumpRenderTree() async {
    if (vmService != null)
      await vmService.vm.refreshViews();
    await currentView.uiIsolate.flutterDebugDumpRenderTree();
  }

  Future<Null> _debugToggleDebugPaintSizeEnabled() async {
    if (vmService != null)
      await vmService.vm.refreshViews();
    await currentView.uiIsolate.flutterToggleDebugPaintSizeEnabled();
  }

  void registerSignalHandlers() {
    ProcessSignal.SIGINT.watch().listen((ProcessSignal signal) async {
      _resetTerminal();
      await cleanupAfterSignal();
      exit(0);
    });
    ProcessSignal.SIGTERM.watch().listen((ProcessSignal signal) async {
      _resetTerminal();
      await cleanupAfterSignal();
      exit(0);
    });
    if (!supportsServiceProtocol)
      return;
    if (!supportsRestart)
      return;
    ProcessSignal.SIGUSR1.watch().listen(_handleSignal);
    ProcessSignal.SIGUSR2.watch().listen(_handleSignal);
  }

  bool _processingSignal = false;
  Future<Null> _handleSignal(ProcessSignal signal) async {
    if (_processingSignal) {
      printTrace('Ignoring signal: "$signal" because we are busy.');
      return;
    }
    _processingSignal = true;

    final bool fullRestart = signal == ProcessSignal.SIGUSR2;

    try {
      await restart(fullRestart: fullRestart);
    } finally {
      _processingSignal = false;
    }
  }

  Future<Null> startEchoingDeviceLog(ApplicationPackage app) async {
    if (_loggingSubscription != null) {
      return;
    }
    _loggingSubscription = device.getLogReader(app: app).logLines.listen((String line) {
      if (!line.contains('Observatory listening on http') &&
          !line.contains('Diagnostic server listening on http'))
        printStatus(line);
    });
  }

  Future<Null> stopEchoingDeviceLog() async {
    if (_loggingSubscription != null) {
      await _loggingSubscription.cancel();
    }
    _loggingSubscription = null;
  }

  Future<Null> connectToServiceProtocol(Uri uri) async {
    if (!debuggingOptions.debuggingEnabled) {
      return new Future<Null>.error('Error the service protocol is not enabled.');
    }
    vmService = await VMService.connect(uri);
    printTrace('Connected to service protocol: $uri');
    await vmService.getVM();

    // Refresh the view list.
    await vmService.vm.refreshViews();
    currentView = vmService.vm.mainView;
    assert(currentView != null);

    // Listen for service protocol connection to close.
    vmService.done.whenComplete(() {
      appFinished();
    });
  }

  /// Returns [true] if the input has been handled by this function.
  Future<bool> _commonTerminalInputHandler(String character) async {
    final String lower = character.toLowerCase();

    printStatus(''); // the key the user tapped might be on this line

    if (lower == 'h' || lower == '?' || character == AnsiTerminal.KEY_F1) {
      // F1, help
      printHelp(details: true);
      return true;
    } else if (lower == 'w') {
      if (!supportsServiceProtocol)
        return true;
      await _debugDumpApp();
      return true;
    } else if (lower == 't') {
      if (!supportsServiceProtocol)
        return true;
      await _debugDumpRenderTree();
      return true;
    } else if (lower == 'p') {
      if (!supportsServiceProtocol)
        return true;
      await _debugToggleDebugPaintSizeEnabled();
      return true;
    } else if (lower == 'q' || character == AnsiTerminal.KEY_F10) {
      // F10, exit
      await stop();
      return true;
    }

    return false;
  }

  bool _processingTerminalRequest = false;

  Future<Null> processTerminalInput(String command) async {
    if (_processingTerminalRequest) {
      printTrace('Ignoring terminal input: "$command" because we are busy.');
      return;
    }
    _processingTerminalRequest = true;
    try {
      bool handled = await _commonTerminalInputHandler(command);
      if (!handled)
        await handleTerminalCommand(command);
    } finally {
      _processingTerminalRequest = false;
    }
  }

  void appFinished() {
    if (_finished.isCompleted)
      return;
    printStatus('Application finished.');
    _resetTerminal();
    _finished.complete(0);
  }

  void _resetTerminal() {
    if (usesTerminalUI)
      terminal.singleCharMode = false;
  }

  void setupTerminal() {
    if (usesTerminalUI) {
      if (!logger.quiet) {
        printStatus('');
        printHelp(details: false);
      }
      terminal.singleCharMode = true;
      terminal.onCharInput.listen((String code) {
        processTerminalInput(code);
      });
    }
  }

  Future<int> waitForAppToFinish() async {
    int exitCode = await _finished.future;
    await cleanupAtFinish();
    return exitCode;
  }

  bool hasDirtyDependencies() {
    DartDependencySetBuilder dartDependencySetBuilder =
        new DartDependencySetBuilder(
            mainPath, projectRootPath, packagesFilePath);
    DependencyChecker dependencyChecker =
        new DependencyChecker(dartDependencySetBuilder, assetBundle);
    String path = package.packagePath;
    if (path == null) {
      return true;
    }
    final FileStat stat = fs.file(path).statSync();
    if (stat.type != FileSystemEntityType.FILE) {
      return true;
    }
    if (!fs.file(path).existsSync()) {
      return true;
    }
    final DateTime lastBuildTime = stat.modified;
    return dependencyChecker.check(lastBuildTime);
  }

  Future<Null> preStop() async { }

  Future<Null> stopApp() async {
    if (vmService != null && !vmService.isClosed) {
      if ((currentView != null) && (currentView.uiIsolate != null)) {
        // TODO(johnmccutchan): Wait for the exit command to complete.
        currentView.uiIsolate.flutterExit();
        await new Future<Null>.delayed(new Duration(milliseconds: 100));
      }
    }
    appFinished();
  }

  /// Called to print help to the terminal.
  void printHelp({ @required bool details });

  void printHelpDetails() {
    printStatus('To dump the widget hierarchy of the app (debugDumpApp), press "w".');
    printStatus('To dump the rendering tree of the app (debugDumpRenderTree), press "t".');
    printStatus('To toggle the display of construction lines (debugPaintSizeEnabled), press "p".');
  }

  /// Called when a signal has requested we exit.
  Future<Null> cleanupAfterSignal();
  /// Called right before we exit.
  Future<Null> cleanupAtFinish();
  /// Called when the runner should handle a terminal command.
  Future<Null> handleTerminalCommand(String code);
}

class OperationResult {
  static final OperationResult ok = new OperationResult(0, '');

  OperationResult(this.code, this.message);

  final int code;
  final String message;

  bool get isOk => code == 0;
}

/// Given the value of the --target option, return the path of the Dart file
/// where the app's main function should be.
String findMainDartFile([String target]) {
  if (target == null)
    target = '';
  String targetPath = path.absolute(target);
  if (fs.isDirectorySync(targetPath))
    return path.join(targetPath, 'lib', 'main.dart');
  else
    return targetPath;
}

String getMissingPackageHintForPlatform(TargetPlatform platform) {
  switch (platform) {
    case TargetPlatform.android_arm:
    case TargetPlatform.android_x64:
      return 'Is your project missing an android/AndroidManifest.xml?\nConsider running "flutter create ." to create one.';
    case TargetPlatform.ios:
      return 'Is your project missing an ios/Runner/Info.plist?\nConsider running "flutter create ." to create one.';
    default:
      return null;
  }
}

class DebugConnectionInfo {
  DebugConnectionInfo({ this.httpUri, this.wsUri, this.baseUri });

  // TODO(danrubel): the httpUri field should be removed as part of
  // https://github.com/flutter/flutter/issues/7050
  final Uri httpUri;
  final Uri wsUri;
  final String baseUri;
}
