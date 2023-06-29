// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show TextDecoration;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'inline_span.dart';
import 'text_span.dart';
import 'text_style.dart';

// TODO(justinmc): On some platforms, may want to underline link?

/// A callback that passes a [String] representing a link that has been tapped.
typedef LinkTapCallback = void Function(String linkString);

/// Builds an [InlineSpan] for displaying a link on [displayString] linking to
/// [linkString].
typedef LinkBuilder = InlineSpan Function(
  String displayString,
  String linkString,
);

/// Finds [TextRange]s in the given [String].
typedef RangesFinder = Iterable<TextRange> Function(String text);

/// A [TextSpan] that makes parts of the [text] interactive.
class InlineLinkedText extends TextSpan {
  /// Create an instance of [InlineLinkedText].
  ///
  /// {@macro flutter.widgets.LinkedText.new}
  ///
  /// See also:
  ///
  ///  * [InlineLinkedText.regExp], which automatically finds ranges that match
  ///    the given [RegExp].
  ///  * [InlineLinkedText.textLinkers], which uses [TextLinker]s to allow
  ///    specifying an arbitrary number of [ranges] and [linkBuilders].
  InlineLinkedText({
    super.style,
    String? text,
    List<InlineSpan>? spans,
    LinkTapCallback? onTap,
    Iterable<TextRange>? ranges,
    LinkBuilder? linkBuilder,
  }) : assert(text != null || spans != null, 'Must specify something to link: either text or spans.'),
       assert(text == null || spans == null, 'Pass one of spans or text, not both.'),
       super(
         children: text != null
             ? TextLinker(
               rangesFinder: ranges != null
                   ? (String text) => ranges
                   : urlRangesFinder,
               linkBuilder: linkBuilder ?? getDefaultLinkBuilder(onTap),
             ).getSpans(text)
             : linkSpans(
                 spans!,
                 <TextLinker>[
                   TextLinker(
                     rangesFinder: ranges != null
                         ? (String text) => ranges
                         : urlRangesFinder,
                     linkBuilder: linkBuilder ?? getDefaultLinkBuilder(onTap),
                   ),
                 ],
               ).toList(),
       );

  /// Create an instance of [InlineLinkedText] where the text matched by the
  /// given [regExp] is made interactive.
  ///
  /// See also:
  ///
  ///  * [InlineLinkedText.new], which can be passed [TextRange]s directly or
  ///    otherwise matches URLs by default.
  ///  * [InlineLinkedText.textLinkers], which uses [TextLinker]s to allow
  ///    specifying an arbitrary number of [ranges] and [linkBuilders].
  InlineLinkedText.regExp({
    super.style,
    required RegExp regExp,
    String? text,
    List<InlineSpan>? spans,
    LinkTapCallback? onTap,
    LinkBuilder? linkBuilder,
  }) : assert(text != null || spans != null, 'Must specify something to link: either text or spans.'),
       assert(text == null || spans == null, 'Pass one of spans or text, not both.'),
       super(
         children: text != null
             ? TextLinker(
               rangesFinder: TextLinker.rangesFinderFromRegExp(regExp),
               linkBuilder: linkBuilder ?? getDefaultLinkBuilder(onTap),
             ).getSpans(text)
             : linkSpans(spans!, urlTextLinkers(onTap)).toList(),
       );

  /// Create an instance of [InlineLinkedText] with the given [textLinkers]
  /// applied.
  ///
  /// {@macro flutter.widgets.LinkedText.textLinkers}
  ///
  /// See also:
  ///
  ///  * [InlineLinkedText.new], which can be passed [TextRange]s directly or
  ///    otherwise matches URLs by default.
  ///  * [InlineLinkedText.regExp], which automatically finds ranges that match
  ///    the given [RegExp].
  InlineLinkedText.textLinkers({
    super.style,
    String? text,
    List<InlineSpan>? spans,
    required Iterable<TextLinker> textLinkers,
  }) : assert(text != null || spans != null, 'Must specify something to link: either text or spans.'),
       assert(text == null || spans == null, 'Pass one of spans or text, not both.'),
       super(
         children: text != null
             ? TextLinker.getSpansForMany(textLinkers, text)
             : linkSpans(spans!, textLinkers).toList(),
       );

  static final RegExp _urlRegExp = RegExp(r'(?<!@[a-zA-Z0-9-]*)(?<![\/\.a-zA-Z0-9-])((https?:\/\/)?(([a-zA-Z0-9-]*\.)*[a-zA-Z0-9-]+(\.[a-zA-Z]+)+))(?::\d{1,5})?(?:\/[^\s]*)?(?:\?[^\s#]*)?(?:#[^\s]*)?(?![a-zA-Z0-9-]*@)');

