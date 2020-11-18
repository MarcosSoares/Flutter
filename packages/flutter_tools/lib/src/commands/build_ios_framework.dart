// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:file/file.dart';
import 'package:meta/meta.dart';

import '../artifacts.dart';
import '../base/common.dart';
import '../base/file_system.dart';
import '../base/logger.dart';
import '../base/platform.dart';
import '../base/process.dart';
import '../base/utils.dart';
import '../build_info.dart';
import '../build_system/build_system.dart';
import '../build_system/targets/common.dart';
import '../build_system/targets/icon_tree_shaker.dart';
import '../build_system/targets/ios.dart';
import '../cache.dart';
import '../convert.dart';
import '../globals.dart' as globals;
import '../macos/cocoapod_utils.dart';
import '../macos/xcode.dart';
import '../plugins.dart';
import '../project.dart';
import '../runner/flutter_command.dart' show DevelopmentArtifact, FlutterCommandResult;
import '../version.dart';
import 'build.dart';

/// Produces a .framework for integration into a host iOS app. The .framework
/// contains the Flutter engine and framework code as well as plugins. It can
/// be integrated into plain Xcode projects without using or other package
/// managers.
class BuildIOSFrameworkCommand extends BuildSubCommand {
  BuildIOSFrameworkCommand({
    FlutterVersion flutterVersion, // Instantiating FlutterVersion kicks off networking, so delay until it's needed, but allow test injection.
    @required BuildSystem buildSystem,
    @required bool verboseHelp,
    Cache cache,
    Platform platform
  }) : _flutterVersion = flutterVersion,
       _buildSystem = buildSystem,
       _injectedCache = cache,
       _injectedPlatform = platform {
    addTreeShakeIconsFlag();
    usesTargetOption();
    usesFlavorOption();
    usesPubOption();
    usesDartDefineOption();
    addSplitDebugInfoOption();
    addDartObfuscationOption();
    usesExtraDartFlagOptions();
    addNullSafetyModeOptions(hide: !verboseHelp);
    addEnableExperimentation(hide: !verboseHelp);

    argParser
      ..addFlag('debug',
        negatable: true,
        defaultsTo: true,
        help: 'Whether to produce a framework for the debug build configuration. '
              'By default, all build configurations are built.'
      )
      ..addFlag('profile',
        negatable: true,
        defaultsTo: true,
        help: 'Whether to produce a framework for the profile build configuration. '
              'By default, all build configurations are built.'
      )
      ..addFlag('release',
        negatable: true,
        defaultsTo: true,
        help: 'Whether to produce a framework for the release build configuration. '
              'By default, all build configurations are built.'
      )
      ..addFlag('universal',
        help: '(Deprecated) Produce universal frameworks that include all valid architectures. '
              'This option will be removed in a future version of Flutter.',
        negatable: true,
        hide: true,
      )
      ..addFlag('xcframework',
        help: 'Produce xcframeworks that include all valid architectures.',
        defaultsTo: true,
      )
      ..addFlag('cocoapods',
        help: 'Produce a Flutter.podspec instead of an engine Flutter.xcframework (recommended if host app uses CocoaPods).',
      )
      ..addOption('output',
        abbr: 'o',
        valueHelp: 'path/to/directory/',
        help: 'Location to write the frameworks.',
      )
      ..addFlag('force',
        abbr: 'f',
        help: 'Force Flutter.podspec creation on the master channel. For testing only.',
        hide: true
      );
  }

  final BuildSystem _buildSystem;
  BuildSystem get buildSystem => _buildSystem ?? globals.buildSystem;

  Cache get _cache => _injectedCache ?? globals.cache;
  final Cache _injectedCache;

  Platform get _platform => _injectedPlatform ?? globals.platform;
  final Platform _injectedPlatform;

  FlutterVersion _flutterVersion;

  @override
  final String name = 'ios-framework';

