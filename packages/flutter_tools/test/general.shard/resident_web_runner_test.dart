// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.8

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dwds/dwds.dart';
import 'package:file/memory.dart';
import 'package:flutter_tools/src/application_package.dart';
import 'package:flutter_tools/src/asset.dart';
import 'package:flutter_tools/src/base/common.dart';
import 'package:flutter_tools/src/base/dds.dart';
import 'package:flutter_tools/src/base/file_system.dart';
import 'package:flutter_tools/src/base/logger.dart';
import 'package:flutter_tools/src/base/platform.dart';
import 'package:flutter_tools/src/base/time.dart';
import 'package:flutter_tools/src/build_info.dart';
import 'package:flutter_tools/src/compile.dart';
import 'package:flutter_tools/src/devfs.dart';
import 'package:flutter_tools/src/device.dart';
import 'package:flutter_tools/src/globals_null_migrated.dart' as globals;
import 'package:flutter_tools/src/isolated/devfs_web.dart';
import 'package:flutter_tools/src/isolated/resident_web_runner.dart';
import 'package:flutter_tools/src/project.dart';
import 'package:flutter_tools/src/reporting/reporting.dart';
import 'package:flutter_tools/src/resident_devtools_handler.dart';
import 'package:flutter_tools/src/resident_runner.dart';
import 'package:flutter_tools/src/vmservice.dart';
import 'package:flutter_tools/src/web/chrome.dart';
import 'package:flutter_tools/src/web/web_device.dart';
import 'package:meta/meta.dart';
import 'package:package_config/package_config.dart';
import 'package:package_config/package_config_types.dart';
import 'package:test/fake.dart';
import 'package:vm_service/vm_service.dart' as vm_service;
import 'package:webkit_inspection_protocol/webkit_inspection_protocol.dart';

import '../src/common.dart';
import '../src/context.dart';
import '../src/fake_vm_services.dart';

const List<VmServiceExpectation> kAttachLogExpectations = <VmServiceExpectation>[
  FakeVmServiceRequest(
    method: 'streamListen',
    args: <String, Object>{
      'streamId': 'Stdout',
    },
  ),
  FakeVmServiceRequest(
    method: 'streamListen',
    args: <String, Object>{
      'streamId': 'Stderr',
    },
  )
];

const List<VmServiceExpectation> kAttachIsolateExpectations = <VmServiceExpectation>[
  FakeVmServiceRequest(
    method: 'streamListen',
    args: <String, Object>{
      'streamId': 'Isolate'
    }
  ),
  FakeVmServiceRequest(
    method: 'registerService',
    args: <String, Object>{
      'service': 'reloadSources',
      'alias': 'Flutter Tools',
    }
  ),
  FakeVmServiceRequest(
    method: 'registerService',
    args: <String, Object>{
      'service': 'flutterVersion',
      'alias': 'Flutter Tools',
    }
  ),
  FakeVmServiceRequest(
    method: 'registerService',
    args: <String, Object>{
      'service': 'flutterMemoryInfo',
      'alias': 'Flutter Tools',
    }
  ),
  FakeVmServiceRequest(
    method: 'streamListen',
    args: <String, Object>{
      'streamId': 'Extension',
    },
  ),
];

const List<VmServiceExpectation> kAttachExpectations = <VmServiceExpectation>[
  ...kAttachLogExpectations,
  ...kAttachIsolateExpectations,
];