  /// A [RangesFinder] that returns [TextRange]s for URLs.
  ///
  /// Matches full (https://www.example.com/?q=1) and shortened (example.com)
  /// URLs.
  ///
  /// Excludes:
  ///
  ///   * URLs with any protocol other than http or https.
  ///   * Email addresses.
  static final RangesFinder urlRangesFinder = TextLinker.rangesFinderFromRegExp(_urlRegExp);

  // TODO(justinmc): Rename defaultTextLinkers?
  /// Finds urls in text and replaces them with a plain, platform-specific link.
  static Iterable<TextLinker> urlTextLinkers(LinkTapCallback? onTap) {
    return <TextLinker>[
      TextLinker(
        rangesFinder: urlRangesFinder,
        linkBuilder: getDefaultLinkBuilder(onTap),
      ),
    ];
  }

  /// Returns a [LinkBuilder] that highlights the given text and sets the given
  /// [onTap] handler.
  static LinkBuilder getDefaultLinkBuilder([LinkTapCallback? onTap]) {
    return (String displayString, String linkString) {
      return InlineLink(
        onTap: () => onTap?.call(linkString),
        text: displayString,
      );
    };
  }

  static List<_TextLinkerMatch> _cleanTextLinkerSingles(Iterable<_TextLinkerMatch> textLinkerSingles) {
    final List<_TextLinkerMatch> nextTextLinkerSingles = textLinkerSingles.toList();

    // Sort by start.
    nextTextLinkerSingles.sort((_TextLinkerMatch a, _TextLinkerMatch b) {
      return a.textRange.start.compareTo(b.textRange.start);
    });

    int lastEnd = 0;
    nextTextLinkerSingles.removeWhere((_TextLinkerMatch textLinkerSingle) {
      // Return empty ranges.
      if (textLinkerSingle.textRange.start == textLinkerSingle.textRange.end) {
        return true;
      }

      // Remove overlapping ranges.
      final bool overlaps = textLinkerSingle.textRange.start < lastEnd;
      if (!overlaps) {
        lastEnd = textLinkerSingle.textRange.end;
      }
      return overlaps;
    });

    return nextTextLinkerSingles;
  }

  /// Apply the given [TextLinker]s to the given [InlineSpan]s and return the
  /// new resulting spans.
  static Iterable<InlineSpan> linkSpans(Iterable<InlineSpan> spans, Iterable<TextLinker> textLinkers) {
    // Flatten the spans and find all ranges in the flat String. This must be done
    // cumulatively, and not during a traversal, because matches may occur across
    // span boundaries.
    final String spansText = spans.fold<String>('', (String value, InlineSpan span) {
      return value + span.toPlainText();
    });
    final Iterable<_TextLinkerMatch> textLinkerSingles =
        _cleanTextLinkerSingles(
          _TextLinkerMatch.fromTextLinkers(textLinkers, spansText),
        );

    final (Iterable<InlineSpan> output, _) =
        _linkSpansRecursive(spans, textLinkerSingles, 0);
    return output;
  }

  static (Iterable<InlineSpan>, Iterable<_TextLinkerMatch>) _linkSpansRecursive(Iterable<InlineSpan> spans, Iterable<_TextLinkerMatch> textLinkerSingles, int index) {
    final List<InlineSpan> output = <InlineSpan>[];
    Iterable<_TextLinkerMatch> nextTextLinkerSingles = textLinkerSingles;
    int nextIndex = index;
    for (final InlineSpan span in spans) {
      final (InlineSpan childSpan, Iterable<_TextLinkerMatch> childTextLinkerSingles) = _linkSpanRecursive(
        span,
        nextTextLinkerSingles,
        nextIndex,
      );
      output.add(childSpan);
      nextTextLinkerSingles = childTextLinkerSingles;
      nextIndex += span.toPlainText().length; // TODO(justinmc): Performance? Maybe you could return the index rather than recalculating it?
    }

    return (output, nextTextLinkerSingles);
  }