  @override
  final String description = 'Produces .frameworks for a Flutter project '
      'and its plugins for integration into existing, plain Xcode projects.\n'
      'This can only be run on macOS hosts.';

  @override
  Future<Set<DevelopmentArtifact>> get requiredArtifacts async => const <DevelopmentArtifact>{
    DevelopmentArtifact.iOS,
  };

  FlutterProject _project;

  Future<List<BuildInfo>> get buildInfos async {
    final List<BuildInfo> buildInfos = <BuildInfo>[];

    if (boolArg('debug')) {
      buildInfos.add(await getBuildInfo(forcedBuildMode: BuildMode.debug));
    }
    if (boolArg('profile')) {
      buildInfos.add(await getBuildInfo(forcedBuildMode: BuildMode.profile));
    }
    if (boolArg('release')) {
      buildInfos.add(await getBuildInfo(forcedBuildMode: BuildMode.release));
    }

    return buildInfos;
  }

  @override
  Future<void> validateCommand() async {
    await super.validateCommand();
    _project = FlutterProject.current();
    if (!_platform.isMacOS) {
      throwToolExit('Building frameworks for iOS is only supported on the Mac.');
    }

    if (!boolArg('universal') && !boolArg('xcframework')) {
      throwToolExit('--xcframework or --universal is required.');
    }
    if (boolArg('xcframework') && globals.xcode.majorVersion < 11) {
      throwToolExit('--xcframework requires Xcode 11.');
    }
    if (boolArg('universal')) {
      globals.printError('--universal has been deprecated to support Apple '
          'Silicon ARM simulators and will be removed in a future version of '
          'Flutter. Use --xcframework instead.');
    }
    if ((await buildInfos).isEmpty) {
      throwToolExit('At least one of "--debug" or "--profile", or "--release" is required.');
    }
  }

  @override
  Future<FlutterCommandResult> runCommand() async {
    final String outputArgument = stringArg('output')
        ?? globals.fs.path.join(globals.fs.currentDirectory.path, 'build', 'ios', 'framework');

    if (outputArgument.isEmpty) {
      throwToolExit('--output is required.');
    }

    if (!_project.ios.existsSync()) {
      throwToolExit('Project does not support iOS');
    }

    final Directory outputDirectory = globals.fs.directory(globals.fs.path.absolute(globals.fs.path.normalize(outputArgument)));

    for (final BuildInfo buildInfo in await buildInfos) {
      final String productBundleIdentifier = await _project.ios.productBundleIdentifier(buildInfo);
      globals.printStatus('Building frameworks for $productBundleIdentifier in ${getNameForBuildMode(buildInfo.mode)} mode...');
      final String xcodeBuildConfiguration = toTitleCase(getNameForBuildMode(buildInfo.mode));
      final Directory modeDirectory = outputDirectory.childDirectory(xcodeBuildConfiguration);

      if (modeDirectory.existsSync()) {
        modeDirectory.deleteSync(recursive: true);
      }

      if (boolArg('cocoapods')) {
        // FlutterVersion.instance kicks off git processing which can sometimes fail, so don't try it until needed.
        _flutterVersion ??= globals.flutterVersion;
        produceFlutterPodspec(buildInfo.mode, modeDirectory, force: boolArg('force'));
      } else {
        // Copy Flutter.framework.
        await _produceFlutterFramework(buildInfo, modeDirectory);
      }

      // Build aot, create module.framework and copy.
      final Directory iPhoneBuildOutput =
          modeDirectory.childDirectory('iphoneos');
      final Directory simulatorBuildOutput =
          modeDirectory.childDirectory('iphonesimulator');
      await _produceAppFramework(
          buildInfo, modeDirectory, iPhoneBuildOutput, simulatorBuildOutput);

      // Build and copy plugins.
      await processPodsIfNeeded(_project.ios, getIosBuildDirectory(), buildInfo.mode);
      if (hasPlugins(_project)) {
        await _producePlugins(buildInfo.mode, xcodeBuildConfiguration, iPhoneBuildOutput, simulatorBuildOutput, modeDirectory, outputDirectory);
      }

      final Status status = globals.logger.startProgress(
        ' └─Moving to ${globals.fs.path.relative(modeDirectory.path)}');
      try {
        // Delete the intermediaries since they would have been copied into our
        // output frameworks.
        if (iPhoneBuildOutput.existsSync()) {
          iPhoneBuildOutput.deleteSync(recursive: true);
        }
        if (simulatorBuildOutput.existsSync()) {
          simulatorBuildOutput.deleteSync(recursive: true);
        }
      } finally {
        status.stop();
      }
    }

    globals.printStatus('Frameworks written to ${outputDirectory.path}.');

    if (!_project.isModule && hasPlugins(_project)) {
      // Apps do not generate a FlutterPluginRegistrant.framework. Users will need
      // to copy the GeneratedPluginRegistrant class to their project manually.
      final File pluginRegistrantHeader = _project.ios.pluginRegistrantHeader;
      final File pluginRegistrantImplementation =
          _project.ios.pluginRegistrantImplementation;
      pluginRegistrantHeader.copySync(
          outputDirectory.childFile(pluginRegistrantHeader.basename).path);
      pluginRegistrantImplementation.copySync(outputDirectory
          .childFile(pluginRegistrantImplementation.basename)
          .path);
      globals.printStatus(
          '\nCopy the ${globals.fs.path.basenameWithoutExtension(pluginRegistrantHeader.path)} class into your project.\n'
          'See https://flutter.dev/docs/development/add-to-app/ios/add-flutter-screen#create-a-flutterengine for more information.');
    }

    return FlutterCommandResult.success();
  }

