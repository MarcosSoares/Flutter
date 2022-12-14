// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:args/command_runner.dart';
import 'package:file_testing/file_testing.dart';
import 'package:flutter_tools/src/artifacts.dart';
import 'package:flutter_tools/src/base/file_system.dart';
import 'package:flutter_tools/src/base/io.dart';
import 'package:flutter_tools/src/base/logger.dart';
import 'package:flutter_tools/src/base/net.dart';
import 'package:flutter_tools/src/base/platform.dart';
import 'package:flutter_tools/src/build_info.dart';
import 'package:flutter_tools/src/cache.dart';
import 'package:flutter_tools/src/commands/create.dart';
import 'package:flutter_tools/src/commands/create_base.dart';
import 'package:flutter_tools/src/dart/pub.dart';
import 'package:flutter_tools/src/features.dart';
import 'package:flutter_tools/src/globals.dart' as globals;
import 'package:flutter_tools/src/project.dart';
import 'package:flutter_tools/src/version.dart';
import 'package:process/process.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:uuid/uuid.dart';
import 'package:yaml/yaml.dart';

import '../../src/common.dart';
import '../../src/context.dart';
import '../../src/fake_http_client.dart';
import '../../src/fakes.dart';
import '../../src/pubspec_schema.dart';
import '../../src/test_flutter_command_runner.dart';

const String _kNoPlatformsMessage = "You've created a plugin project that doesn't yet support any platforms.\n";
const String frameworkRevision = '12345678';
const String frameworkChannel = 'omega';
const String _kDisabledPlatformRequestedMessage = 'currently not supported on your local environment.';

// This needs to be created from the local platform due to re-entrant flutter calls made in this test.
FakePlatform _kNoColorTerminalPlatform() => FakePlatform.fromPlatform(const LocalPlatform())..stdoutSupportsAnsi = false;
FakePlatform _kNoColorTerminalMacOSPlatform() => FakePlatform.fromPlatform(const LocalPlatform())
  ..stdoutSupportsAnsi = false
  ..operatingSystem = 'macos';

final Map<Type, Generator> noColorTerminalOverride = <Type, Generator>{
  Platform: _kNoColorTerminalPlatform,
};

const String samplesIndexJson = '''
[
  { "id": "sample1" },
  { "id": "sample2" }
]''';

