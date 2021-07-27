// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show TextPosition;

import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, TextMetrics, TextRange;

import 'actions.dart';
import 'editable_text.dart';
import 'focus_manager.dart';
import 'framework.dart';

// TODO(justinmc): Should TextEditingActionTarget be in its own file?
/// The recipient of a [TextEditingAction].
///
/// TextEditingActions will only be enabled when an implementer of this class is
/// focused.
///
/// See also:
///
///   * [EditableTextState], which implements this and is the most typical
///     target of a TextEditingAction.
abstract class TextEditingActionTarget {
  /// Whether the characters in the field are obscured from the user.
  ///
  /// When true, the entire contents of the field are treated as one word.
  bool get obscureText;

  /// Whether the field currently in a read-only state.
  ///
  /// When true, [value]'s text may not be modified, but its selection can be.
  bool get readOnly;

  /// Whether the [value]'s selection can be modified.
  bool get selectionEnabled;

  // TODO(justinmc): Could this be made private?
  /// Provides information about the text that is the target of this action.
  ///
  /// See also:
  ///
  /// * [EditableTextState.renderEditable], which overrides this.
  TextMetrics get textMetrics;

  /// The [TextEditingValue] expressed in this field.
  TextEditingValue get value;

  // Holds the last cursor location the user selected in the case the user tries
  // to select vertically past the end or beginning of the field. If they do,
  // then we need to keep the old cursor location so that we can go back to it
  // if they change their minds. Only used for moving selection up and down in a
  // multiline text field when selecting using the keyboard.
  int _cursorResetLocation = -1;

  // Whether we should reset the location of the cursor in the case the user
  // tries to select vertically past the end or beginning of the field. If they
  // do, then we need to keep the old cursor location so that we can go back to
  // it if they change their minds. Only used for resetting selection up and
  // down in a multiline text field when selecting using the keyboard.
  bool _wasSelectingVerticallyWithKeyboard = false;

  /// {@template flutter.rendering.TextEditingAction.setSelection}
  /// Called to update the [TextSelection] in the current [TextEditingValue].
  /// {@endtemplate}
  void setSelection(TextSelection nextSelection, SelectionChangedCause cause) {
    setTextEditingValue(
      value.copyWith(selection: nextSelection),
      cause,
    );
  }

  /// {@template flutter.rendering.TextEditingAction.setSelection}
  /// Called to update the current [TextEditingValue].
  /// {@endtemplate}
  void setTextEditingValue(TextEditingValue newValue, SelectionChangedCause cause);

  // Extend the current selection to the end of the field.
  //
  // If selectionEnabled is false, keeps the selection collapsed and moves it to
  // the end.
  //
  // See also:
  //
  //   * _extendSelectionToStart
  void _extendSelectionToEnd(SelectionChangedCause cause) {
    if (value.selection.extentOffset == value.text.length) {
      return;
    }

    final TextSelection nextSelection = value.selection.copyWith(
      extentOffset: value.text.length,
    );
    return setSelection(nextSelection, cause);
  }

  // Extend the current selection to the start of the field.
  //
  // If selectionEnabled is false, keeps the selection collapsed and moves it to
  // the start.
  //
  // The given [SelectionChangedCause] indicates the cause of this change and
  // will be passed to [onSelectionChanged].
  //
  // See also:
  //
  //   * _extendSelectionToEnd
  void _extendSelectionToStart(SelectionChangedCause cause) {
    if (!selectionEnabled) {
      return moveSelectionToStart(cause);
    }

    setSelection(value.extendSelectionTo(0), cause);
  }

  /// Return the offset at the start of the nearest word to the left of the
  /// given offset.
  ///
  /// {@macro flutter.rendering.RenderEditable.stopAtReversal}
  int _getLeftByWord(int offset, [bool includeWhitespace = true]) {
    // If the offset is already all the way left, there is nothing to do.
    if (offset <= 0) {
      return offset;
    }

    // If we can just return the start of the text without checking for a word.
    if (offset == 1) {
      return 0;
    }

    final int startPoint = TextEditingValue.previousCharacter(
        offset, value.text, includeWhitespace);
    final TextRange word =
        textMetrics.getWordBoundary(TextPosition(offset: startPoint));
    return word.start;
  }

  /// Return the offset at the end of the nearest word to the right of the given
  /// offset.
  ///
  /// {@macro flutter.rendering.RenderEditable.stopAtReversal}
  int _getRightByWord(int offset, [bool includeWhitespace = true]) {
    // If the selection is already all the way right, there is nothing to do.
    if (offset == value.text.length) {
      return offset;
    }

    // If we can just return the end of the text without checking for a word.
    if (offset == value.text.length - 1 || offset == value.text.length) {
      return value.text.length;
    }

    final int startPoint = includeWhitespace ||
            !TextEditingValue.isWhitespace(value.text.codeUnitAt(offset))
        ? offset
        : TextEditingValue.nextCharacter(offset, value.text, includeWhitespace);
    final TextRange nextWord =
        textMetrics.getWordBoundary(TextPosition(offset: startPoint));
    return nextWord.end;
  }