  /// Create podspec that will download and unzip remote engine assets so host apps can leverage CocoaPods
  /// vendored framework caching.
  @visibleForTesting
  void produceFlutterPodspec(BuildMode mode, Directory modeDirectory, { bool force = false }) {
    final Status status = globals.logger.startProgress(' ├─Creating Flutter.podspec...');
    try {
      final GitTagVersion gitTagVersion = _flutterVersion.gitTagVersion;
      if (!force && (gitTagVersion.x == null || gitTagVersion.y == null || gitTagVersion.z == null || gitTagVersion.commits != 0)) {
        throwToolExit(
            '--cocoapods is only supported on the dev, beta, or stable channels. Detected version is ${_flutterVersion.frameworkVersion}');
      }

      // Podspecs use semantic versioning, which don't support hotfixes.
      // Fake out a semantic version with major.minor.(patch * 100) + hotfix.
      // A real increasing version is required to prompt CocoaPods to fetch
      // new artifacts when the source URL changes.
      final int minorHotfixVersion = gitTagVersion.z * 100 + (gitTagVersion.hotfix ?? 0);

      final File license = _cache.getLicenseFile();
      if (!license.existsSync()) {
        throwToolExit('Could not find license at ${license.path}');
      }
      final String licenseSource = license.readAsStringSync();
      final String artifactsMode = mode == BuildMode.debug ? 'ios' : 'ios-${mode.name}';

      final String podspecContents = '''
Pod::Spec.new do |s|
  s.name                  = 'Flutter'
  s.version               = '${gitTagVersion.x}.${gitTagVersion.y}.$minorHotfixVersion' # ${_flutterVersion.frameworkVersion}
  s.summary               = 'Flutter Engine Framework'
  s.description           = <<-DESC
Flutter is Google’s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.
This pod vends the iOS Flutter engine framework. It is compatible with application frameworks created with this version of the engine and tools.
The pod version matches Flutter version major.minor.(patch * 100) + hotfix.
DESC
  s.homepage              = 'https://flutter.dev'
  s.license               = { :type => 'MIT', :text => <<-LICENSE
$licenseSource
LICENSE
  }
  s.author                = { 'Flutter Dev Team' => 'flutter-dev@googlegroups.com' }
  s.source                = { :http => '${_cache.storageBaseUrl}/flutter_infra/flutter/${_cache.engineRevision}/$artifactsMode/artifacts.zip' }
  s.documentation_url     = 'https://flutter.dev/docs'
  s.platform              = :ios, '8.0'
  s.vendored_frameworks   = 'Flutter.framework'
  s.prepare_command       = <<-CMD
unzip Flutter.framework -d Flutter.framework
CMD
end
''';

      final File podspec = modeDirectory.childFile('Flutter.podspec')..createSync(recursive: true);
      podspec.writeAsStringSync(podspecContents);
    } finally {
      status.stop();
    }
  }