void main() {
  FakeDebugConnection debugConnection;
  FakeChromeDevice chromeDevice;
  FakeAppConnection appConnection;
  FakeFlutterDevice flutterDevice;
  FakeWebDevFS webDevFS;
  FakeResidentCompiler residentCompiler;
  FakeChromeConnection chromeConnection;
  FakeChromeTab chromeTab;
  FakeWebServerDevice webServerDevice;
  FakeDevice mockDevice;
  FakeVmServiceHost fakeVmServiceHost;
  FileSystem fileSystem;
  ProcessManager processManager;
  TestUsage testUsage;

  setUp(() {
    testUsage = TestUsage();
    fileSystem = MemoryFileSystem.test();
    processManager = FakeProcessManager.any();
    debugConnection = FakeDebugConnection();
    mockDevice = FakeDevice();
    appConnection = FakeAppConnection();
    webDevFS = FakeWebDevFS();
    residentCompiler = FakeResidentCompiler();
    chromeConnection = FakeChromeConnection();
    chromeTab = FakeChromeTab('index.html');
    webServerDevice = FakeWebServerDevice();
    flutterDevice = FakeFlutterDevice()
      .._devFS = webDevFS
      ..device = mockDevice
      ..generator = residentCompiler;
    fileSystem.file('.packages').writeAsStringSync('\n');
  });

  void _setupMocks() {
    fileSystem.file('pubspec.yaml').createSync();
    fileSystem.file('lib/main.dart').createSync(recursive: true);
    fileSystem.file('web/index.html').createSync(recursive: true);
    webDevFS.report = UpdateFSReport(success: true, syncedBytes: 0);
    debugConnection.fakeVmServiceHost = () => fakeVmServiceHost;
    webDevFS.result = ConnectionResult(
      appConnection,
      debugConnection,
      debugConnection.vmService,
    );
    debugConnection.uri = 'ws://127.0.0.1/abcd/';
    chromeConnection.tabs.add(chromeTab);
  }

  testUsingContext('runner with web server device does not support debugging without --start-paused', () {
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice);
    flutterDevice.device = WebServerDevice(
      logger: BufferLogger.test(),
    );
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[]);
    final ResidentRunner profileResidentWebRunner = ResidentWebRunner(
      flutterDevice,
      flutterProject: FlutterProject.fromDirectoryTest(fileSystem.currentDirectory),
      debuggingOptions: DebuggingOptions.enabled(BuildInfo.debug),
      ipv6: true,
      stayResident: true,
      urlTunneller: null,
      fileSystem: fileSystem,
      logger: BufferLogger.test(),
      usage: globals.flutterUsage,
      systemClock: globals.systemClock,
    );

    expect(profileResidentWebRunner.debuggingEnabled, false);

    flutterDevice.device = FakeChromeDevice();

    expect(residentWebRunner.debuggingEnabled, true);
    expect(fakeVmServiceHost.hasRemainingExpectations, false);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('runner with web server device supports debugging with --start-paused', () {
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[]);
    _setupMocks();
    flutterDevice.device = WebServerDevice(
      logger: BufferLogger.test(),
    );
    final ResidentRunner profileResidentWebRunner = ResidentWebRunner(
      flutterDevice,
      flutterProject: FlutterProject.fromDirectoryTest(fileSystem.currentDirectory),
      debuggingOptions: DebuggingOptions.enabled(BuildInfo.debug, startPaused: true),
      ipv6: true,
      stayResident: true,
      urlTunneller: null,
      fileSystem: fileSystem,
      logger: BufferLogger.test(),
      usage: globals.flutterUsage,
      systemClock: globals.systemClock,
    );

    expect(profileResidentWebRunner.uri, webDevFS.baseUri);
    expect(profileResidentWebRunner.debuggingEnabled, true);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });
  testUsingContext('profile does not supportsServiceProtocol', () {
    final ResidentRunner residentWebRunner = ResidentWebRunner(
      flutterDevice,
      flutterProject: FlutterProject.fromDirectoryTest(fileSystem.currentDirectory),
      debuggingOptions: DebuggingOptions.enabled(BuildInfo.debug),
      ipv6: true,
      stayResident: true,
      urlTunneller: null,
      fileSystem: fileSystem,
      logger: BufferLogger.test(),
      usage: globals.flutterUsage,
      systemClock: globals.systemClock,
    );
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[]);
    flutterDevice.device = chromeDevice;
    final ResidentRunner profileResidentWebRunner = ResidentWebRunner(
      flutterDevice,
      flutterProject: FlutterProject.fromDirectoryTest(fileSystem.currentDirectory),
      debuggingOptions: DebuggingOptions.enabled(BuildInfo.profile),
      ipv6: true,
      stayResident: true,
      urlTunneller: null,
      fileSystem: fileSystem,
      logger: BufferLogger.test(),
      usage: globals.flutterUsage,
      systemClock: globals.systemClock,
    );

    expect(profileResidentWebRunner.supportsServiceProtocol, false);
    expect(residentWebRunner.supportsServiceProtocol, true);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Can successfully run and connect to vmservice', () async {
    final BufferLogger logger = BufferLogger.test();
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice, logger: logger);
    fakeVmServiceHost = FakeVmServiceHost(requests: kAttachExpectations.toList());
    _setupMocks();

    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    final DebugConnectionInfo debugConnectionInfo = await connectionInfoCompleter.future;

    expect(appConnection.ranMain, true);
    expect(logger.statusText, contains('Debug service listening on ws://127.0.0.1/abcd/'));
    expect(debugConnectionInfo.wsUri.toString(), 'ws://127.0.0.1/abcd/');
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('WebRunner copies compiled app.dill to cache during startup', () async {
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice);
    fakeVmServiceHost = FakeVmServiceHost(requests: kAttachExpectations.toList());
    _setupMocks();

    residentWebRunner.artifactDirectory.childFile('app.dill').writeAsStringSync('ABC');
    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    await connectionInfoCompleter.future;

    expect(await fileSystem.file(fileSystem.path.join('build', 'cache.dill')).readAsString(), 'ABC');
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  // Regression test for https://github.com/flutter/flutter/issues/60613
  testUsingContext('ResidentWebRunner calls appFailedToStart if initial compilation fails', () async {
    _setupMocks();
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice);
    fileSystem.file(globals.fs.path.join('lib', 'main.dart'))
      .createSync(recursive: true);
    fakeVmServiceHost = FakeVmServiceHost(requests: kAttachExpectations.toList());
    webDevFS.report = UpdateFSReport(success: false, syncedBytes: 0);

    expect(await residentWebRunner.run(), 1);
    // Completing this future ensures that the daemon can exit correctly.
    expect(await residentWebRunner.waitForAppToFinish(), 1);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Can successfully run without an index.html including status warning', () async {
    final BufferLogger logger = BufferLogger.test();
    fakeVmServiceHost = FakeVmServiceHost(requests: kAttachExpectations.toList());
    _setupMocks();
    fileSystem.file(fileSystem.path.join('web', 'index.html'))
      .deleteSync();
    final ResidentWebRunner residentWebRunner = ResidentWebRunner(
      flutterDevice,
      flutterProject: FlutterProject.fromDirectoryTest(fileSystem.currentDirectory),
      debuggingOptions: DebuggingOptions.enabled(BuildInfo.debug),
      ipv6: true,
      stayResident: false,
      urlTunneller: null,
      fileSystem: fileSystem,
      logger: logger,
      usage: globals.flutterUsage,
      systemClock: globals.systemClock,
    );

    expect(await residentWebRunner.run(), 0);
    expect(logger.statusText,
      contains('This application is not configured to build on the web'));
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Can successfully run and disconnect with --no-resident', () async {
    fakeVmServiceHost = FakeVmServiceHost(requests: kAttachExpectations.toList());
    _setupMocks();
    final ResidentRunner residentWebRunner = ResidentWebRunner(
      flutterDevice,
      flutterProject: FlutterProject.fromDirectoryTest(fileSystem.currentDirectory),
      debuggingOptions: DebuggingOptions.enabled(BuildInfo.debug),
      ipv6: true,
      stayResident: false,
      urlTunneller: null,
      fileSystem: fileSystem,
      logger: BufferLogger.test(),
      usage: globals.flutterUsage,
      systemClock: globals.systemClock,
    );

    expect(await residentWebRunner.run(), 0);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Listens to stdout and stderr streams before running main', () async {
    final BufferLogger logger = BufferLogger.test();
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice, logger: logger);
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[
      ...kAttachLogExpectations,
      FakeVmServiceStreamResponse(
        streamId: 'Stdout',
        event: vm_service.Event(
          timestamp: 0,
          kind: vm_service.EventStreams.kStdout,
          bytes: base64.encode(utf8.encode('THIS MESSAGE IS IMPORTANT'))
        ),
      ),
      FakeVmServiceStreamResponse(
        streamId: 'Stderr',
        event: vm_service.Event(
          timestamp: 0,
          kind: vm_service.EventStreams.kStderr,
          bytes: base64.encode(utf8.encode('SO IS THIS'))
        ),
      ),
      ...kAttachIsolateExpectations,
    ]);
    _setupMocks();
    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    await connectionInfoCompleter.future;

    expect(logger.statusText, contains('THIS MESSAGE IS IMPORTANT'));
    expect(logger.statusText, contains('SO IS THIS'));
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Listens to extension events with structured errors', () async {
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice, logger: testLogger);
    final Map<String, String> extensionData = <String, String>{
      'test': 'data',
      'renderedErrorText': 'error text',
    };
    final Map<String, String> emptyExtensionData = <String, String>{
      'test': 'data',
      'renderedErrorText': '',
    };
    final Map<String, String> nonStructuredErrorData = <String, String>{
      'other': 'other stuff',
    };
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[
      ...kAttachExpectations,
      FakeVmServiceStreamResponse(
        streamId: 'Extension',
        event: vm_service.Event(
          timestamp: 0,
          extensionKind: 'Flutter.Error',
          extensionData: vm_service.ExtensionData.parse(extensionData),
          kind: vm_service.EventStreams.kExtension,
        ),
      ),
      // Empty error text should not break anything.
      FakeVmServiceStreamResponse(
        streamId: 'Extension',
        event: vm_service.Event(
          timestamp: 0,
          extensionKind: 'Flutter.Error',
          extensionData: vm_service.ExtensionData.parse(emptyExtensionData),
          kind: vm_service.EventStreams.kExtension,
        ),
      ),
      // This is not Flutter.Error kind data, so it should not be logged.
      FakeVmServiceStreamResponse(
        streamId: 'Extension',
        event: vm_service.Event(
          timestamp: 0,
          extensionKind: 'Other',
          extensionData: vm_service.ExtensionData.parse(nonStructuredErrorData),
          kind: vm_service.EventStreams.kExtension,
        ),
      ),
    ]);

    _setupMocks();
    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    await connectionInfoCompleter.future;
    await null;

    expect(testLogger.statusText, contains('\nerror text'));
    expect(testLogger.statusText, isNot(contains('other stuff')));
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Does not run main with --start-paused', () async {
    final ResidentRunner residentWebRunner = ResidentWebRunner(
      flutterDevice,
      flutterProject: FlutterProject.fromDirectoryTest(fileSystem.currentDirectory),
      debuggingOptions: DebuggingOptions.enabled(BuildInfo.debug, startPaused: true),
      ipv6: true,
      stayResident: true,
      urlTunneller: null,
      fileSystem: fileSystem,
      logger: BufferLogger.test(),
      usage: globals.flutterUsage,
      systemClock: globals.systemClock,
    );
    fakeVmServiceHost = FakeVmServiceHost(requests: kAttachExpectations.toList());
    _setupMocks();
    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();

    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    await connectionInfoCompleter.future;

    expect(appConnection.ranMain, false);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Can hot reload after attaching', () async {
    final BufferLogger logger = BufferLogger.test();
    final ResidentRunner residentWebRunner = setUpResidentRunner(
      flutterDevice,
      logger: logger,
      systemClock: SystemClock.fixed(DateTime(2001, 1, 1)),
    );
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[
      ...kAttachExpectations,
      const FakeVmServiceRequest(
        method: 'hotRestart',
        jsonResponse: <String, Object>{
          'type': 'Success',
        }
      ),
      const FakeVmServiceRequest(
        method: 'streamListen',
        args: <String, Object>{
          'streamId': 'Isolate',
        },
      ),
    ]);
    _setupMocks();
    final TestChromiumLauncher chromiumLauncher = TestChromiumLauncher();
    final Chromium chrome = Chromium(1, chromeConnection, chromiumLauncher: chromiumLauncher);
    chromiumLauncher.instance = chrome;

    flutterDevice.device = GoogleChromeDevice(
      fileSystem: fileSystem,
      chromiumLauncher: chromiumLauncher,
      logger: BufferLogger.test(),
      platform: FakePlatform(operatingSystem: 'linux'),
      processManager: FakeProcessManager.any(),
    );
    webDevFS.report = UpdateFSReport(success: true);

    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    final DebugConnectionInfo debugConnectionInfo = await connectionInfoCompleter.future;

    expect(debugConnectionInfo, isNotNull);

    final OperationResult result = await residentWebRunner.restart(fullRestart: false);

    expect(logger.statusText, contains('Restarted application in'));
    expect(result.code, 0);
    expect(webDevFS.mainUri.toString(), contains('entrypoint.dart'));

    // ensure that analytics are sent.
    expect(testUsage.events, <TestUsageEvent>[
      TestUsageEvent('hot', 'restart', parameters: CustomDimensions.fromMap(<String, String>{'cd27': 'web-javascript', 'cd28': '', 'cd29': 'false', 'cd30': 'true', 'cd13': '0'})),
    ]);
    expect(testUsage.timings, const <TestTimingEvent>[
      TestTimingEvent('hot', 'web-incremental-restart', Duration.zero),
    ]);
  }, overrides: <Type, Generator>{
    Usage: () => testUsage,
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Can hot restart after attaching', () async {
    final BufferLogger logger = BufferLogger.test();
    final ResidentRunner residentWebRunner = setUpResidentRunner(
      flutterDevice,
      logger: logger,
      systemClock: SystemClock.fixed(DateTime(2001, 1, 1)),
    );
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[
      ...kAttachExpectations,
      const FakeVmServiceRequest(
        method: 'hotRestart',
        jsonResponse: <String, Object>{
          'type': 'Success',
        }
      ),
    ]);
    _setupMocks();
    final TestChromiumLauncher chromiumLauncher = TestChromiumLauncher();
    final Chromium chrome = Chromium(1, chromeConnection, chromiumLauncher: chromiumLauncher);
    chromiumLauncher.instance = chrome;

    flutterDevice.device = GoogleChromeDevice(
      fileSystem: fileSystem,
      chromiumLauncher: chromiumLauncher,
      logger: BufferLogger.test(),
      platform: FakePlatform(operatingSystem: 'linux'),
      processManager: FakeProcessManager.any(),
    );
    webDevFS.report = UpdateFSReport(success: true);

    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    await connectionInfoCompleter.future;
    final OperationResult result = await residentWebRunner.restart(fullRestart: true);

    // Ensure that generated entrypoint is generated correctly.
    expect(webDevFS.mainUri, isNotNull);
    final String entrypointContents = fileSystem.file(webDevFS.mainUri).readAsStringSync();
    expect(entrypointContents, contains('// Flutter web bootstrap script'));
    expect(entrypointContents, contains("import 'dart:ui' as ui;"));
    expect(entrypointContents, contains('await ui.webOnlyInitializePlatform();'));

    expect(logger.statusText, contains('Restarted application in'));
    expect(result.code, 0);

	  // ensure that analytics are sent.
    expect(testUsage.events, <TestUsageEvent>[
      TestUsageEvent('hot', 'restart', parameters: CustomDimensions.fromMap(<String, String>{'cd27': 'web-javascript', 'cd28': '', 'cd29': 'false', 'cd30': 'true', 'cd13': '0'})),
    ]);
    expect(testUsage.timings, const <TestTimingEvent>[
      TestTimingEvent('hot', 'web-incremental-restart', Duration.zero),
    ]);
  }, overrides: <Type, Generator>{
    Usage: () => testUsage,
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Can hot restart after attaching with web-server device', () async {
    final BufferLogger logger = BufferLogger.test();
    final ResidentRunner residentWebRunner = setUpResidentRunner(
      flutterDevice,
      logger: logger,
      systemClock: SystemClock.fixed(DateTime(2001, 1, 1)),
    );
    fakeVmServiceHost = FakeVmServiceHost(requests :kAttachExpectations);
    _setupMocks();
    flutterDevice.device = webServerDevice;
    webDevFS.report = UpdateFSReport(success: true);

    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    await connectionInfoCompleter.future;
    final OperationResult result = await residentWebRunner.restart(fullRestart: true);

    expect(logger.statusText, contains('Restarted application in'));
    expect(result.code, 0);

	  // web-server device does not send restart analytics
    expect(testUsage.events, isEmpty);
    expect(testUsage.timings, isEmpty);
  }, overrides: <Type, Generator>{
    Usage: () => testUsage,
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('web resident runner is debuggable', () {
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice);
    fakeVmServiceHost = FakeVmServiceHost(requests: kAttachExpectations.toList());

    expect(residentWebRunner.debuggingEnabled, true);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Exits when initial compile fails', () async {
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice);
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[]);
    _setupMocks();
    webDevFS.report = UpdateFSReport(success: false,  syncedBytes: 0);

    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));

    expect(await residentWebRunner.run(), 1);
    expect(testUsage.events, isEmpty);
    expect(testUsage.timings, isEmpty);
  }, overrides: <Type, Generator>{
    Usage: () => testUsage,
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Faithfully displays stdout messages with leading/trailing spaces', () async {
    final BufferLogger logger = BufferLogger.test();
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice, logger: logger);
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[
      ...kAttachLogExpectations,
      FakeVmServiceStreamResponse(
        streamId: 'Stdout',
        event: vm_service.Event(
          timestamp: 0,
          kind: vm_service.EventStreams.kStdout,
          bytes: base64.encode(
            utf8.encode('    This is a message with 4 leading and trailing spaces    '),
          ),
        ),
      ),
      ...kAttachIsolateExpectations,
    ]);
    _setupMocks();
    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    await connectionInfoCompleter.future;

    expect(logger.statusText,
      contains('    This is a message with 4 leading and trailing spaces    '));
    expect(fakeVmServiceHost.hasRemainingExpectations, false);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Fails on compilation errors in hot restart', () async {
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice);
    fakeVmServiceHost = FakeVmServiceHost(requests: kAttachExpectations.toList());
    _setupMocks();
    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    await connectionInfoCompleter.future;
    webDevFS.report = UpdateFSReport(success: false,  syncedBytes: 0);

    final OperationResult result = await residentWebRunner.restart(fullRestart: true);

    expect(result.code, 1);
    expect(result.message, contains('Failed to recompile application.'));
    expect(testUsage.events, isEmpty);
    expect(testUsage.timings, isEmpty);
  }, overrides: <Type, Generator>{
    Usage: () => testUsage,
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Fails non-fatally on vmservice response error for hot restart', () async {
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice);
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[
      ...kAttachExpectations,
      const FakeVmServiceRequest(
        method: 'hotRestart',
        jsonResponse: <String, Object>{
          'type': 'Failed',
        }
      )
    ]);
    _setupMocks();
    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    await connectionInfoCompleter.future;

    final OperationResult result = await residentWebRunner.restart(fullRestart: false);

    expect(result.code, 0);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Fails fatally on Vm Service error response', () async {
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice);
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[
      ...kAttachExpectations,
      const FakeVmServiceRequest(
        method: 'hotRestart',
        // Failed response,
        errorCode: RPCErrorCodes.kInternalError,
      ),
    ]);
    _setupMocks();
    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    await connectionInfoCompleter.future;
    final OperationResult result = await residentWebRunner.restart(fullRestart: false);

    expect(result.code, 1);
    expect(result.message,
      contains(RPCErrorCodes.kInternalError.toString()));
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('printHelp without details shows hot restart help message', () async {
    final BufferLogger logger = BufferLogger.test();
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice, logger: logger);
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[]);
    residentWebRunner.printHelp(details: false);

    expect(logger.statusText, contains('To hot restart changes'));
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('cleanup of resources is safe to call multiple times', () async {
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice);
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[
      ...kAttachExpectations,
    ]);
    _setupMocks();
    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    await connectionInfoCompleter.future;

    await residentWebRunner.exit();
    await residentWebRunner.exit();

    expect(debugConnection.didClose, false);
    expect(fakeVmServiceHost.hasRemainingExpectations, false);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('cleans up Chrome if tab is closed', () async {
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice);
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[
      ...kAttachExpectations,
    ]);
    _setupMocks();
    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    final Future<int> result = residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    );
    await connectionInfoCompleter.future;
    debugConnection.completer.complete();

    await result;
    expect(fakeVmServiceHost.hasRemainingExpectations, false);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Prints target and device name on run', () async {
    final BufferLogger logger = BufferLogger.test();
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice, logger: logger);
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[
      ...kAttachExpectations,
    ]);
    _setupMocks();
    mockDevice.name = 'Chromez';
    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(residentWebRunner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    await connectionInfoCompleter.future;

    expect(logger.statusText, contains(
      'Launching ${fileSystem.path.join('lib', 'main.dart')} on '
      'Chromez in debug mode',
    ));
    expect(fakeVmServiceHost.hasRemainingExpectations, false);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Sends launched app.webLaunchUrl event for Chrome device', () async {
    final BufferLogger logger = BufferLogger.test();
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[
      ...kAttachLogExpectations,
      ...kAttachIsolateExpectations,
    ]);
    _setupMocks();
    final FakeChromeConnection chromeConnection = FakeChromeConnection();
    final TestChromiumLauncher chromiumLauncher = TestChromiumLauncher();
    final Chromium chrome = Chromium(1, chromeConnection, chromiumLauncher: chromiumLauncher);
    chromiumLauncher.instance = chrome;

    flutterDevice.device = GoogleChromeDevice(
      fileSystem: fileSystem,
      chromiumLauncher: chromiumLauncher,
      logger: logger,
      platform: FakePlatform(operatingSystem: 'linux'),
      processManager: FakeProcessManager.any(),
    );
    webDevFS.baseUri = Uri.parse('http://localhost:8765/app/');

    final FakeChromeTab chromeTab = FakeChromeTab('index.html');
    chromeConnection.tabs.add(chromeTab);

    final ResidentWebRunner runner = ResidentWebRunner(
      flutterDevice,
      flutterProject: FlutterProject.fromDirectoryTest(fileSystem.currentDirectory),
      debuggingOptions: DebuggingOptions.enabled(BuildInfo.debug),
      ipv6: true,
      stayResident: true,
      urlTunneller: null,
      fileSystem: fileSystem,
      logger: logger,
      usage: globals.flutterUsage,
      systemClock: globals.systemClock,
    );

    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(runner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    await connectionInfoCompleter.future;

    // Ensure we got the URL and that it was already launched.
    expect(logger.eventText,
      contains(json.encode(<String, Object>{
        'name': 'app.webLaunchUrl',
        'args': <String, Object>{
          'url': 'http://localhost:8765/app/',
          'launched': true,
        },
      },
    )));
    expect(fakeVmServiceHost.hasRemainingExpectations, false);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Sends unlaunched app.webLaunchUrl event for Web Server device', () async {
    final BufferLogger logger = BufferLogger.test();
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[]);
    _setupMocks();
    flutterDevice.device = WebServerDevice(
      logger: logger,
    );
    webDevFS.baseUri = Uri.parse('http://localhost:8765/app/');

    final ResidentWebRunner runner = ResidentWebRunner(
      flutterDevice,
      flutterProject: FlutterProject.fromDirectoryTest(fileSystem.currentDirectory),
      debuggingOptions: DebuggingOptions.enabled(BuildInfo.debug),
      ipv6: true,
      stayResident: true,
      urlTunneller: null,
      fileSystem: fileSystem,
      logger: logger,
      usage: globals.flutterUsage,
      systemClock: globals.systemClock,
    );

    final Completer<DebugConnectionInfo> connectionInfoCompleter = Completer<DebugConnectionInfo>();
    unawaited(runner.run(
      connectionInfoCompleter: connectionInfoCompleter,
    ));
    await connectionInfoCompleter.future;

    // Ensure we got the URL and that it was not already launched.
    expect(logger.eventText,
      contains(json.encode(<String, Object>{
        'name': 'app.webLaunchUrl',
        'args': <String, Object>{
          'url': 'http://localhost:8765/app/',
          'launched': false,
        },
      },
    )));
    expect(fakeVmServiceHost.hasRemainingExpectations, false);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Successfully turns WebSocketException into ToolExit', () async {
    final BufferLogger logger = BufferLogger.test();
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice, logger: logger);
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[]);
    _setupMocks();
    webDevFS.exception = const WebSocketException();

    await expectLater(residentWebRunner.run, throwsToolExit());
    expect(logger.errorText, contains('WebSocketException'));
    expect(fakeVmServiceHost.hasRemainingExpectations, false);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Successfully turns AppConnectionException into ToolExit', () async {
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice);
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[]);
    _setupMocks();
    webDevFS.exception = AppConnectionException('');

    await expectLater(residentWebRunner.run, throwsToolExit());
    expect(fakeVmServiceHost.hasRemainingExpectations, false);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Successfully turns ChromeDebugError into ToolExit', () async {
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice);
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[]);
    _setupMocks();

    webDevFS.exception = ChromeDebugException(<String, dynamic>{});

    await expectLater(residentWebRunner.run, throwsToolExit());
    expect(fakeVmServiceHost.hasRemainingExpectations, false);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Rethrows unknown Exception type from dwds', () async {
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice);
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[]);
    _setupMocks();
    webDevFS.exception = Exception();

    await expectLater(residentWebRunner.run, throwsException);
    expect(fakeVmServiceHost.hasRemainingExpectations, false);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });

  testUsingContext('Rethrows unknown Error type from dwds tooling', () async {
    final BufferLogger logger = BufferLogger.test();
    final ResidentRunner residentWebRunner = setUpResidentRunner(flutterDevice, logger: logger);
    fakeVmServiceHost = FakeVmServiceHost(requests: <VmServiceExpectation>[]);
    _setupMocks();
    webDevFS.exception = StateError('');

    await expectLater(residentWebRunner.run, throwsStateError);
    expect(fakeVmServiceHost.hasRemainingExpectations, false);
  }, overrides: <Type, Generator>{
    FileSystem: () => fileSystem,
    ProcessManager: () => processManager,
  });
}