  // index is the index of the start of `span` in the overall flattened tree
  // string.
  static (InlineSpan, Iterable<_TextLinkerMatch>) _linkSpanRecursive(InlineSpan span, Iterable<_TextLinkerMatch> textLinkerSingles, int index) {
    if (span is! TextSpan) {
      return (span, textLinkerSingles);
    }

    final List<InlineSpan> nextChildren = <InlineSpan>[];
    List<_TextLinkerMatch> nextTextLinkerSingles = <_TextLinkerMatch>[...textLinkerSingles];
    int lastLinkEnd = index;
    if (span.text?.isNotEmpty ?? false) {
      final int textEnd = index + span.text!.length;
      for (final _TextLinkerMatch textLinkerSingle in textLinkerSingles) {
        if (textLinkerSingle.textRange.start >= textEnd) {
          // Because ranges is ordered, there are no more relevant ranges for this
          // text.
          break;
        }
        if (textLinkerSingle.textRange.end <= index) {
          // This range ends before this span and is therefore irrelevant to it.
          // It should have been removed from ranges.
          assert(false, 'Invalid ranges.');
          nextTextLinkerSingles.removeAt(0);
          continue;
        }
        if (textLinkerSingle.textRange.start > index) {
          // Add the unlinked text before the range.
          nextChildren.add(TextSpan(
            text: span.text!.substring(
              lastLinkEnd - index,
              textLinkerSingle.textRange.start - index,
            ),
          ));
        }
        // Add the link itself.
        final int linkStart = math.max(textLinkerSingle.textRange.start, index);
        lastLinkEnd = math.min(textLinkerSingle.textRange.end, textEnd);
        nextChildren.add(textLinkerSingle.linkBuilder(
          span.text!.substring(linkStart - index, lastLinkEnd - index),
          textLinkerSingle.linkString,
        ));
        if (textLinkerSingle.textRange.end > textEnd) {
          // If we only partially used this range, keep it in nextRanges. Since
          // overlapping ranges have been removed, this must be the last relevant
          // range for this span.
          break;
        }
        nextTextLinkerSingles.removeAt(0);
      }

      // Add any extra text after any ranges.
      final String remainingText = span.text!.substring(lastLinkEnd - index);
      if (remainingText.isNotEmpty) {
        nextChildren.add(TextSpan(
          text: remainingText,
        ));
      }
    }

    // Recurse on the children.
    if (span.children?.isNotEmpty ?? false) {
      final (
        Iterable<InlineSpan> childrenSpans,
        Iterable<_TextLinkerMatch> childrenTextLinkerSingles,
      ) = _linkSpansRecursive(
        span.children!,
        nextTextLinkerSingles,
        index + (span.text?.length ?? 0),
      );
      nextTextLinkerSingles = childrenTextLinkerSingles.toList();
      nextChildren.addAll(childrenSpans);
    }

    return (
      TextSpan(
        style: span.style,
        children: nextChildren,
      ),
      nextTextLinkerSingles,
    );
  }
}

// TODO(justinmc): Private?
// TODO(justinmc): The clickable area is full-width, should be narrow.
/// An inline, interactive text link.
class InlineLink extends TextSpan {
  /// Create an instance of [InlineLink].
  InlineLink({
    required String text,
    VoidCallback? onTap,
    TextStyle style = defaultLinkStyle,
    super.locale,
    super.semanticsLabel,
  }) : super(
    style: style,
    mouseCursor: SystemMouseCursors.click,
    text: text,
    // TODO(justinmc): You need to manage the lifecycle of this recognizer. I
    // think that means this must come from a Widget? So maybe this can't be in
    // the painting library.
    recognizer: onTap == null ? null : (TapGestureRecognizer()..onTap = onTap),
  );

  @visibleForTesting
  static const TextStyle defaultLinkStyle = TextStyle(
    // TODO(justinmc): Correct color per-platform. Get it from Theme in
    // Material somehow?
    // And decide underline or not per-platform.
    color: Color(0xff0000ff),
    decoration: TextDecoration.underline,
  );
}

/// A matched replacement on some String.
///
/// Produced by applying a [TextLinker]'s [RangesFinder] to a string.
class _TextLinkerMatch {
  _TextLinkerMatch({
    required this.textRange,
    required this.linkBuilder,
    required this.linkString,
  }) : assert(textRange.end - textRange.start == linkString.length);

  final LinkBuilder linkBuilder;
  final TextRange textRange;

  /// The [String] that [textRange] matches.
  final String linkString;

  /// Get all [_TextLinkerMatch]s obtained from applying the given
  // `textLinker`s with the given `text`.
  static List<_TextLinkerMatch> fromTextLinkers(Iterable<TextLinker> textLinkers, String text) {
    return textLinkers
        .fold<List<_TextLinkerMatch>>(
          <_TextLinkerMatch>[],
          (List<_TextLinkerMatch> previousValue, TextLinker value) {
            return previousValue..addAll(value._link(text));
        });
  }