  /// Deletes backwards from the selection in [textSelectionDelegate].
  ///
  /// This method operates on the text/selection contained in
  /// [textSelectionDelegate], and does not depend on [selection].
  ///
  /// If the selection is collapsed, deletes a single character before the
  /// cursor.
  ///
  /// If the selection is not collapsed, deletes the selection.
  ///
  /// If [readOnly] is true, does nothing.
  ///
  /// {@template flutter.rendering.RenderEditable.cause}
  /// The given [SelectionChangedCause] indicates the cause of this change and
  /// will be passed to [onSelectionChanged].
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///   * [deleteForward], which is same but in the opposite direction.
  void delete(SelectionChangedCause cause) {
    if (readOnly) {
      return;
    }

    // `delete` does not depend on the text layout, and the boundary analysis is
    // done using the `previousCharacter` method instead of ICU, we can keep
    // deleting without having to layout the text. For this reason, we can
    // directly delete the character before the caret in the controller.
    final String textBefore = value.selection.textBefore(value.text);
    final int characterBoundary = TextEditingValue.previousCharacter(
      textBefore.length,
      textBefore,
    );
    setTextEditingValue(value.deleteTo(characterBoundary), cause);
  }

  // TODO(justinmc): Update the references on this whiteSpace template.
  /// Deletes a word backwards from the current selection.
  ///
  /// If the [selection] is collapsed, deletes a word before the cursor.
  ///
  /// If the [selection] is not collapsed, deletes the selection.
  ///
  /// If [readOnly] is true, does nothing.
  ///
  /// If [obscureText] is true, it treats the whole text content as a single
  /// word.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// {@template flutter.rendering.RenderEditable.whiteSpace}
  /// By default, includeWhitespace is set to true, meaning that whitespace can
  /// be considered a word in itself.  If set to false, the selection will be
  /// extended past any whitespace and the first word following the whitespace.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.deleteByWord], which is used by this method.
  ///   * [deleteForwardByWord], which is same but in the opposite direction.
  void deleteByWord(SelectionChangedCause cause,
      [bool includeWhitespace = true]) {
    if (readOnly) {
      return;
    }

    if (obscureText) {
      // When the text is obscured, the whole thing is treated as one big line.
      return deleteToStart(cause);
    }

    String textBefore = value.selection.textBefore(value.text);
    final int characterBoundary =
        _getLeftByWord(textBefore.length, includeWhitespace);
    final TextEditingValue nextValue = value.deleteTo(characterBoundary, includeWhitespace);

    setTextEditingValue(nextValue, cause);
  }

  /// Deletes a line backwards from the current selection.
  ///
  /// If the [selection] is collapsed, deletes a line before the cursor.
  ///
  /// If the [selection] is not collapsed, deletes the selection.
  ///
  /// If [obscureText] is true, it treats the whole text content as
  /// a single word.
  ///
  /// If [readOnly] is true, does nothing.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.deleteByLine], which is used by this method.
  ///   * [deleteForwardByLine], which is same but in the opposite direction.
  void deleteByLine(SelectionChangedCause cause) {
    if (readOnly) {
      return;
    }

    // When there is a line break, line delete shouldn't do anything
    final String textBefore = value.selection.textBefore(value.text);
    final bool isPreviousCharacterBreakLine =
        textBefore.codeUnitAt(textBefore.length - 1) == 0x0A;
    if (isPreviousCharacterBreakLine) {
      return;
    }

    // When the text is obscured, the whole thing is treated as one big line.
    if (obscureText) {
      return deleteToStart(cause);
    }

    final TextSelection line = textMetrics.getLineAtOffset(
      value.text, TextPosition(offset: textBefore.length - 1),
    );

    setTextEditingValue(value.deleteTo(line.start), cause);
  }

  /// Deletes in the forward direction.
  ///
  /// If the selection is collapsed, deletes a single character after the
  /// cursor.
  ///
  /// If the selection is not collapsed, deletes the selection.
  ///
  /// If [readOnly] is true, does nothing.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [delete], which is the same but in the opposite direction.
  void deleteForward(SelectionChangedCause cause) {
    final String textAfter = value.selection.textAfter(value.text);
    final int characterBoundary = TextEditingValue.nextCharacter(0, textAfter);
    setTextEditingValue(value.deleteTo(value.selection.end + characterBoundary), cause);
  }

  /// Deletes a word in the forward direction from the current selection.
  ///
  /// If the [selection] is collapsed, deletes a word after the cursor.
  ///
  /// If the [selection] is not collapsed, deletes the selection.
  ///
  /// If [readOnly] is true, does nothing.
  ///
  /// If [obscureText] is true, it treats the whole text content as
  /// a single word.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// {@macro flutter.rendering.RenderEditable.whiteSpace}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.deleteForwardByWord], which is used by this method.
  ///   * [deleteByWord], which is same but in the opposite direction.
  void deleteForwardByWord(SelectionChangedCause cause,
      [bool includeWhitespace = true]) {
    if (readOnly) {
      return;
    }

    if (obscureText) {
      // When the text is obscured, the whole thing is treated as one big word.
      return deleteToEnd(cause);
    }

    final String textBefore = value.selection.textBefore(value.text);
    final int characterBoundary = _getRightByWord(textBefore.length, includeWhitespace);
    final TextEditingValue nextValue = value.deleteTo(characterBoundary, includeWhitespace);

    setTextEditingValue(nextValue, cause);
  }