ResidentRunner setUpResidentRunner(FlutterDevice flutterDevice, {
  Logger logger,
  SystemClock systemClock,
}) {
  return ResidentWebRunner(
    flutterDevice,
    flutterProject: FlutterProject.fromDirectoryTest(globals.fs.currentDirectory),
    debuggingOptions: DebuggingOptions.enabled(BuildInfo.debug),
    ipv6: true,
    stayResident: true,
    urlTunneller: null,
    usage: globals.flutterUsage,
    systemClock: systemClock ?? SystemClock.fixed(DateTime.now()),
    fileSystem: globals.fs,
    logger: logger ?? BufferLogger.test(),
    devtoolsHandler: createNoOpHandler,
  );
}

class FakeWebServerDevice extends FakeDevice implements WebServerDevice { }

class FakeDevice extends Fake implements Device {
  @override
  String name;

  int count = 0;

  @override
  Future<String> get sdkNameAndVersion async => 'SDK Name and Version';

  @override
  DartDevelopmentService dds;

  @override
  Future<LaunchResult> startApp(
    covariant ApplicationPackage package, {
    String mainPath,
    String route,
    DebuggingOptions debuggingOptions,
    Map<String, dynamic> platformArgs,
    bool prebuiltApplication = false,
    bool ipv6 = false,
    String userIdentifier,
  }) async {
    return LaunchResult.succeeded();
  }

