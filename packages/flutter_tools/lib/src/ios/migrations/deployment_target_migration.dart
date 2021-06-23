// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../base/file_system.dart';
import '../../base/logger.dart';
import '../../base/project_migrator.dart';
import '../../project.dart';

/// Update the minimum iOS deployment version to the minimum allowed by Xcode without causing a warning.
class DeploymentTargetMigration extends ProjectMigrator {
  DeploymentTargetMigration(
    IosProject project,
    Logger logger,
  )   : _xcodeProjectInfoFile = project.xcodeProjectInfoFile,
        super(logger);

  final File _xcodeProjectInfoFile;

  @override
  bool migrate() {
    if (!_xcodeProjectInfoFile.existsSync()) {
      logger.printTrace('Xcode project not found, skipping iOS deployment target version migration.');
      return true;
    }

    processFileLines(_xcodeProjectInfoFile);

    return true;
  }

  @override
  String? migrateLine(String line) {
    const String deploymentTargetOriginal = 'IPHONEOS_DEPLOYMENT_TARGET = 8.0;';
    const String deploymentTargetReplacement = 'IPHONEOS_DEPLOYMENT_TARGET = 9.0;';
    if (line.contains(deploymentTargetOriginal)) {
      if (!migrationRequired) {
        // Only print for the first discovered change found.
        logger.printStatus('Updating minimum iOS deployment target from 8.0 to 9.0.');
      }
      return line.replaceAll(deploymentTargetOriginal, deploymentTargetReplacement);
    }

    return line;
  }
}