void main() {
  late Directory tempDir;
  late Directory projectDir;
  late FakeFlutterVersion fakeFlutterVersion;
  late LoggingProcessManager loggingProcessManager;
  late FakeProcessManager fakeProcessManager;
  late BufferLogger logger;
  late FakeStdio mockStdio;

  setUpAll(() async {
    Cache.disableLocking();
    await _ensureFlutterToolsSnapshot();
  });

  setUp(() {
    loggingProcessManager = LoggingProcessManager();
    logger = BufferLogger.test();
    tempDir = globals.fs.systemTempDirectory.createTempSync('flutter_tools_create_test.');
    projectDir = tempDir.childDirectory('flutter_project');
    fakeFlutterVersion = FakeFlutterVersion(
      frameworkRevision: frameworkRevision,
      channel: frameworkChannel,
    );
    fakeProcessManager = FakeProcessManager.empty();
    mockStdio = FakeStdio();
  });

  tearDown(() {
    tryToDelete(tempDir);
  });

  tearDownAll(() async {
    await _restoreFlutterToolsSnapshot();
  });

  test('createAndroidIdentifier emits a valid identifier', () {
    final String identifier = CreateBase.createAndroidIdentifier('42org', '8project');
    expect(identifier.contains('.'), isTrue);

    final RegExp startsWithLetter = RegExp(r'^[a-zA-Z][\w]*$');
    final List<String> segments = identifier.split('.');
    for (final String segment in segments) {
      expect(startsWithLetter.hasMatch(segment), isTrue);
    }
  });

  test('createUTIIdentifier emits a valid identifier', () {
    final String identifier = CreateBase.createUTIIdentifier('org@', 'project');
    expect(identifier.contains('.'), isTrue);
    expect(identifier.contains('@'), isFalse);
  });

  test('createWindowsIdentifier emits a GUID', () {
    final String identifier = CreateBase.createWindowsIdentifier('org', 'project');
    expect(Uuid.isValidUUID(fromString: identifier), isTrue);
  });

  testUsingContext('tool exits on Windows if given a drive letter without a path', () async {
    // Must use LocalFileSystem as it is dependent on dart:io handling of
    // Windows paths, which the MemoryFileSystem does not implement
    final Directory workingDir = globals.fs.directory(r'X:\path\to\working\dir');
    // Must use [io.IOOverrides] as directory.absolute depends on Directory.current
    // from dart:io.
    await io.IOOverrides.runZoned<Future<void>>(
      () async {
        // Verify IOOverrides is working
        expect(io.Directory.current, workingDir);
        final CreateCommand command = CreateCommand();
        final CommandRunner<void> runner = createTestCommandRunner(command);
        const String driveName = 'X:';
        await expectToolExitLater(
          runner.run(<String>[
            'create',
            '--project-name',
            'test_app',
            '--offline',
            driveName,
          ]),
          contains('You attempted to create a flutter project at the path "$driveName"'),
        );
      },
      getCurrentDirectory: () => workingDir,
    );
  }, overrides: <Type, Generator>{
    Logger: () => BufferLogger.test(),
  }, skip: !io.Platform.isWindows // [intended] relies on Windows file system
  );

  // Verify that we create a default project ('app') that is
  // well-formed.
  testUsingContext('can create a default project', () async {
    await _createAndAnalyzeProject(
      projectDir,
      <String>['-i', 'objc', '-a', 'java'],
      <String>[
        'analysis_options.yaml',
        'android/app/src/main/java/com/example/flutter_project/MainActivity.java',
        'android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java',
        'flutter_project.iml',
        'ios/Flutter/AppFrameworkInfo.plist',
        'ios/Runner/AppDelegate.m',
        'ios/Runner/GeneratedPluginRegistrant.h',
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png',
        'ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png',
        'lib/main.dart',
      ],
    );
    expect(logger.statusText, contains('In order to run your application, type:'));
    // check that we're telling them about documentation
    expect(logger.statusText, contains('https://docs.flutter.dev/'));
    expect(logger.statusText, contains('https://api.flutter.dev/'));
    // check that the tests run clean
    return _runFlutterTest(projectDir);
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
    Logger: () => logger,
  });

  testUsingContext('can create a skeleton (list/detail) app', () async {
    await _createAndAnalyzeProject(
      projectDir,
      <String>['-t', 'skeleton', '-i', 'objc', '-a', 'java', '--implementation-tests'],
      <String>[
        '.dart_tool/flutter_gen/pubspec.yaml',
        '.dart_tool/flutter_gen/gen_l10n/app_localizations.dart',
        'analysis_options.yaml',
        'android/app/src/main/java/com/example/flutter_project/MainActivity.java',
        'android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java',
        'flutter_project.iml',
        'ios/Flutter/AppFrameworkInfo.plist',
        'ios/Runner/AppDelegate.m',
        'ios/Runner/GeneratedPluginRegistrant.h',
        'lib/main.dart',
        'l10n.yaml',
        'assets/images/2.0x/flutter_logo.png',
        'assets/images/flutter_logo.png',
        'assets/images/3.0x/flutter_logo.png',
        'test/unit_test.dart',
        'test/widget_test.dart',
        'test/implementation_test.dart',
        'lib/src/localization/app_en.arb',
        'lib/src/app.dart',
        'lib/src/sample_feature/sample_item_details_view.dart',
        'lib/src/sample_feature/sample_item_list_view.dart',
        'lib/src/sample_feature/sample_item.dart',
        'lib/src/settings/settings_controller.dart',
        'lib/src/settings/settings_view.dart',
        'lib/src/settings/settings_service.dart',
        'lib/main.dart',
        'pubspec.yaml',
        'README.md',
      ],
    );
    return _runFlutterTest(projectDir);
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('can create a default project if empty directory exists', () async {
    await projectDir.create(recursive: true);
    await _createAndAnalyzeProject(
      projectDir,
      <String>['-i', 'objc', '-a', 'java'],
      <String>[
        'analysis_options.yaml',
        'android/app/src/main/java/com/example/flutter_project/MainActivity.java',
        'android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java',
        'flutter_project.iml',
        'ios/Flutter/AppFrameworkInfo.plist',
        'ios/Runner/AppDelegate.m',
        'ios/Runner/GeneratedPluginRegistrant.h',
      ],
    );
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('creates a module project correctly', () async {
    await _createAndAnalyzeProject(projectDir, <String>[
      '--template=module',
    ], <String>[
      '.android/app/',
      '.gitignore',
      '.ios/Flutter',
      '.metadata',
      'analysis_options.yaml',
      'lib/main.dart',
      'pubspec.yaml',
      'README.md',
      'test/widget_test.dart',
    ], unexpectedPaths: <String>[
      'android/',
      'ios/',
    ]);
    return _runFlutterTest(projectDir);
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('cannot create a project if non-empty non-project directory exists with .metadata', () async {
    await projectDir.absolute.childDirectory('blag').create(recursive: true);
    await projectDir.absolute.childFile('.metadata').writeAsString('project_type: blag\n');
    expect(() async => _createAndAnalyzeProject(
        projectDir,
        <String>[],
        <String>[],
        unexpectedPaths: <String>[
          'android/',
          'ios/',
          '.android/',
          '.ios/',
        ]),
      throwsToolExit(message: 'Sorry, unable to detect the type of project to recreate'));
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
    ...noColorTerminalOverride,
  });

  testUsingContext('cannot create a project in flutter root', () async {
    Cache.flutterRoot = '../..';
    final String flutterBin = globals.fs.path.join(getFlutterRoot(), 'bin', globals.platform.isWindows ? 'flutter.bat' : 'flutter');
    final ProcessResult exec = await Process.run(
      flutterBin,
      <String>[
        'create',
        'flutter_project',
      ],
      workingDirectory: Cache.flutterRoot,
    );
    expect(exec.exitCode, 2);
    expect(exec.stderr, contains('Cannot create a project within the Flutter SDK'));
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
    ...noColorTerminalOverride,
  });

  testUsingContext('Will create an app project if non-empty non-project directory exists without .metadata', () async {
    await projectDir.absolute.childDirectory('blag').create(recursive: true);
    await projectDir.absolute.childDirectory('.idea').create(recursive: true);
    await _createAndAnalyzeProject(
      projectDir,
      <String>[
        '-i', 'objc', '-a', 'java',
      ],
      <String>[
        'android/app/src/main/java/com/example/flutter_project/MainActivity.java',
        'android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java',
        'flutter_project.iml',
        'ios/Flutter/AppFrameworkInfo.plist',
        'ios/Runner/AppDelegate.m',
        'ios/Runner/GeneratedPluginRegistrant.h',
      ],
      unexpectedPaths: <String>[
        '.android/',
        '.ios/',
      ],
    );
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('detects and recreates an app project correctly', () async {
    await projectDir.absolute.childDirectory('lib').create(recursive: true);
    await projectDir.absolute.childDirectory('ios').create(recursive: true);
    await _createAndAnalyzeProject(
      projectDir,
      <String>[
        '-i', 'objc', '-a', 'java',
      ],
      <String>[
        'android/app/src/main/java/com/example/flutter_project/MainActivity.java',
        'android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java',
        'flutter_project.iml',
        'ios/Flutter/AppFrameworkInfo.plist',
        'ios/Runner/AppDelegate.m',
        'ios/Runner/GeneratedPluginRegistrant.h',
      ],
      unexpectedPaths: <String>[
        '.android/',
        '.ios/',
      ],
    );
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('detects and recreates a plugin project correctly', () async {
    await projectDir.create(recursive: true);
    await projectDir.absolute.childFile('.metadata').writeAsString('project_type: plugin\n');
    await _createAndAnalyzeProject(
      projectDir,
      <String>[],
      <String>[
        'example/lib/main.dart',
        'flutter_project.iml',
        'lib/flutter_project.dart',
      ],
      unexpectedPaths: <String>[
        'android/app/src/main/java/com/example/flutter_project/MainActivity.java',
        'android/src/main/java/com/example/flutter_project/FlutterProjectPlugin.java',
        'example/android/app/src/main/java/com/example/flutter_project_example/MainActivity.java',]
    );
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('detects and recreates a package project correctly', () async {
    await projectDir.create(recursive: true);
    await projectDir.absolute.childFile('.metadata').writeAsString('project_type: package\n');
    return _createAndAnalyzeProject(
      projectDir,
      <String>[],
      <String>[
        'lib/flutter_project.dart',
        'test/flutter_project_test.dart',
      ],
      unexpectedPaths: <String>[
        'android/app/src/main/java/com/example/flutter_project/MainActivity.java',
        'android/src/main/java/com/example/flutter_project/FlutterProjectPlugin.java',
        'example/android/app/src/main/java/com/example/flutter_project_example/MainActivity.java',
        'example/ios/Runner/AppDelegate.h',
        'example/ios/Runner/AppDelegate.m',
        'example/ios/Runner/main.m',
        'example/lib/main.dart',
        'ios/Classes/FlutterProjectPlugin.h',
        'ios/Classes/FlutterProjectPlugin.m',
        'ios/Runner/AppDelegate.h',
        'ios/Runner/AppDelegate.m',
        'ios/Runner/main.m',
        'lib/main.dart',
        'test/widget_test.dart',
      ],
    );
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('kotlin/swift legacy app project', () async {
    return _createProject(
      projectDir,
      <String>['--no-pub', '--template=app', '--android-language=kotlin', '--ios-language=swift'],
      <String>[
        'android/app/src/main/kotlin/com/example/flutter_project/MainActivity.kt',
        'ios/Runner/AppDelegate.swift',
        'ios/Runner/Runner-Bridging-Header.h',
        'lib/main.dart',
        '.idea/libraries/KotlinJavaRuntime.xml',
      ],
      unexpectedPaths: <String>[
        'android/app/src/main/java/com/example/flutter_project/MainActivity.java',
        'ios/Runner/AppDelegate.h',
        'ios/Runner/AppDelegate.m',
        'ios/Runner/main.m',
      ],
    );
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('can create a package project', () async {
    await _createAndAnalyzeProject(
      projectDir,
      <String>['--template=package'],
      <String>[
        'analysis_options.yaml',
        'lib/flutter_project.dart',
        'test/flutter_project_test.dart',
      ],
      unexpectedPaths: <String>[
        'android/app/src/main/java/com/example/flutter_project/MainActivity.java',
        'android/src/main/java/com/example/flutter_project/FlutterProjectPlugin.java',
        'example/android/app/src/main/java/com/example/flutter_project_example/MainActivity.java',
        'example/ios/Runner/AppDelegate.h',
        'example/ios/Runner/AppDelegate.m',
        'example/ios/Runner/main.m',
        'example/lib/main.dart',
        'ios/Classes/FlutterProjectPlugin.h',
        'ios/Classes/FlutterProjectPlugin.m',
        'ios/Runner/AppDelegate.h',
        'ios/Runner/AppDelegate.m',
        'ios/Runner/main.m',
        'lib/main.dart',
        'test/widget_test.dart',
      ],
    );
    return _runFlutterTest(projectDir);
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('can create a plugin project', () async {
    await _createAndAnalyzeProject(
      projectDir,
      <String>['--template=plugin', '-i', 'objc', '-a', 'java'],
      <String>[
        'analysis_options.yaml',
        'LICENSE',
        'README.md',
        'example/lib/main.dart',
        'flutter_project.iml',
        'lib/flutter_project.dart',
      ],
      unexpectedPaths: <String>[
        'android/src/main/java/com/example/flutter_project/FlutterProjectPlugin.java',
        'example/android/app/src/main/java/com/example/flutter_project_example/MainActivity.java',
        'example/integration_test/plugin_integration_test.dart',
        'lib/flutter_project_web.dart',
      ],
    );
    return _runFlutterTest(projectDir.childDirectory('example'));
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('plugin project supports web', () async {
    await _createAndAnalyzeProject(
      projectDir,
      <String>['--template=plugin', '--platform=web'],
      <String>[
        'lib/flutter_project.dart',
        'lib/flutter_project_web.dart',
      ],
    );
    final String rawPubspec = await projectDir.childFile('pubspec.yaml').readAsString();
    final Pubspec pubspec = Pubspec.parse(rawPubspec);
    // Expect the dependency on flutter_web_plugins exists
    expect(pubspec.dependencies, contains('flutter_web_plugins'));
    // The platform is correctly registered
    final YamlMap web = ((pubspec.flutter!['plugin'] as YamlMap)['platforms'] as YamlMap)['web'] as YamlMap;
    expect(web['pluginClass'], 'FlutterProjectWeb');
    expect(web['fileName'], 'flutter_project_web.dart');
    expect(logger.errorText, isNot(contains(_kNoPlatformsMessage)));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWebEnabled: true),
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
    Logger: () => logger,
  });

  testUsingContext('plugin example app depends on plugin', () async {
    await _createProject(
      projectDir,
      <String>['--template=plugin', '-i', 'objc', '-a', 'java'],
      <String>[
        'example/pubspec.yaml',
      ],
    );
    final String rawPubspec = await projectDir.childDirectory('example').childFile('pubspec.yaml').readAsString();
    final Pubspec pubspec = Pubspec.parse(rawPubspec);
    final String pluginName = projectDir.basename;
    expect(pubspec.dependencies, contains(pluginName));
    expect(pubspec.dependencies[pluginName] is PathDependency, isTrue);
    final PathDependency pathDependency = pubspec.dependencies[pluginName]! as PathDependency;
    expect(pathDependency.path, '../');
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('kotlin/swift plugin project', () async {
    return _createProject(
      projectDir,
      <String>['--no-pub', '--template=plugin', '-a', 'kotlin', '--ios-language', 'swift', '--platforms', 'ios,android'],
      <String>[
        'analysis_options.yaml',
        'android/src/main/kotlin/com/example/flutter_project/FlutterProjectPlugin.kt',
        'example/android/app/src/main/kotlin/com/example/flutter_project_example/MainActivity.kt',
        'example/ios/Runner/AppDelegate.swift',
        'example/ios/Runner/Runner-Bridging-Header.h',
        'example/lib/main.dart',
        'ios/Classes/FlutterProjectPlugin.swift',
        'lib/flutter_project.dart',
      ],
      unexpectedPaths: <String>[
        'android/src/main/java/com/example/flutter_project/FlutterProjectPlugin.java',
        'example/android/app/src/main/java/com/example/flutter_project_example/MainActivity.java',
        'example/ios/Runner/AppDelegate.h',
        'example/ios/Runner/AppDelegate.m',
        'example/ios/Runner/main.m',
        'ios/Classes/FlutterProjectPlugin.h',
        'ios/Classes/FlutterProjectPlugin.m',
      ],
    );
  });

  testUsingContext('plugin project with custom org', () async {
    return _createProject(
      projectDir,
      <String>[
        '--no-pub',
        '--template=plugin',
        '--org', 'com.bar.foo',
        '-i', 'objc',
        '-a', 'java',
        '--platform', 'android',
      ], <String>[
        'android/src/main/java/com/bar/foo/flutter_project/FlutterProjectPlugin.java',
        'example/android/app/src/main/java/com/bar/foo/flutter_project_example/MainActivity.java',
      ],
      unexpectedPaths: <String>[
        'android/src/main/java/com/example/flutter_project/FlutterProjectPlugin.java',
        'example/android/app/src/main/java/com/example/flutter_project_example/MainActivity.java',
      ],
    );
  });

  testUsingContext('plugin project with valid custom project name', () async {
    return _createProject(
      projectDir,
      <String>[
        '--no-pub',
        '--template=plugin',
        '--project-name', 'xyz',
        '-i', 'objc',
        '-a', 'java',
        '--platforms', 'android,ios',
      ], <String>[
        'android/src/main/java/com/example/xyz/XyzPlugin.java',
        'example/android/app/src/main/java/com/example/xyz_example/MainActivity.java',
      ],
      unexpectedPaths: <String>[
        'android/src/main/java/com/example/flutter_project/FlutterProjectPlugin.java',
        'example/android/app/src/main/java/com/example/flutter_project_example/MainActivity.java',
      ],
    );
  });

  testUsingContext('plugin project with invalid custom project name', () async {
    expect(
      () => _createProject(projectDir,
        <String>['--no-pub', '--template=plugin', '--project-name', 'xyz.xyz', '--platforms', 'android,ios',],
        <String>[],
      ),
      throwsToolExit(message: '"xyz.xyz" is not a valid Dart package name.'),
    );
  });

  testUsingContext('module project with pub', () async {
    return _createProject(projectDir, <String>[
      '--template=module',
    ], <String>[
      '.android/build.gradle',
      '.android/Flutter/build.gradle',
      '.android/Flutter/flutter.iml',
      '.android/Flutter/src/main/AndroidManifest.xml',
      '.android/Flutter/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java',
      '.android/gradle.properties',
      '.android/gradle/wrapper/gradle-wrapper.jar',
      '.android/gradle/wrapper/gradle-wrapper.properties',
      '.android/gradlew',
      '.android/gradlew.bat',
      '.android/include_flutter.groovy',
      '.android/local.properties',
      '.android/settings.gradle',
      '.gitignore',
      '.metadata',
      '.dart_tool/package_config.json',
      'analysis_options.yaml',
      'lib/main.dart',
      'pubspec.lock',
      'pubspec.yaml',
      'README.md',
      'test/widget_test.dart',
    ], unexpectedPaths: <String>[
      'android/',
      'ios/',
      '.android/Flutter/src/main/java/io/flutter/facade/FlutterFragment.java',
      '.android/Flutter/src/main/java/io/flutter/facade/Flutter.java',
    ]);
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });


  testUsingContext('androidx is used by default in an app project', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);

    void expectExists(String relPath) {
      expect(globals.fs.isFileSync('${projectDir.path}/$relPath'), true);
    }

    expectExists('android/gradle.properties');

    final String actualContents = await globals.fs.file('${projectDir.path}/android/gradle.properties').readAsString();

    expect(actualContents.contains('useAndroidX'), true);
  });

  testUsingContext('androidx is used by default in a module project', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--template=module', '--no-pub', projectDir.path]);

    final FlutterProject project = FlutterProject.fromDirectory(projectDir);
    expect(
      project.usesAndroidX,
      true,
    );
  });

  testUsingContext('creating a new project should create v2 embedding and never show an Android v1 deprecation warning', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--platform', 'android', projectDir.path]);

    final String androidManifest = await globals.fs.file(
      '${projectDir.path}/android/app/src/main/AndroidManifest.xml'
    ).readAsString();
    expect(androidManifest.contains('android:name="flutterEmbedding"'), true);
    expect(androidManifest.contains('android:value="2"'), true);

    final String mainActivity = await globals.fs.file(
      '${projectDir.path}/android/app/src/main/kotlin/com/example/flutter_project/MainActivity.kt'
    ).readAsString();
    // Import for the new embedding class.
    expect(mainActivity.contains('import io.flutter.embedding.android.FlutterActivity'), true);

    expect(logger.statusText, isNot(contains('https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects')));
  }, overrides: <Type, Generator>{
    Logger: () => logger,
  });

  testUsingContext('app supports android and ios by default', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);

    expect(projectDir.childDirectory('android'), exists);
    expect(projectDir.childDirectory('ios'), exists);
  }, overrides: <Type, Generator>{});

  testUsingContext('app does not include android if disabled in config', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);

    expect(projectDir.childDirectory('android'), isNot(exists));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isAndroidEnabled: false),
  });

  testUsingContext('app does not include ios if disabled in config', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);

    expect(projectDir.childDirectory('ios'), isNot(exists));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isIOSEnabled: false),
  });

  testUsingContext('app does not include desktop or web by default', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);

    expect(projectDir.childDirectory('linux'), isNot(exists));
    expect(projectDir.childDirectory('macos'), isNot(exists));
    expect(projectDir.childDirectory('windows'), isNot(exists));
    expect(projectDir.childDirectory('web'), isNot(exists));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
  });

  testUsingContext('plugin does not include desktop or web by default',
      () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(
        <String>['create', '--no-pub', '--template=plugin', projectDir.path]);

    expect(projectDir.childDirectory('linux'), isNot(exists));
    expect(projectDir.childDirectory('macos'), isNot(exists));
    expect(projectDir.childDirectory('windows'), isNot(exists));
    expect(projectDir.childDirectory('web'), isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('linux'), isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('macos'), isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('windows'), isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('web'), isNot(exists));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
  });

  testUsingContext('app supports Linux if requested', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>[
      'create',
      '--no-pub',
      '--platform=linux',
      projectDir.path,
    ]);

    expect(projectDir.childDirectory('linux').childFile('CMakeLists.txt'), exists);
    expect(projectDir.childDirectory('android'), isNot(exists));
    expect(projectDir.childDirectory('ios'), isNot(exists));
    expect(projectDir.childDirectory('windows'), isNot(exists));
    expect(projectDir.childDirectory('macos'), isNot(exists));
    expect(projectDir.childDirectory('web'), isNot(exists));
    expect(logger.errorText, isNot(contains(_kNoPlatformsMessage)));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isLinuxEnabled: true),
    Logger: () => logger,
  });

  testUsingContext('plugin supports Linux if requested', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=linux', projectDir.path]);

    expect(
        projectDir.childDirectory('linux').childFile('CMakeLists.txt'), exists);
    expect(
        projectDir.childDirectory('example').childDirectory('linux'), exists);
    expect(projectDir.childDirectory('example').childDirectory('android'),
        isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('ios'),
        isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('windows'),
        isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('macos'),
        isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('web'),
        isNot(exists));
    validatePubspecForPlugin(
        projectDir: projectDir.absolute.path,
        expectedPlatforms: const <String>[
          'linux',
        ],
        pluginClass: 'FlutterProjectPlugin',
    unexpectedPlatforms: <String>['some_platform']);
    expect(logger.errorText, isNot(contains(_kNoPlatformsMessage)));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isLinuxEnabled: true),
    Logger: () => logger,
  });

  testUsingContext('app supports macOS if requested', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>[
      'create',
      '--no-pub',
      '--platform=macos',
      projectDir.path,
    ]);

    expect(
        projectDir.childDirectory('macos').childDirectory('Runner.xcworkspace'),
        exists);
    expect(projectDir.childDirectory('android'), isNot(exists));
    expect(projectDir.childDirectory('ios'), isNot(exists));
    expect(projectDir.childDirectory('linux'), isNot(exists));
    expect(projectDir.childDirectory('windows'), isNot(exists));
    expect(projectDir.childDirectory('web'), isNot(exists));
    expect(logger.errorText, isNot(contains(_kNoPlatformsMessage)));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isMacOSEnabled: true),
    Logger: () => logger,
  });

  testUsingContext('plugin supports macOS if requested', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=macos', projectDir.path]);

    expect(projectDir.childDirectory('macos').childFile('flutter_project.podspec'),
        exists);
    expect(
        projectDir.childDirectory('example').childDirectory('macos'), exists);
    expect(projectDir.childDirectory('example').childDirectory('linux'),
        isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('android'),
        isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('ios'),
        isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('windows'),
        isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('web'),
        isNot(exists));
    validatePubspecForPlugin(projectDir: projectDir.absolute.path, expectedPlatforms: const <String>[
      'macos',
    ], pluginClass: 'FlutterProjectPlugin',
    unexpectedPlatforms: <String>['some_platform']);
    expect(logger.errorText, isNot(contains(_kNoPlatformsMessage)));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isMacOSEnabled: true),
    Logger: () => logger,
  });

  testUsingContext('app supports Windows if requested', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>[
      'create',
      '--no-pub',
      '--platform=windows',
      projectDir.path,
    ]);

    expect(projectDir.childDirectory('windows').childFile('CMakeLists.txt'),
        exists);
    expect(projectDir.childDirectory('android'), isNot(exists));
    expect(projectDir.childDirectory('ios'), isNot(exists));
    expect(projectDir.childDirectory('linux'), isNot(exists));
    expect(projectDir.childDirectory('macos'), isNot(exists));
    expect(projectDir.childDirectory('web'), isNot(exists));
    expect(logger.errorText, isNot(contains(_kNoPlatformsMessage)));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWindowsEnabled: true),
    Logger: () => logger,
  });

  testUsingContext('Windows has correct VERSIONINFO', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--org', 'com.foo.bar', projectDir.path]);

    final File resourceFile = projectDir.childDirectory('windows').childDirectory('runner').childFile('Runner.rc');
    expect(resourceFile, exists);
    final String contents = resourceFile.readAsStringSync();
    expect(contents, contains('"CompanyName", "com.foo.bar"'));
    expect(contents, contains('"FileDescription", "flutter_project"'));
    expect(contents, contains('"ProductName", "flutter_project"'));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWindowsEnabled: true),
  });

  testUsingContext('plugin supports Windows if requested', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=windows', projectDir.path]);

    expect(projectDir.childDirectory('windows').childFile('CMakeLists.txt'),
        exists);
    expect(
        projectDir.childDirectory('example').childDirectory('windows'), exists);
    expect(
        projectDir
            .childDirectory('example')
            .childDirectory('android'),
        isNot(exists));
    expect(
        projectDir.childDirectory('example').childDirectory('ios'),
        isNot(exists));
    expect(
        projectDir
            .childDirectory('example')
            .childDirectory('linux'),
        isNot(exists));
    expect(
        projectDir
            .childDirectory('example')
            .childDirectory('macos'),
        isNot(exists));
    expect(
        projectDir.childDirectory('example').childDirectory('web'),
        isNot(exists));
    validatePubspecForPlugin(projectDir: projectDir.absolute.path, expectedPlatforms: const <String>[
      'windows',
    ], pluginClass: 'FlutterProjectPluginCApi',
    unexpectedPlatforms: <String>['some_platform']);
    expect(logger.errorText, isNot(contains(_kNoPlatformsMessage)));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWindowsEnabled: true),
    Logger: () => logger,
  });

  testUsingContext('app supports web if requested', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>[
      'create',
      '--no-pub',
      '--platform=web',
      projectDir.path,
    ]);

    expect(
        projectDir.childDirectory('web').childFile('index.html'),
        exists);
    expect(projectDir.childDirectory('android'), isNot(exists));
    expect(projectDir.childDirectory('ios'), isNot(exists));
    expect(projectDir.childDirectory('linux'), isNot(exists));
    expect(projectDir.childDirectory('macos'), isNot(exists));
    expect(projectDir.childDirectory('windows'), isNot(exists));
    expect(logger.errorText, isNot(contains(_kNoPlatformsMessage)));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWebEnabled: true),
    Logger: () => logger,
  });

  testUsingContext('app creates maskable icons for web', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>[
      'create',
      '--no-pub',
      '--platform=web',
      projectDir.path,
    ]);

    final Directory iconsDir = projectDir.childDirectory('web').childDirectory('icons');

    expect(iconsDir.childFile('Icon-maskable-192.png'), exists);
    expect(iconsDir.childFile('Icon-maskable-512.png'), exists);
  });

  testUsingContext('plugin uses new platform schema', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);

    final String pubspecContents = await globals.fs.directory(projectDir.path).childFile('pubspec.yaml').readAsString();

    expect(pubspecContents.contains('platforms:'), true);
  });

  testUsingContext('has correct content and formatting with module template', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--template=module', '--no-pub', '--org', 'com.foo.bar', projectDir.path]);

    void expectExists(String relPath, [bool expectation = true]) {
      expect(globals.fs.isFileSync('${projectDir.path}/$relPath'), expectation);
    }

    expectExists('lib/main.dart');
    expectExists('test/widget_test.dart');

    final String actualContents = await globals.fs.file('${projectDir.path}/test/widget_test.dart').readAsString();

    expect(actualContents.contains('flutter_test.dart'), true);

    for (final FileSystemEntity file in projectDir.listSync(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        final String original = file.readAsStringSync();

        final Process process = await Process.start(
          globals.artifacts!.getArtifactPath(Artifact.engineDartBinary),
          <String>['format', '--output=show', file.path],
          workingDirectory: projectDir.path,
        );
        final String formatted = await process.stdout.transform(utf8.decoder).join();

        expect(formatted, contains(original), reason: file.path);
      }
    }

    await _runFlutterTest(projectDir, target: globals.fs.path.join(projectDir.path, 'test', 'widget_test.dart'));

    // Generated Xcode settings
    final String xcodeConfigPath = globals.fs.path.join('.ios', 'Flutter', 'Generated.xcconfig');
    expectExists(xcodeConfigPath);
    final File xcodeConfigFile = globals.fs.file(globals.fs.path.join(projectDir.path, xcodeConfigPath));
    final String xcodeConfig = xcodeConfigFile.readAsStringSync();
    expect(xcodeConfig, contains('FLUTTER_ROOT='));
    expect(xcodeConfig, contains('FLUTTER_APPLICATION_PATH='));
    expect(xcodeConfig, contains('FLUTTER_TARGET='));
    expect(xcodeConfig, contains('COCOAPODS_PARALLEL_CODE_SIGN=true'));
    expect(xcodeConfig, contains('EXCLUDED_ARCHS[sdk=iphoneos*]=armv7'));
    // Avoid legacy build locations to support Swift Package Manager.
    expect(xcodeConfig, isNot(contains('SYMROOT')));

    // Generated export environment variables script
    final String buildPhaseScriptPath = globals.fs.path.join('.ios', 'Flutter', 'flutter_export_environment.sh');
    expectExists(buildPhaseScriptPath);
    final File buildPhaseScriptFile = globals.fs.file(globals.fs.path.join(projectDir.path, buildPhaseScriptPath));
    final String buildPhaseScript = buildPhaseScriptFile.readAsStringSync();
    expect(buildPhaseScript, contains('FLUTTER_ROOT='));
    expect(buildPhaseScript, contains('FLUTTER_APPLICATION_PATH='));
    expect(buildPhaseScript, contains('FLUTTER_TARGET='));
    expect(buildPhaseScript, contains('COCOAPODS_PARALLEL_CODE_SIGN=true'));
    // Do not override host app build settings.
    expect(buildPhaseScript, isNot(contains('SYMROOT')));

    // App identification
    final String xcodeProjectPath = globals.fs.path.join('.ios', 'Runner.xcodeproj', 'project.pbxproj');
    expectExists(xcodeProjectPath);
    final File xcodeProjectFile = globals.fs.file(globals.fs.path.join(projectDir.path, xcodeProjectPath));
    final String xcodeProject = xcodeProjectFile.readAsStringSync();
    expect(xcodeProject, contains('PRODUCT_BUNDLE_IDENTIFIER = com.foo.bar.flutterProject'));
    expect(xcodeProject, contains('LastUpgradeCheck = 1300;'));
    // Xcode workspace shared data
    final Directory workspaceSharedData = globals.fs.directory(globals.fs.path.join('.ios', 'Runner.xcworkspace', 'xcshareddata'));
    expectExists(workspaceSharedData.childFile('WorkspaceSettings.xcsettings').path);
    expectExists(workspaceSharedData.childFile('IDEWorkspaceChecks.plist').path);
    // Xcode project shared data
    final Directory projectSharedData = globals.fs.directory(globals.fs.path.join('.ios', 'Runner.xcodeproj', 'project.xcworkspace', 'xcshareddata'));
    expectExists(projectSharedData.childFile('WorkspaceSettings.xcsettings').path);
    expectExists(projectSharedData.childFile('IDEWorkspaceChecks.plist').path);


    final String versionPath = globals.fs.path.join('.metadata');
    expectExists(versionPath);
    final String version = globals.fs.file(globals.fs.path.join(projectDir.path, versionPath)).readAsStringSync();
    expect(version, contains('version:'));
    expect(version, contains('revision: 12345678'));
    expect(version, contains('channel: omega'));

    // IntelliJ metadata
    final String intelliJSdkMetadataPath = globals.fs.path.join('.idea', 'libraries', 'Dart_SDK.xml');
    expectExists(intelliJSdkMetadataPath);
    final String sdkMetaContents = globals.fs
        .file(globals.fs.path.join(
          projectDir.path,
          intelliJSdkMetadataPath,
        ))
        .readAsStringSync();
    expect(sdkMetaContents, contains('<root url="file:/'));
    expect(sdkMetaContents, contains('/bin/cache/dart-sdk/lib/core"'));
  }, overrides: <Type, Generator>{
    FlutterVersion: () => fakeFlutterVersion,
    Platform: _kNoColorTerminalPlatform,
  });

  testUsingContext('has correct default content and formatting with app template', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--template=app', '--no-pub', '--org', 'com.foo.bar', projectDir.path]);

    void expectExists(String relPath) {
      expect(globals.fs.isFileSync('${projectDir.path}/$relPath'), true);
    }

    expectExists('lib/main.dart');
    expectExists('test/widget_test.dart');

    for (final FileSystemEntity file in projectDir.listSync(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        final String original = file.readAsStringSync();

        final Process process = await Process.start(
          globals.artifacts!.getArtifactPath(Artifact.engineDartBinary),
          <String>['format', '--output=show', file.path],
          workingDirectory: projectDir.path,
        );
        final String formatted = await process.stdout.transform(utf8.decoder).join();

        expect(formatted, contains(original), reason: file.path);
      }
    }

    await _runFlutterTest(projectDir, target: globals.fs.path.join(projectDir.path, 'test', 'widget_test.dart'));

    // Generated Xcode settings
    final String xcodeConfigPath = globals.fs.path.join('ios', 'Flutter', 'Generated.xcconfig');
    expectExists(xcodeConfigPath);
    final File xcodeConfigFile = globals.fs.file(globals.fs.path.join(projectDir.path, xcodeConfigPath));
    final String xcodeConfig = xcodeConfigFile.readAsStringSync();
    expect(xcodeConfig, contains('FLUTTER_ROOT='));
    expect(xcodeConfig, contains('FLUTTER_APPLICATION_PATH='));
    expect(xcodeConfig, contains('COCOAPODS_PARALLEL_CODE_SIGN=true'));
    expect(xcodeConfig, contains('EXCLUDED_ARCHS[sdk=iphoneos*]=armv7'));
    // Xcode project
    final String xcodeProjectPath = globals.fs.path.join('ios', 'Runner.xcodeproj', 'project.pbxproj');
    expectExists(xcodeProjectPath);
    final File xcodeProjectFile = globals.fs.file(globals.fs.path.join(projectDir.path, xcodeProjectPath));
    final String xcodeProject = xcodeProjectFile.readAsStringSync();
    expect(xcodeProject, contains('PRODUCT_BUNDLE_IDENTIFIER = com.foo.bar.flutterProject'));
    expect(xcodeProject, contains('LastUpgradeCheck = 1300;'));
    // Xcode workspace shared data
    final Directory workspaceSharedData = globals.fs.directory(globals.fs.path.join('ios', 'Runner.xcworkspace', 'xcshareddata'));
    expectExists(workspaceSharedData.childFile('WorkspaceSettings.xcsettings').path);
    expectExists(workspaceSharedData.childFile('IDEWorkspaceChecks.plist').path);
    // Xcode project shared data
    final Directory projectSharedData = globals.fs.directory(globals.fs.path.join('ios', 'Runner.xcodeproj', 'project.xcworkspace', 'xcshareddata'));
    expectExists(projectSharedData.childFile('WorkspaceSettings.xcsettings').path);
    expectExists(projectSharedData.childFile('IDEWorkspaceChecks.plist').path);

    final String versionPath = globals.fs.path.join('.metadata');
    expectExists(versionPath);
    final String version = globals.fs.file(globals.fs.path.join(projectDir.path, versionPath)).readAsStringSync();
    expect(version, contains('version:'));
    expect(version, contains('revision: 12345678'));
    expect(version, contains('channel: omega'));

    // IntelliJ metadata
    final String intelliJSdkMetadataPath = globals.fs.path.join('.idea', 'libraries', 'Dart_SDK.xml');
    expectExists(intelliJSdkMetadataPath);
    final String sdkMetaContents = globals.fs
        .file(globals.fs.path.join(
          projectDir.path,
          intelliJSdkMetadataPath,
        ))
        .readAsStringSync();
    expect(sdkMetaContents, contains('<root url="file:/'));
    expect(sdkMetaContents, contains('/bin/cache/dart-sdk/lib/core"'));
  }, overrides: <Type, Generator>{
    FlutterVersion: () => fakeFlutterVersion,
    Platform: _kNoColorTerminalPlatform,
  });

  testUsingContext('has iOS development team with app template', () async {
    Cache.flutterRoot = '../..';

    final Completer<void> completer = Completer<void>();
    final StreamController<List<int>> controller = StreamController<List<int>>();
    const String certificates = '''
1) 86f7e437faa5a7fce15d1ddcb9eaeaea377667b8 "iPhone Developer: Profile 1 (1111AAAA11)"
    1 valid identities found''';
    fakeProcessManager.addCommands(<FakeCommand>[
      const FakeCommand(
        command: <String>['which', 'security'],
      ),
      const FakeCommand(
        command: <String>['which', 'openssl'],
      ),
      const FakeCommand(
        command: <String>['security', 'find-identity', '-p', 'codesigning', '-v'],
        stdout: certificates,
      ),
      const FakeCommand(
        command: <String>['security', 'find-certificate', '-c', '1111AAAA11', '-p'],
        stdout: 'This is a fake certificate',
      ),
      FakeCommand(
        command: const <String>['openssl', 'x509', '-subject'],
        stdin: IOSink(controller.sink),
        stdout: 'subject= /CN=iPhone Developer: Profile 1 (1111AAAA11)/OU=3333CCCC33/O=My Team/C=US',
      ),
    ]);

    controller.stream.listen((List<int> chunk) {
      completer.complete();
    });

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--template=app', '--no-pub', '--org', 'com.foo.bar', projectDir.path]);

    final String xcodeProjectPath = globals.fs.path.join('ios', 'Runner.xcodeproj', 'project.pbxproj');
    final File xcodeProjectFile = globals.fs.file(globals.fs.path.join(projectDir.path, xcodeProjectPath));
    expect(xcodeProjectFile, exists);
    final String xcodeProject = xcodeProjectFile.readAsStringSync();
    expect(xcodeProject, contains('DEVELOPMENT_TEAM = 3333CCCC33;'));
  }, overrides: <Type, Generator>{
    FlutterVersion: () => fakeFlutterVersion,
    Platform: _kNoColorTerminalMacOSPlatform,
    ProcessManager: () => fakeProcessManager,
  });

  testUsingContext('Correct info.plist key-value pairs for objc iOS project.', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--template=app', '--no-pub', '--org', 'com.foo.bar','--ios-language=objc', '--project-name=my_project', projectDir.path]);

    final String plistPath = globals.fs.path.join('ios', 'Runner', 'Info.plist');
    final File plistFile = globals.fs.file(globals.fs.path.join(projectDir.path, plistPath));
    expect(plistFile, exists);
    final bool disabled = _getBooleanValueFromPlist(plistFile: plistFile, key: 'CADisableMinimumFrameDurationOnPhone');
    expect(disabled, isTrue);
    final bool indirectInput = _getBooleanValueFromPlist(plistFile: plistFile, key: 'UIApplicationSupportsIndirectInputEvents');
    expect(indirectInput, isTrue);
    final String displayName = _getStringValueFromPlist(plistFile: plistFile, key: 'CFBundleDisplayName');
    expect(displayName, 'My Project');
  });

  testUsingContext('Correct info.plist key-value pairs for objc swift project.', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--template=app', '--no-pub', '--org', 'com.foo.bar','--ios-language=swift', '--project-name=my_project', projectDir.path]);

    final String plistPath = globals.fs.path.join('ios', 'Runner', 'Info.plist');
    final File plistFile = globals.fs.file(globals.fs.path.join(projectDir.path, plistPath));
    expect(plistFile, exists);
    final bool disabled = _getBooleanValueFromPlist(plistFile: plistFile, key: 'CADisableMinimumFrameDurationOnPhone');
    expect(disabled, isTrue);
    final bool indirectInput = _getBooleanValueFromPlist(plistFile: plistFile, key: 'UIApplicationSupportsIndirectInputEvents');
    expect(indirectInput, isTrue);
    final String displayName = _getStringValueFromPlist(plistFile: plistFile, key: 'CFBundleDisplayName');
    expect(displayName, 'My Project');
  });

  testUsingContext('Correct info.plist key-value pairs for objc iOS module.', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--template=module', '--org', 'com.foo.bar','--ios-language=objc', '--project-name=my_project', projectDir.path]);

    final String plistPath = globals.fs.path.join('.ios', 'Runner', 'Info.plist');
    final File plistFile = globals.fs.file(globals.fs.path.join(projectDir.path, plistPath));
    expect(plistFile, exists);
    final bool disabled = _getBooleanValueFromPlist(plistFile: plistFile, key: 'CADisableMinimumFrameDurationOnPhone');
    expect(disabled, isTrue);
    final bool indirectInput = _getBooleanValueFromPlist(plistFile: plistFile, key: 'UIApplicationSupportsIndirectInputEvents');
    expect(indirectInput, isTrue);
    final String displayName = _getStringValueFromPlist(plistFile: plistFile, key: 'CFBundleDisplayName');
    expect(displayName, 'My Project');
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('Correct info.plist key-value pairs for swift iOS module.', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--template=module', '--org', 'com.foo.bar','--ios-language=swift', '--project-name=my_project', projectDir.path]);

    final String plistPath = globals.fs.path.join('.ios', 'Runner', 'Info.plist');
    final File plistFile = globals.fs.file(globals.fs.path.join(projectDir.path, plistPath));
    expect(plistFile, exists);
    final bool disabled = _getBooleanValueFromPlist(plistFile: plistFile, key: 'CADisableMinimumFrameDurationOnPhone');
    expect(disabled, isTrue);
    final bool indirectInput = _getBooleanValueFromPlist(plistFile: plistFile, key: 'UIApplicationSupportsIndirectInputEvents');
    expect(indirectInput, isTrue);
    final String displayName = _getStringValueFromPlist(plistFile: plistFile, key: 'CFBundleDisplayName');
    expect(displayName, 'My Project');
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('Correct info.plist key-value pairs for swift iOS plugin.', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--template=plugin', '--no-pub', '--org', 'com.foo.bar', '--platforms=ios', '--ios-language=swift', '--project-name=my_project', projectDir.path]);

    final String plistPath = globals.fs.path.join('example', 'ios', 'Runner', 'Info.plist');
    final File plistFile = globals.fs.file(globals.fs.path.join(projectDir.path, plistPath));
    expect(plistFile, exists);
    final bool disabled = _getBooleanValueFromPlist(plistFile: plistFile, key: 'CADisableMinimumFrameDurationOnPhone');
    expect(disabled, isTrue);
    final bool indirectInput = _getBooleanValueFromPlist(plistFile: plistFile, key: 'UIApplicationSupportsIndirectInputEvents');
    expect(indirectInput, isTrue);
    final String displayName = _getStringValueFromPlist(plistFile: plistFile, key: 'CFBundleDisplayName');
    expect(displayName, 'My Project');
  });

  testUsingContext('Correct info.plist key-value pairs for objc iOS plugin.', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--template=plugin', '--no-pub', '--org', 'com.foo.bar', '--platforms=ios', '--ios-language=objc', '--project-name=my_project', projectDir.path]);

    final String plistPath = globals.fs.path.join('example', 'ios', 'Runner', 'Info.plist');
    final File plistFile = globals.fs.file(globals.fs.path.join(projectDir.path, plistPath));
    expect(plistFile, exists);
    final bool disabled = _getBooleanValueFromPlist(plistFile: plistFile, key: 'CADisableMinimumFrameDurationOnPhone');
    expect(disabled, isTrue);
    final bool indirectInput = _getBooleanValueFromPlist(plistFile: plistFile, key: 'UIApplicationSupportsIndirectInputEvents');
    expect(indirectInput, isTrue);
    final String displayName = _getStringValueFromPlist(plistFile: plistFile, key: 'CFBundleDisplayName');
    expect(displayName, 'My Project');
  });

  testUsingContext('has correct content and formatting with macOS app template', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--template=app', '--platforms=macos', '--no-pub', '--org', 'com.foo.bar', projectDir.path]);

    void expectExists(String relPath) {
      expect(globals.fs.isFileSync('${projectDir.path}/$relPath'), true);
    }

    // Generated Xcode settings
    final String macosXcodeConfigPath = globals.fs.path.join('macos', 'Runner', 'Configs', 'AppInfo.xcconfig');
    expectExists(macosXcodeConfigPath);
    final File macosXcodeConfigFile = globals.fs.file(globals.fs.path.join(projectDir.path, macosXcodeConfigPath));
    final String macosXcodeConfig = macosXcodeConfigFile.readAsStringSync();
    expect(macosXcodeConfig, contains('PRODUCT_NAME = flutter_project'));
    expect(macosXcodeConfig, contains('PRODUCT_BUNDLE_IDENTIFIER = com.foo.bar.flutterProject'));
    expect(macosXcodeConfig, contains('PRODUCT_COPYRIGHT ='));

    // Xcode project
    final String xcodeProjectPath = globals.fs.path.join('macos', 'Runner.xcodeproj', 'project.pbxproj');
    expectExists(xcodeProjectPath);
    final File xcodeProjectFile = globals.fs.file(globals.fs.path.join(projectDir.path, xcodeProjectPath));
    final String xcodeProject = xcodeProjectFile.readAsStringSync();
    expect(xcodeProject, contains('path = "flutter_project.app";'));
    expect(xcodeProject, contains('LastUpgradeCheck = 1300;'));

    // Xcode workspace shared data
    final Directory workspaceSharedData = globals.fs.directory(globals.fs.path.join('macos', 'Runner.xcworkspace', 'xcshareddata'));
    expectExists(workspaceSharedData.childFile('IDEWorkspaceChecks.plist').path);
    // Xcode project shared data
    final Directory projectSharedData = globals.fs.directory(globals.fs.path.join('macos', 'Runner.xcodeproj', 'project.xcworkspace', 'xcshareddata'));
    expectExists(projectSharedData.childFile('IDEWorkspaceChecks.plist').path);
  }, overrides: <Type, Generator>{
    Platform: _kNoColorTerminalPlatform,
    FeatureFlags: () => TestFeatureFlags(isMacOSEnabled: true),
  });

  testUsingContext('has correct application id for android, bundle id for ios and application id for Linux', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    String tmpProjectDir = globals.fs.path.join(tempDir.path, 'hello_flutter');
    await runner.run(<String>['create', '--template=app', '--no-pub', '--org', 'com.example', tmpProjectDir]);
    FlutterProject project = FlutterProject.fromDirectory(globals.fs.directory(tmpProjectDir));
    expect(
      await project.ios.productBundleIdentifier(BuildInfo.debug),
      'com.example.helloFlutter',
    );
    expect(
      await project.ios.productBundleIdentifier(BuildInfo.profile),
      'com.example.helloFlutter',
    );
    expect(
      await project.ios.productBundleIdentifier(BuildInfo.release),
      'com.example.helloFlutter',
    );
    expect(
      await project.ios.productBundleIdentifier(null),
      'com.example.helloFlutter',
    );
    expect(
        project.android.applicationId,
        'com.example.hello_flutter',
    );
    expect(
        project.linux.applicationId,
        'com.example.hello_flutter',
    );

    tmpProjectDir = globals.fs.path.join(tempDir.path, 'test_abc');
    await runner.run(<String>['create', '--template=app', '--no-pub', '--org', 'abc^*.1#@', tmpProjectDir]);
    project = FlutterProject.fromDirectory(globals.fs.directory(tmpProjectDir));
    expect(
        await project.ios.productBundleIdentifier(BuildInfo.debug),
        'abc.1.testAbc',
    );
    expect(
        project.android.applicationId,
        'abc.u1.test_abc',
    );

    tmpProjectDir = globals.fs.path.join(tempDir.path, 'flutter_project');
    await runner.run(<String>['create', '--template=app', '--no-pub', '--org', '#+^%', tmpProjectDir]);
    project = FlutterProject.fromDirectory(globals.fs.directory(tmpProjectDir));
    expect(
        await project.ios.productBundleIdentifier(BuildInfo.debug),
        'flutterProject.untitled',
    );
    expect(
        project.android.applicationId,
        'flutter_project.untitled',
    );
    expect(
        project.linux.applicationId,
        'flutter_project.untitled',
    );
  }, overrides: <Type, Generator>{
    FlutterVersion: () => fakeFlutterVersion,
    Platform: _kNoColorTerminalPlatform,
    FeatureFlags: () => TestFeatureFlags(isLinuxEnabled: true),
  });

  testUsingContext('can re-gen default template over existing project', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);

    final String metadata = globals.fs.file(globals.fs.path.join(projectDir.path, '.metadata')).readAsStringSync();
    expect(LineSplitter.split(metadata), contains('project_type: app'));
  });

  testUsingContext('can re-gen default template over existing app project with no metadta and detect the type', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=app', projectDir.path]);

    // Remove the .metadata to simulate an older instantiation that didn't generate those.
    globals.fs.file(globals.fs.path.join(projectDir.path, '.metadata')).deleteSync();

    await runner.run(<String>['create', '--no-pub', projectDir.path]);

    final String metadata = globals.fs.file(globals.fs.path.join(projectDir.path, '.metadata')).readAsStringSync();
    expect(LineSplitter.split(metadata), contains('project_type: app'));
  });

  testUsingContext('can re-gen app template over existing app project and detect the type', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=app', projectDir.path]);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);

    final String metadata = globals.fs.file(globals.fs.path.join(projectDir.path, '.metadata')).readAsStringSync();
    expect(LineSplitter.split(metadata), contains('project_type: app'));
  });

  testUsingContext('can re-gen template over existing module project and detect the type', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=module', projectDir.path]);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);

    final String metadata = globals.fs.file(globals.fs.path.join(projectDir.path, '.metadata')).readAsStringSync();
    expect(LineSplitter.split(metadata), contains('project_type: module'));
  });

  testUsingContext('can re-gen default template over existing plugin project and detect the type', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);

    final String metadata = globals.fs.file(globals.fs.path.join(projectDir.path, '.metadata')).readAsStringSync();
    expect(LineSplitter.split(metadata), contains('project_type: plugin'));
  });

  testUsingContext('can re-gen default template over existing package project and detect the type', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=package', projectDir.path]);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);

    final String metadata = globals.fs.file(globals.fs.path.join(projectDir.path, '.metadata')).readAsStringSync();
    expect(LineSplitter.split(metadata), contains('project_type: package'));
  });

  testUsingContext('can re-gen module .android/ folder, reusing custom org', () async {
    await _createProject(
      projectDir,
      <String>['--template=module', '--org', 'com.bar.foo'],
      <String>[],
    );
    projectDir.childDirectory('.android').deleteSync(recursive: true);
    return _createProject(
      projectDir,
      <String>[],
      <String>[
        '.android/app/src/main/java/com/bar/foo/flutter_project/host/MainActivity.java',
      ],
    );
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('can re-gen module .ios/ folder, reusing custom org', () async {
    await _createProject(
      projectDir,
      <String>['--template=module', '--org', 'com.bar.foo'],
      <String>[],
    );
    projectDir.childDirectory('.ios').deleteSync(recursive: true);
    await _createProject(projectDir, <String>[], <String>[]);
    final FlutterProject project = FlutterProject.fromDirectory(projectDir);
    expect(
      await project.ios.productBundleIdentifier(BuildInfo.debug),
      'com.bar.foo.flutterProject',
    );
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('can re-gen app android/ folder, reusing custom org', () async {
    await _createProject(
      projectDir,
      <String>[
        '--no-pub',
        '--template=app',
        '--org', 'com.bar.foo',
        '-i', 'objc',
        '-a', 'java',
      ],
      <String>[],
    );
    projectDir.childDirectory('android').deleteSync(recursive: true);
    return _createProject(
      projectDir,
      <String>['--no-pub', '-i', 'objc', '-a', 'java'],
      <String>[
        'android/app/src/main/java/com/bar/foo/flutter_project/MainActivity.java',
      ],
      unexpectedPaths: <String>[
        'android/app/src/main/java/com/example/flutter_project/MainActivity.java',
      ],
    );
  });

  testUsingContext('can re-gen app ios/ folder, reusing custom org', () async {
    await _createProject(
      projectDir,
      <String>['--no-pub', '--template=app', '--org', 'com.bar.foo'],
      <String>[],
    );
    projectDir.childDirectory('ios').deleteSync(recursive: true);
    await _createProject(projectDir, <String>['--no-pub'], <String>[]);
    final FlutterProject project = FlutterProject.fromDirectory(projectDir);
    expect(
      await project.ios.productBundleIdentifier(BuildInfo.debug),
      'com.bar.foo.flutterProject',
    );
  });

  testUsingContext('can re-gen plugin ios/ and example/ folders, reusing custom org', () async {
    await _createProject(
      projectDir,
      <String>[
        '--no-pub',
        '--template=plugin',
        '--org', 'com.bar.foo',
        '-i', 'objc',
        '-a', 'java',
        '--platforms', 'ios,android',
      ],
      <String>[],
    );
    projectDir.childDirectory('example').deleteSync(recursive: true);
    projectDir.childDirectory('ios').deleteSync(recursive: true);
    await _createProject(
      projectDir,
      <String>['--no-pub', '--template=plugin', '-i', 'objc', '-a', 'java', '--platforms', 'ios,android'],
      <String>[
        'example/android/app/src/main/java/com/bar/foo/flutter_project_example/MainActivity.java',
        'ios/Classes/FlutterProjectPlugin.h',
      ],
      unexpectedPaths: <String>[
        'example/android/app/src/main/java/com/example/flutter_project_example/MainActivity.java',
        'android/src/main/java/com/example/flutter_project/FlutterProjectPlugin.java',
      ],
    );
    final FlutterProject project = FlutterProject.fromDirectory(projectDir);
    expect(
      await project.example.ios.productBundleIdentifier(BuildInfo.debug),
      'com.bar.foo.flutterProjectExample',
    );
  });

  testUsingContext('fails to re-gen without specified org when org is ambiguous', () async {
    await _createProject(
      projectDir,
      <String>['--no-pub', '--template=app', '--org', 'com.bar.foo'],
      <String>[],
    );
    globals.fs.directory(globals.fs.path.join(projectDir.path, 'ios')).deleteSync(recursive: true);
    await _createProject(
      projectDir,
      <String>['--no-pub', '--template=app', '--org', 'com.bar.baz'],
      <String>[],
    );
    expect(
      () => _createProject(projectDir, <String>[], <String>[]),
      throwsToolExit(message: 'Ambiguous organization'),
    );
  });

  testUsingContext('fails when file exists where output directory should be', () async {
    Cache.flutterRoot = '../..';
    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    final File existingFile = globals.fs.file(globals.fs.path.join(projectDir.path, 'bad'));
    if (!existingFile.existsSync()) {
      existingFile.createSync(recursive: true);
    }
    expect(
      runner.run(<String>['create', existingFile.path]),
      throwsToolExit(message: 'existing file'),
    );
  });

  testUsingContext('fails overwrite when file exists where output directory should be', () async {
    Cache.flutterRoot = '../..';
    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    final File existingFile = globals.fs.file(globals.fs.path.join(projectDir.path, 'bad'));
    if (!existingFile.existsSync()) {
      existingFile.createSync(recursive: true);
    }
    expect(
      runner.run(<String>['create', '--overwrite', existingFile.path]),
      throwsToolExit(message: 'existing file'),
    );
  });

  testUsingContext('overwrites existing directory when requested', () async {
    Cache.flutterRoot = '../..';
    final Directory existingDirectory = globals.fs.directory(globals.fs.path.join(projectDir.path, 'bad'));
    if (!existingDirectory.existsSync()) {
      existingDirectory.createSync(recursive: true);
    }
    final File existingFile = globals.fs.file(globals.fs.path.join(existingDirectory.path, 'lib', 'main.dart'));
    existingFile.createSync(recursive: true);
    await _createProject(
      globals.fs.directory(existingDirectory.path),
      <String>['--overwrite', '-i', 'objc', '-a', 'java'],
      <String>[
        'android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java',
        'lib/main.dart',
        'ios/Flutter/AppFrameworkInfo.plist',
        'ios/Runner/AppDelegate.m',
        'ios/Runner/GeneratedPluginRegistrant.h',
      ],
    );
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext(
    'invokes pub in online and offline modes',
    () async {
      Cache.flutterRoot = '../..';

      final CreateCommand command = CreateCommand();
      final CommandRunner<void> runner = createTestCommandRunner(command);

      // Run pub online first in order to populate the pub cache.
      await runner.run(<String>['create', '--pub', projectDir.path]);
      final RegExp dartCommand = RegExp(r'dart-sdk[\\/]bin[\\/]dart');
      expect(loggingProcessManager.commands, contains(predicate(
        (List<String> c) => dartCommand.hasMatch(c[0]) && c[1].contains('pub') && !c.contains('--offline')
      )));

      // Run pub offline.
      loggingProcessManager.clear();
      await runner.run(<String>['create', '--pub', '--offline', projectDir.path]);
      expect(loggingProcessManager.commands, contains(predicate(
        (List<String> c) => dartCommand.hasMatch(c[0]) && c[1].contains('pub') && c.contains('--offline')
      )));
    },
    overrides: <Type, Generator>{
      ProcessManager: () => loggingProcessManager,
      Pub: () => Pub.test(
        fileSystem: globals.fs,
        logger: globals.logger,
        processManager: globals.processManager,
        usage: globals.flutterUsage,
        botDetector: globals.botDetector,
        platform: globals.platform,
        stdio: mockStdio,
      ),
    },
  );

  testUsingContext('can create an empty application project', () async {
    await _createAndAnalyzeProject(
      projectDir,
      <String>['--no-pub', '--empty'],
      <String>[
        'lib/main.dart',
        'flutter_project.iml',
        'android/app/src/main/AndroidManifest.xml',
        'ios/Flutter/AppFrameworkInfo.plist',
      ],
      unexpectedPaths: <String>['test'],
    );
    expect(projectDir.childDirectory('lib').childFile('main.dart').readAsStringSync(),
      contains("Text('Hello World!')"));
    expect(projectDir.childDirectory('lib').childFile('main.dart').readAsStringSync(),
      isNot(contains('int _counter')));
    expect(projectDir.childFile('analysis_options.yaml').readAsStringSync(),
      isNot(contains('#')));
    expect(projectDir.childFile('README.md').readAsStringSync(),
      isNot(contains('Getting Started')));
  });

  testUsingContext('can create a sample-based project', () async {
    await _createAndAnalyzeProject(
      projectDir,
      <String>['--no-pub', '--sample=foo.bar.Baz'],
      <String>[
        'lib/main.dart',
        'flutter_project.iml',
        'android/app/src/main/AndroidManifest.xml',
        'ios/Flutter/AppFrameworkInfo.plist',
      ],
      unexpectedPaths: <String>['test'],
    );
    expect(projectDir.childDirectory('lib').childFile('main.dart').readAsStringSync(),
      contains('void main() {}'));
  }, overrides: <Type, Generator>{
    HttpClientFactory: () {
      return () {
        return FakeHttpClient.list(<FakeRequest>[
          FakeRequest(
            Uri.parse('https://master-api.flutter.dev/snippets/foo.bar.Baz.dart'),
            response: FakeResponse(body: utf8.encode('void main() {}')),
          ),
        ]);
      };
    },
  });

  testUsingContext('null-safe sample-based project have no analyzer errors', () async {
    await _createAndAnalyzeProject(
      projectDir,
      <String>['--no-pub', '--sample=foo.bar.Baz'],
      <String>['lib/main.dart'],
    );
    expect(
      projectDir.childDirectory('lib').childFile('main.dart').readAsStringSync(),
      contains('String?'), // uses null-safe syntax
    );
  }, overrides: <Type, Generator>{
    HttpClientFactory: () {
      return () {
        return FakeHttpClient.list(<FakeRequest>[
          FakeRequest(
            Uri.parse('https://master-api.flutter.dev/snippets/foo.bar.Baz.dart'),
            response: FakeResponse(body: utf8.encode('void main() { String? foo; print(foo); } // ignore: avoid_print')),
          ),
        ]);
      };
    },
  });

  testUsingContext('can write samples index to disk', () async {
    final String outputFile = globals.fs.path.join(tempDir.path, 'flutter_samples.json');
    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    final List<String> args = <String>[
      'create',
      '--list-samples',
      outputFile,
    ];

    await runner.run(args);
    final File expectedFile = globals.fs.file(outputFile);
    expect(expectedFile, exists);
    expect(expectedFile.readAsStringSync(), equals(samplesIndexJson));
  }, overrides: <Type, Generator>{
    HttpClientFactory: () {
      return () {
        return FakeHttpClient.list(<FakeRequest>[
          FakeRequest(
            Uri.parse('https://master-api.flutter.dev/snippets/index.json'),
            response: FakeResponse(body: utf8.encode(samplesIndexJson)),
          ),
        ]);
      };
    },
  });

  testUsingContext('Throws tool exit on empty samples index', () async {
    final String outputFile = globals.fs.path.join(tempDir.path, 'flutter_samples.json');
    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    final List<String> args = <String>[
      'create',
      '--list-samples',
      outputFile,
    ];

    await expectLater(
      runner.run(args),
      throwsToolExit(
        exitCode: 2,
        message: 'Unable to download samples',
    ));
  }, overrides: <Type, Generator>{
    HttpClientFactory: () {
      return () {
        return FakeHttpClient.list(<FakeRequest>[
          FakeRequest(
            Uri.parse('https://master-api.flutter.dev/snippets/index.json'),
          ),
        ]);
      };
    },
  });

  testUsingContext('provides an error to the user if samples json download fails', () async {
    final String outputFile = globals.fs.path.join(tempDir.path, 'flutter_samples.json');
    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    final List<String> args = <String>[
      'create',
      '--list-samples',
      outputFile,
    ];

    await expectLater(runner.run(args), throwsToolExit(exitCode: 2, message: 'Failed to write samples'));
    expect(globals.fs.file(outputFile), isNot(exists));
  }, overrides: <Type, Generator>{
    HttpClientFactory: () {
      return () {
        return FakeHttpClient.list(<FakeRequest>[
          FakeRequest(
            Uri.parse('https://master-api.flutter.dev/snippets/index.json'),
            response: const FakeResponse(statusCode: HttpStatus.notFound),
          ),
        ]);
      };
    },
  });

  testUsingContext('plugin does not support any platform by default', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);

    expect(projectDir.childDirectory('ios'), isNot(exists));
    expect(projectDir.childDirectory('android'), isNot(exists));
    expect(projectDir.childDirectory('web'), isNot(exists));
    expect(projectDir.childDirectory('linux'), isNot(exists));
    expect(projectDir.childDirectory('windows'), isNot(exists));
    expect(projectDir.childDirectory('macos'), isNot(exists));

    expect(projectDir.childDirectory('example').childDirectory('ios'),
        isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('android'),
        isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('web'),
        isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('linux'),
        isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('windows'),
        isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('macos'),
        isNot(exists));
    validatePubspecForPlugin(projectDir: projectDir.absolute.path, expectedPlatforms: <String>[
      'some_platform',
    ], pluginClass: 'somePluginClass',
    unexpectedPlatforms: <String>[ 'ios', 'android', 'web', 'linux', 'windows', 'macos']);
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
  });

  testUsingContext('plugin creates platform interface by default', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);

    expect(projectDir.childDirectory('lib').childFile('flutter_project_method_channel.dart'),
      exists);
    expect(projectDir.childDirectory('lib').childFile('flutter_project_platform_interface.dart'),
      exists);

  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
  });

  testUsingContext('plugin passes analysis and unit tests', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);

    await _getPackages(projectDir);
    await _analyzeProject(projectDir.path);
    await _runFlutterTest(projectDir);
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
  });

  testUsingContext('plugin example passes analysis and unit tests', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);

    final Directory exampleDir = projectDir.childDirectory('example');

    await _getPackages(exampleDir);
    await _analyzeProject(exampleDir.path);
    await _runFlutterTest(exampleDir);
  });

  testUsingContext('plugin supports ios if requested', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=ios', projectDir.path]);

    expect(projectDir.childDirectory('ios'), exists);
    expect(projectDir.childDirectory('example').childDirectory('ios'), exists);
    validatePubspecForPlugin(projectDir: projectDir.absolute.path, expectedPlatforms: <String>[
      'ios',
    ], pluginClass: 'FlutterProjectPlugin',
    unexpectedPlatforms: <String>['some_platform']);
    expect(logger.errorText, isNot(contains(_kNoPlatformsMessage)));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
    Logger: () => logger,
  });

  testUsingContext('plugin supports android if requested', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=android', projectDir.path]);

    expect(projectDir.childDirectory('android'), exists);
    expect(
        projectDir.childDirectory('example').childDirectory('android'), exists);
    validatePubspecForPlugin(projectDir: projectDir.absolute.path, expectedPlatforms: const <String>[
      'android',
    ], pluginClass: 'FlutterProjectPlugin',
    unexpectedPlatforms: <String>['some_platform'],
    androidIdentifier: 'com.example.flutter_project');
    expect(logger.errorText, isNot(contains(_kNoPlatformsMessage)));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
    Logger: () => logger,
  });

  testUsingContext('plugin supports web if requested', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=web', projectDir.path]);
    expect(
        projectDir.childDirectory('lib').childFile('flutter_project_web.dart'),
        exists);
    validatePubspecForPlugin(projectDir: projectDir.absolute.path, expectedPlatforms: const <String>[
      'web',
    ], pluginClass: 'FlutterProjectWeb',
    unexpectedPlatforms: <String>['some_platform'],
    androidIdentifier: 'com.example.flutter_project',
    webFileName: 'flutter_project_web.dart');
    expect(logger.errorText, isNot(contains(_kNoPlatformsMessage)));

    await _getPackages(projectDir);
    await _analyzeProject(projectDir.path);
    await _runFlutterTest(projectDir);
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWebEnabled: true),
    Logger: () => logger,
  });

  testUsingContext('plugin does not support web if feature is not enabled', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=web', projectDir.path]);
    expect(
        projectDir.childDirectory('lib').childFile('flutter_project_web.dart'),
        isNot(exists));
    validatePubspecForPlugin(projectDir: projectDir.absolute.path, expectedPlatforms: const <String>[
      'some_platform',
    ], pluginClass: 'somePluginClass',
    unexpectedPlatforms: <String>['web']);
    expect(logger.errorText, contains(_kNoPlatformsMessage));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
    Logger: () => logger,
  });

  testUsingContext('create an empty plugin, then add ios', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=ios', projectDir.path]);

    expect(projectDir.childDirectory('ios'), exists);
    expect(projectDir.childDirectory('example').childDirectory('ios'), exists);
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
  });

  testUsingContext('create an empty plugin, then add android', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=android', projectDir.path]);

    expect(projectDir.childDirectory('android'), exists);
    expect(
        projectDir.childDirectory('example').childDirectory('android'), exists);
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
  });

  testUsingContext('create an empty plugin, then add linux', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=linux', projectDir.path]);

    expect(projectDir.childDirectory('linux'), exists);
    expect(
        projectDir.childDirectory('example').childDirectory('linux'), exists);
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isLinuxEnabled: true),
  });

  testUsingContext('create an empty plugin, then add macos', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=macos', projectDir.path]);

    expect(projectDir.childDirectory('macos'), exists);
    expect(
        projectDir.childDirectory('example').childDirectory('macos'), exists);
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isMacOSEnabled: true),
  });

  testUsingContext('create an empty plugin, then add windows', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=windows', projectDir.path]);

    expect(projectDir.childDirectory('windows'), exists);
    expect(
        projectDir.childDirectory('example').childDirectory('windows'), exists);
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWindowsEnabled: true),
  });

  testUsingContext('create an empty plugin, then add web', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=web', projectDir.path]);

    expect(
        projectDir.childDirectory('lib').childFile('flutter_project_web.dart'),
        exists);
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWebEnabled: true),
  });

  testUsingContext('create a plugin with ios, then add macos', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=ios', projectDir.path]);
    expect(projectDir.childDirectory('ios'), exists);
    expect(projectDir.childDirectory('example').childDirectory('ios'), exists);
    validatePubspecForPlugin(projectDir: projectDir.absolute.path, expectedPlatforms: const <String>[
      'ios',
    ], pluginClass: 'FlutterProjectPlugin',
    unexpectedPlatforms: <String>['some_platform']);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=macos', projectDir.path]);
    expect(projectDir.childDirectory('macos'), exists);
    expect(
        projectDir.childDirectory('example').childDirectory('macos'), exists);
    expect(projectDir.childDirectory('ios'), exists);
    expect(projectDir.childDirectory('example').childDirectory('ios'), exists);
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isMacOSEnabled: true),
  });

  testUsingContext('create a plugin with ios and android', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platforms=ios,android', projectDir.path]);
    expect(projectDir.childDirectory('ios'), exists);
    expect(projectDir.childDirectory('example').childDirectory('ios'), exists);

    expect(projectDir.childDirectory('android'), exists);
    expect(
        projectDir.childDirectory('example').childDirectory('android'), exists);
    expect(projectDir.childDirectory('ios'), exists);
    expect(projectDir.childDirectory('example').childDirectory('ios'), exists);
    validatePubspecForPlugin(projectDir: projectDir.absolute.path, expectedPlatforms: const <String>[
      'ios', 'android',
    ], pluginClass: 'FlutterProjectPlugin',
    unexpectedPlatforms: <String>['some_platform'],
    androidIdentifier: 'com.example.flutter_project');
  });

  testUsingContext('create a module with --platforms throws error.', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await expectLater(
      runner.run(<String>['create', '--no-pub', '--template=module', '--platform=ios', projectDir.path])
      , throwsToolExit(message: 'The "--platforms" argument is not supported', exitCode:2));
  });

  testUsingContext('create a package with --platforms throws error.', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await expectLater(
      runner.run(<String>['create', '--no-pub', '--template=package', '--platform=ios', projectDir.path])
      , throwsToolExit(message: 'The "--platforms" argument is not supported', exitCode: 2));
  });

  testUsingContext('create a plugin with android, delete then re-create folders', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=android', projectDir.path]);
    expect(projectDir.childDirectory('android'), exists);
    expect(
        projectDir.childDirectory('example').childDirectory('android'), exists);

    globals.fs.file(globals.fs.path.join(projectDir.path, 'android')).deleteSync(recursive: true);
    globals.fs.file(globals.fs.path.join(projectDir.path, 'example/android')).deleteSync(recursive: true);
    expect(projectDir.childDirectory('android'), isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('android'),
        isNot(exists));

    await runner.run(<String>['create', '--no-pub', projectDir.path]);

    expect(projectDir.childDirectory('android'), exists);
    expect(
        projectDir.childDirectory('example').childDirectory('android'), exists);
  });

  testUsingContext('create a plugin with android, delete then re-create folders while also adding windows', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=android', projectDir.path]);
    expect(projectDir.childDirectory('android'), exists);
    expect(
        projectDir.childDirectory('example').childDirectory('android'), exists);

    globals.fs.file(globals.fs.path.join(projectDir.path, 'android')).deleteSync(recursive: true);
    globals.fs.file(globals.fs.path.join(projectDir.path, 'example/android')).deleteSync(recursive: true);
    expect(projectDir.childDirectory('android'), isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('android'),
        isNot(exists));

    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=windows', projectDir.path]);

    expect(projectDir.childDirectory('android'), exists);
    expect(
        projectDir.childDirectory('example').childDirectory('android'), exists);
    expect(projectDir.childDirectory('windows'), exists);
    expect(
        projectDir.childDirectory('example').childDirectory('windows'), exists);
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWindowsEnabled: true),
  });

  testUsingContext('flutter create . on and existing plugin does not add android folders if android is not supported in pubspec', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=ios', projectDir.path]);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);
    expect(projectDir.childDirectory('android'), isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('android'), isNot(exists));
  });

  testUsingContext('flutter create . on and existing plugin does not add windows folder even feature is enabled', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=android', projectDir.path]);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);
    expect(projectDir.childDirectory('windows'), isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('windows'), isNot(exists));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWindowsEnabled: true),
  });

  testUsingContext('flutter create . on and existing plugin does not add linux folder even feature is enabled', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=android', projectDir.path]);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);
    expect(projectDir.childDirectory('linux'), isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('linux'), isNot(exists));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isLinuxEnabled: true),
  });

  testUsingContext('flutter create . on and existing plugin does not add web files even feature is enabled', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=android', projectDir.path]);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);
    expect(projectDir.childDirectory('lib').childFile('flutter_project_web.dart'), isNot(exists));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWebEnabled: true),
  });

  testUsingContext('flutter create . on and existing plugin does not add macos folder even feature is enabled', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=android', projectDir.path]);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);
    expect(projectDir.childDirectory('macos'), isNot(exists));
    expect(projectDir.childDirectory('example').childDirectory('macos'), isNot(exists));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isMacOSEnabled: true),
  });

  testUsingContext('flutter create . on and existing plugin should show "Your example app code in"', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    final String projectDirPath = globals.fs.path.normalize(projectDir.absolute.path);
    final String relativePluginPath = globals.fs.path.normalize(globals.fs.path.relative(projectDirPath));
    final String relativeExamplePath = globals.fs.path.normalize(globals.fs.path.join(relativePluginPath, 'example/lib/main.dart'));

    await runner.run(<String>['create', '--no-pub', '--org=com.example', '--template=plugin', '--platform=android', projectDir.path]);
    expect(logger.statusText, contains('Your example app code is in $relativeExamplePath.\n'));
    await runner.run(<String>['create', '--no-pub', '--org=com.example', '--template=plugin', '--platform=ios', projectDir.path]);
    expect(logger.statusText, contains('Your example app code is in $relativeExamplePath.\n'));
    await runner.run(<String>['create', '--no-pub', projectDir.path]);
    expect(logger.statusText, contains('Your example app code is in $relativeExamplePath.\n'));
  }, overrides: <Type, Generator> {
    Logger: () => logger,
  });

  testUsingContext('flutter create -t plugin in an empty folder should not show pubspec.yaml updating suggestion', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=android', projectDir.path]);
    final String projectDirPath = globals.fs.path.normalize(projectDir.absolute.path);
    final String relativePluginPath = globals.fs.path.normalize(globals.fs.path.relative(projectDirPath));
    expect(logger.statusText, isNot(contains('You need to update $relativePluginPath/pubspec.yaml to support android.\n')));
  }, overrides: <Type, Generator> {
    Logger: () => logger,
  });

  testUsingContext('flutter create -t plugin in an existing plugin should show pubspec.yaml updating suggestion', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    final String projectDirPath = globals.fs.path.normalize(projectDir.absolute.path);
    final String relativePluginPath = globals.fs.path.normalize(globals.fs.path.relative(projectDirPath));
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=ios', projectDir.path]);
    expect(logger.statusText, isNot(contains('You need to update $relativePluginPath/pubspec.yaml to support ios.\n')));
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=android', projectDir.path]);
    expect(logger.statusText, contains('You need to update $relativePluginPath/pubspec.yaml to support android.\n'));
  }, overrides: <Type, Generator> {
    Logger: () => logger,
  });

  testUsingContext('newly created plugin has min flutter sdk version as 2.5.0', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);
    final String rawPubspec = await projectDir.childFile('pubspec.yaml').readAsString();
    final Pubspec pubspec = Pubspec.parse(rawPubspec);
    final Map<String, VersionConstraint?> env = pubspec.environment!;
    expect(env['flutter']!.allows(Version(2, 5, 0)), true);
    expect(env['flutter']!.allows(Version(2, 4, 9)), false);
  });

  testUsingContext('default app uses flutter default versions', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', projectDir.path]);

    expect(globals.fs.isFileSync('${projectDir.path}/android/app/build.gradle'), true);

    final String buildContent = await globals.fs.file('${projectDir.path}/android/app/build.gradle').readAsString();

    expect(buildContent.contains('compileSdkVersion flutter.compileSdkVersion'), true);
    expect(buildContent.contains('ndkVersion flutter.ndkVersion'), true);
    expect(buildContent.contains('targetSdkVersion flutter.targetSdkVersion'), true);
  });

  testUsingContext('Linux plugins handle partially camel-case project names correctly', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    const String projectName = 'foo_BarBaz';
    final Directory projectDir = tempDir.childDirectory(projectName);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=linux', '--skip-name-checks', projectDir.path]);
    final Directory platformDir = projectDir.childDirectory('linux');

    const String classFilenameBase = 'foo_bar_baz_plugin';
    const String headerName = '$classFilenameBase.h';
    final File headerFile = platformDir
        .childDirectory('include')
        .childDirectory(projectName)
        .childFile(headerName);
    final File implFile = platformDir.childFile('$classFilenameBase.cc');
    // Ensure that the files have the right names.
    expect(headerFile, exists);
    expect(implFile, exists);
    // Ensure that the include is correct.
    expect(implFile.readAsStringSync(), contains(headerName));
    // Ensure that the CMake file has the right target and source values.
    final String cmakeContents = platformDir.childFile('CMakeLists.txt').readAsStringSync();
    expect(cmakeContents, contains('"$classFilenameBase.cc"'));
    expect(cmakeContents, contains('set(PLUGIN_NAME "foo_BarBaz_plugin")'));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isLinuxEnabled: true),
  });

  testUsingContext('Windows plugins handle partially camel-case project names correctly', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    const String projectName = 'foo_BarBaz';
    final Directory projectDir = tempDir.childDirectory(projectName);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=windows', '--skip-name-checks', projectDir.path]);
    final Directory platformDir = projectDir.childDirectory('windows');

    const String classFilenameBase = 'foo_bar_baz_plugin';
    const String cApiHeaderName = '${classFilenameBase}_c_api.h';
    const String pluginClassHeaderName = '$classFilenameBase.h';
    final File cApiHeaderFile = platformDir
        .childDirectory('include')
        .childDirectory(projectName)
        .childFile(cApiHeaderName);
    final File cApiImplFile = platformDir.childFile('${classFilenameBase}_c_api.cpp');
    final File pluginClassHeaderFile = platformDir.childFile(pluginClassHeaderName);
    final File pluginClassImplFile = platformDir.childFile('$classFilenameBase.cpp');
    // Ensure that the files have the right names.
    expect(cApiHeaderFile, exists);
    expect(cApiImplFile, exists);
    expect(pluginClassHeaderFile, exists);
    expect(pluginClassImplFile, exists);
    // Ensure that the includes are correct.
    expect(cApiImplFile.readAsLinesSync(), containsAllInOrder(<Matcher>[
      contains('#include "include/$projectName/$cApiHeaderName"'),
      contains('#include "$pluginClassHeaderName"'),
    ]));
    expect(pluginClassImplFile.readAsLinesSync(), contains('#include "$pluginClassHeaderName"'));
    // Ensure that the plugin target name matches the post-processed version.
    // Ensure that the CMake file has the right target and source values.
    final String cmakeContents = platformDir.childFile('CMakeLists.txt').readAsStringSync();
    expect(cmakeContents, contains('"$classFilenameBase.cpp"'));
    expect(cmakeContents, contains('"$classFilenameBase.h"'));
    expect(cmakeContents, contains('"${classFilenameBase}_c_api.cpp"'));
    expect(cmakeContents, contains('"include/$projectName/${classFilenameBase}_c_api.h"'));
    expect(cmakeContents, contains('set(PLUGIN_NAME "foo_BarBaz_plugin")'));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWindowsEnabled: true),
  });

  testUsingContext('Linux plugins handle project names ending in _plugin correctly', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    const String projectName = 'foo_bar_plugin';
    final Directory projectDir = tempDir.childDirectory(projectName);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=linux', projectDir.path]);
    final Directory platformDir = projectDir.childDirectory('linux');

    // If the project already ends in _plugin, it shouldn't be added again.
    const String classFilenameBase = projectName;
    const String headerName = '$classFilenameBase.h';
    final File headerFile = platformDir
        .childDirectory('include')
        .childDirectory(projectName)
        .childFile(headerName);
    final File implFile = platformDir.childFile('$classFilenameBase.cc');
    // Ensure that the files have the right names.
    expect(headerFile, exists);
    expect(implFile, exists);
    // Ensure that the include is correct.
    expect(implFile.readAsStringSync(), contains(headerName));
    // Ensure that the CMake file has the right target and source values.
    final String cmakeContents = platformDir.childFile('CMakeLists.txt').readAsStringSync();
    expect(cmakeContents, contains('"$classFilenameBase.cc"'));
    // The "_plugin_plugin" suffix is intentional; because the target names must
    // be unique across the ecosystem, no canonicalization can be done,
    // otherwise plugins called "foo_bar" and "foo_bar_plugin" would collide in
    // builds.
    expect(cmakeContents, contains('set(PLUGIN_NAME "foo_bar_plugin_plugin")'));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isLinuxEnabled: true),
  });

  testUsingContext('Windows plugins handle project names ending in _plugin correctly', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    const String projectName = 'foo_bar_plugin';
    final Directory projectDir = tempDir.childDirectory(projectName);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=windows', projectDir.path]);
    final Directory platformDir = projectDir.childDirectory('windows');

    // If the project already ends in _plugin, it shouldn't be added again.
    const String classFilenameBase = projectName;
    const String cApiHeaderName = '${classFilenameBase}_c_api.h';
    const String pluginClassHeaderName = '$classFilenameBase.h';
    final File cApiHeaderFile = platformDir
        .childDirectory('include')
        .childDirectory(projectName)
        .childFile(cApiHeaderName);
    final File cApiImplFile = platformDir.childFile('${classFilenameBase}_c_api.cpp');
    final File pluginClassHeaderFile = platformDir.childFile(pluginClassHeaderName);
    final File pluginClassImplFile = platformDir.childFile('$classFilenameBase.cpp');
    // Ensure that the files have the right names.
    expect(cApiHeaderFile, exists);
    expect(cApiImplFile, exists);
    expect(pluginClassHeaderFile, exists);
    expect(pluginClassImplFile, exists);
    // Ensure that the includes are correct.
    expect(cApiImplFile.readAsLinesSync(), containsAllInOrder(<Matcher>[
      contains('#include "include/$projectName/$cApiHeaderName"'),
      contains('#include "$pluginClassHeaderName"'),
    ]));
    expect(pluginClassImplFile.readAsLinesSync(), contains('#include "$pluginClassHeaderName"'));
    // Ensure that the CMake file has the right target and source values.
    final String cmakeContents = platformDir.childFile('CMakeLists.txt').readAsStringSync();
    expect(cmakeContents, contains('"$classFilenameBase.cpp"'));
    // The "_plugin_plugin" suffix is intentional; because the target names must
    // be unique across the ecosystem, no canonicalization can be done,
    // otherwise plugins called "foo_bar" and "foo_bar_plugin" would collide in
    // builds.
    expect(cmakeContents, contains('set(PLUGIN_NAME "foo_bar_plugin_plugin")'));
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWindowsEnabled: true),
  });

  testUsingContext('created plugin supports no platforms should print `no platforms` message', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);
    expect(logger.errorText, contains(_kNoPlatformsMessage));
    expect(logger.statusText, contains('To add platforms, run `flutter create -t plugin --platforms <platforms> .` under ${globals.fs.path.normalize(globals.fs.path.relative(projectDir.path))}.'));
    expect(logger.statusText, contains('For more information, see https://flutter.dev/go/plugin-platforms.'));

  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
    Logger: ()=> logger,
  });

  testUsingContext('created FFI plugin supports no platforms should print `no platforms` message', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin_ffi', projectDir.path]);
    expect(logger.errorText, contains(_kNoPlatformsMessage));
    expect(logger.statusText, contains('To add platforms, run `flutter create -t plugin_ffi --platforms <platforms> .` under ${globals.fs.path.normalize(globals.fs.path.relative(projectDir.path))}.'));
    expect(logger.statusText, contains('For more information, see https://flutter.dev/go/plugin-platforms.'));

  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
    Logger: ()=> logger,
  });

  testUsingContext('created plugin with no --platforms flag should not print `no platforms` message if the existing plugin supports a platform.', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=ios', projectDir.path]);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);
    expect(logger.errorText, isNot(contains(_kNoPlatformsMessage)));

  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
    Logger: () => logger,
  });

  testUsingContext('should show warning when disabled platforms are selected while creating a plugin', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platforms=android,ios,web,windows,macos,linux', projectDir.path]);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);
    expect(logger.statusText, contains(_kDisabledPlatformRequestedMessage));

  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
    Logger: () => logger,
  });

  testUsingContext("shouldn't show warning when only enabled platforms are selected while creating a plugin", () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platforms=android,ios,windows', projectDir.path]);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);
    expect(logger.statusText, isNot(contains(_kDisabledPlatformRequestedMessage)));

  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWindowsEnabled: true),
    Logger: () => logger,
  });

  testUsingContext('should show warning when disabled platforms are selected while creating a app', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--platforms=android,ios,web,windows,macos,linux', projectDir.path]);
    await runner.run(<String>['create', '--no-pub', projectDir.path]);
    expect(logger.statusText, contains(_kDisabledPlatformRequestedMessage));

  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
    Logger: () => logger,
  });

  testUsingContext("shouldn't show warning when only enabled platforms are selected while creating a app", () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin', '--platform=windows', projectDir.path]);
    await runner.run(<String>['create', '--no-pub', '--template=plugin', projectDir.path]);
    expect(logger.statusText, isNot(contains(_kDisabledPlatformRequestedMessage)));

  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isWindowsEnabled: true, isAndroidEnabled: false, isIOSEnabled: false),
    Logger: () => logger,
  });

  testUsingContext('default project has analysis_options.yaml set up correctly', () async {
    await _createProject(
        projectDir,
        <String>[],
        <String>[
          'analysis_options.yaml',
        ],
    );
    final String dataPath = globals.fs.path.join(
      getFlutterRoot(),
      'packages',
      'flutter_tools',
      'test',
      'commands.shard',
      'permeable',
      'data',
    );
    final File toAnalyze = await globals.fs.file(globals.fs.path.join(dataPath, 'to_analyze.dart.test'))
        .copy(globals.fs.path.join(projectDir.path, 'lib', 'to_analyze.dart'));
    final String relativePath = globals.fs.path.join('lib', 'to_analyze.dart');
    final List<String> expectedFailures = <String>[
      '$relativePath:11:7: use_key_in_widget_constructors',
      '$relativePath:20:3: prefer_const_constructors_in_immutables',
      '$relativePath:31:26: use_full_hex_values_for_flutter_colors',
    ];
    expect(expectedFailures.length, '// LINT:'.allMatches(toAnalyze.readAsStringSync()).length);
    await _analyzeProject(
      projectDir.path,
      expectedFailures: expectedFailures,
    );
  }, overrides: <Type, Generator>{
    Pub: () => Pub.test(
      fileSystem: globals.fs,
      logger: globals.logger,
      processManager: globals.processManager,
      usage: globals.flutterUsage,
      botDetector: globals.botDetector,
      platform: globals.platform,
      stdio: mockStdio,
    ),
  });

  testUsingContext('create an FFI plugin with ios, then add macos', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    await runner.run(<String>['create', '--no-pub', '--template=plugin_ffi', '--platform=ios', projectDir.path]);
    expect(projectDir.childDirectory('src'), exists);
    expect(projectDir.childDirectory('ios'), exists);
    expect(projectDir.childDirectory('example').childDirectory('ios'), exists);
    validatePubspecForPlugin(
      projectDir: projectDir.absolute.path,
      expectedPlatforms: const <String>[
        'ios',
      ],
      ffiPlugin: true,
      unexpectedPlatforms: <String>['some_platform'],
    );

    await runner.run(<String>['create', '--no-pub', '--template=plugin_ffi', '--platform=macos', projectDir.path]);
    expect(projectDir.childDirectory('macos'), exists);
    expect(
        projectDir.childDirectory('example').childDirectory('macos'), exists);
    expect(projectDir.childDirectory('ios'), exists);
    expect(projectDir.childDirectory('example').childDirectory('ios'), exists);
  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(isMacOSEnabled: true),
  });

  testUsingContext('FFI plugins error android language', () async {
    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    final List<String> args = <String>[
      'create',
      '--no-pub',
      '--template=plugin_ffi',
      '-a',
      'kotlin',
      '--platforms=android',
      projectDir.path,
    ];

    await expectLater(
      runner.run(args),
      throwsToolExit(message: 'The "android-language" option is not supported with the plugin_ffi template: the language will always be C or C++.'),
    );
  });

  testUsingContext('FFI plugins error ios language', () async {
    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    final List<String> args = <String>[
      'create',
      '--no-pub',
      '--template=plugin_ffi',
      '--ios-language',
      'swift',
      '--platforms=ios',
      projectDir.path,
    ];

    await expectLater(
      runner.run(args),
      throwsToolExit(message: 'The "ios-language" option is not supported with the plugin_ffi template: the language will always be C or C++.'),
    );
  });

  testUsingContext('FFI plugins error web platform', () async {
    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);
    final List<String> args = <String>[
      'create',
      '--no-pub',
      '--template=plugin_ffi',
      '--platforms=web',
      projectDir.path,
    ];

    await expectLater(
      runner.run(args),
      throwsToolExit(message: 'The web platform is not supported in plugin_ffi template.'),
    );
  });

  testUsingContext('should show warning when disabled platforms are selected while creating an FFI plugin', () async {
    Cache.flutterRoot = '../..';

    final CreateCommand command = CreateCommand();
    final CommandRunner<void> runner = createTestCommandRunner(command);

    await runner.run(<String>['create', '--no-pub', '--template=plugin_ffi', '--platforms=android,ios,windows,macos,linux', projectDir.path]);
    await runner.run(<String>['create', '--no-pub', '--template=plugin_ffi', projectDir.path]);
    expect(logger.statusText, contains(_kDisabledPlatformRequestedMessage));

  }, overrides: <Type, Generator>{
    FeatureFlags: () => TestFeatureFlags(),
    Logger: () => logger,
  });
}