  @override
  Future<bool> stopApp(
    covariant ApplicationPackage app, {
    String userIdentifier,
  }) async {
    if (count > 0) {
      throw StateError('stopApp called more than once.');
    }
    count += 1;
    return true;
  }
}

class FakeDebugConnection extends Fake implements DebugConnection {
  FakeVmServiceHost Function() fakeVmServiceHost;

  @override
  vm_service.VmService get vmService => fakeVmServiceHost.call().vmService.service;

  @override
  String uri;

  final Completer<void> completer = Completer<void>();
  bool didClose = false;

  @override
  Future<void> get onDone => completer.future;

  @override
  Future<void> close() async {
    didClose = true;
  }
}

class FakeAppConnection extends Fake implements AppConnection {
  bool ranMain = false;

  @override
  void runMain() {
    ranMain = true;
  }
}

class FakeChromeDevice extends Fake implements ChromiumDevice { }

class FakeWipDebugger extends Fake implements WipDebugger { }

class FakeResidentCompiler extends Fake implements ResidentCompiler {
  @override
  Future<CompilerOutput> recompile(
    Uri mainUri,
    List<Uri> invalidatedFiles, {
    @required String outputPath,
    @required PackageConfig packageConfig,
    @required String projectRootPath,
    @required FileSystem fs,
    bool suppressErrors = false,
  }) async {
    return const CompilerOutput('foo.dill', 0, <Uri>[]);
  }