  /// Deletes a line in the forward direction from the current selection.
  ///
  /// If the [selection] is collapsed, deletes a line after the cursor.
  ///
  /// If the [selection] is not collapsed, deletes the selection.
  ///
  /// If [readOnly] is true, does nothing.
  ///
  /// If [obscureText] is true, it treats the whole text content as
  /// a single word.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [deleteByLine], which is same but in the opposite direction.
  void deleteForwardByLine(SelectionChangedCause cause) {
    if (readOnly) {
      return;
    }

    if (obscureText) {
      // When the text is obscured, the whole thing is treated as one big line.
      return deleteToEnd(cause);
    }


    // When there is a line break, it shouldn't do anything.
    String textAfter = value.selection.textAfter(value.text);
    final bool isNextCharacterBreakLine = textAfter.codeUnitAt(0) == 0x0A;
    if (isNextCharacterBreakLine) {
      return;
    }

    final String textBefore = value.selection.textBefore(value.text);
    final TextSelection line = textMetrics.getLineAtOffset(value.text, TextPosition(offset: textBefore.length));

    setTextEditingValue(value.deleteTo(line.end), cause);
  }

  /// Deletes the from the current collapsed selection to the end of the field.
  ///
  /// The given SelectionChangedCause indicates the cause of this change and
  /// will be passed to onSelectionChanged.
  ///
  /// See also:
  ///   * [deleteToStart]
  void deleteToEnd(SelectionChangedCause cause) {
    assert(value.selection.isCollapsed);

    setTextEditingValue(value.deleteTo(value.text.length), cause);
  }

  /// Deletes the from the current collapsed selection to the start of the field.
  ///
  /// The given SelectionChangedCause indicates the cause of this change and
  /// will be passed to onSelectionChanged.
  ///
  /// See also:
  ///   * [deleteToEnd]
  void deleteToStart(SelectionChangedCause cause) {
    assert(value.selection.isCollapsed);

    setTextEditingValue(value.deleteTo(0), cause);
  }

  /// Expand the current selection to the end of the field.
  ///
  /// The selection will never shrink. The [TextSelection.extentOffset] will
  // always be at the end of the field, regardless of the original order of
  /// [TextSelection.baseOffset] and [TextSelection.extentOffset].
  ///
  /// If [selectionEnabled] is false, keeps the selection collapsed and moves it
  /// to the end.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [expandSelectionToStart], which is same but in the opposite direction.
  void expandSelectionToEnd(SelectionChangedCause cause) {
    if (!selectionEnabled) {
      return moveSelectionToEnd(cause);
    }

    setSelection(value.expandSelectionTo(value.text.length, true), cause);
  }

  /// Expand the current [selection] to the start of the field.
  ///
  /// The selection will never shrink. The [TextSelection.extentOffset] will
  /// always be at the start of the field, regardless of the original order of
  /// [TextSelection.baseOffset] and [TextSelection.extentOffset].
  ///
  /// If [selectionEnabled] is false, keeps the selection collapsed and moves it
  /// to the start.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.extendSelectionToStart], which is used by this method.
  ///   * [expandSelectionToEnd], which is the same but in the opposite
  ///     direction.
  void expandSelectionToStart(SelectionChangedCause cause) {
    if (!selectionEnabled) {
      return moveSelectionToStart(cause);
    }

    setSelection(value.expandSelectionTo(0, true), cause);
  }

  /// {@macro flutter.rendering.TextEditingValue.expandSelectionLeftByLine}
  ///
  /// If [selectionEnabled] is false, keeps the selection collapsed and moves it
  /// left by line.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.extendSelectionLeftByLine], which is used by this method.
  ///   * [expandSelectionRightByLine], which is the same but in the opposite
  ///     direction.
  void expandSelectionLeftByLine(SelectionChangedCause cause) {
    if (!selectionEnabled) {
      return moveSelectionLeftByLine(cause);
    }

    final int firstOffset =
        math.min(value.selection.baseOffset, value.selection.extentOffset);
    final int startPoint =
        TextEditingValue.previousCharacter(firstOffset, value.text, false);
    final TextSelection selectedLine = textMetrics.getLineAtOffset(
        value.text, TextPosition(offset: startPoint));

    setSelection(value.expandSelectionTo(selectedLine.baseOffset), cause);
  }

  /// {@macro flutter.rendering.TextEditingValue.expandSelectionRightByLine}
  ///
  /// If [selectionEnabled] is false, keeps the selection collapsed and moves it
  /// right by line.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.expandSelectionRightByLine], which is used by this method.
  ///   * [expandSelectionLeftByLine], which is the same but in the opposite
  ///     direction.
  void expandSelectionRightByLine(SelectionChangedCause cause) {
    if (!selectionEnabled) {
      return moveSelectionRightByLine(cause);
    }

    final int lastOffset =
        math.max(value.selection.baseOffset, value.selection.extentOffset);
    final int startPoint =
        TextEditingValue.nextCharacter(lastOffset, value.text, false);
    final TextSelection selectedLine = textMetrics.getLineAtOffset(
        value.text, TextPosition(offset: startPoint));

    setSelection(value.expandSelectionTo(selectedLine.extentOffset), cause);
  }