  Future<void> _produceFlutterFramework(
    BuildInfo buildInfo,
    Directory modeDirectory,
  ) async {
    final Status status = globals.logger.startProgress(
      ' ├─Populating Flutter.framework...',
    );
    final String engineCacheFlutterFrameworkDirectory = globals.artifacts.getArtifactPath(
      Artifact.flutterFramework,
      platform: TargetPlatform.ios,
      mode: buildInfo.mode,
    );
    final String flutterFrameworkFileName = globals.fs.path.basename(
      engineCacheFlutterFrameworkDirectory,
    );
    final Directory fatFlutterFrameworkCopy = modeDirectory.childDirectory(
      flutterFrameworkFileName,
    );

    try {
      // Copy universal engine cache framework to mode directory.
      globals.fsUtils.copyDirectorySync(
        globals.fs.directory(engineCacheFlutterFrameworkDirectory),
        fatFlutterFrameworkCopy,
      );

      if (buildInfo.mode != BuildMode.debug) {
        final File fatFlutterFrameworkBinary = fatFlutterFrameworkCopy.childFile('Flutter');

        // Remove simulator architecture in profile and release mode.
        final List<String> lipoCommand = <String>[
          ...globals.xcode.xcrunCommand(),
          'lipo',
          fatFlutterFrameworkBinary.path,
          '-remove',
          'x86_64',
          '-output',
          fatFlutterFrameworkBinary.path
        ];
        final RunResult lipoResult = await globals.processUtils.run(
          lipoCommand,
          allowReentrantFlutter: false,
        );

        if (lipoResult.exitCode != 0) {
          throwToolExit(
            'Unable to remove simulator architecture in ${buildInfo.mode}: ${lipoResult.stderr}',
          );
        }
      }
    } finally {
      status.stop();
    }

    await _produceXCFrameworkFromUniversal(buildInfo, fatFlutterFrameworkCopy);
  }