Future<void> _createProject(
  Directory dir,
  List<String> createArgs,
  List<String> expectedPaths, {
  List<String> unexpectedPaths = const <String>[],
}) async {
  Cache.flutterRoot = '../..';
  final CreateCommand command = CreateCommand();
  final CommandRunner<void> runner = createTestCommandRunner(command);
  await runner.run(<String>[
    'create',
    ...createArgs,
    dir.path,
  ]);

  bool pathExists(String path) {
    final String fullPath = globals.fs.path.join(dir.path, path);
    return globals.fs.typeSync(fullPath) != FileSystemEntityType.notFound;
  }

  final List<String> failures = <String>[
    for (final String path in expectedPaths)
      if (!pathExists(path))
        'Path "$path" does not exist.',
    for (final String path in unexpectedPaths)
      if (pathExists(path))
        'Path "$path" exists when it shouldn\'t.',
  ];
  expect(failures, isEmpty, reason: failures.join('\n'));
}

Future<void> _createAndAnalyzeProject(
  Directory dir,
  List<String> createArgs,
  List<String> expectedPaths, {
  List<String> unexpectedPaths = const <String>[],
}) async {
  await _createProject(dir, createArgs, expectedPaths, unexpectedPaths: unexpectedPaths);
  await _analyzeProject(dir.path);
}