  @override
  void accept() { }

  @override
  void reset() { }

  @override
  Future<CompilerOutput> reject() async {
    return const CompilerOutput('foo.dill', 0, <Uri>[]);
  }

  @override
  void addFileSystemRoot(String root) { }
}

class FakeWebDevFS extends Fake implements WebDevFS {
  Object exception;
  ConnectionResult result;
  UpdateFSReport report;

  Uri mainUri;

  @override
  List<Uri> sources = <Uri>[];

  @override
  Uri baseUri = Uri.parse('http://localhost:12345');

  @override
  DateTime lastCompiled = DateTime.now();

  @override
  PackageConfig lastPackageConfig = PackageConfig.empty;

  @override
  Future<Uri> create() async {
    return baseUri;
  }

  @override
  Future<UpdateFSReport> update({
    @required Uri mainUri,
    @required ResidentCompiler generator,
    @required bool trackWidgetCreation,
    @required String pathToReload,
    @required List<Uri> invalidatedFiles,
    @required PackageConfig packageConfig,
    @required String dillOutputPath,
    DevFSWriter devFSWriter,
    String target,
    AssetBundle bundle,
    DateTime firstBuildTime,
    bool bundleFirstUpload = false,
    bool fullRestart = false,
    String projectRootPath,
  }) async {
    this.mainUri = mainUri;
    return report;
  }

