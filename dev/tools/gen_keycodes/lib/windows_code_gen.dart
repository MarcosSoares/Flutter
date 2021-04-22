// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'base_code_gen.dart';
import 'logical_key_data.dart';
import 'physical_key_data.dart';
import 'utils.dart';

/// Generates the key mapping of Windows, based on the information in the key
/// data structure given to it.
class WindowsCodeGenerator extends PlatformCodeGenerator {
  WindowsCodeGenerator(PhysicalKeyData keyData, LogicalKeyData logicalData)
    : super(keyData, logicalData);

  /// This generates the map of Windows scan codes to physical keys.
  String get _windowsScanCodeMap {
    final StringBuffer windowsScanCodeMap = StringBuffer();
    for (final PhysicalKeyEntry entry in keyData.data.values) {
      if (entry.windowsScanCode != null) {
        windowsScanCodeMap.writeln('        {${toHex(entry.windowsScanCode)}, ${toHex(entry.usbHidCode)}},  // ${entry.constantName}');
      }
    }
    return windowsScanCodeMap.toString().trimRight();
  }

  /// This generates the map of Windows key codes to logical keys.
  String get _windowsLogicalKeyCodeMap {
    final StringBuffer result = StringBuffer();
    for (final LogicalKeyEntry entry in logicalData.data.values) {
      zipStrict(entry.windowsValues, entry.windowsNames, (int windowsValue, String windowsName) {
        result.writeln('        {${toHex(windowsValue)}, ${toHex(entry.value, digits: 11)}},  // $windowsName');
      });
    }
    return result.toString().trimRight();
  }

  /// This generates the map from scan code to logical keys.
  ///
  /// Normally logical keys should only be derived from key codes, but since some
  /// key codes are either 0 or ambiguous (multiple keys using the same key
  /// code), these keys are resolved by scan codes.
  String get _scanCodeToLogicalMap {
    final Map<String, dynamic> source = json.decode(File(
      path.join(flutterRoot.path, 'dev', 'tools', 'gen_keycodes', 'data', 'windows_scancode_logical_map.json')
    ).readAsStringSync()) as Map<String, dynamic>;
    final StringBuffer result = StringBuffer();
    source.forEach((String scanCodeName, dynamic logicalName) {
      final PhysicalKeyEntry? physicalEntry = keyData.data[scanCodeName];
      final int? logicalValue = logicalData.data[logicalName]?.value;
      if (physicalEntry == null) {
        print('Unexpected scan code $scanCodeName specified for scanCodeToLogicalMap.');
        return;
      }
      if (logicalValue == null) {
        print('Unexpected logical key $logicalName specified for scanCodeToLogicalMap.');
        return;
      }
      result.writeln('        {${toHex(physicalEntry.windowsScanCode)}, ${toHex(logicalValue, digits: 10)}},  // ${physicalEntry.name}');
    });
    return result.toString().trimRight();
  }

  @override
  String get templatePath => path.join(flutterRoot.path, 'dev', 'tools', 'gen_keycodes', 'data', 'windows_flutter_key_map_cc.tmpl');

  @override
  String outputPath(String platform) => path.join(flutterRoot.path, '..', 'engine', 'src', 'flutter', path.join('shell', 'platform', 'windows', 'flutter_key_map.cc'));

  @override
  Map<String, String> mappings() {
    return <String, String>{
      'WINDOWS_SCAN_CODE_MAP': _windowsScanCodeMap,
      'WINDOWS_SCAN_CODE_TO_LOGICAL_MAP': _scanCodeToLogicalMap,
      'WINDOWS_KEY_CODE_MAP': _windowsLogicalKeyCodeMap,
    };
  }
}