  /// Keeping [selection]'s [TextSelection.baseOffset] fixed, move the
  /// [TextSelection.extentOffset] down by one line.
  ///
  /// If selectionEnabled is false, keeps the selection collapsed and just
  /// moves it down.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [extendSelectionUp], which is same but in the opposite direction.
  void extendSelectionDown(SelectionChangedCause cause) {
    if (!selectionEnabled) {
      return moveSelectionDown(cause);
    }

    // If the selection is collapsed at the end of the field already, then
    // nothing happens.
    if (value.selection.isCollapsed &&
        value.selection.extentOffset >= value.text.length) {
      return;
    }

    int index =
        textMetrics.getTextPositionBelow(value.selection.extentOffset).offset;

    if (index == value.selection.extentOffset) {
      index = value.text.length;
      _wasSelectingVerticallyWithKeyboard = true;
    } else if (_wasSelectingVerticallyWithKeyboard) {
      index = _cursorResetLocation;
      _wasSelectingVerticallyWithKeyboard = false;
    } else {
      _cursorResetLocation = index;
    }

    setSelection(value.extendSelectionTo(index), cause);
  }

  /// {@macro flutter.rendering.TextEditingValue.extendSelectionLeft}
  ///
  /// If [selectionEnabled] is false, keeps the selection collapsed and moves it
  /// left.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.extendSelectionLeft], which is used by this method.
  ///   * [extendSelectionRight], which is same but in the opposite direction.
  void extendSelectionLeft(SelectionChangedCause cause) {
    // TODO(justinmc): Can I get selectionEnabled from a cleaner place?
    if (!selectionEnabled) {
      return moveSelectionLeft(cause);
    }

    // If the selection is already all the way left, there is nothing to do.
    if (value.selection.extentOffset <= 0) {
      return;
    }

    final int previousExtent = TextEditingValue.previousCharacter(
      value.selection.extentOffset,
      value.text,
    );

    final int distance = value.selection.extentOffset - previousExtent;
    _cursorResetLocation -= distance;
    setSelection(value.extendSelectionTo(previousExtent), cause);
  }

  /// Extend the current [selection] to the start of
  /// [TextSelection.extentOffset]'s line.
  ///
  /// Uses [TextSelection.baseOffset] as a pivot point and doesn't change it.
  /// If [TextSelection.extentOffset] is right of [TextSelection.baseOffset],
  /// then the selection will be collapsed.
  ///
  /// If [selectionEnabled] is false, keeps the selection collapsed and moves it
  /// left by line.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.extendSelectionLeftByLine], which is used by this method.
  ///   * [extendSelectionRightByLine], which is same but in the opposite
  ///     direction.
  ///   * [expandSelectionRightByLine], which strictly grows the selection
  ///     regardless of the order.
  void extendSelectionLeftByLine(SelectionChangedCause cause) {
    if (!selectionEnabled) {
      return moveSelectionLeftByLine(cause);
    }

    // When going left, we want to skip over any whitespace before the line,
    // so we go back to the first non-whitespace before asking for the line
    // bounds, since getLineAtOffset finds the line boundaries without
    // including whitespace (like the newline).
    final int startPoint = TextEditingValue.previousCharacter(
        value.selection.extentOffset, value.text, false);
    final TextSelection selectedLine = textMetrics.getLineAtOffset(
        value.text, TextPosition(offset: startPoint));

    late final TextSelection nextSelection;
    // If the extent and base offsets would reverse order, then instead the
    // selection collapses.
    if (value.selection.extentOffset > value.selection.baseOffset) {
      nextSelection = value.selection.copyWith(
        extentOffset: value.selection.baseOffset,
      );
    } else {
      nextSelection = value.extendSelectionTo(selectedLine.baseOffset);
    }

    setSelection(nextSelection, cause);
  }

  /// Keeping [selection]'s [TextSelection.baseOffset] fixed, move the
  /// [TextSelection.extentOffset] right.
  ///
  /// If [selectionEnabled] is false, keeps the selection collapsed and moves it
  /// right.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.extendSelectionRight], which is used by this method.
  ///   * [extendSelectionLeft], which is same but in the opposite direction.
  void extendSelectionRight(SelectionChangedCause cause) {
    if (!selectionEnabled) {
      return moveSelectionRight(cause);
    }

    // If the selection is already all the way right, there is nothing to do.
    if (value.selection.extentOffset >= value.text.length) {
      return;
    }
    final int nextExtent = TextEditingValue.nextCharacter(
        value.selection.extentOffset, value.text);

    final int distance = nextExtent - value.selection.extentOffset;
    _cursorResetLocation += distance;
    setSelection(value.extendSelectionTo(nextExtent), cause);
  }