Future<void> _ensureFlutterToolsSnapshot() async {
  final String flutterToolsPath = globals.fs.path.absolute(globals.fs.path.join(
    'bin',
    'flutter_tools.dart',
  ));
  final String flutterToolsSnapshotPath = globals.fs.path.absolute(globals.fs.path.join(
    '..',
    '..',
    'bin',
    'cache',
    'flutter_tools.snapshot',
  ));
  final String packageConfig = globals.fs.path.absolute(globals.fs.path.join(
    '.dart_tool',
    'package_config.json'
  ));

  final File snapshotFile = globals.fs.file(flutterToolsSnapshotPath);
  if (snapshotFile.existsSync()) {
    snapshotFile.renameSync('$flutterToolsSnapshotPath.bak');
  }

  final List<String> snapshotArgs = <String>[
    '--snapshot=$flutterToolsSnapshotPath',
    '--packages=$packageConfig',
    flutterToolsPath,
  ];
  final ProcessResult snapshotResult = await Process.run(
    '../../bin/cache/dart-sdk/bin/dart',
    snapshotArgs,
  );
  printOnFailure('Results of generating snapshot:');
  printOnFailure(snapshotResult.stdout.toString());
  printOnFailure(snapshotResult.stderr.toString());
  expect(snapshotResult.exitCode, 0);
}

