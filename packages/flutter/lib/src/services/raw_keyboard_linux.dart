// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

import 'keyboard_key.dart';
import 'keyboard_maps.dart';
import 'raw_keyboard.dart';

/// Platform-specific key event data for Linux.
///
/// Different window toolkit implementations can map to different key codes. This class
/// will use the correct mapping depending on the [toolkit] provided.
///
/// See also:
///
///  * [RawKeyboard], which uses this interface to expose key data.
class RawKeyEventDataLinux extends RawKeyEventData {
  /// Creates a key event data structure specific for macOS.
  ///
  /// The [toolkit], [scanCode], [codePoint], [keyCode], and
  /// [modifiers], arguments must not be null.
  const RawKeyEventDataLinux({
    @required this.keyHelper,
    this.codePoint = '',
    this.scanCode = 0,
    this.keyCode = 0,
    this.modifiers = 0,
  }) : assert(scanCode != null),
       assert(codePoint != null),
       assert(keyCode != null),
       assert(modifiers != null),
       assert(keyHelper != null);

  /// A helper class that abstracts the fetching of the toolkit-specific mappings.
  ///
  /// There is no real concept of a "native" window toolkit on Linux, and each implementation
  /// (GLFW, GTK, QT, etc) may have a different key code mapping.
  final KeyHelper keyHelper;

  /// The name of the printable key, encoded as UTF-8. This is
  /// typically the character that key would produce without any modifier keys.
  /// For dead keys, it is typically the diacritic it would add to a character.
  /// Defaults to an empty string, asserted to be not null.
  final String codePoint;

  /// The hardware scan code id corresponding to this key event.
  ///
  /// These values are not reliable and vary from device to device, so this
  /// information is mainly useful for debugging.
  final int scanCode;

  /// The hardware key code corresponding to this key event.
  ///
  /// This is the physical key that was pressed, not the Unicode character.
  /// See [codePoint] for the unmodified Unicode character.
  /// This value may be different depending on the window toolkit used. See [KeyHelper].
  final int keyCode;

  /// A mask of the current modifiers using the values in Modifier Flags.
  /// This value may be different depending on the window toolkit used See [KeyHelper].
  final int modifiers;

  @override
  String get keyLabel => codePoint.isEmpty ? null : codePoint;

  @override
  PhysicalKeyboardKey get physicalKey => kLinuxToPhysicalKey[scanCode] ?? PhysicalKeyboardKey.none;

  @override
  LogicalKeyboardKey get logicalKey {
    // Look to see if the keyCode is a printable number pad key, so that a
    // difference between regular keys (e.g. "=") and the number pad version
    // (e.g. the "=" on the number pad) can be determined.
    final LogicalKeyboardKey numPadKey = keyHelper.numpadKey(keyCode);
    if (numPadKey != null) {
      return numPadKey;
    }

    // If it has a non-control-character label, then either return the existing
    // constant, or construct a new Unicode-based key from it. Don't mark it as
    // autogenerated, since the label uniquely identifies an ID from the Unicode
    // plane.
    if (keyLabel != null &&
        !LogicalKeyboardKey.isControlCharacter(keyLabel)) {
      // Not covering length > 2 case since > 1 is already unlikely.
      assert(codePoint.length <= 2);
      int codeUnit = codePoint.codeUnitAt(0);
      if (codePoint.length == 2) {
        final int secondCode = codePoint.codeUnitAt(1);
        codeUnit = (codeUnit << 16) | secondCode;
      }

      final int keyId = LogicalKeyboardKey.unicodePlane | (codeUnit & LogicalKeyboardKey.valueMask);
      return LogicalKeyboardKey.findKeyByKeyId(keyId) ?? LogicalKeyboardKey(
        keyId,
        keyLabel: keyLabel,
        debugName: kReleaseMode ? null : 'Key ${keyLabel.toUpperCase()}',
      );
    }

    // Look to see if the keyCode is one we know about and have a mapping for.
    LogicalKeyboardKey newKey = keyHelper.logicalKey(keyCode);
    if (newKey != null) {
      return newKey;
    }

    const int linuxKeyIdPlane = 0x00600000000;

    // This is a non-printable key that we don't know about, so we mint a new
    // code with the autogenerated bit set.
    newKey ??= LogicalKeyboardKey(
      linuxKeyIdPlane | keyCode | LogicalKeyboardKey.autogeneratedMask,
      debugName: kReleaseMode ? null : 'Unknown key code $keyCode',
    );
    return newKey;
  }

  @override
  bool isModifierPressed(ModifierKey key, {KeyboardSide side = KeyboardSide.any}) {
   return keyHelper.isModifierPressed(key, modifiers, side: side);
  }

  @override
  KeyboardSide getModifierSide(ModifierKey key) {
    return keyHelper.getModifierSide(key);
  }

  @override
  String toString() {
    return '$runtimeType(keyLabel: $keyLabel, keyCode: $keyCode, scanCode: $scanCode,'
        ' codePoint: $codePoint, modifiers: $modifiers, '
        'modifiers down: $modifiersPressed)';
  }
}