  /// Extend the current [selection] to the end of [TextSelection.extentOffset]'s
  /// line.
  ///
  /// Uses [TextSelection.baseOffset] as a pivot point and doesn't change it. If
  /// [TextSelection.extentOffset] is left of [TextSelection.baseOffset], then
  /// collapses the selection.
  ///
  /// If [selectionEnabled] is false, keeps the selection collapsed and moves it
  /// right by line.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.extendSelectionRightByLine], which is used by this method.
  ///   * [extendSelectionLeftByLine], which is same but in the opposite
  ///     direction.
  ///   * [expandSelectionRightByLine], which strictly grows the selection
  ///     regardless of the order.
  void extendSelectionRightByLine(SelectionChangedCause cause) {
    if (!selectionEnabled) {
      return moveSelectionRightByLine(cause);
    }

    final int startPoint = TextEditingValue.nextCharacter(
        value.selection.extentOffset, value.text, false);
    final TextSelection selectedLine = textMetrics.getLineAtOffset(
        value.text, TextPosition(offset: startPoint));

    // If the extent and base offsets would reverse order, then instead the
    // selection collapses.
    late final TextSelection nextSelection;
    if (value.selection.extentOffset < value.selection.baseOffset) {
      nextSelection = value.selection.copyWith(
        extentOffset: value.selection.baseOffset,
      );
    } else {
      nextSelection = value.extendSelectionTo(selectedLine.extentOffset);
    }

    setSelection(nextSelection, cause);
  }

  /// {@macro flutter.rendering.TextEditingValue.extendSelectionLeftByWord}
  ///
  /// Extend the current [selection] to the previous start of a word.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// {@macro flutter.rendering.RenderEditable.whiteSpace}
  ///
  /// {@template flutter.rendering.RenderEditable.stopAtReversal}
  /// The `stopAtReversal` parameter is false by default, meaning that it's
  /// ok for the base and extent to flip their order here. If set to true, then
  /// the selection will collapse when it would otherwise reverse its order. A
  /// selection that is already collapsed is not affected by this parameter.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.extendSelectionLeftByWord], which is used by this method.
  ///   * [extendSelectionRightByWord], which is the same but in the opposite
  ///     direction.
  void extendSelectionLeftByWord(SelectionChangedCause cause,
      [bool includeWhitespace = true, bool stopAtReversal = false]) {
    // When the text is obscured, the whole thing is treated as one big word.
    if (obscureText) {
      return _extendSelectionToStart(cause);
    }

    // TODO(justinmc): I think this assert has to happen in RenderEditable. If
    // we need it here, I could create an overriding method in EditableTextState
    // that calls some method on RenderEditable that does the assert.
    // Same for other instances of this assertion.
    /*
    assert(
      _textLayoutLastMaxWidth == constraints.maxWidth &&
      _textLayoutLastMinWidth == constraints.minWidth,
      'Last width ($_textLayoutLastMinWidth, $_textLayoutLastMaxWidth) not the same as max width constraint (${constraints.minWidth}, ${constraints.maxWidth}).',
    );
    */
    // If the selection is already all the way left, there is nothing to do.
    if (value.selection.isCollapsed && value.selection.extentOffset <= 0) {
      return;
    }

    final int leftOffset =
        _getLeftByWord(value.selection.extentOffset, includeWhitespace);

    late final TextSelection nextSelection;
    if (stopAtReversal &&
        value.selection.extentOffset > value.selection.baseOffset &&
        leftOffset < value.selection.baseOffset) {
      nextSelection = value.extendSelectionTo(value.selection.baseOffset);
    } else {
      nextSelection = value.extendSelectionTo(leftOffset);
    }

    if (nextSelection == value.selection) {
      return;
    }
    setSelection(nextSelection, cause);
  }

  /// {@macro flutter.rendering.TextEditingValue.extendSelectionRightByWord}
  ///
  /// Extend the current [selection] to the next end of a word.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// {@macro flutter.rendering.RenderEditable.whiteSpace}
  ///
  /// {@macro flutter.rendering.RenderEditable.stopAtReversal}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.extendSelectionRightByWord], which is used by this method.
  ///   * [extendSelectionLeftByWord], which is the same but in the opposite
  ///     direction.
  void extendSelectionRightByWord(SelectionChangedCause cause,
      [bool includeWhitespace = true, bool stopAtReversal = false]) {
    /*
    assert(
      _textLayoutLastMaxWidth == constraints.maxWidth &&
      _textLayoutLastMinWidth == constraints.minWidth,
      'Last width ($_textLayoutLastMinWidth, $_textLayoutLastMaxWidth) not the same as max width constraint (${constraints.minWidth}, ${constraints.maxWidth}).',
    );
    */
    // When the text is obscured, the whole thing is treated as one big word.
    if (obscureText) {
      return _extendSelectionToEnd(cause);
    }

    // If the selection is already all the way right, there is nothing to do.
    if (value.selection.isCollapsed &&
        value.selection.extentOffset == value.text.length) {
      return;
    }

    final int rightOffset =
        _getRightByWord(value.selection.extentOffset, includeWhitespace);

    late final TextSelection nextSelection;
    if (stopAtReversal &&
        value.selection.baseOffset > value.selection.extentOffset &&
        rightOffset > value.selection.baseOffset) {
      nextSelection = value.moveSelectionTo(value.selection.baseOffset);
    } else {
      nextSelection = value.extendSelectionTo(rightOffset);
    }

    if (nextSelection == value.selection) {
      return;
    }
    setSelection(nextSelection, cause);
  }