Future<void> _restoreFlutterToolsSnapshot() async {
  final String flutterToolsSnapshotPath = globals.fs.path.absolute(globals.fs.path.join(
    '..',
    '..',
    'bin',
    'cache',
    'flutter_tools.snapshot',
  ));

  final File snapshotBackup = globals.fs.file('$flutterToolsSnapshotPath.bak');
  if (!snapshotBackup.existsSync()) {
    // No backup to restore.
    return;
  }

  snapshotBackup.renameSync(flutterToolsSnapshotPath);
}

Future<void> _analyzeProject(String workingDir, { List<String> expectedFailures = const <String>[] }) async {
  final String flutterToolsSnapshotPath = globals.fs.path.absolute(globals.fs.path.join(
    '..',
    '..',
    'bin',
    'cache',
    'flutter_tools.snapshot',
  ));

  final List<String> args = <String>[
    flutterToolsSnapshotPath,
    'analyze',
  ];

  final ProcessResult exec = await Process.run(
    globals.artifacts!.getArtifactPath(Artifact.engineDartBinary),
    args,
    workingDirectory: workingDir,
  );
  if (expectedFailures.isEmpty) {
    printOnFailure('Results of running analyzer:');
    printOnFailure(exec.stdout.toString());
    printOnFailure(exec.stderr.toString());
    expect(exec.exitCode, 0);
    return;
  }
  expect(exec.exitCode, isNot(0));
  String lineParser(String line) {
    try {
      final String analyzerSeparator = globals.platform.isWindows ? ' - ' : ' • ';
      final List<String> lineComponents = line.trim().split(analyzerSeparator);
      final String lintName = lineComponents.removeLast();
      final String location = lineComponents.removeLast();
      return '$location: $lintName';
    } on RangeError catch (err) {
      throw RangeError('Received "$err" while trying to parse: "$line".');
    }
  }
  final String stdout = exec.stdout.toString();
  final List<String> errors = <String>[];
  try {
    bool analyzeLineFound = false;
    const LineSplitter().convert(stdout).forEach((String line) {
      // Conditional to filter out any stdout from `pub get`
      if (!analyzeLineFound && line.startsWith('Analyzing')) {
        analyzeLineFound = true;
        return;
      }

      if (analyzeLineFound && line.trim().isNotEmpty) {
        errors.add(lineParser(line.trim()));
      }
    });
  } on Exception catch (err) {
    fail('$err\n\nComplete STDOUT was:\n\n$stdout');
  }
  expect(errors, unorderedEquals(expectedFailures),
      reason: 'Failed with stdout:\n\n$stdout');
}