  Future<void> _produceAppFramework(
    BuildInfo buildInfo,
    Directory outputDirectory,
    Directory iPhoneBuildOutput,
    Directory simulatorBuildOutput,
  ) async {
    const String appFrameworkName = 'App.framework';

    final Status status = globals.logger.startProgress(
      ' ├─Building App.framework...',
    );
    final List<SdkType> sdkTypes = <SdkType>[SdkType.iPhone];
    final List<Directory> frameworks = <Directory>[];
    Target target;
    if (buildInfo.isDebug) {
      sdkTypes.add(SdkType.iPhoneSimulator);
      target = const DebugIosApplicationBundle();
    } else if (buildInfo.isProfile) {
      target = const ProfileIosApplicationBundle();
    } else {
      target = const ReleaseIosApplicationBundle();
    }

    try {
      for (final SdkType sdkType in sdkTypes) {
        final Directory outputBuildDirectory = sdkType == SdkType.iPhone
            ? iPhoneBuildOutput
            : simulatorBuildOutput;
        frameworks.add(outputBuildDirectory.childDirectory(appFrameworkName));
        final Environment environment = Environment(
          projectDir: globals.fs.currentDirectory,
          outputDir: outputBuildDirectory,
          buildDir: _project.dartTool.childDirectory('flutter_build'),
          cacheDir: null,
          flutterRootDir: globals.fs.directory(Cache.flutterRoot),
          defines: <String, String>{
            kTargetFile: targetFile,
            kBuildMode: getNameForBuildMode(buildInfo.mode),
            kTargetPlatform: getNameForTargetPlatform(TargetPlatform.ios),
            kIconTreeShakerFlag: buildInfo.treeShakeIcons.toString(),
            kDartDefines: jsonEncode(buildInfo.dartDefines),
            kBitcodeFlag: 'true',
            if (buildInfo?.extraGenSnapshotOptions?.isNotEmpty ?? false)
              kExtraGenSnapshotOptions:
                  buildInfo.extraGenSnapshotOptions.join(','),
            if (buildInfo?.extraFrontEndOptions?.isNotEmpty ?? false)
              kExtraFrontEndOptions: buildInfo.extraFrontEndOptions.join(','),
            kIosArchs: defaultIOSArchsForSdk(sdkType)
                .map(getNameForDarwinArch)
                .join(' '),
            kSdkRoot: await globals.xcode.sdkLocation(sdkType),
          },
          artifacts: globals.artifacts,
          fileSystem: globals.fs,
          logger: globals.logger,
          processManager: globals.processManager,
          engineVersion: globals.artifacts.isLocalEngine
              ? null
              : globals.flutterVersion.engineRevision,
        );
        final BuildResult result = await buildSystem.build(target, environment);
        if (!result.success) {
          for (final ExceptionMeasurement measurement
              in result.exceptions.values) {
            globals.printError(measurement.exception.toString());
          }
          throwToolExit('The App.framework build failed.');
        }
      }
    } finally {
      status.stop();
    }

    await _produceUniversalFramework(frameworks, 'App', outputDirectory);
    await _produceXCFramework(frameworks, 'App', outputDirectory);
  }

  Future<void> _producePlugins(
    BuildMode mode,
    String xcodeBuildConfiguration,
    Directory iPhoneBuildOutput,
    Directory simulatorBuildOutput,
    Directory modeDirectory,
    Directory outputDirectory,
  ) async {
    final Status status = globals.logger.startProgress(
      ' ├─Building plugins...'
    );
    try {
      final String bitcodeGenerationMode = mode == BuildMode.release ?
          'bitcode' : 'marker'; // In release, force bitcode embedding without archiving.

      List<String> pluginsBuildCommand = <String>[
        ...globals.xcode.xcrunCommand(),
        'xcodebuild',
        '-alltargets',
        '-sdk',
        'iphoneos',
        '-configuration',
        xcodeBuildConfiguration,
        'SYMROOT=${iPhoneBuildOutput.path}',
        'BITCODE_GENERATION_MODE=$bitcodeGenerationMode',
        'ENABLE_BITCODE=YES', // Support host apps with bitcode enabled.
        'ONLY_ACTIVE_ARCH=NO', // No device targeted, so build all valid architectures.
        'BUILD_LIBRARY_FOR_DISTRIBUTION=YES',
      ];

      RunResult buildPluginsResult = await globals.processUtils.run(
        pluginsBuildCommand,
        workingDirectory: _project.ios.hostAppRoot.childDirectory('Pods').path,
        allowReentrantFlutter: false,
      );

      if (buildPluginsResult.exitCode != 0) {
        throwToolExit('Unable to build plugin frameworks: ${buildPluginsResult.stderr}');
      }

      if (mode == BuildMode.debug) {
        pluginsBuildCommand = <String>[
          ...globals.xcode.xcrunCommand(),
          'xcodebuild',
          '-alltargets',
          '-sdk',
          'iphonesimulator',
          '-configuration',
          xcodeBuildConfiguration,
          'SYMROOT=${simulatorBuildOutput.path}',
          'ENABLE_BITCODE=YES', // Support host apps with bitcode enabled.
          'ARCHS=x86_64',
          'ONLY_ACTIVE_ARCH=NO', // No device targeted, so build all valid architectures.
          'BUILD_LIBRARY_FOR_DISTRIBUTION=YES',
        ];

        buildPluginsResult = await globals.processUtils.run(
          pluginsBuildCommand,
          workingDirectory: _project.ios.hostAppRoot
            .childDirectory('Pods')
            .path,
          allowReentrantFlutter: false,
        );

        if (buildPluginsResult.exitCode != 0) {
          throwToolExit(
            'Unable to build plugin frameworks for simulator: ${buildPluginsResult.stderr}',
          );
        }
      }

      final Directory iPhoneBuildConfiguration = iPhoneBuildOutput.childDirectory(
        '$xcodeBuildConfiguration-iphoneos',
      );
      final Directory simulatorBuildConfiguration = simulatorBuildOutput.childDirectory(
        '$xcodeBuildConfiguration-iphonesimulator',
      );

      final Iterable<Directory> products = iPhoneBuildConfiguration
        .listSync(followLinks: false)
        .whereType<Directory>();
      for (final Directory builtProduct in products) {
        for (final FileSystemEntity podProduct in builtProduct.listSync(followLinks: false)) {
          final String podFrameworkName = podProduct.basename;
          if (globals.fs.path.extension(podFrameworkName) != '.framework') {
            continue;
          }
          final String binaryName = globals.fs.path.basenameWithoutExtension(podFrameworkName);

          final List<Directory> frameworks = <Directory>[
            podProduct as Directory,
            if (mode == BuildMode.debug)
              simulatorBuildConfiguration
                  .childDirectory(builtProduct.basename)
                  .childDirectory(podFrameworkName)
          ];

          await _produceUniversalFramework(frameworks, binaryName, modeDirectory);
          await _produceXCFramework(frameworks, binaryName, modeDirectory);
        }
      }
    } finally {
      status.stop();
    }
  }