  /// Keeping [selection]'s [TextSelection.baseOffset] fixed, move the
  /// [TextSelection.extentOffset] up by one
  /// line.
  ///
  /// If [selectionEnabled] is false, keeps the selection collapsed and moves it
  /// up.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.extendSelectionUp], which is used by this method.
  ///   * [extendSelectionDown], which is the same but in the opposite
  ///     direction.
  void extendSelectionUp(SelectionChangedCause cause) {
    if (!selectionEnabled) {
      return moveSelectionUp(cause);
    }

    // If the selection is collapsed at the beginning of the field already, then
    // nothing happens.
    if (value.selection.isCollapsed && value.selection.extentOffset <= 0.0) {
      return;
    }

    final TextPosition positionAbove =
        textMetrics.getTextPositionAbove(value.selection.extentOffset);
    late final TextSelection nextSelection;
    if (positionAbove.offset == value.selection.extentOffset) {
      nextSelection = value.selection.copyWith(
        extentOffset: 0,
      );
      _wasSelectingVerticallyWithKeyboard = true;
    } else if (_wasSelectingVerticallyWithKeyboard) {
      nextSelection = value.selection.copyWith(
        baseOffset: value.selection.baseOffset,
        extentOffset: _cursorResetLocation,
      );
      _wasSelectingVerticallyWithKeyboard = false;
    } else {
      nextSelection = value.selection.copyWith(
        baseOffset: value.selection.baseOffset,
        extentOffset: positionAbove.offset,
      );
      _cursorResetLocation = nextSelection.extentOffset;
    }

    setSelection(nextSelection, cause);
  }

  /// Move the current [selection] to the leftmost point of the current line.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.moveSelectionLeftByLine], which is used by this
  ///     method.
  ///   * [moveSelectionRightByLine], which is the same but in the opposite
  ///     direction.
  void moveSelectionLeftByLine(SelectionChangedCause cause) {
    // If the previous character is the edge of a line, don't do anything.
    final int previousPoint = TextEditingValue.previousCharacter(
        value.selection.extentOffset, value.text, true);
    final TextSelection line = textMetrics.getLineAtOffset(
        value.text, TextPosition(offset: previousPoint));
    if (line.extentOffset == previousPoint) {
      return;
    }

    // When going left, we want to skip over any whitespace before the line,
    // so we go back to the first non-whitespace before asking for the line
    // bounds, since getLineAtOffset finds the line boundaries without
    // including whitespace (like the newline).
    final int startPoint = TextEditingValue.previousCharacter(
        value.selection.extentOffset, value.text, false);
    final TextSelection selectedLine = textMetrics.getLineAtOffset(
      value.text,
      TextPosition(offset: startPoint),
    );
    final TextSelection nextSelection = TextSelection.collapsed(
      offset: selectedLine.baseOffset,
    );

    setSelection(nextSelection, cause);
  }

  /// Move the current [selection] to the next line.
  ///
  /// Move the current [selection] to the next line.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.moveSelectionDown], which is used by this method.
  ///   * [moveSelectionUp], which is the same but in the opposite direction.
  void moveSelectionDown(SelectionChangedCause cause) {
    // If the selection is collapsed at the end of the field already, then
    // nothing happens.
    if (value.selection.isCollapsed &&
        value.selection.extentOffset >= value.text.length) {
      return;
    }

    final TextPosition positionBelow =
        textMetrics.getTextPositionBelow(value.selection.extentOffset);

    late final TextSelection nextSelection;
    if (positionBelow.offset == value.selection.extentOffset) {
      nextSelection = value.selection.copyWith(
        baseOffset: value.text.length,
        extentOffset: value.text.length,
      );
    } else {
      nextSelection = TextSelection.fromPosition(positionBelow);
    }

    if (value.selection.extentOffset == value.text.length) {
      _wasSelectingVerticallyWithKeyboard = false;
    } else {
      _cursorResetLocation = nextSelection.extentOffset;
    }

    setSelection(nextSelection, cause);
  }

  /// Move the current [selection] left by one character.
  ///
  /// If it can't be moved left, do nothing.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.moveSelectionLeft], which is used by this method.
  ///   * [moveSelectionRight], which is the same but in the opposite direction.
  void moveSelectionLeft(SelectionChangedCause cause) {
    // If the selection is already all the way left, there is nothing to do.
    if (value.selection.isCollapsed && value.selection.extentOffset <= 0) {
      return;
    }

    int previousExtent;
    if (value.selection.start != value.selection.end) {
      previousExtent = value.selection.start;
    } else {
      previousExtent = TextEditingValue.previousCharacter(
          value.selection.extentOffset, value.text);
    }
    final TextSelection nextSelection = value.moveSelectionTo(previousExtent);

    if (nextSelection == value.selection) {
      return;
    }
    _cursorResetLocation -=
        value.selection.extentOffset - nextSelection.extentOffset;
    setSelection(nextSelection, cause);
  }