Future<void> _getPackages(Directory workingDir) async {
  final String flutterToolsSnapshotPath = globals.fs.path.absolute(globals.fs.path.join(
    '..',
    '..',
    'bin',
    'cache',
    'flutter_tools.snapshot',
  ));

  // While flutter test does get packages, it doesn't write version
  // files anymore.
  await Process.run(
    globals.artifacts!.getArtifactPath(Artifact.engineDartBinary),
    <String>[
      flutterToolsSnapshotPath,
      'packages',
      'get',
    ],
    workingDirectory: workingDir.path,
  );
}

Future<void> _runFlutterTest(Directory workingDir, { String? target }) async {
  final String flutterToolsSnapshotPath = globals.fs.path.absolute(globals.fs.path.join(
    '..',
    '..',
    'bin',
    'cache',
    'flutter_tools.snapshot',
  ));

  await _getPackages(workingDir);

  final List<String> args = <String>[
    flutterToolsSnapshotPath,
    'test',
    '--no-color',
    if (target != null) target,
  ];

  final ProcessResult exec = await Process.run(
    globals.artifacts!.getArtifactPath(Artifact.engineDartBinary),
    args,
    workingDirectory: workingDir.path,
  );
  printOnFailure('Output of running flutter test:');
  printOnFailure(exec.stdout.toString());
  printOnFailure(exec.stderr.toString());
  expect(exec.exitCode, 0);
}