  /// Returns a list of [InlineSpan]s representing all of the [text].
  ///
  /// Ranges matched by [textLinkerSingles] are built with their respective
  /// [LinkBuilder], and other text is represented with a simple [TextSpan].
  static List<InlineSpan> getSpansForMany(Iterable<_TextLinkerMatch> textLinkerSingles, String text) {
    // Sort so that overlapping ranges can be detected and ignored.
    final List<_TextLinkerMatch> textLinkerSinglesList = textLinkerSingles
        .toList()
        ..sort((_TextLinkerMatch a, _TextLinkerMatch b) {
          return a.textRange.start.compareTo(b.textRange.start);
        });

    final List<InlineSpan> spans = <InlineSpan>[];
    int index = 0;
    for (final _TextLinkerMatch textLinkerSingle in textLinkerSinglesList) {
      // Ignore overlapping ranges.
      if (index > textLinkerSingle.textRange.start) {
        continue;
      }
      if (index < textLinkerSingle.textRange.start) {
        spans.add(TextSpan(
          text: text.substring(index, textLinkerSingle.textRange.start),
        ));
      }
      spans.add(textLinkerSingle.linkBuilder(
        text.substring(
          textLinkerSingle.textRange.start,
          textLinkerSingle.textRange.end,
        ),
        textLinkerSingle.linkString,
      ));

      index = textLinkerSingle.textRange.end;
    }
    if (index < text.length) {
      spans.add(TextSpan(
        text: text.substring(index),
      ));
    }

    return spans;
  }

  @override
  String toString() {
    return '_TextLinkerSingle $textRange, $linkBuilder, $linkString';
  }
}

// TODO(justinmc): Would it simplify things if the public class TextLinker
// actually handled multiple rangesFinders and linkBuilders? Then there was a
// private single _TextLinker or something?
// TODO(justinmc): Think about which links need to go here vs. on InlineTextLinker.
/// Specifies a way to find and style parts of a String.
class TextLinker {
  /// Creates an instance of [TextLinker].
  const TextLinker({
    // TODO(justinmc): Change "range" naming to always be "textRange"?
    required this.rangesFinder,
    required this.linkBuilder,
  });

  /// Builds an [InlineSpan] to display the text that it's passed.
  final LinkBuilder linkBuilder;

  // TODO(justinmc): Is it possible to enforce this order by TextRange.start, or should I just assume it's unordered?
  /// Returns [TextRange]s that should be built with [linkBuilder].
  final RangesFinder rangesFinder;

  // Turns all matches from the regExp into a list of TextRanges.
  static Iterable<TextRange> _rangesFromText({
    required String text,
    required RegExp regExp,
  }) {
    final Iterable<RegExpMatch> matches = regExp.allMatches(text);
    return matches.map((RegExpMatch match) {
      return TextRange(
        start: match.start,
        end: match.end,
      );
    });
  }

  /// Returns a flat list of [InlineSpan]s for multiple [TextLinker]s.
  ///
  /// Similar to [getSpans], but for multiple [TextLinker]s instead of just one.
  static List<InlineSpan> getSpansForMany(Iterable<TextLinker> textLinkers, String text) {
    final List<_TextLinkerMatch> combinedRanges = textLinkers
        .fold<List<_TextLinkerMatch>>(
          <_TextLinkerMatch>[],
          (List<_TextLinkerMatch> previousValue, TextLinker value) {
            final Iterable<TextRange> ranges = value.rangesFinder(text);
            for (final TextRange range in ranges) {
              previousValue.add(_TextLinkerMatch(
                textRange: range,
                linkBuilder: value.linkBuilder,
                linkString: text.substring(range.start, range.end),
              ));
            }
            return previousValue;
        });

    return _TextLinkerMatch.getSpansForMany(combinedRanges, text);
  }

  /// Creates a [RangesFinder] that finds all the matches of the given [RegExp].
  static RangesFinder rangesFinderFromRegExp(RegExp regExp) {
    return (String text) {
      return _rangesFromText(
        text: text,
        regExp: regExp,
      );
    };
  }

  /// Apply this [TextLinker] to a [String].
  Iterable<_TextLinkerMatch> _link(String text) {
    final Iterable<TextRange> textRanges = rangesFinder(text);
    return textRanges.map((TextRange textRange) {
      return _TextLinkerMatch(
        textRange: textRange,
        linkBuilder: linkBuilder,
        linkString: text.substring(textRange.start, textRange.end),
      );
    });
  }

  /// Builds the [InlineSpan]s for the given text.
  ///
  /// Builds [linkBuilder] for any ranges found by [rangesFinder]. All other
  /// text is presented in a plain [TextSpan].
  List<InlineSpan> getSpans(String text) {
    final Iterable<_TextLinkerMatch> textLinkerSingles = _link(text);
    return _TextLinkerMatch.getSpansForMany(textLinkerSingles, text);
  }

  @override
  String toString() {
    return 'TextLinker $rangesFinder, $linkBuilder';
  }
}