/// Abstract class for window-specific key mappings.
///
/// Given that there might be multiple window toolkit implementations (GLFW,
/// GTK, QT, etc), this creates a common interface for each of the
/// different toolkits.
abstract class KeyHelper {
  /// Create a KeyHelper implementation depending on the given toolkit.
  factory KeyHelper(String toolkit) {
    if (toolkit == 'glfw') {
      return GLFWKeyHelper();
    } else {
      throw FlutterError('Window toolkit not recognized: $toolkit');
    }
  }

  /// Returns a [KeyboardSide] enum value that describes which side or sides of
  /// the given keyboard modifier key were pressed at the time of this event.
  KeyboardSide getModifierSide(ModifierKey key);

  /// Returns true if the given [ModifierKey] was pressed at the time of this
  /// event.
  bool isModifierPressed(ModifierKey key, int modifiers, {KeyboardSide side = KeyboardSide.any});

  /// The numpad key from the specific key code mapping.
  LogicalKeyboardKey numpadKey(int keyCode);

  /// The logical key key from the specific key code mapping.
  LogicalKeyboardKey logicalKey(int keyCode);
}

/// Helper class that uses GLFW-specific key mappings.
class GLFWKeyHelper with KeyHelper {
  /// This mask is used to check the [modifiers] field to test whether the CAPS
  /// LOCK modifier key is on.
  ///
  /// {@template flutter.services.logicalKeyboardKey.modifiers}
  /// Use this value if you need to decode the [modifiers] field yourself, but
  /// it's much easier to use [isModifierPressed] if you just want to know if
  /// a modifier is pressed.
  /// {@endtemplate}
  static const int modifierCapsLock = 0x0010;

  /// This mask is used to check the [modifiers] field to test whether one of the
  /// SHIFT modifier keys is pressed.
  ///
  /// {@macro flutter.services.logicalKeyboardKey.modifiers}
  static const int modifierShift = 0x0001;

  /// This mask is used to check the [modifiers] field to test whether one of the
  /// CTRL modifier keys is pressed.
  ///
  /// {@macro flutter.services.logicalKeyboardKey.modifiers}
  static const int modifierControl = 0x0002;

  /// This mask is used to check the [modifiers] field to test whether one of the
  /// ALT modifier keys is pressed.
  ///
  /// {@macro flutter.services.logicalKeyboardKey.modifiers}
  static const int modifierAlt = 0x0004;

  /// This mask is used to check the [modifiers] field to test whether one of the
  /// Meta(SUPER) modifier keys is pressed.
  ///
  /// {@macro flutter.services.logicalKeyboardKey.modifiers}
  static const int modifierMeta = 0x0008;


  /// This mask is used to check the [modifiers] field to test whether any key in
  /// the numeric keypad is pressed.
  ///
  /// {@macro flutter.services.logicalKeyboardKey.modifiers}
  static const int modifierNumericPad = 0x0020;

  @override
  bool isModifierPressed(ModifierKey key, int modifiers, {KeyboardSide side = KeyboardSide.any}) {
    switch (key) {
      case ModifierKey.controlModifier:
      return modifiers & modifierControl != 0;
      case ModifierKey.shiftModifier:
            return modifiers & modifierShift != 0;
      case ModifierKey.altModifier:
            return modifiers & modifierAlt != 0;
      case ModifierKey.metaModifier:
            return modifiers & modifierMeta != 0;
      case ModifierKey.capsLockModifier:
        return modifiers & modifierCapsLock != 0;
      case ModifierKey.numLockModifier:
        return modifiers & modifierNumericPad != 0;
      case ModifierKey.functionModifier:
      case ModifierKey.symbolModifier:
      case ModifierKey.scrollLockModifier:
        // These are not used in GLFW keyboards.
        return false;
    }
    return false;
  }

  @override
  KeyboardSide getModifierSide(ModifierKey key) {
    switch (key) {
      case ModifierKey.controlModifier:
      case ModifierKey.shiftModifier:
      case ModifierKey.altModifier:
      case ModifierKey.metaModifier:
       // Neither GLFW or X11 provide a distinction between left and right modifiers, so defaults to KeyboardSide.any.
       // https://code.woboq.org/qt5/include/X11/X.h.html#_M/ShiftMask
       return KeyboardSide.any;
      case ModifierKey.capsLockModifier:
      case ModifierKey.numLockModifier:
      case ModifierKey.functionModifier:
      case ModifierKey.symbolModifier:
      case ModifierKey.scrollLockModifier:
       return KeyboardSide.all;
    }
    assert(false, 'Not handling $key type properly.');
    return null;
  }

  @override
  LogicalKeyboardKey numpadKey(int keyCode) {
    return kGlfwNumpadMap[keyCode];
  }

  @override
  LogicalKeyboardKey logicalKey(int keyCode) {
      return kGlfwToLogicalKey[keyCode];
  }
}