/// A ProcessManager that invokes a real process manager, but keeps
/// track of all commands sent to it.
class LoggingProcessManager extends LocalProcessManager {
  List<List<String>> commands = <List<String>>[];

  @override
  Future<Process> start(
    List<Object> command, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    ProcessStartMode mode = ProcessStartMode.normal,
  }) {
    commands.add(command.map((Object arg) => arg.toString()).toList());
    return super.start(
      command,
      workingDirectory: workingDirectory,
      environment: environment,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
      mode: mode,
    );
  }

  void clear() {
    commands.clear();
  }
}

String _getStringValueFromPlist({required File plistFile, String? key}) {
  final List<String> plist = plistFile.readAsLinesSync().map((String line) => line.trim()).toList();
  final int keyIndex = plist.indexOf('<key>$key</key>');
  assert(keyIndex > 0);
  return plist[keyIndex+1].replaceAll('<string>', '').replaceAll('</string>', '');
}

bool _getBooleanValueFromPlist({required File plistFile, String? key}) {
  final List<String> plist = plistFile.readAsLinesSync().map((String line) => line.trim()).toList();
  final int keyIndex = plist.indexOf('<key>$key</key>');
  assert(keyIndex > 0);
  return plist[keyIndex+1].replaceAll('<', '').replaceAll('/>', '') == 'true';
}