  @override
  Future<ConnectionResult> connect(bool useDebugExtension) async {
    if (exception != null) {
      throw exception;
    }
    return result;
  }
}

class FakeChromeConnection extends Fake implements ChromeConnection {
  final List<ChromeTab> tabs = <ChromeTab>[];

  @override
  Future<ChromeTab> getTab(bool Function(ChromeTab tab) accept, {Duration retryFor}) async {
    return tabs.firstWhere(accept);
  }
}

class FakeChromeTab extends Fake implements ChromeTab {
  FakeChromeTab(this.url);

  @override
  final String url;
  final FakeWipConnection connection = FakeWipConnection();

  @override
  Future<WipConnection> connect() async {
    return connection;
  }
}

class FakeWipConnection extends Fake implements WipConnection {
  @override
  final WipDebugger debugger = FakeWipDebugger();
}

/// A test implementation of the [ChromiumLauncher] that launches a fixed instance.
class TestChromiumLauncher implements ChromiumLauncher {
  TestChromiumLauncher();

  set instance(Chromium chromium) {
    _hasInstance = true;
    currentCompleter.complete(chromium);
  }
  bool _hasInstance = false;

  @override
  Completer<Chromium> currentCompleter = Completer<Chromium>();

  @override
  bool canFindExecutable() {
    return true;
  }