  /// Move the current [selection] to the previous start of a word.
  ///
  /// A TextSelection that isn't collapsed will be collapsed and moved from the
  /// extentOffset.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// {@macro flutter.rendering.RenderEditable.whiteSpace}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.moveSelectionLeftByWord], which is used by this method.
  ///   * [moveSelectionRightByWord], which is the same but in the opposite
  ///     direction.
  void moveSelectionLeftByWord(SelectionChangedCause cause,
      [bool includeWhitespace = true]) {
    // When the text is obscured, the whole thing is treated as one big word.
    if (obscureText) {
      return moveSelectionToStart(cause);
    }

    /*
    assert(
      _textLayoutLastMaxWidth == constraints.maxWidth &&
      _textLayoutLastMinWidth == constraints.minWidth,
      'Last width ($_textLayoutLastMinWidth, $_textLayoutLastMaxWidth) not the same as max width constraint (${constraints.minWidth}, ${constraints.maxWidth}).',
    );
    */
    // If the selection is already all the way left, there is nothing to do.
    if (value.selection.isCollapsed && value.selection.extentOffset <= 0) {
      return;
    }

    final int leftOffset =
        _getLeftByWord(value.selection.extentOffset, includeWhitespace);
    final TextSelection nextSelection = value.moveSelectionTo(leftOffset);

    if (nextSelection == value.selection) {
      return;
    }
    setSelection(nextSelection, cause);
  }

  /// Move the current [selection] to the right by one character.
  ///
  /// If it can't be moved right, do nothing.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.moveSelectionRight], which is used by this method.
  ///   * [moveSelectionLeft], which is the same but in the opposite direction.
  void moveSelectionRight(SelectionChangedCause cause) {
    // If the selection is already all the way right, there is nothing to do.
    if (value.selection.isCollapsed &&
        value.selection.extentOffset >= value.text.length) {
      return;
    }

    int nextExtent;
    if (value.selection.start != value.selection.end) {
      nextExtent = value.selection.end;
    } else {
      nextExtent = TextEditingValue.nextCharacter(
          value.selection.extentOffset, value.text);
    }
    final TextSelection nextSelection = value.moveSelectionTo(nextExtent);

    if (nextSelection == value.selection) {
      return;
    }
    setSelection(nextSelection, cause);
  }

  /// Move the current [selection] to the rightmost point of the current line.
  ///
  /// Move the current [selection] to the rightmost point of the current line.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.moveSelectionRightByLine], which is used by this method.
  ///   * [moveSelectionLeftByLine], which is the same but in the opposite
  ///     direction.
  void moveSelectionRightByLine(SelectionChangedCause cause) {
    // If already at the right edge of the line, do nothing.
    final TextSelection currentLine = textMetrics.getLineAtOffset(
      value.text,
      TextPosition(
        offset: value.selection.extentOffset,
      ),
    );
    if (currentLine.extentOffset == value.selection.extentOffset) {
      return;
    }

    // When going right, we want to skip over any whitespace after the line,
    // so we go forward to the first non-whitespace character before asking
    // for the line bounds, since getLineAtOffset finds the line
    // boundaries without including whitespace (like the newline).
    final int startPoint = TextEditingValue.nextCharacter(
        value.selection.extentOffset, value.text, false);
    final TextSelection selectedLine = textMetrics.getLineAtOffset(
        value.text, TextPosition(offset: startPoint));
    final TextSelection nextSelection = TextSelection.collapsed(
      offset: selectedLine.extentOffset,
    );
    setSelection(nextSelection, cause);
  }

  /// Move the current [selection] to the next end of a word.
  ///
  /// A TextSelection that isn't collapsed will be collapsed and moved from the
  /// extentOffset.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// {@macro flutter.rendering.RenderEditable.whiteSpace}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.moveSelectionRightByWord], which is used by this
  ///     method.
  ///   * [moveSelectionLeftByWord], which is the same but in the opposite
  ///     direction.
  void moveSelectionRightByWord(SelectionChangedCause cause,
      [bool includeWhitespace = true]) {
    // When the text is obscured, the whole thing is treated as one big word.
    if (obscureText) {
      return moveSelectionToEnd(cause);
    }

    /*
    assert(
      _textLayoutLastMaxWidth == constraints.maxWidth &&
      _textLayoutLastMinWidth == constraints.minWidth,
      'Last width ($_textLayoutLastMinWidth, $_textLayoutLastMaxWidth) not the same as max width constraint (${constraints.minWidth}, ${constraints.maxWidth}).',
    );
    */
    // If the selection is already all the way right, there is nothing to do.
    if (value.selection.isCollapsed &&
        value.selection.extentOffset == value.text.length) {
      return;
    }

    final int rightOffset =
        _getRightByWord(value.selection.extentOffset, includeWhitespace);
    final TextSelection nextSelection = value.moveSelectionTo(rightOffset);

    if (nextSelection == value.selection) {
      return;
    }
    setSelection(nextSelection, cause);
  }

