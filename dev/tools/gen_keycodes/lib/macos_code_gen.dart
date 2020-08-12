// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:path/path.dart' as path;

import 'base_code_gen.dart';
import 'key_data.dart';
import 'utils.dart';
import 'mask_constants.dart';

String _toConstantVariableName(String variableName) {
  return 'k${variableName[0].toUpperCase()}${variableName.substring(1)}';
}

/// Generates the key mapping of macOS, based on the information in the key
/// data structure given to it.
class MacOsCodeGenerator extends PlatformCodeGenerator {
  MacOsCodeGenerator(KeyData keyData, this.maskConstants) : super(keyData);

  final List<MaskConstant> maskConstants;

  /// This generates the map of macOS key codes to physical keys.
  String get _macOsScanCodeMap {
    final StringBuffer macOsScanCodeMap = StringBuffer();
    for (final Key entry in keyData.data) {
      if (entry.macOsScanCode != null) {
        macOsScanCodeMap.writeln('  @${toHex(entry.macOsScanCode)} : @${toHex(entry.usbHidCode)},    // ${entry.constantName}');
      }
    }
    return macOsScanCodeMap.toString().trimRight();
  }

  /// This generates the map of macOS number pad key codes to logical keys.
  String get _macOsNumpadMap {
    final StringBuffer macOsNumPadMap = StringBuffer();
    for (final Key entry in numpadKeyData) {
      if (entry.macOsScanCode != null) {
        macOsNumPadMap.writeln('  @${toHex(entry.macOsScanCode)} : @${toHex(entry.flutterId, digits: 10)},    // ${entry.constantName}');
      }
    }
    return macOsNumPadMap.toString().trimRight();
  }

  String get _macOsFunctionKeyMap {
    final StringBuffer macOsFunctionKeyMap = StringBuffer();
    for (final Key entry in functionKeyData) {
      if (entry.macOsScanCode != null) {
        macOsFunctionKeyMap.writeln('  @${toHex(entry.macOsScanCode)} : @${toHex(entry.flutterId, digits: 10)},    // ${entry.constantName}');
      }
    }
    return macOsFunctionKeyMap.toString().trimRight();
  }

  String get _maskConstants {
    final StringBuffer buffer = StringBuffer();
    for (final MaskConstant constant in maskConstants) {
      buffer.writeln('/**');
      buffer.write(constant.description
        .map((String line) => wrapString(line, prefix: ' * '))
        .join(' *\n'));
      buffer.writeln(' */');
      buffer.writeln('const uint64_t ${_toConstantVariableName(constant.name)} = ${constant.value};');
      buffer.writeln('');
    }
    return buffer.toString().trimRight();
  }

  @override
  String get templatePath => path.join(flutterRoot.path, 'dev', 'tools', 'gen_keycodes', 'data', 'keyboard_map_darwin_cc.tmpl');

  @override
  String outputPath(String platform) => path.join(flutterRoot.path, '..', 'engine', 'src', 'flutter', path.join('shell', 'platform', 'darwin', 'macos', 'framework', 'Source', 'KeyCodeMap.mm'));

  @override
  Map<String, String> mappings() {
    // There is no macOS keycode map since macOS uses keycode to represent a physical key.
    // The LogicalKeyboardKey is generated by raw_keyboard_macos.dart from the unmodified characters
    // from NSEvent.
    return <String, String>{
      'MACOS_SCAN_CODE_MAP': _macOsScanCodeMap,
      'MACOS_NUMPAD_MAP': _macOsNumpadMap,
      'MACOS_FUNCTION_KEY_MAP': _macOsFunctionKeyMap,
      'MASK_CONSTANTS': _maskConstants,
    };
  }
}
