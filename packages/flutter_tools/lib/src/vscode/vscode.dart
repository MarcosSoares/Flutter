// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import '../base/common.dart';
import '../base/file_system.dart';
import '../base/platform.dart';
import '../base/version.dart';
import '../ios/plist_utils.dart';

// VS Code layout:

// macOS:
//   /Applications/Visual Studio Code.app/Contents/
//   /Applications/Visual Studio Code - Insiders.app/Contents/
//   $HOME/Applications/Visual Studio Code.app/Contents/
//   $HOME/Applications/Visual Studio Code - Insiders.app/Contents/
// macOS Extensions:
//   $HOME/.vscode/extensions
//   $HOME/.vscode-insiders/extensions

// Windows:
//   $programfiles(x86)\Microsoft VS Code
//   $programfiles(x86)\Microsoft VS Code Insiders
// TODO: Confirm these are correct for 64bit
//   $programfiles\Microsoft VS Code
//   $programfiles\Microsoft VS Code Insiders
// Windows Extensions:
//   $HOME/.vscode/extensions
//   $HOME/.vscode-insiders/extensions

// Linux:
//   /usr/share/code/bin/code
//   /usr/share/code-insiders/bin/code-insiders
// Linux Extensions:
//   $HOME/.vscode/extensions
//   $HOME/.vscode-insiders/extensions

const String extensionIdentifier = 'Dart-Code.dart-code';

const bool _includeInsiders =
    false; // Include VS Code insiders (useful for debugging).

class VsCode {
  VsCode(this.directory, this.dataFolderName, {Version version})
      : this.version = version ?? Version.unknown {
    _init();
  }

  final String directory;
  final String dataFolderName;
  final Version version;

  bool _isValid = false;
  Version extensionVersion;
  final List<String> _validationMessages = <String>[];

  factory VsCode.fromFolder(String installPath, String dataFolderName) {
    final String packageJsonPath =
        fs.path.join(installPath, 'resources', 'app', 'package.json');
    final String versionString = _getVersionFromPackageJson(packageJsonPath);
    Version version;
    if (versionString != null) version = new Version.parse(versionString);
    return new VsCode(installPath, dataFolderName, version: version);
  }

  bool get isValid => _isValid;

  List<String> get validationMessages => _validationMessages;

  static List<VsCode> allInstalled() {
    if (platform.isMacOS)
      return _installedMacOS();
    else if (platform.isWindows)
      return _installedWindows();
    else if (platform.isLinux)
      return _installedLinux();
    else
      // VS Code isn't supported on the other platforms.
      return [];
  }

  static List<VsCode> _installedMacOS() {
    final stable = {
      fs.path.join('/Applications', 'Visual Studio Code.app', 'Contents'):
          '.vscode',
      fs.path.join(homeDirPath, 'Applications', 'Visual Studio Code.app',
          'Contents'): '.vscode'
    };
    final insiders = {
      fs.path.join(
              '/Applications', 'Visual Studio Code - Insiders.app', 'Contents'):
          '.vscode-insiders',
      fs.path.join(homeDirPath, 'Applications',
          'Visual Studio Code - Insiders.app', 'Contents'): '.vscode-insiders'
    };

    return _findInstalled(stable, insiders);
  }

  static List<VsCode> _installedWindows() {
    final progFiles86 = platform.environment['programfiles(x86)'];
    final progFiles = platform.environment['programfiles'];

    final stable = {
      fs.path.join(progFiles86, 'Microsoft VS Code'): '.vscode',
      fs.path.join(progFiles, 'Microsoft VS Code'): '.vscode'
    };
    final insiders = {
      fs.path.join(progFiles86, 'Microsoft VS Code Insiders'):
          '.vscode-insiders',
      fs.path.join(progFiles, 'Microsoft VS Code Insiders'): '.vscode-insiders'
    };

    return _findInstalled(stable, insiders);
  }

  static List<VsCode> _installedLinux() {
    return _findInstalled({'/usr/share/code': '.vscode'},
        {'/usr/share/code-insiders': '.vscode-insiders'});
  }

  static List<VsCode> _findInstalled(
      Map<String, String> stable, Map<String, String> insiders) {
    final allPaths = new Map<String, String>();
    allPaths.addAll(stable);
    if (_includeInsiders) allPaths.addAll(insiders);

    final List<VsCode> results = <VsCode>[];

    for (var directory in allPaths.keys) {
      if (fs.directory(directory).existsSync())
        results.add(new VsCode.fromFolder(directory, allPaths[directory]));
    }

    return results;
  }

  void _init() {
    _isValid = false;
    _validationMessages.clear();

    if (!fs.isDirectorySync(directory)) {
      _validationMessages.add('VS Code not found at $directory');
      return;
    }

    // Check for presence of extension.
    final extensionFolders = fs
        .directory(fs.path.join(homeDirPath, dataFolderName, 'extensions'))
        .listSync()
        .where((d) => fs.isDirectorySync(d.path))
        .where((d) => d.basename.startsWith(extensionIdentifier));

    if (extensionFolders.isNotEmpty) {
      final extensionFolder = extensionFolders.first;

      _isValid = true;
      extensionVersion = new Version.parse(
          extensionFolder.basename.substring('Dart-Code.dart-code-'.length));
      validationMessages.add('Dart Code extension version $extensionVersion');
    }
  }

  @override
  String toString() =>
      'VS Code ($version)${(extensionVersion != Version.unknown ? ', Dart Code ($extensionVersion)' : '')}';

  static String _getVersionFromPackageJson(String packageJsonPath) {
    if (!fs.isFileSync(packageJsonPath)) return null;
    final jsonString = fs.file(packageJsonPath).readAsStringSync();
    Map json = JSON.decode(jsonString);
    return json['version'];
  }
}