  /// Move the current [selection] to the end of the field.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.moveSelectionToEnd], which is used by this method.
  ///   * [moveSelectionToStart], which is the same but in the opposite
  ///     direction.
  void moveSelectionToEnd(SelectionChangedCause cause) {
    setSelection(value.moveSelectionTo(value.text.length), cause);
  }

  /// Move the current [selection] to the start of the field.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.moveSelectionToStart], which is used by this method.
  ///   * [moveSelectionToEnd], which is the same but in the opposite direction.
  void moveSelectionToStart(SelectionChangedCause cause) {
    setSelection(value.moveSelectionTo(0), cause);
  }

  /// Move the current [selection] up by one line.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  ///
  /// See also:
  ///
  ///   * [TextEditingValue.moveSelectionUp], which is used by this method.
  ///   * [moveSelectionDown], which is the same but in the opposite direction.
  void moveSelectionUp(SelectionChangedCause cause) {
    final int nextIndex =
        textMetrics.getTextPositionAbove(value.selection.extentOffset).offset;

    if (nextIndex == value.selection.extentOffset) {
      _wasSelectingVerticallyWithKeyboard = false;
      return moveSelectionToStart(cause);
    }
    _cursorResetLocation = nextIndex;

    setSelection(value.moveSelectionTo(nextIndex), cause);
  }

  /// {@macro flutter.rendering.TextEditingValue.selectAll}
  ///
  /// Set the current [selection] to contain the entire text value.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  void selectAll(SelectionChangedCause cause) {
    setSelection(
      value.selectAll(),
      cause,
    );
  }

  /// {@macro flutter.rendering.TextEditingValue.copySelection}
  ///
  /// Copy current [selection] to [Clipboard].
  void copySelection() {
    final TextSelection selection = value.selection;
    final String text = value.text;
    assert(selection != null);
    if (!selection.isCollapsed) {
      Clipboard.setData(ClipboardData(text: selection.textInside(text)));
    }
  }

  /// {@macro flutter.rendering.TextEditingValue.cutSelection}
  /// Cut current [selection] to Clipboard.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  void cutSelection(SelectionChangedCause cause) {
    if (readOnly) {
      return;
    }
    final TextSelection selection = value.selection;
    final String text = value.text;
    assert(selection != null);
    if (!selection.isCollapsed) {
      Clipboard.setData(ClipboardData(text: selection.textInside(text)));
      setTextEditingValue(
        TextEditingValue(
          text: selection.textBefore(text) + selection.textAfter(text),
          selection: TextSelection.collapsed(
              offset: math.min(selection.start, selection.end)),
        ),
        cause,
      );
    }
  }

  /// {@macro flutter.rendering.TextEditingValue.pasteText}
  /// Paste text from [Clipboard].
  ///
  /// If there is currently a selection, it will be replaced.
  ///
  /// {@macro flutter.rendering.RenderEditable.cause}
  Future<void> pasteText(SelectionChangedCause cause) async {
    if (readOnly) {
      return;
    }
    final TextSelection selection = value.selection;
    final String text = value.text;
    assert(selection != null);
    // Snapshot the input before using `await`.
    // See https://github.com/flutter/flutter/issues/11427
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && selection.isValid) {
      setTextEditingValue(
        TextEditingValue(
          text: selection.textBefore(text) +
              data.text! +
              selection.textAfter(text),
          selection: TextSelection.collapsed(
            offset:
                math.min(selection.start, selection.end) + data.text!.length,
          ),
        ),
        cause,
      );
    }
  }
}

/// An [Action] related to editing text.
///
/// Enables itself only when a [TextEditingActionTarget], e.g. [EditableText],
/// is currently focused. The result of this is that when a
/// TextEditingActionTarget is not focused, it will fall through to any
/// non-TextEditingAction that handles the same shortcut. For example,
/// overriding the tab key in [Shortcuts] with a TextEditingAction will only
/// invoke your TextEditingAction when a TextEditingActionTarget is focused,
/// otherwise the default tab behavior will apply.
///
/// The currently focused TextEditingActionTarget is available in the [invoke]
/// method via [textEditingActionTarget].
///
/// See also:
///
///  * [CallbackAction], which is a similar Action type but unrelated to text
///    editing.
abstract class TextEditingAction<T extends Intent> extends ContextAction<T> {
  /// Returns the currently focused [TextEditingAction], or null if none is
  /// focused.
  @protected
  TextEditingActionTarget? get textEditingActionTarget {
    // If a TextEditingActionTarget is not focused, then ignore this action.
    if (primaryFocus?.context == null ||
        primaryFocus!.context! is! StatefulElement ||
        ((primaryFocus!.context! as StatefulElement).state
            is! TextEditingActionTarget)) {
      return null;
    }
    return (primaryFocus!.context! as StatefulElement).state
        as TextEditingActionTarget;
  }

  @override
  bool isEnabled(T intent) {
    // The Action is disabled if there is no focused TextEditingActionTarget.
    return textEditingActionTarget != null;
  }
}