  Future<void> _produceXCFrameworkFromUniversal(BuildInfo buildInfo, Directory fatFramework) async {
    if (boolArg('xcframework')) {
      final String frameworkBinaryName = globals.fs.path.basenameWithoutExtension(
          fatFramework.basename);

      final Status status = globals.logger.startProgress(
        ' ├─Creating $frameworkBinaryName.xcframework...',
      );
      try {
        if (buildInfo.mode == BuildMode.debug) {
          await _produceDebugXCFramework(fatFramework, frameworkBinaryName);
        } else {
          await _produceXCFramework(
              <Directory>[fatFramework], frameworkBinaryName,
              fatFramework.parent);
        }
      } finally {
        status.stop();
      }
    }

    if (!boolArg('universal')) {
      fatFramework.deleteSync(recursive: true);
    }
  }

  Future<void> _produceDebugXCFramework(Directory fatFramework, String frameworkBinaryName) async {
    final String frameworkFileName = fatFramework.basename;
    final File fatFlutterFrameworkBinary = fatFramework.childFile(
      frameworkBinaryName,
    );
    final Directory temporaryOutput = globals.fs.systemTempDirectory.createTempSync(
      'flutter_tool_build_ios_framework.',
    );
    try {
      // Copy universal framework to variant directory.
      final Directory iPhoneBuildOutput = temporaryOutput.childDirectory(
        'ios',
      )..createSync(recursive: true);
      final Directory simulatorBuildOutput = temporaryOutput.childDirectory(
        'simulator',
      )..createSync(recursive: true);
      final Directory armFlutterFrameworkDirectory = iPhoneBuildOutput
        .childDirectory(frameworkFileName);
      final File armFlutterFrameworkBinary = armFlutterFrameworkDirectory
        .childFile(frameworkBinaryName);
      globals.fsUtils.copyDirectorySync(fatFramework, armFlutterFrameworkDirectory);

      // Create iOS framework.
      List<String> lipoCommand = <String>[
        ...globals.xcode.xcrunCommand(),
        'lipo',
        fatFlutterFrameworkBinary.path,
        '-remove',
        'x86_64',
        '-output',
        armFlutterFrameworkBinary.path
      ];

      RunResult lipoResult = await globals.processUtils.run(
        lipoCommand,
        allowReentrantFlutter: false,
      );

      if (lipoResult.exitCode != 0) {
        throwToolExit('Unable to create ARM framework: ${lipoResult.stderr}');
      }

      // Create simulator framework.
      final Directory simulatorFlutterFrameworkDirectory = simulatorBuildOutput
        .childDirectory(frameworkFileName);
      final File simulatorFlutterFrameworkBinary = simulatorFlutterFrameworkDirectory
        .childFile(frameworkBinaryName);
      globals.fsUtils.copyDirectorySync(fatFramework, simulatorFlutterFrameworkDirectory);

      lipoCommand = <String>[
        ...globals.xcode.xcrunCommand(),
        'lipo',
        fatFlutterFrameworkBinary.path,
        '-thin',
        'x86_64',
        '-output',
        simulatorFlutterFrameworkBinary.path
      ];

      lipoResult = await globals.processUtils.run(
        lipoCommand,
        allowReentrantFlutter: false,
      );

      if (lipoResult.exitCode != 0) {
        throwToolExit(
            'Unable to create simulator framework: ${lipoResult.stderr}');
      }

      // Create XCFramework from iOS and simulator frameworks.
      await _produceXCFramework(
        <Directory>[
          armFlutterFrameworkDirectory,
          simulatorFlutterFrameworkDirectory
        ],
        frameworkBinaryName,
        fatFramework.parent,
      );
    } finally {
      temporaryOutput.deleteSync(recursive: true);
    }
  }