  @override
  Future<Chromium> get connectedInstance => currentCompleter.future;

  @override
  String findExecutable() {
    return 'chrome';
  }

  @override
  bool get hasChromeInstance => _hasInstance;

  @override
  Future<Chromium> launch(String url, {bool headless = false, int debugPort, bool skipCheck = false, Directory cacheDir}) async {
    return currentCompleter.future;
  }
}

class FakeFlutterDevice extends Fake implements FlutterDevice {
  Uri testUri;
  UpdateFSReport report = UpdateFSReport(
    success: true,
    syncedBytes: 0,
    invalidatedSourcesCount: 1,
  );
  Object reportError;

  @override
  ResidentCompiler generator;

  @override
  Stream<Uri> get observatoryUris => Stream<Uri>.value(testUri);

  @override
  FlutterVmService vmService;

  DevFS _devFS;

  @override
  DevFS get devFS => _devFS;

  @override
  set devFS(DevFS value) { }

  @override
  Device device;

  @override
  Future<void> stopEchoingDeviceLog() async { }

  @override
  Future<void> initLogReader() async { }

  @override
  Future<Uri> setupDevFS(String fsName, Directory rootDirectory) async {
    return testUri;
  }

  @override
  Future<void> exitApps({Duration timeoutDelay = const Duration(seconds: 10)}) async { }

  @override
  Future<void> connect({
    ReloadSources reloadSources,
    Restart restart,
    CompileExpression compileExpression,
    GetSkSLMethod getSkSLMethod,
    PrintStructuredErrorLogMethod printStructuredErrorLogMethod,
    int hostVmServicePort,
    int ddsPort,
    bool disableServiceAuthCodes = false,
    bool enableDds = true,
    @required bool allowExistingDdsInstance,
    bool ipv6 = false,
  }) async { }

  @override
  Future<UpdateFSReport> updateDevFS({
    Uri mainUri,
    String target,
    AssetBundle bundle,
    DateTime firstBuildTime,
    bool bundleFirstUpload = false,
    bool bundleDirty = false,
    bool fullRestart = false,
    String projectRootPath,
    String pathToReload,
    String dillOutputPath,
    List<Uri> invalidatedFiles,
    PackageConfig packageConfig,
  }) async {
    if (reportError != null) {
      throw reportError;
    }
    return report;
  }

  @override
  Future<void> updateReloadStatus(bool wasReloadSuccessful) async { }
}
