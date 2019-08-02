// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_tools/src/base/common.dart';
import 'package:flutter_tools/src/base/file_system.dart';
import 'package:flutter_tools/src/build_info.dart';
import 'package:flutter_tools/src/build_system/build_system.dart';
import 'package:flutter_tools/src/bundle.dart';
import 'package:flutter_tools/src/project.dart';
import 'package:mockito/mockito.dart';

import '../src/common.dart';
import '../src/testbed.dart';

// Tests for the temporary flutter assemble/bundle shim.
void main() {
  Testbed testbed;

  setUp(() {
    testbed = Testbed(overrides: <Type, Generator>{
      BuildSystem: () => MockBuildSystem(),
    });
  });

  test('Copies assets to expected directory after building', () => testbed.run(() async {
    when(buildSystem.build(any, any)).thenAnswer((Invocation invocation) async {
      final Environment environment = invocation.positionalArguments[1];
      environment.buildDir.childFile('app.dill').createSync(recursive: true);
      environment.buildDir.childDirectory('flutter_assets')
          .childFile('LICENSE').createSync(recursive: true);
      return BuildResult(success: true);
    });
    await buildWithAssemble(
      buildMode: BuildMode.debug,
      flutterProject: FlutterProject.current(),
      mainPath: fs.path.join('lib', 'main.dart'),
      outputDir: 'example',
      targetPlatform: TargetPlatform.ios
    );
    expect(fs.file(fs.path.join('example', 'kernel_blob.bin')).existsSync(), true);
    expect(fs.file(fs.path.join('example', 'LICENSE')).existsSync(), true);
  }));

  test('Handles build system failure', () => testbed.run(() {
    when(buildSystem.build(any, any)).thenAnswer((Invocation _) async {
      return BuildResult(
        success: false,
        exceptions: <String, ExceptionMeasurement>{},
      );
    });

    expect(() => buildWithAssemble(
      buildMode: BuildMode.debug,
      flutterProject: FlutterProject.current(),
      mainPath: 'lib/main.dart',
      outputDir: 'example',
      targetPlatform: TargetPlatform.linux_x64,
    ), throwsA(isInstanceOf<ToolExit>()));
  }));
}

class MockBuildSystem extends Mock implements BuildSystem {}