  Future<void> _produceXCFramework(Iterable<Directory> frameworks,
      String frameworkBinaryName, Directory outputDirectory) async {
    if (!boolArg('xcframework')) {
      return;
    }
    final List<String> xcframeworkCommand = <String>[
      ...globals.xcode.xcrunCommand(),
      'xcodebuild',
      '-create-xcframework',
      for (Directory framework in frameworks) ...<String>[
        '-framework',
        framework.path
      ],
      '-output',
      outputDirectory.childDirectory('$frameworkBinaryName.xcframework').path
    ];

    final RunResult xcframeworkResult = await globals.processUtils.run(
      xcframeworkCommand,
      allowReentrantFlutter: false,
    );

    if (xcframeworkResult.exitCode != 0) {
      throwToolExit(
          'Unable to create $frameworkBinaryName.xcframework: ${xcframeworkResult.stderr}');
    }
  }

  Future<void> _produceUniversalFramework(Iterable<Directory> frameworks,
      String frameworkBinaryName, Directory outputDirectory) async {
    if (!boolArg('universal')) {
      return;
    }
    final Directory outputFrameworkDirectory =
        outputDirectory.childDirectory('$frameworkBinaryName.framework');

    // Copy the first framework over completely to get headers, resources, etc.
    globals.fsUtils.copyDirectorySync(
      frameworks.first,
      outputFrameworkDirectory,
    );

    // Recreate the framework binary by lipo'ing the framework binaries together.
    final List<String> lipoCommand = <String>[
      ...globals.xcode.xcrunCommand(),
      'lipo',
      '-create',
      for (Directory framework in frameworks) ...<String>[
        framework.childFile(frameworkBinaryName).path
      ],
      '-output',
      outputFrameworkDirectory.childFile(frameworkBinaryName).path
    ];

    final RunResult lipoResult = await globals.processUtils.run(
      lipoCommand,
      workingDirectory: outputDirectory.path,
      allowReentrantFlutter: false,
    );

    if (lipoResult.exitCode != 0) {
      throwToolExit(
          'Unable to create $frameworkBinaryName.framework: ${lipoResult.stderr}');
    }
  }
}
