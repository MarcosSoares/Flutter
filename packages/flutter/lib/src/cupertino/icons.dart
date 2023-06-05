// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

/// Identifiers for the supported Cupertino icons.
///
/// Use with the [Icon] class to show specific icons.
///
/// Icons are identified by their name as listed below.
///
/// To use this class, make sure you add a dependency on `cupertino_icons` in your
/// project's `pubspec.yaml` file. This ensures that the CupertinoIcons font is
/// included in your application. This font is used to display the icons. For example:
///
/// ```yaml
/// name: my_awesome_application
///
/// dependencies:
///   cupertino_icons: ^1.0.0
/// ```
///
/// {@tool snippet}
///
/// This example shows how to create a [Row] of Cupertino [Icon]s in different colors and
/// sizes. The first [Icon] uses a [Icon.semanticLabel] to announce in accessibility
/// modes like VoiceOver.
///
/// ![The following code snippet would generate a row of icons consisting of a pink heart, a green bell, and a blue umbrella, each progressively bigger than the last.](https://flutter.github.io/assets-for-api-docs/assets/cupertino/cupertino_icon.png)
///
/// ```dart
/// const Row(
///   mainAxisAlignment: MainAxisAlignment.spaceAround,
///   children: <Widget>[
///     Icon(
///       CupertinoIcons.heart_fill,
///       color: Colors.pink,
///       size: 24.0,
///       semanticLabel: 'Text to announce in accessibility modes',
///     ),
///     Icon(
///       CupertinoIcons.bell_fill,
///       color: Colors.green,
///       size: 30.0,
///     ),
///     Icon(
///       CupertinoIcons.umbrella_fill,
///       color: Colors.blue,
///       size: 36.0,
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// For versions 0.1.3 and below, see this [glyph map](https://raw.githubusercontent.com/flutter/packages/master/third_party/packages/cupertino_icons/map.png).
///
/// See also:
///
///  * [Icon], used to show these icons.
///
/// {@hideConstantImplementations}
@staticIconProvider
abstract final class CupertinoIcons {
  /// The icon font used for Cupertino icons.
  static const String iconFont = 'CupertinoIcons';

  /// The dependent package providing the Cupertino icons font.
  static const String iconFontPackage = 'cupertino_icons';

  // ===========================================================================
  // BEGIN LEGACY PRE SF SYMBOLS NAMES
  // We need to leave them as-is with the same codepoints for backward
  // compatibility with cupertino_icons <0.1.3.

  /// <i class='cupertino-icons md-36'>chevron_left</i> &#x2014; Cupertino icon for a thin left chevron.
  /// This is the same icon as [chevron_left] in cupertino_icons 1.0.0+.
  static const IconData left_chevron = IconData(0xf3d2, fontFamily: iconFont, fontPackage: iconFontPackage, matchTextDirection: true);

  /// <i class='cupertino-icons md-36'>chevron_right</i> &#x2014; Cupertino icon for a thin right chevron.
  /// This is the same icon as [chevron_right] in cupertino_icons 1.0.0+.
  static const IconData right_chevron = IconData(0xf3d3, fontFamily: iconFont, fontPackage: iconFontPackage, matchTextDirection: true);

  /// <i class='cupertino-icons md-36'>square_arrow_up</i> &#x2014; Cupertino icon for an iOS style share icon with an arrow pointing up from a box. This icon is not filled in.
  /// This is the same icon as [square_arrow_up] and [share_up] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [share_solid], which is similar, but filled in.
  ///  * [share_up], for another (pre-iOS 7) version of this icon.
  static const IconData share = IconData(0xf4ca, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>square_arrow_up_fill</i> &#x2014; Cupertino icon for an iOS style share icon with an arrow pointing up from a box. This icon is filled in.
  /// This is the same icon as [square_arrow_up_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [share], which is similar, but not filled in.
  ///  * [share_up], for another (pre-iOS 7) version of this icon.
  static const IconData share_solid = IconData(0xf4cb, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>book</i> &#x2014; Cupertino icon for a book silhouette spread open. This icon is not filled in.
  /// See also:
  ///
  ///  * [book_solid], which is similar, but filled in.
  static const IconData book = IconData(0xf3e7, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>book_fill</i> &#x2014; Cupertino icon for a book silhouette spread open. This icon is filled in.
  /// This is the same icon as [book_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [book], which is similar, but not filled in.
  static const IconData book_solid = IconData(0xf3e8, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>bookmark</i> &#x2014; Cupertino icon for a book silhouette spread open containing a bookmark in the upper right. This icon is not filled in.
  ///
  /// See also:
  ///
  ///  * [bookmark_solid], which is similar, but filled in.
  static const IconData bookmark = IconData(0xf3e9, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>bookmark_fill</i> &#x2014; Cupertino icon for a book silhouette spread open containing a bookmark in the upper right. This icon is filled in.
  /// This is the same icon as [bookmark_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [bookmark], which is similar, but not filled in.
  static const IconData bookmark_solid = IconData(0xf3ea, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>info_circle</i> &#x2014; Cupertino icon for a letter 'i' in a circle.
  /// This is the same icon as [info_circle] in cupertino_icons 1.0.0+.
  static const IconData info = IconData(0xf44c, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrowshape_turn_up_left</i> &#x2014; Cupertino icon for a curved up and left pointing arrow.
  /// This is the same icon as [arrowshape_turn_up_left] in cupertino_icons 1.0.0+.
  ///
  /// For another version of this icon, see [reply_thick_solid].
  static const IconData reply = IconData(0xf4c6, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>chat_bubble</i> &#x2014; Cupertino icon for a chat bubble.
  /// This is the same icon as [chat_bubble] in cupertino_icons 1.0.0+.
  static const IconData conversation_bubble = IconData(0xf3fb, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>person_crop_circle</i> &#x2014; Cupertino icon for a person's silhouette in a circle.
  /// This is the same icon as [person_crop_circle] in cupertino_icons 1.0.0+.
  static const IconData profile_circled = IconData(0xf419, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>plus_circle</i> &#x2014; Cupertino icon for a '+' sign in a circle.
  /// This is the same icon as [plus_circle] in cupertino_icons 1.0.0+.
  static const IconData plus_circled = IconData(0xf48a, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>minus_circle</i> &#x2014; Cupertino icon for a '-' sign in a circle.
  /// This is the same icon as [minus_circle] in cupertino_icons 1.0.0+.
  static const IconData minus_circled = IconData(0xf463, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>flag</i> &#x2014; Cupertino icon for a right facing flag and pole outline.
  static const IconData flag = IconData(0xf42c, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>search</i> &#x2014; Cupertino icon for a magnifier loop outline.
  static const IconData search = IconData(0xf4a5, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>checkmark</i> &#x2014; Cupertino icon for a checkmark.
  /// This is the same icon as [checkmark] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [check_mark_circled], which consists of this check mark and a circle surrounding it.
  static const IconData check_mark = IconData(0xf3fd, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>checkmark_circle</i> &#x2014; Cupertino icon for a checkmark in a circle. The circle is not filled in.
  /// This is the same icon as [checkmark_circle] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [check_mark_circled_solid], which is similar, but filled in.
  ///  * [check_mark], which is the check mark without a circle.
  static const IconData check_mark_circled = IconData(0xf3fe, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>checkmark_circle_fill</i> &#x2014; Cupertino icon for a checkmark in a circle. The circle is filled in.
  /// This is the same icon as [checkmark_circle_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [check_mark_circled], which is similar, but not filled in.
  static const IconData check_mark_circled_solid = IconData(0xf3ff, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>circle</i> &#x2014; Cupertino icon for an empty circle (a ring). An un-selected radio button.
  ///
  /// See also:
  ///
  ///  * [circle_filled], which is similar but filled in.
  static const IconData circle = IconData(0xf401, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>circle_fill</i> &#x2014; Cupertino icon for a filled circle. The circle is surrounded by a ring. A selected radio button.
  /// This is the same icon as [circle_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [circle], which is similar but not filled in.
  static const IconData circle_filled = IconData(0xf400, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>chevron_back</i> &#x2014; Cupertino icon for a thicker left chevron used in iOS for the navigation bar back button.
  /// This is the same icon as [chevron_back] in cupertino_icons 1.0.0+.
  static const IconData back = IconData(0xf3cf, fontFamily: iconFont, fontPackage: iconFontPackage, matchTextDirection: true);

  /// <i class='cupertino-icons md-36'>chevron_forward</i> &#x2014; Cupertino icon for a thicker right chevron that's the reverse of [back].
  /// This is the same icon as [chevron_forward] in cupertino_icons 1.0.0+.
  static const IconData forward = IconData(0xf3d1, fontFamily: iconFont, fontPackage: iconFontPackage, matchTextDirection: true);

  /// <i class='cupertino-icons md-36'>house</i> &#x2014; Cupertino icon for an outline of a simple front-facing house.
  /// This is the same icon as [house] in cupertino_icons 1.0.0+.
  static const IconData home = IconData(0xf447, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>cart</i> &#x2014; Cupertino icon for a right-facing shopping cart outline.
  /// This is the same icon as [cart] in cupertino_icons 1.0.0+.
  static const IconData shopping_cart = IconData(0xf3f7, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>ellipsis</i> &#x2014; Cupertino icon for three solid dots.
  static const IconData ellipsis = IconData(0xf46a, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>phone</i> &#x2014; Cupertino icon for a phone handset outline.
  static const IconData phone = IconData(0xf4b8, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>phone_fill</i> &#x2014; Cupertino icon for a phone handset.
  /// This is the same icon as [phone_fill] in cupertino_icons 1.0.0+.
  static const IconData phone_solid = IconData(0xf4b9, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrow_down</i> &#x2014; Cupertino icon for a solid down arrow.
  /// This is the same icon as [arrow_down] in cupertino_icons 1.0.0+.
  static const IconData down_arrow = IconData(0xf35d, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrow_up</i> &#x2014; Cupertino icon for a solid up arrow.
  /// This is the same icon as [arrow_up] in cupertino_icons 1.0.0+.
  static const IconData up_arrow = IconData(0xf366, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>battery_100</i> &#x2014; Cupertino icon for a charging battery.
  /// This is the same icon as [battery_100], [battery_full] and [battery_75_percent] in cupertino_icons 1.0.0+.
  static const IconData battery_charging = IconData(0xf111, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>battery_0</i> &#x2014; Cupertino icon for an empty battery.
  /// This is the same icon as [battery_0] in cupertino_icons 1.0.0+.
  static const IconData battery_empty = IconData(0xf112, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>battery_100</i> &#x2014; Cupertino icon for a full battery.
  /// This is the same icon as [battery_100], [battery_charging] and [battery_75_percent] in cupertino_icons 1.0.0+.
  static const IconData battery_full = IconData(0xf113, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>battery_100</i> &#x2014; Cupertino icon for a 75% charged battery.
  /// This is the same icon as [battery_100], [battery_charging] and [battery_full] in cupertino_icons 1.0.0+.
  static const IconData battery_75_percent = IconData(0xf114, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>battery_25</i> &#x2014; Cupertino icon for a 25% charged battery.
  /// This is the same icon as [battery_25] in cupertino_icons 1.0.0+.
  static const IconData battery_25_percent = IconData(0xf115, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>bluetooth</i> &#x2014; Cupertino icon for the Bluetooth logo.
  /// This icon is available in cupertino_icons 1.0.0+ for backward
  /// compatibility but not part of Apple icons' aesthetics.
  static const IconData bluetooth = IconData(0xf116, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrow_counterclockwise</i> &#x2014; Cupertino icon for a restart arrow, pointing downwards.
  /// This is the same icon as [arrow_counterclockwise] in cupertino_icons 1.0.0+.
  static const IconData restart = IconData(0xf21c, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrowshape_turn_up_left_2</i> &#x2014; Cupertino icon for two curved up and left pointing arrows.
  /// This is the same icon as [arrowshape_turn_up_left_2] in cupertino_icons 1.0.0+.
  static const IconData reply_all = IconData(0xf21d, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrowshape_turn_up_left_2_fill</i> &#x2014; Cupertino icon for a curved up and left pointing arrow.
  /// This is the same icon as [arrowshape_turn_up_left_2_fill] in cupertino_icons 1.0.0+.
  ///
  /// For another version of this icon, see [reply].
  static const IconData reply_thick_solid = IconData(0xf21e, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>square_arrow_up</i> &#x2014; Cupertino icon for an iOS style share icon with an arrow pointing upwards to the right from a box.
  /// This is the same icon as [square_arrow_up] and [share_up] in cupertino_icons 1.0.0+.
  ///
  /// For another version of this icon (introduced in iOS 7), see [share].
  static const IconData share_up = IconData(0xf220, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>shuffle_medium</i> &#x2014; Cupertino icon for two thin right-facing intertwined arrows.
  /// This is the same icon as [shuffle_medium] and [shuffle_thick] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [shuffle_medium], with slightly thicker arrows.
  ///  * [shuffle_thick], with thicker, bold arrows.
  static const IconData shuffle = IconData(0xf4a9, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>shuffle</i> &#x2014; Cupertino icon for an two medium thickness right-facing intertwined arrows.
  /// This is the same icon as [shuffle] and [shuffle_thick] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [shuffle], with thin arrows.
  ///  * [shuffle_thick], with thicker, bold arrows.
  static const IconData shuffle_medium = IconData(0xf4a8, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>shuffle_medium</i> &#x2014; Cupertino icon for two thick right-facing intertwined arrows.
  /// This is the same icon as [shuffle_medium] and [shuffle] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [shuffle], with thin arrows.
  ///  * [shuffle_medium], with slightly thinner arrows.
  static const IconData shuffle_thick = IconData(0xf221, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>camera</i> &#x2014; Cupertino icon for a camera for still photographs. This icon is filled in.
  /// This is the same icon as [camera] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [photo_camera], which is similar, but not filled in.
  ///  * [video_camera_solid], for the moving picture equivalent.
  static const IconData photo_camera = IconData(0xf3f5, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>camera_fill</i> &#x2014; Cupertino icon for a camera for still photographs. This icon is not filled in.
  /// This is the same icon as [camera_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [photo_camera_solid], which is similar, but filled in.
  ///  * [video_camera], for the moving picture equivalent.
  static const IconData photo_camera_solid = IconData(0xf3f6, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>videocam</i> &#x2014; Cupertino icon for a camera for moving pictures. This icon is not filled in.
  /// This is the same icon as [videocam] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [video_camera_solid], which is similar, but filled in.
  ///  * [photo_camera], for the still photograph equivalent.
  static const IconData video_camera = IconData(0xf4cc, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>videocam_fill</i> &#x2014; Cupertino icon for a camera for moving pictures. This icon is filled in.
  /// This is the same icon as [videocam_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [video_camera], which is similar, but not filled in.
  ///  * [photo_camera_solid], for the still photograph equivalent.
  static const IconData video_camera_solid = IconData(0xf4cd, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>camera_rotate</i> &#x2014; Cupertino icon for a camera containing two circular arrows pointing at each other, which indicate switching. This icon is not filled in.
  /// This is the same icon as [camera_rotate] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [switch_camera_solid], which is similar, but filled in.
  static const IconData switch_camera = IconData(0xf49e, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>camera_rotate_fill</i> &#x2014; Cupertino icon for a camera containing two circular arrows pointing at each other, which indicate switching. This icon is filled in.
  /// This is the same icon as [camera_rotate_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [switch_camera], which is similar, but not filled in.
  static const IconData switch_camera_solid = IconData(0xf49f, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>rectangle_stack</i> &#x2014; Cupertino icon for a collection of folders, which store collections of files, i.e. an album. This icon is not filled in.
  /// This is the same icon as [rectangle_stack] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [collections_solid], which is similar, but filled in.
  static const IconData collections = IconData(0xf3c9, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>rectangle_stack_fill</i> &#x2014; Cupertino icon for a collection of folders, which store collections of files, i.e. an album. This icon is filled in.
  /// This is the same icon as [rectangle_stack_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [collections], which is similar, but not filled in.
  static const IconData collections_solid = IconData(0xf3ca, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>folder_open</i> &#x2014; Cupertino icon for a single folder, which stores multiple files. This icon is not filled in.
  /// This is the same icon as [folder_open] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [folder_solid], which is similar, but filled in.
  ///  * [folder_open], which is the pre-iOS 7 version of this icon.
  static const IconData folder = IconData(0xf434, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>folder_fill</i> &#x2014; Cupertino icon for a single folder, which stores multiple files. This icon is filled in.
  /// This is the same icon as [folder_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [folder], which is similar, but not filled in.
  ///  * [folder_open], which is the pre-iOS 7 version of this icon and not filled in.
  static const IconData folder_solid = IconData(0xf435, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>folder</i> &#x2014; Cupertino icon for a single folder that indicates being opened. A folder like this typically stores multiple files.
  /// This is the same icon as [folder] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [folder], which is the equivalent of this icon for iOS versions later than or equal to iOS 7.
  static const IconData folder_open = IconData(0xf38a, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>trash</i> &#x2014; Cupertino icon for a trash bin for removing items. This icon is not filled in.
  /// This is the same icon as [trash] and [delete_simple] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [delete_solid], which is similar, but filled in.
  static const IconData delete = IconData(0xf4c4, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>trash_fill</i> &#x2014; Cupertino icon for a trash bin for removing items. This icon is filled in.
  /// This is the same icon as [trash_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [delete], which is similar, but not filled in.
  static const IconData delete_solid = IconData(0xf4c5, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>trash</i> &#x2014; Cupertino icon for a trash bin with minimal detail for removing items.
  /// This is the same icon as [trash] and [delete] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [delete], which is the iOS 7 equivalent of this icon with richer detail.
  static const IconData delete_simple = IconData(0xf37f, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>pen</i> &#x2014; Cupertino icon for a simple pen.
  ///
  /// See also:
  ///
  ///  * [pencil], which is similar, but has less detail and looks like a pencil.
  static const IconData pen = IconData(0xf2bf, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>pencil</i> &#x2014; Cupertino icon for a simple pencil.
  ///
  /// See also:
  ///
  ///  * [pen], which is similar, but has more detail and looks like a pen.
  static const IconData pencil = IconData(0xf37e, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>square_pencil</i> &#x2014; Cupertino icon for a box for writing and a pen on top (that indicates the writing). This icon is not filled in.
  /// This is the same icon as [square_pencil] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [create_solid], which is similar, but filled in.
  ///  * [pencil], which is just a pencil.
  ///  * [pen], which is just a pen.
  static const IconData create = IconData(0xf417, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>square_pencil_fill</i> &#x2014; Cupertino icon for a box for writing and a pen on top (that indicates the writing). This icon is filled in.
  /// This is the same icon as [square_pencil_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [create], which is similar, but not filled in.
  ///  * [pencil], which is just a pencil.
  ///  * [pen], which is just a pen.
  static const IconData create_solid = IconData(0xf417, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrow_clockwise</i> &#x2014; Cupertino icon for an arrow on a circular path with its end pointing at its start.
  /// This is the same icon as [arrow_clockwise], [refresh_thin] and [refresh_thick] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [refresh_circled], which is this icon put in a circle.
  ///  * [refresh_thin], which is an arrow of the same concept, but thinner and with a smaller gap in between its end and start.
  ///  * [refresh_thick], which is similar, but rotated 45 degrees clockwise and thicker.
  ///  * [refresh_bold], which is similar, but rotated 90 degrees clockwise and much thicker.
  static const IconData refresh = IconData(0xf49a, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrow_clockwise_circle</i> &#x2014; Cupertino icon for an arrow on a circular path with its end pointing at its start surrounded by a circle. This is icon is not filled in.
  /// This is the same icon as [arrow_clockwise_circle] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [refresh_circled_solid], which is similar, but filled in.
  ///  * [refresh], which is the arrow of this icon without a circle.
  static const IconData refresh_circled = IconData(0xf49b, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrow_clockwise_circle_fill</i> &#x2014; Cupertino icon for an arrow on a circular path with its end pointing at its start surrounded by a circle. This is icon is filled in.
  /// This is the same icon as [arrow_clockwise_circle_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [refresh_circled], which is similar, but not filled in.
  ///  * [refresh], which is the arrow of this icon filled in without a circle.
  static const IconData refresh_circled_solid = IconData(0xf49c, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrow_clockwise</i> &#x2014; Cupertino icon for an arrow on a circular path with its end pointing at its start.
  /// This is the same icon as [arrow_clockwise], [refresh] and [refresh_thick] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [refresh], which is an arrow of the same concept, but thicker and with a larger gap in between its end and start.
  static const IconData refresh_thin = IconData(0xf49d, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrow_clockwise</i> &#x2014; Cupertino icon for an arrow on a circular path with its end pointing at its start.
  /// This is the same icon as [arrow_clockwise], [refresh_thin] and [refresh] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [refresh], which is similar, but rotated 45 degrees anti-clockwise and thinner.
  ///  * [refresh_bold], which is similar, but rotated 45 degrees clockwise and thicker.
  static const IconData refresh_thick = IconData(0xf3a8, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrow_counterclockwise</i> &#x2014; Cupertino icon for an arrow on a circular path with its end pointing at its start.
  /// This is the same icon as [arrow_counterclockwise] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [refresh_thick], which is similar, but rotated 45 degrees anti-clockwise and thinner.
  ///  * [refresh], which is similar, but rotated 90 degrees anti-clockwise and much thinner.
  static const IconData refresh_bold = IconData(0xf21c, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>xmark</i> &#x2014; Cupertino icon for a cross of two diagonal lines from edge to edge crossing in an angle of 90 degrees, which is used for dismissal.
  /// This is the same icon as [xmark] and [clear] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [clear_circled], which uses this cross as a blank space in a filled out circled.
  ///  * [clear], which uses a thinner cross and is the iOS 7 equivalent of this icon.
  static const IconData clear_thick = IconData(0xf2d7, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>xmark_circle_fill</i> &#x2014; Cupertino icon for a cross of two diagonal lines from edge to edge crossing in an angle of 90 degrees, which is used for dismissal, used as a blank space in a circle.
  /// This is the same icon as [xmark_circle_fill] and [clear_circled_solid] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [clear], which is equivalent to the cross of this icon without a circle.
  ///  * [clear_circled_solid], which is similar, but uses a thinner cross.
  static const IconData clear_thick_circled = IconData(0xf36e, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>xmark</i> &#x2014; Cupertino icon for a cross of two diagonal lines from edge to edge crossing in an angle of 90 degrees, which is used for dismissal.
  /// This is the same icon as [xmark] and [clear_thick] in cupertino_icons 1.0.0+.
  ///
  ///
  /// See also:
  ///
  ///  * [clear_circled], which consists of this cross and a circle surrounding it.
  ///  * [clear], which uses a thicker cross and is the pre-iOS 7 equivalent of this icon.
  static const IconData clear = IconData(0xf404, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>xmark_circle</i> &#x2014; Cupertino icon for a cross of two diagonal lines from edge to edge crossing in an angle of 90 degrees, which is used for dismissal, surrounded by circle. This icon is not filled in.
  /// This is the same icon as [xmark_circle] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [clear_circled_solid], which is similar, but filled in.
  ///  * [clear], which is the standalone cross of this icon.
  static const IconData clear_circled = IconData(0xf405, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>xmark_circle_fill</i> &#x2014; Cupertino icon for a cross of two diagonal lines from edge to edge crossing in an angle of 90 degrees, which is used for dismissal, used as a blank space in a circle. This icon is filled in.
  /// This is the same icon as [xmark_circle_fill] and [clear_thick_circled] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [clear_circled], which is similar, but not filled in.
  static const IconData clear_circled_solid = IconData(0xf406, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>plus</i> &#x2014; Cupertino icon for an two straight lines, one horizontal and one vertical, meeting in the middle, which is the equivalent of a plus sign.
  /// This is the same icon as [plus] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [plus_circled], which is the pre-iOS 7 version of this icon with a thicker cross.
  ///  * [add_circled], which consists of the plus and a circle around it.
  static const IconData add = IconData(0xf489, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>plus_circle</i> &#x2014; Cupertino icon for an two straight lines, one horizontal and one vertical, meeting in the middle, which is the equivalent of a plus sign, surrounded by a circle. This icon is not filled in.
  /// This is the same icon as [plus_circle] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [plus_circled], which is the pre-iOS 7 version of this icon with a thicker cross and a filled in circle.
  ///  * [add_circled_solid], which is similar, but filled in.
  static const IconData add_circled = IconData(0xf48a, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>plus_circle_fill</i> &#x2014; Cupertino icon for an two straight lines, one horizontal and one vertical, meeting in the middle, which is the equivalent of a plus sign, surrounded by a circle. This icon is not filled in.
  /// This is the same icon as [plus_circle_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [plus_circled], which is the pre-iOS 7 version of this icon with a thicker cross.
  ///  * [add_circled], which is similar, but not filled in.
  static const IconData add_circled_solid = IconData(0xf48b, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>gear_alt</i> &#x2014; Cupertino icon for a gear with eight cogs. This icon is not filled in.
  /// This is the same icon as [gear_alt] and [gear_big] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [gear_solid], which is similar, but filled in.
  ///  * [gear_big], which is the pre-iOS 7 version of this icon and appears bigger because of fewer and bigger cogs.
  ///  * [settings], which is another cogwheel with a different design.
  static const IconData gear = IconData(0xf43c, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>gear_alt_fill</i> &#x2014; Cupertino icon for a gear with eight cogs. This icon is filled in.
  /// This is the same icon as [gear_alt_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [gear], which is similar, but not filled in.
  ///  * [settings_solid], which is another cogwheel with a different design.
  static const IconData gear_solid = IconData(0xf43d, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>gear_alt</i> &#x2014; Cupertino icon for a gear with six cogs.
  /// This is the same icon as [gear_alt] and [gear] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [gear], which is the iOS 7 version of this icon and appears smaller because of more and larger cogs.
  ///  * [settings_solid], which is another cogwheel with a different design.
  static const IconData gear_big = IconData(0xf2f7, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>settings</i> &#x2014; Cupertino icon for a cogwheel with many cogs and decoration in the middle. This icon is not filled in.
  ///
  /// See also:
  ///
  ///  * [settings_solid], which is similar, but filled in.
  ///  * [gear], which is another cogwheel with a different design.
  static const IconData settings = IconData(0xf411, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>settings_solid</i> &#x2014; Cupertino icon for a cogwheel with many cogs and decoration in the middle. This icon is filled in.
  ///
  /// See also:
  ///
  ///  * [settings], which is similar, but not filled in.
  ///  * [gear_solid], which is another cogwheel with a different design.
  static const IconData settings_solid = IconData(0xf412, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>music_note</i> &#x2014; Cupertino icon for a symbol representing a solid single musical note.
  ///
  /// See also:
  ///
  ///  * [double_music_note], which is similar, but with 2 connected notes.
  static const IconData music_note = IconData(0xf46b, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>music_note_2</i> &#x2014; Cupertino icon for a symbol representing 2 connected musical notes.
  /// This is the same icon as [music_note_2] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [music_note], which is similar, but with a single note.
  static const IconData double_music_note = IconData(0xf46c, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>play</i> &#x2014; Cupertino icon for a triangle facing to the right. This icon is not filled in.
  /// This is the same icon as [play] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [play_arrow_solid], which is similar, but filled in.
  static const IconData play_arrow = IconData(0xf487, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>play_fill</i> &#x2014; Cupertino icon for a triangle facing to the right. This icon is filled in.
  /// This is the same icon as [play_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [play_arrow], which is similar, but not filled in.
  static const IconData play_arrow_solid = IconData(0xf488, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>pause</i> &#x2014; Cupertino icon for an two vertical rectangles. This icon is not filled in.
  ///
  /// See also:
  ///
  ///  * [pause_solid], which is similar, but filled in.
  static const IconData pause = IconData(0xf477, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>pause_fill</i> &#x2014; Cupertino icon for an two vertical rectangles. This icon is filled in.
  /// This is the same icon as [pause_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [pause], which is similar, but not filled in.
  static const IconData pause_solid = IconData(0xf478, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>infinite</i> &#x2014; Cupertino icon for the infinity symbol.
  /// This is the same icon as [infinite] and [loop_thick] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [loop_thick], which is similar, but thicker.
  static const IconData loop = IconData(0xf449, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>infinite</i> &#x2014; Cupertino icon for the infinity symbol.
  /// This is the same icon as [infinite] and [loop] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [loop], which is similar, but thinner.
  static const IconData loop_thick = IconData(0xf44a, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>speaker_1_fill</i> &#x2014; Cupertino icon for a speaker with a single small sound wave.
  /// This is the same icon as [speaker_1_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [volume_mute], which is similar, but has no sound waves.
  ///  * [volume_off], which is similar, but with an additional larger sound wave and a diagonal line crossing the whole icon.
  ///  * [volume_up], which has an additional larger sound wave next to the small one.
  static const IconData volume_down = IconData(0xf3b7, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>speaker_fill</i> &#x2014; Cupertino icon for a speaker symbol.
  /// This is the same icon as [speaker_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [volume_down], which is similar, but adds a small sound wave.
  ///  * [volume_off], which is similar, but adds a small and a large sound wave and a diagonal line crossing the whole icon.
  ///  * [volume_up], which is similar, but has a small and a large sound wave.
  static const IconData volume_mute = IconData(0xf3b8, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>speaker_slash_fill</i> &#x2014; Cupertino icon for a speaker with a small and a large sound wave and a diagonal line crossing the whole icon.
  /// This is the same icon as [speaker_slash_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [volume_down], which is similar, but not crossed out and only has the small wave.
  ///  * [volume_mute], which is similar, but not crossed out.
  ///  * [volume_up], which is the version of this icon that is not crossed out.
  static const IconData volume_off = IconData(0xf3b9, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>speaker_3_fill</i> &#x2014; Cupertino icon for a speaker with a small and a large sound wave.
  /// This is the same icon as [speaker_3_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [volume_down], which is similar, but only has the small sound wave.
  ///  * [volume_mute], which is similar, but has no sound waves.
  ///  * [volume_off], which is the crossed out version of this icon.
  static const IconData volume_up = IconData(0xf3ba, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrow_up_left_arrow_down_right</i> &#x2014; Cupertino icon for all four corners of a square facing inwards.
  /// This is the same icon as [arrow_up_left_arrow_down_right] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [fullscreen_exit], which is similar, but has the corners facing outwards.
  static const IconData fullscreen = IconData(0xf386, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrow_down_right_arrow_up_left</i> &#x2014; Cupertino icon for all four corners of a square facing outwards.
  /// This is the same icon as [arrow_down_right_arrow_up_left] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [fullscreen], which is similar, but has the corners facing inwards.
  static const IconData fullscreen_exit = IconData(0xf37d, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>mic_slash</i> &#x2014; Cupertino icon for a filled in microphone with a diagonal line crossing it.
  /// This is the same icon as [mic_slash] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [mic], which is similar, but not filled in and without a diagonal line.
  ///  * [mic_solid], which is similar, but without a diagonal line.
  static const IconData mic_off = IconData(0xf45f, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>mic</i> &#x2014; Cupertino icon for a microphone.
  ///
  /// See also:
  ///
  ///  * [mic_solid], which is similar, but filled in.
  ///  * [mic_off], which is similar, but filled in and with a diagonal line crossing the icon.
  static const IconData mic = IconData(0xf460, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>mic_fill</i> &#x2014; Cupertino icon for a filled in microphone.
  /// This is the same icon as [mic_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [mic], which is similar, but not filled in.
  ///  * [mic_off], which is similar, but with a diagonal line crossing the icon.
  static const IconData mic_solid = IconData(0xf461, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>time</i> &#x2014; Cupertino icon for a circle with a dotted clock face inside with hands showing 10:30.
  /// This is the same icon as [time] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [clock_solid], which is similar, but filled in.
  ///  * [time], which is similar, but without dots on the clock face.
  ///  * [time_solid], which is similar, but filled in and without dots on the clock face.
  static const IconData clock = IconData(0xf4be, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>clock_fill</i> &#x2014; Cupertino icon for a filled in circle with a dotted clock face inside with hands showing 10:30.
  /// This is the same icon as [clock_fill] and [time_solid] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [clock], which is similar, but not filled in.
  ///  * [time], which is similar, but not filled in and without dots on the clock face.
  ///  * [time_solid], which is similar, but without dots on the clock face.
  static const IconData clock_solid = IconData(0xf4bf, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>clock</i> &#x2014; Cupertino icon for a circle with a 90 degree angle shape in the center, resembling a clock with hands showing 09:00.
  /// This is the same icon as [clock] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [time_solid], which is similar, but filled in.
  ///  * [clock], which is similar, but with dots on the clock face.
  ///  * [clock_solid], which is similar, but filled in and with dots on the clock face.
  static const IconData time = IconData(0xf402, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>clock_fill</i> &#x2014; Cupertino icon for a filled in circle with a 90 degree angle shape in the center, resembling a clock with hands showing 09:00.
  /// This is the same icon as [clock_fill] and [clock_solid] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [time], which is similar, but not filled in.
  ///  * [clock], which is similar, but not filled in and with dots on the clock face.
  ///  * [clock_solid], which is similar, but with dots on the clock face.
  static const IconData time_solid = IconData(0xf403, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>lock</i> &#x2014; Cupertino icon for an unlocked padlock.
  /// This is the same icon as [lock] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [padlock_solid], which is similar, but filled in.
  static const IconData padlock = IconData(0xf4c8, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>lock_fill</i> &#x2014; Cupertino icon for an unlocked padlock.
  /// This is the same icon as [lock_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [padlock], which is similar, but not filled in.
  static const IconData padlock_solid = IconData(0xf4c9, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>eye</i> &#x2014; Cupertino icon for an open eye.
  ///
  /// See also:
  ///
  ///  * [eye_solid], which is similar, but filled in.
  static const IconData eye = IconData(0xf424, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>eye_fill</i> &#x2014; Cupertino icon for an open eye.
  /// This is the same icon as [eye_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [eye], which is similar, but not filled in.
  static const IconData eye_solid = IconData(0xf425, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>person</i> &#x2014; Cupertino icon for a single person. This icon is not filled in.
  ///
  /// See also:
  ///
  ///  * [person_solid], which is similar, but filled in.
  ///  * [person_add], which has an additional plus sign next to the person.
  ///  * [group], which consists of three people.
  static const IconData person = IconData(0xf47d, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>person_fill</i> &#x2014; Cupertino icon for a single person. This icon is filled in.
  /// This is the same icon as [person_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [person], which is similar, but not filled in.
  ///  * [person_add_solid], which has an additional plus sign next to the person.
  ///  * [group_solid], which consists of three people.
  static const IconData person_solid = IconData(0xf47e, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>person_badge_plus</i> &#x2014; Cupertino icon for a single person with a plus sign next to it. This icon is not filled in.
  /// This is the same icon as [person_badge_plus] in cupertino_icons 1.0.0+.x
  ///
  /// See also:
  ///
  ///  * [person_add_solid], which is similar, but filled in.
  ///  * [person], which is just the person.
  ///  * [group], which consists of three people.
  static const IconData person_add = IconData(0xf47f, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>person_badge_plus_fill</i> &#x2014; Cupertino icon for a single person with a plus sign next to it. This icon is filled in.
  /// This is the same icon as [person_badge_plus_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [person_add], which is similar, but not filled in.
  ///  * [person_solid], which is just the person.
  ///  * [group_solid], which consists of three people.
  static const IconData person_add_solid = IconData(0xf480, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>person_3</i> &#x2014; Cupertino icon for a group of three people. This icon is not filled in.
  /// This is the same icon as [person_3] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [group_solid], which is similar, but filled in.
  ///  * [person], which is just a single person.
  static const IconData group = IconData(0xf47b, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>person_3_fill</i> &#x2014; Cupertino icon for a group of three people. This icon is filled in.
  /// This is the same icon as [person_3_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [group], which is similar, but not filled in.
  ///  * [person_solid], which is just a single person.
  static const IconData group_solid = IconData(0xf47c, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>envelope</i> &#x2014; Cupertino icon for the outline of a closed mail envelope.
  /// This is the same icon as [envelope] in cupertino_icons 1.0.0+.
  static const IconData mail = IconData(0xf422, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>envelope_fill</i> &#x2014; Cupertino icon for a closed mail envelope. This icon is filled in.
  /// This is the same icon as [envelope_fill] in cupertino_icons 1.0.0+.
  static const IconData mail_solid = IconData(0xf423, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>location</i> &#x2014; Cupertino icon for a location pin.
  static const IconData location = IconData(0xf6ee, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>placemark_fill</i> &#x2014; Cupertino icon for a location pin. This icon is filled in.
  /// This is the same icon as [placemark_fill] in cupertino_icons 1.0.0+.
  static const IconData location_solid = IconData(0xf456, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>tags</i> &#x2014; Cupertino icon for the outline of a sticker tag.
  /// This is the same icon as [tags] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [tags], similar but with 2 overlapping tags.
  static const IconData tag = IconData(0xf48c, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>tag_fill</i> &#x2014; Cupertino icon for a sticker tag. This icon is filled in.
  /// This is the same icon as [tag_fill] and [tags_solid] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [tags_solid], similar but with 2 overlapping tags.
  static const IconData tag_solid = IconData(0xf48d, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>tag</i> &#x2014; Cupertino icon for outlines of 2 overlapping sticker tags.
  /// This is the same icon as [tag] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [tag], similar but with only one tag.
  static const IconData tags = IconData(0xf48e, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>tag_fill</i> &#x2014; Cupertino icon for 2 overlapping sticker tags. This icon is filled in.
  /// This is the same icon as [tag_fill] and [tag_solid] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [tag_solid], similar but with only one tag.
  static const IconData tags_solid = IconData(0xf48f, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>bus</i> &#x2014; Cupertino icon for a filled in bus.
  /// This icon is available in cupertino_icons 1.0.0+ for backward
  /// compatibility but not part of Apple icons' aesthetics.
  static const IconData bus = IconData(0xf36d, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>car_fill</i> &#x2014; Cupertino icon for a filled in car.
  /// This is the same icon as [car_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [car_detailed], similar, but a more detailed and realistic representation.
  static const IconData car = IconData(0xf36f, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>car_detailed</i> &#x2014; Cupertino icon for a filled in detailed, realistic car.
  ///
  /// See also:
  ///
  ///  * [car], similar, but a more simple representation.
  /// This icon is available in cupertino_icons 1.0.0+ for backward
  /// compatibility but not part of Apple icons' aesthetics.
  static const IconData car_detailed = IconData(0xf2c1, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>train_style_one</i> &#x2014; Cupertino icon for a filled in train with a window divided in half and two headlights.
  /// This icon is available in cupertino_icons 1.0.0+ for backward
  /// compatibility but not part of Apple icons' aesthetics.
  ///
  /// See also:
  ///
  ///  * [train_style_two], similar, but with a full, undivided window and a single, centered headlight.
  static const IconData train_style_one = IconData(0xf3af, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>train_style_two</i> &#x2014; Cupertino icon for a filled in train with a window and a single, centered headlight.
  /// This icon is available in cupertino_icons 1.0.0+ for backward
  /// compatibility but not part of Apple icons' aesthetics.
  ///
  /// See also:
  ///
  ///  * [train_style_one], similar, but with a with a window divided in half and two headlights.
  static const IconData train_style_two = IconData(0xf3b4, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>paw</i> &#x2014; Cupertino icon for an outlined paw.
  ///
  /// See also:
  ///
  ///  * [paw_solid], similar, but filled in.
  static const IconData paw = IconData(0xf479, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>paw</i> &#x2014; Cupertino icon for a filled in paw.
  /// This is the same icon as [paw] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [paw], similar, but not filled in.
  static const IconData paw_solid = IconData(0xf47a, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>gamecontroller</i> &#x2014; Cupertino icon for an outlined game controller.
  /// This is the same icon as [gamecontroller] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [game_controller_solid], similar, but filled in.
  static const IconData game_controller = IconData(0xf43a, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>gamecontroller_fill</i> &#x2014; Cupertino icon for a filled in game controller.
  /// This is the same icon as [gamecontroller_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [game_controller], similar, but not filled in.
  static const IconData game_controller_solid = IconData(0xf43b, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>lab_flask</i> &#x2014; Cupertino icon for an outlined lab flask.
  /// This icon is available in cupertino_icons 1.0.0+ for backward
  /// compatibility but not part of Apple icons' aesthetics.
  ///
  /// See also:
  ///
  ///  * [lab_flask_solid], similar, but filled in.
  static const IconData lab_flask = IconData(0xf430, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>lab_flask_solid</i> &#x2014; Cupertino icon for a filled in lab flask.
  /// This icon is available in cupertino_icons 1.0.0+ for backward
  /// compatibility but not part of Apple icons' aesthetics.
  ///
  /// See also:
  ///
  ///  * [lab_flask], similar, but not filled in.
  static const IconData lab_flask_solid = IconData(0xf431, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>heart</i> &#x2014; Cupertino icon for an outlined heart shape. Can be used to indicate like or favorite states.
  ///
  /// See also:
  ///
  ///  * [heart_solid], same shape, but filled in.
  static const IconData heart = IconData(0xf442, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>heart_solid</i> &#x2014; Cupertino icon for a filled heart shape. Can be used to indicate like or favorite states.
  /// This is the same icon as [heart_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [heart], same shape, but not filled in.
  static const IconData heart_solid = IconData(0xf443, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>bell</i> &#x2014; Cupertino icon for an outlined bell. Can be used to represent notifications.
  ///
  /// See also:
  ///
  ///  * [bell_solid], same shape, but filled in.
  static const IconData bell = IconData(0xf3e1, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>bell_fill</i> &#x2014; Cupertino icon for a filled bell. Can be used represent notifications.
  /// This is the same icon as [bell_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [bell], same shape, but not filled in.
  static const IconData bell_solid = IconData(0xf3e2, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>news</i> &#x2014; Cupertino icon for an outlined folded newspaper icon.
  /// This icon is available in cupertino_icons 1.0.0+ for backward
  /// compatibility but not part of Apple icons' aesthetics.
  ///
  /// See also:
  ///
  ///  * [news_solid], same shape, but filled in.
  static const IconData news = IconData(0xf471, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>news_solid</i> &#x2014; Cupertino icon for a filled folded newspaper icon.
  /// This icon is available in cupertino_icons 1.0.0+ for backward
  /// compatibility but not part of Apple icons' aesthetics.
  ///
  /// See also:
  ///
  ///  * [news], same shape, but not filled in.
  static const IconData news_solid = IconData(0xf472, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>sun_max</i> &#x2014; Cupertino icon for an outlined brightness icon.
  /// This is the same icon as [sun_max] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [brightness_solid], same shape, but filled in.
  static const IconData brightness = IconData(0xf4B6, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>sun_max_fill</i> &#x2014; Cupertino icon for a filled in brightness icon.
  /// This is the same icon as [sun_max_fill] in cupertino_icons 1.0.0+.
  ///
  /// See also:
  ///
  ///  * [brightness], same shape, but not filled in.
  static const IconData brightness_solid = IconData(0xf4B7, fontFamily: iconFont, fontPackage: iconFontPackage);
  // END LEGACY PRE SF SYMBOLS NAMES
  // ===========================================================================

  // ===========================================================================
  // BEGIN GENERATED SF SYMBOLS NAMES
  /// <i class='cupertino-icons md-36'>airplane</i> &#x2014; Cupertino icon named "airplane". Available on cupertino_icons package 1.0.0+ only.
  static const IconData airplane = IconData(0xf4d4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>alarm</i> &#x2014; Cupertino icon named "alarm". Available on cupertino_icons package 1.0.0+ only.
  static const IconData alarm = IconData(0xf4d5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>alarm_fill</i> &#x2014; Cupertino icon named "alarm_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData alarm_fill = IconData(0xf4d6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>alt</i> &#x2014; Cupertino icon named "alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData alt = IconData(0xf4d7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>ant</i> &#x2014; Cupertino icon named "ant". Available on cupertino_icons package 1.0.0+ only.
  static const IconData ant = IconData(0xf4d8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>ant_circle</i> &#x2014; Cupertino icon named "ant_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData ant_circle = IconData(0xf4d9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>ant_circle_fill</i> &#x2014; Cupertino icon named "ant_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData ant_circle_fill = IconData(0xf4da, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>ant_fill</i> &#x2014; Cupertino icon named "ant_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData ant_fill = IconData(0xf4db, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>antenna_radiowaves_left_right</i> &#x2014; Cupertino icon named "antenna_radiowaves_left_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData antenna_radiowaves_left_right = IconData(0xf4dc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>app</i> &#x2014; Cupertino icon named "app". Available on cupertino_icons package 1.0.0+ only.
  static const IconData app = IconData(0xf4dd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>app_badge</i> &#x2014; Cupertino icon named "app_badge". Available on cupertino_icons package 1.0.0+ only.
  static const IconData app_badge = IconData(0xf4de, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>app_badge_fill</i> &#x2014; Cupertino icon named "app_badge_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData app_badge_fill = IconData(0xf4df, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>app_fill</i> &#x2014; Cupertino icon named "app_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData app_fill = IconData(0xf4e0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>archivebox</i> &#x2014; Cupertino icon named "archivebox". Available on cupertino_icons package 1.0.0+ only.
  static const IconData archivebox = IconData(0xf4e1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>archivebox_fill</i> &#x2014; Cupertino icon named "archivebox_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData archivebox_fill = IconData(0xf4e2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_2_circlepath</i> &#x2014; Cupertino icon named "arrow_2_circlepath". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_2_circlepath = IconData(0xf4e3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_2_circlepath_circle</i> &#x2014; Cupertino icon named "arrow_2_circlepath_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_2_circlepath_circle = IconData(0xf4e4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_2_circlepath_circle_fill</i> &#x2014; Cupertino icon named "arrow_2_circlepath_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_2_circlepath_circle_fill = IconData(0xf4e5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_2_squarepath</i> &#x2014; Cupertino icon named "arrow_2_squarepath". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_2_squarepath = IconData(0xf4e6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_3_trianglepath</i> &#x2014; Cupertino icon named "arrow_3_trianglepath". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_3_trianglepath = IconData(0xf4e7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_branch</i> &#x2014; Cupertino icon named "arrow_branch". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_branch = IconData(0xf4e8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_clockwise</i> &#x2014; Cupertino icon named "arrow_clockwise". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [refresh] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [refresh_thin] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [refresh_thick] which is available in cupertino_icons 0.1.3.
  static const IconData arrow_clockwise = IconData(0xf49a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_clockwise_circle</i> &#x2014; Cupertino icon named "arrow_clockwise_circle". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [refresh_circled] which is available in cupertino_icons 0.1.3.
  static const IconData arrow_clockwise_circle = IconData(0xf49b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_clockwise_circle_fill</i> &#x2014; Cupertino icon named "arrow_clockwise_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [refresh_circled_solid] which is available in cupertino_icons 0.1.3.
  static const IconData arrow_clockwise_circle_fill = IconData(0xf49c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_counterclockwise</i> &#x2014; Cupertino icon named "arrow_counterclockwise". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [restart] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [refresh_bold] which is available in cupertino_icons 0.1.3.
  static const IconData arrow_counterclockwise = IconData(0xf21c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_counterclockwise_circle</i> &#x2014; Cupertino icon named "arrow_counterclockwise_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_counterclockwise_circle = IconData(0xf4e9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_counterclockwise_circle_fill</i> &#x2014; Cupertino icon named "arrow_counterclockwise_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_counterclockwise_circle_fill = IconData(0xf4ea, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down</i> &#x2014; Cupertino icon named "arrow_down". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [down_arrow] which is available in cupertino_icons 0.1.3.
  static const IconData arrow_down = IconData(0xf35d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_circle</i> &#x2014; Cupertino icon named "arrow_down_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_circle = IconData(0xf4eb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_circle_fill</i> &#x2014; Cupertino icon named "arrow_down_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_circle_fill = IconData(0xf4ec, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_doc</i> &#x2014; Cupertino icon named "arrow_down_doc". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_doc = IconData(0xf4ed, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_doc_fill</i> &#x2014; Cupertino icon named "arrow_down_doc_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_doc_fill = IconData(0xf4ee, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_left</i> &#x2014; Cupertino icon named "arrow_down_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_left = IconData(0xf4ef, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_left_circle</i> &#x2014; Cupertino icon named "arrow_down_left_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_left_circle = IconData(0xf4f0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_left_circle_fill</i> &#x2014; Cupertino icon named "arrow_down_left_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_left_circle_fill = IconData(0xf4f1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_left_square</i> &#x2014; Cupertino icon named "arrow_down_left_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_left_square = IconData(0xf4f2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_left_square_fill</i> &#x2014; Cupertino icon named "arrow_down_left_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_left_square_fill = IconData(0xf4f3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_right</i> &#x2014; Cupertino icon named "arrow_down_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_right = IconData(0xf4f4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_right_arrow_up_left</i> &#x2014; Cupertino icon named "arrow_down_right_arrow_up_left". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [fullscreen_exit] which is available in cupertino_icons 0.1.3.
  static const IconData arrow_down_right_arrow_up_left = IconData(0xf37d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_right_circle</i> &#x2014; Cupertino icon named "arrow_down_right_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_right_circle = IconData(0xf4f5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_right_circle_fill</i> &#x2014; Cupertino icon named "arrow_down_right_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_right_circle_fill = IconData(0xf4f6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_right_square</i> &#x2014; Cupertino icon named "arrow_down_right_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_right_square = IconData(0xf4f7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_right_square_fill</i> &#x2014; Cupertino icon named "arrow_down_right_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_right_square_fill = IconData(0xf4f8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_square</i> &#x2014; Cupertino icon named "arrow_down_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_square = IconData(0xf4f9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_square_fill</i> &#x2014; Cupertino icon named "arrow_down_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_square_fill = IconData(0xf4fa, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_to_line</i> &#x2014; Cupertino icon named "arrow_down_to_line". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_to_line = IconData(0xf4fb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_down_to_line_alt</i> &#x2014; Cupertino icon named "arrow_down_to_line_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_down_to_line_alt = IconData(0xf4fc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_left</i> &#x2014; Cupertino icon named "arrow_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_left = IconData(0xf4fd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_left_circle</i> &#x2014; Cupertino icon named "arrow_left_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_left_circle = IconData(0xf4fe, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_left_circle_fill</i> &#x2014; Cupertino icon named "arrow_left_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_left_circle_fill = IconData(0xf4ff, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_left_right</i> &#x2014; Cupertino icon named "arrow_left_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_left_right = IconData(0xf500, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_left_right_circle</i> &#x2014; Cupertino icon named "arrow_left_right_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_left_right_circle = IconData(0xf501, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_left_right_circle_fill</i> &#x2014; Cupertino icon named "arrow_left_right_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_left_right_circle_fill = IconData(0xf502, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_left_right_square</i> &#x2014; Cupertino icon named "arrow_left_right_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_left_right_square = IconData(0xf503, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_left_right_square_fill</i> &#x2014; Cupertino icon named "arrow_left_right_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_left_right_square_fill = IconData(0xf504, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_left_square</i> &#x2014; Cupertino icon named "arrow_left_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_left_square = IconData(0xf505, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_left_square_fill</i> &#x2014; Cupertino icon named "arrow_left_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_left_square_fill = IconData(0xf506, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_left_to_line</i> &#x2014; Cupertino icon named "arrow_left_to_line". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_left_to_line = IconData(0xf507, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_left_to_line_alt</i> &#x2014; Cupertino icon named "arrow_left_to_line_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_left_to_line_alt = IconData(0xf508, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_merge</i> &#x2014; Cupertino icon named "arrow_merge". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_merge = IconData(0xf509, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_right</i> &#x2014; Cupertino icon named "arrow_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_right = IconData(0xf50a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_right_arrow_left</i> &#x2014; Cupertino icon named "arrow_right_arrow_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_right_arrow_left = IconData(0xf50b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_right_arrow_left_circle</i> &#x2014; Cupertino icon named "arrow_right_arrow_left_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_right_arrow_left_circle = IconData(0xf50c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_right_arrow_left_circle_fill</i> &#x2014; Cupertino icon named "arrow_right_arrow_left_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_right_arrow_left_circle_fill = IconData(0xf50d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_right_arrow_left_square</i> &#x2014; Cupertino icon named "arrow_right_arrow_left_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_right_arrow_left_square = IconData(0xf50e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_right_arrow_left_square_fill</i> &#x2014; Cupertino icon named "arrow_right_arrow_left_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_right_arrow_left_square_fill = IconData(0xf50f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_right_circle</i> &#x2014; Cupertino icon named "arrow_right_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_right_circle = IconData(0xf510, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_right_circle_fill</i> &#x2014; Cupertino icon named "arrow_right_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_right_circle_fill = IconData(0xf511, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_right_square</i> &#x2014; Cupertino icon named "arrow_right_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_right_square = IconData(0xf512, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_right_square_fill</i> &#x2014; Cupertino icon named "arrow_right_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_right_square_fill = IconData(0xf513, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_right_to_line</i> &#x2014; Cupertino icon named "arrow_right_to_line". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_right_to_line = IconData(0xf514, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_right_to_line_alt</i> &#x2014; Cupertino icon named "arrow_right_to_line_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_right_to_line_alt = IconData(0xf515, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_swap</i> &#x2014; Cupertino icon named "arrow_swap". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_swap = IconData(0xf516, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_turn_down_left</i> &#x2014; Cupertino icon named "arrow_turn_down_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_turn_down_left = IconData(0xf517, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_turn_down_right</i> &#x2014; Cupertino icon named "arrow_turn_down_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_turn_down_right = IconData(0xf518, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_turn_left_down</i> &#x2014; Cupertino icon named "arrow_turn_left_down". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_turn_left_down = IconData(0xf519, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_turn_left_up</i> &#x2014; Cupertino icon named "arrow_turn_left_up". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_turn_left_up = IconData(0xf51a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_turn_right_down</i> &#x2014; Cupertino icon named "arrow_turn_right_down". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_turn_right_down = IconData(0xf51b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_turn_right_up</i> &#x2014; Cupertino icon named "arrow_turn_right_up". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_turn_right_up = IconData(0xf51c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_turn_up_left</i> &#x2014; Cupertino icon named "arrow_turn_up_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_turn_up_left = IconData(0xf51d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_turn_up_right</i> &#x2014; Cupertino icon named "arrow_turn_up_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_turn_up_right = IconData(0xf51e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up</i> &#x2014; Cupertino icon named "arrow_up". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [up_arrow] which is available in cupertino_icons 0.1.3.
  static const IconData arrow_up = IconData(0xf366, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_arrow_down</i> &#x2014; Cupertino icon named "arrow_up_arrow_down". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_arrow_down = IconData(0xf51f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_arrow_down_circle</i> &#x2014; Cupertino icon named "arrow_up_arrow_down_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_arrow_down_circle = IconData(0xf520, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_arrow_down_circle_fill</i> &#x2014; Cupertino icon named "arrow_up_arrow_down_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_arrow_down_circle_fill = IconData(0xf521, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_arrow_down_square</i> &#x2014; Cupertino icon named "arrow_up_arrow_down_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_arrow_down_square = IconData(0xf522, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_arrow_down_square_fill</i> &#x2014; Cupertino icon named "arrow_up_arrow_down_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_arrow_down_square_fill = IconData(0xf523, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_bin</i> &#x2014; Cupertino icon named "arrow_up_bin". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_bin = IconData(0xf524, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_bin_fill</i> &#x2014; Cupertino icon named "arrow_up_bin_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_bin_fill = IconData(0xf525, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_circle</i> &#x2014; Cupertino icon named "arrow_up_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_circle = IconData(0xf526, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_circle_fill</i> &#x2014; Cupertino icon named "arrow_up_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_circle_fill = IconData(0xf527, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_doc</i> &#x2014; Cupertino icon named "arrow_up_doc". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_doc = IconData(0xf528, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_doc_fill</i> &#x2014; Cupertino icon named "arrow_up_doc_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_doc_fill = IconData(0xf529, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_down</i> &#x2014; Cupertino icon named "arrow_up_down". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_down = IconData(0xf52a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_down_circle</i> &#x2014; Cupertino icon named "arrow_up_down_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_down_circle = IconData(0xf52b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_down_circle_fill</i> &#x2014; Cupertino icon named "arrow_up_down_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_down_circle_fill = IconData(0xf52c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_down_square</i> &#x2014; Cupertino icon named "arrow_up_down_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_down_square = IconData(0xf52d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_down_square_fill</i> &#x2014; Cupertino icon named "arrow_up_down_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_down_square_fill = IconData(0xf52e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_left</i> &#x2014; Cupertino icon named "arrow_up_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_left = IconData(0xf52f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_left_arrow_down_right</i> &#x2014; Cupertino icon named "arrow_up_left_arrow_down_right". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [fullscreen] which is available in cupertino_icons 0.1.3.
  static const IconData arrow_up_left_arrow_down_right = IconData(0xf386, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_left_circle</i> &#x2014; Cupertino icon named "arrow_up_left_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_left_circle = IconData(0xf530, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_left_circle_fill</i> &#x2014; Cupertino icon named "arrow_up_left_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_left_circle_fill = IconData(0xf531, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_left_square</i> &#x2014; Cupertino icon named "arrow_up_left_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_left_square = IconData(0xf532, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_left_square_fill</i> &#x2014; Cupertino icon named "arrow_up_left_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_left_square_fill = IconData(0xf533, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_right</i> &#x2014; Cupertino icon named "arrow_up_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_right = IconData(0xf534, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_right_circle</i> &#x2014; Cupertino icon named "arrow_up_right_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_right_circle = IconData(0xf535, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_right_circle_fill</i> &#x2014; Cupertino icon named "arrow_up_right_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_right_circle_fill = IconData(0xf536, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_right_diamond</i> &#x2014; Cupertino icon named "arrow_up_right_diamond". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_right_diamond = IconData(0xf537, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_right_diamond_fill</i> &#x2014; Cupertino icon named "arrow_up_right_diamond_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_right_diamond_fill = IconData(0xf538, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_right_square</i> &#x2014; Cupertino icon named "arrow_up_right_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_right_square = IconData(0xf539, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_right_square_fill</i> &#x2014; Cupertino icon named "arrow_up_right_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_right_square_fill = IconData(0xf53a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_square</i> &#x2014; Cupertino icon named "arrow_up_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_square = IconData(0xf53b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_square_fill</i> &#x2014; Cupertino icon named "arrow_up_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_square_fill = IconData(0xf53c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_to_line</i> &#x2014; Cupertino icon named "arrow_up_to_line". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_to_line = IconData(0xf53d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_up_to_line_alt</i> &#x2014; Cupertino icon named "arrow_up_to_line_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_up_to_line_alt = IconData(0xf53e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_down</i> &#x2014; Cupertino icon named "arrow_uturn_down". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_down = IconData(0xf53f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_down_circle</i> &#x2014; Cupertino icon named "arrow_uturn_down_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_down_circle = IconData(0xf540, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_down_circle_fill</i> &#x2014; Cupertino icon named "arrow_uturn_down_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_down_circle_fill = IconData(0xf541, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_down_square</i> &#x2014; Cupertino icon named "arrow_uturn_down_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_down_square = IconData(0xf542, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_down_square_fill</i> &#x2014; Cupertino icon named "arrow_uturn_down_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_down_square_fill = IconData(0xf543, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_left</i> &#x2014; Cupertino icon named "arrow_uturn_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_left = IconData(0xf544, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_left_circle</i> &#x2014; Cupertino icon named "arrow_uturn_left_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_left_circle = IconData(0xf545, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_left_circle_fill</i> &#x2014; Cupertino icon named "arrow_uturn_left_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_left_circle_fill = IconData(0xf546, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_left_square</i> &#x2014; Cupertino icon named "arrow_uturn_left_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_left_square = IconData(0xf547, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_left_square_fill</i> &#x2014; Cupertino icon named "arrow_uturn_left_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_left_square_fill = IconData(0xf548, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_right</i> &#x2014; Cupertino icon named "arrow_uturn_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_right = IconData(0xf549, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_right_circle</i> &#x2014; Cupertino icon named "arrow_uturn_right_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_right_circle = IconData(0xf54a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_right_circle_fill</i> &#x2014; Cupertino icon named "arrow_uturn_right_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_right_circle_fill = IconData(0xf54b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_right_square</i> &#x2014; Cupertino icon named "arrow_uturn_right_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_right_square = IconData(0xf54c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_right_square_fill</i> &#x2014; Cupertino icon named "arrow_uturn_right_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_right_square_fill = IconData(0xf54d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_up</i> &#x2014; Cupertino icon named "arrow_uturn_up". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_up = IconData(0xf54e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_up_circle</i> &#x2014; Cupertino icon named "arrow_uturn_up_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_up_circle = IconData(0xf54f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_up_circle_fill</i> &#x2014; Cupertino icon named "arrow_uturn_up_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_up_circle_fill = IconData(0xf550, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_up_square</i> &#x2014; Cupertino icon named "arrow_uturn_up_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_up_square = IconData(0xf551, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrow_uturn_up_square_fill</i> &#x2014; Cupertino icon named "arrow_uturn_up_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrow_uturn_up_square_fill = IconData(0xf552, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowshape_turn_up_left</i> &#x2014; Cupertino icon named "arrowshape_turn_up_left". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [reply] which is available in cupertino_icons 0.1.3.
  static const IconData arrowshape_turn_up_left = IconData(0xf4c6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowshape_turn_up_left_2</i> &#x2014; Cupertino icon named "arrowshape_turn_up_left_2". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [reply_all] which is available in cupertino_icons 0.1.3.
  static const IconData arrowshape_turn_up_left_2 = IconData(0xf21d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowshape_turn_up_left_2_fill</i> &#x2014; Cupertino icon named "arrowshape_turn_up_left_2_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [reply_thick_solid] which is available in cupertino_icons 0.1.3.
  static const IconData arrowshape_turn_up_left_2_fill = IconData(0xf21e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowshape_turn_up_left_circle</i> &#x2014; Cupertino icon named "arrowshape_turn_up_left_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowshape_turn_up_left_circle = IconData(0xf553, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowshape_turn_up_left_circle_fill</i> &#x2014; Cupertino icon named "arrowshape_turn_up_left_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowshape_turn_up_left_circle_fill = IconData(0xf554, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowshape_turn_up_left_fill</i> &#x2014; Cupertino icon named "arrowshape_turn_up_left_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowshape_turn_up_left_fill = IconData(0xf555, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowshape_turn_up_right</i> &#x2014; Cupertino icon named "arrowshape_turn_up_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowshape_turn_up_right = IconData(0xf556, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowshape_turn_up_right_circle</i> &#x2014; Cupertino icon named "arrowshape_turn_up_right_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowshape_turn_up_right_circle = IconData(0xf557, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowshape_turn_up_right_circle_fill</i> &#x2014; Cupertino icon named "arrowshape_turn_up_right_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowshape_turn_up_right_circle_fill = IconData(0xf558, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowshape_turn_up_right_fill</i> &#x2014; Cupertino icon named "arrowshape_turn_up_right_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowshape_turn_up_right_fill = IconData(0xf559, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_down</i> &#x2014; Cupertino icon named "arrowtriangle_down". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_down = IconData(0xf55a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_down_circle</i> &#x2014; Cupertino icon named "arrowtriangle_down_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_down_circle = IconData(0xf55b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_down_circle_fill</i> &#x2014; Cupertino icon named "arrowtriangle_down_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_down_circle_fill = IconData(0xf55c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_down_fill</i> &#x2014; Cupertino icon named "arrowtriangle_down_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_down_fill = IconData(0xf55d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_down_square</i> &#x2014; Cupertino icon named "arrowtriangle_down_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_down_square = IconData(0xf55e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_down_square_fill</i> &#x2014; Cupertino icon named "arrowtriangle_down_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_down_square_fill = IconData(0xf55f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_left</i> &#x2014; Cupertino icon named "arrowtriangle_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_left = IconData(0xf560, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_left_circle</i> &#x2014; Cupertino icon named "arrowtriangle_left_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_left_circle = IconData(0xf561, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_left_circle_fill</i> &#x2014; Cupertino icon named "arrowtriangle_left_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_left_circle_fill = IconData(0xf562, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_left_fill</i> &#x2014; Cupertino icon named "arrowtriangle_left_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_left_fill = IconData(0xf563, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_left_square</i> &#x2014; Cupertino icon named "arrowtriangle_left_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_left_square = IconData(0xf564, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_left_square_fill</i> &#x2014; Cupertino icon named "arrowtriangle_left_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_left_square_fill = IconData(0xf565, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_right</i> &#x2014; Cupertino icon named "arrowtriangle_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_right = IconData(0xf566, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_right_circle</i> &#x2014; Cupertino icon named "arrowtriangle_right_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_right_circle = IconData(0xf567, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_right_circle_fill</i> &#x2014; Cupertino icon named "arrowtriangle_right_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_right_circle_fill = IconData(0xf568, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_right_fill</i> &#x2014; Cupertino icon named "arrowtriangle_right_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_right_fill = IconData(0xf569, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_right_square</i> &#x2014; Cupertino icon named "arrowtriangle_right_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_right_square = IconData(0xf56a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_right_square_fill</i> &#x2014; Cupertino icon named "arrowtriangle_right_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_right_square_fill = IconData(0xf56b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_up</i> &#x2014; Cupertino icon named "arrowtriangle_up". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_up = IconData(0xf56c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_up_circle</i> &#x2014; Cupertino icon named "arrowtriangle_up_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_up_circle = IconData(0xf56d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_up_circle_fill</i> &#x2014; Cupertino icon named "arrowtriangle_up_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_up_circle_fill = IconData(0xf56e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_up_fill</i> &#x2014; Cupertino icon named "arrowtriangle_up_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_up_fill = IconData(0xf56f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_up_square</i> &#x2014; Cupertino icon named "arrowtriangle_up_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_up_square = IconData(0xf570, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>arrowtriangle_up_square_fill</i> &#x2014; Cupertino icon named "arrowtriangle_up_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData arrowtriangle_up_square_fill = IconData(0xf571, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>asterisk_circle</i> &#x2014; Cupertino icon named "asterisk_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData asterisk_circle = IconData(0xf572, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>asterisk_circle_fill</i> &#x2014; Cupertino icon named "asterisk_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData asterisk_circle_fill = IconData(0xf573, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>at</i> &#x2014; Cupertino icon named "at". Available on cupertino_icons package 1.0.0+ only.
  static const IconData at = IconData(0xf574, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>at_badge_minus</i> &#x2014; Cupertino icon named "at_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData at_badge_minus = IconData(0xf575, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>at_badge_plus</i> &#x2014; Cupertino icon named "at_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData at_badge_plus = IconData(0xf576, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>at_circle</i> &#x2014; Cupertino icon named "at_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData at_circle = IconData(0xf8af, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>at_circle_fill</i> &#x2014; Cupertino icon named "at_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData at_circle_fill = IconData(0xf8b0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>backward</i> &#x2014; Cupertino icon named "backward". Available on cupertino_icons package 1.0.0+ only.
  static const IconData backward = IconData(0xf577, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>backward_end</i> &#x2014; Cupertino icon named "backward_end". Available on cupertino_icons package 1.0.0+ only.
  static const IconData backward_end = IconData(0xf578, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>backward_end_alt</i> &#x2014; Cupertino icon named "backward_end_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData backward_end_alt = IconData(0xf579, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>backward_end_alt_fill</i> &#x2014; Cupertino icon named "backward_end_alt_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData backward_end_alt_fill = IconData(0xf57a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>backward_end_fill</i> &#x2014; Cupertino icon named "backward_end_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData backward_end_fill = IconData(0xf57b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>backward_fill</i> &#x2014; Cupertino icon named "backward_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData backward_fill = IconData(0xf57c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>badge_plus_radiowaves_right</i> &#x2014; Cupertino icon named "badge_plus_radiowaves_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData badge_plus_radiowaves_right = IconData(0xf57d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bag</i> &#x2014; Cupertino icon named "bag". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bag = IconData(0xf57e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bag_badge_minus</i> &#x2014; Cupertino icon named "bag_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bag_badge_minus = IconData(0xf57f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bag_badge_plus</i> &#x2014; Cupertino icon named "bag_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bag_badge_plus = IconData(0xf580, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bag_fill</i> &#x2014; Cupertino icon named "bag_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bag_fill = IconData(0xf581, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bag_fill_badge_minus</i> &#x2014; Cupertino icon named "bag_fill_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bag_fill_badge_minus = IconData(0xf582, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bag_fill_badge_plus</i> &#x2014; Cupertino icon named "bag_fill_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bag_fill_badge_plus = IconData(0xf583, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bandage</i> &#x2014; Cupertino icon named "bandage". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bandage = IconData(0xf584, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bandage_fill</i> &#x2014; Cupertino icon named "bandage_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bandage_fill = IconData(0xf585, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>barcode</i> &#x2014; Cupertino icon named "barcode". Available on cupertino_icons package 1.0.0+ only.
  static const IconData barcode = IconData(0xf586, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>barcode_viewfinder</i> &#x2014; Cupertino icon named "barcode_viewfinder". Available on cupertino_icons package 1.0.0+ only.
  static const IconData barcode_viewfinder = IconData(0xf587, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bars</i> &#x2014; Cupertino icon named "bars". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bars = IconData(0xf8b1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>battery_0</i> &#x2014; Cupertino icon named "battery_0". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [battery_empty] which is available in cupertino_icons 0.1.3.
  static const IconData battery_0 = IconData(0xf112, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>battery_100</i> &#x2014; Cupertino icon named "battery_100". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [battery_charging] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [battery_full] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [battery_75_percent] which is available in cupertino_icons 0.1.3.
  static const IconData battery_100 = IconData(0xf113, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>battery_25</i> &#x2014; Cupertino icon named "battery_25". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [battery_25_percent] which is available in cupertino_icons 0.1.3.
  static const IconData battery_25 = IconData(0xf115, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bed_double</i> &#x2014; Cupertino icon named "bed_double". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bed_double = IconData(0xf588, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bed_double_fill</i> &#x2014; Cupertino icon named "bed_double_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bed_double_fill = IconData(0xf589, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bell_circle</i> &#x2014; Cupertino icon named "bell_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bell_circle = IconData(0xf58a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bell_circle_fill</i> &#x2014; Cupertino icon named "bell_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bell_circle_fill = IconData(0xf58b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bell_fill</i> &#x2014; Cupertino icon named "bell_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [bell_solid] which is available in cupertino_icons 0.1.3.
  static const IconData bell_fill = IconData(0xf3e2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bell_slash</i> &#x2014; Cupertino icon named "bell_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bell_slash = IconData(0xf58c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bell_slash_fill</i> &#x2014; Cupertino icon named "bell_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bell_slash_fill = IconData(0xf58d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bin_xmark</i> &#x2014; Cupertino icon named "bin_xmark". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bin_xmark = IconData(0xf58e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bin_xmark_fill</i> &#x2014; Cupertino icon named "bin_xmark_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bin_xmark_fill = IconData(0xf58f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bitcoin</i> &#x2014; Cupertino icon named "bitcoin". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bitcoin = IconData(0xf8b2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bitcoin_circle</i> &#x2014; Cupertino icon named "bitcoin_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bitcoin_circle = IconData(0xf8b3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bitcoin_circle_fill</i> &#x2014; Cupertino icon named "bitcoin_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bitcoin_circle_fill = IconData(0xf8b4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bold</i> &#x2014; Cupertino icon named "bold". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bold = IconData(0xf590, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bold_italic_underline</i> &#x2014; Cupertino icon named "bold_italic_underline". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bold_italic_underline = IconData(0xf591, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bold_underline</i> &#x2014; Cupertino icon named "bold_underline". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bold_underline = IconData(0xf592, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bolt</i> &#x2014; Cupertino icon named "bolt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bolt = IconData(0xf593, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bolt_badge_a</i> &#x2014; Cupertino icon named "bolt_badge_a". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bolt_badge_a = IconData(0xf594, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bolt_badge_a_fill</i> &#x2014; Cupertino icon named "bolt_badge_a_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bolt_badge_a_fill = IconData(0xf595, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bolt_circle</i> &#x2014; Cupertino icon named "bolt_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bolt_circle = IconData(0xf596, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bolt_circle_fill</i> &#x2014; Cupertino icon named "bolt_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bolt_circle_fill = IconData(0xf597, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bolt_fill</i> &#x2014; Cupertino icon named "bolt_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bolt_fill = IconData(0xf598, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bolt_horizontal</i> &#x2014; Cupertino icon named "bolt_horizontal". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bolt_horizontal = IconData(0xf599, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bolt_horizontal_circle</i> &#x2014; Cupertino icon named "bolt_horizontal_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bolt_horizontal_circle = IconData(0xf59a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bolt_horizontal_circle_fill</i> &#x2014; Cupertino icon named "bolt_horizontal_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bolt_horizontal_circle_fill = IconData(0xf59b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bolt_horizontal_fill</i> &#x2014; Cupertino icon named "bolt_horizontal_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bolt_horizontal_fill = IconData(0xf59c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bolt_slash</i> &#x2014; Cupertino icon named "bolt_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bolt_slash = IconData(0xf59d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bolt_slash_fill</i> &#x2014; Cupertino icon named "bolt_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bolt_slash_fill = IconData(0xf59e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>book_circle</i> &#x2014; Cupertino icon named "book_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData book_circle = IconData(0xf59f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>book_circle_fill</i> &#x2014; Cupertino icon named "book_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData book_circle_fill = IconData(0xf5a0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>book_fill</i> &#x2014; Cupertino icon named "book_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [book_solid] which is available in cupertino_icons 0.1.3.
  static const IconData book_fill = IconData(0xf3e8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bookmark_fill</i> &#x2014; Cupertino icon named "bookmark_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [bookmark_solid] which is available in cupertino_icons 0.1.3.
  static const IconData bookmark_fill = IconData(0xf3ea, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>briefcase</i> &#x2014; Cupertino icon named "briefcase". Available on cupertino_icons package 1.0.0+ only.
  static const IconData briefcase = IconData(0xf5a1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>briefcase_fill</i> &#x2014; Cupertino icon named "briefcase_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData briefcase_fill = IconData(0xf5a2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bubble_left</i> &#x2014; Cupertino icon named "bubble_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bubble_left = IconData(0xf5a3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bubble_left_bubble_right</i> &#x2014; Cupertino icon named "bubble_left_bubble_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bubble_left_bubble_right = IconData(0xf5a4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bubble_left_bubble_right_fill</i> &#x2014; Cupertino icon named "bubble_left_bubble_right_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bubble_left_bubble_right_fill = IconData(0xf5a5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bubble_left_fill</i> &#x2014; Cupertino icon named "bubble_left_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bubble_left_fill = IconData(0xf5a6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bubble_middle_bottom</i> &#x2014; Cupertino icon named "bubble_middle_bottom". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bubble_middle_bottom = IconData(0xf5a7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bubble_middle_bottom_fill</i> &#x2014; Cupertino icon named "bubble_middle_bottom_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bubble_middle_bottom_fill = IconData(0xf5a8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bubble_middle_top</i> &#x2014; Cupertino icon named "bubble_middle_top". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bubble_middle_top = IconData(0xf5a9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bubble_middle_top_fill</i> &#x2014; Cupertino icon named "bubble_middle_top_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bubble_middle_top_fill = IconData(0xf5aa, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bubble_right</i> &#x2014; Cupertino icon named "bubble_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bubble_right = IconData(0xf5ab, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>bubble_right_fill</i> &#x2014; Cupertino icon named "bubble_right_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData bubble_right_fill = IconData(0xf5ac, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>building_2_fill</i> &#x2014; Cupertino icon named "building_2_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData building_2_fill = IconData(0xf8b5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>burn</i> &#x2014; Cupertino icon named "burn". Available on cupertino_icons package 1.0.0+ only.
  static const IconData burn = IconData(0xf5ad, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>burst</i> &#x2014; Cupertino icon named "burst". Available on cupertino_icons package 1.0.0+ only.
  static const IconData burst = IconData(0xf5ae, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>burst_fill</i> &#x2014; Cupertino icon named "burst_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData burst_fill = IconData(0xf5af, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>calendar</i> &#x2014; Cupertino icon named "calendar". Available on cupertino_icons package 1.0.0+ only.
  static const IconData calendar = IconData(0xf5b0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>calendar_badge_minus</i> &#x2014; Cupertino icon named "calendar_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData calendar_badge_minus = IconData(0xf5b1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>calendar_badge_plus</i> &#x2014; Cupertino icon named "calendar_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData calendar_badge_plus = IconData(0xf5b2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>calendar_circle</i> &#x2014; Cupertino icon named "calendar_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData calendar_circle = IconData(0xf5b3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>calendar_circle_fill</i> &#x2014; Cupertino icon named "calendar_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData calendar_circle_fill = IconData(0xf5b4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>calendar_today</i> &#x2014; Cupertino icon named "calendar_today". Available on cupertino_icons package 1.0.0+ only.
  static const IconData calendar_today = IconData(0xf8b6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>camera</i> &#x2014; Cupertino icon named "camera". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [photo_camera] which is available in cupertino_icons 0.1.3.
  static const IconData camera = IconData(0xf3f5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>camera_circle</i> &#x2014; Cupertino icon named "camera_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData camera_circle = IconData(0xf5b5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>camera_circle_fill</i> &#x2014; Cupertino icon named "camera_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData camera_circle_fill = IconData(0xf5b6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>camera_fill</i> &#x2014; Cupertino icon named "camera_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [photo_camera_solid] which is available in cupertino_icons 0.1.3.
  static const IconData camera_fill = IconData(0xf3f6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>camera_on_rectangle</i> &#x2014; Cupertino icon named "camera_on_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData camera_on_rectangle = IconData(0xf5b7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>camera_on_rectangle_fill</i> &#x2014; Cupertino icon named "camera_on_rectangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData camera_on_rectangle_fill = IconData(0xf5b8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>camera_rotate</i> &#x2014; Cupertino icon named "camera_rotate". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [switch_camera] which is available in cupertino_icons 0.1.3.
  static const IconData camera_rotate = IconData(0xf49e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>camera_rotate_fill</i> &#x2014; Cupertino icon named "camera_rotate_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [switch_camera_solid] which is available in cupertino_icons 0.1.3.
  static const IconData camera_rotate_fill = IconData(0xf49f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>camera_viewfinder</i> &#x2014; Cupertino icon named "camera_viewfinder". Available on cupertino_icons package 1.0.0+ only.
  static const IconData camera_viewfinder = IconData(0xf5b9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>capslock</i> &#x2014; Cupertino icon named "capslock". Available on cupertino_icons package 1.0.0+ only.
  static const IconData capslock = IconData(0xf5ba, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>capslock_fill</i> &#x2014; Cupertino icon named "capslock_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData capslock_fill = IconData(0xf5bb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>capsule</i> &#x2014; Cupertino icon named "capsule". Available on cupertino_icons package 1.0.0+ only.
  static const IconData capsule = IconData(0xf5bc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>capsule_fill</i> &#x2014; Cupertino icon named "capsule_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData capsule_fill = IconData(0xf5bd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>captions_bubble</i> &#x2014; Cupertino icon named "captions_bubble". Available on cupertino_icons package 1.0.0+ only.
  static const IconData captions_bubble = IconData(0xf5be, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>captions_bubble_fill</i> &#x2014; Cupertino icon named "captions_bubble_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData captions_bubble_fill = IconData(0xf5bf, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>car_fill</i> &#x2014; Cupertino icon named "car_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [car] which is available in cupertino_icons 0.1.3.
  static const IconData car_fill = IconData(0xf36f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cart</i> &#x2014; Cupertino icon named "cart". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [shopping_cart] which is available in cupertino_icons 0.1.3.
  static const IconData cart = IconData(0xf3f7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cart_badge_minus</i> &#x2014; Cupertino icon named "cart_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cart_badge_minus = IconData(0xf5c0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cart_badge_plus</i> &#x2014; Cupertino icon named "cart_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cart_badge_plus = IconData(0xf5c1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cart_fill</i> &#x2014; Cupertino icon named "cart_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cart_fill = IconData(0xf5c2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cart_fill_badge_minus</i> &#x2014; Cupertino icon named "cart_fill_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cart_fill_badge_minus = IconData(0xf5c3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cart_fill_badge_plus</i> &#x2014; Cupertino icon named "cart_fill_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cart_fill_badge_plus = IconData(0xf5c4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chart_bar</i> &#x2014; Cupertino icon named "chart_bar". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chart_bar = IconData(0xf5c5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chart_bar_alt_fill</i> &#x2014; Cupertino icon named "chart_bar_alt_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chart_bar_alt_fill = IconData(0xf8b7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chart_bar_circle</i> &#x2014; Cupertino icon named "chart_bar_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chart_bar_circle = IconData(0xf8b8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chart_bar_circle_fill</i> &#x2014; Cupertino icon named "chart_bar_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chart_bar_circle_fill = IconData(0xf8b9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chart_bar_fill</i> &#x2014; Cupertino icon named "chart_bar_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chart_bar_fill = IconData(0xf5c6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chart_bar_square</i> &#x2014; Cupertino icon named "chart_bar_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chart_bar_square = IconData(0xf8ba, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chart_bar_square_fill</i> &#x2014; Cupertino icon named "chart_bar_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chart_bar_square_fill = IconData(0xf8bb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chart_pie</i> &#x2014; Cupertino icon named "chart_pie". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chart_pie = IconData(0xf5c7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chart_pie_fill</i> &#x2014; Cupertino icon named "chart_pie_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chart_pie_fill = IconData(0xf5c8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chat_bubble</i> &#x2014; Cupertino icon named "chat_bubble". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [conversation_bubble] which is available in cupertino_icons 0.1.3.
  static const IconData chat_bubble = IconData(0xf3fb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chat_bubble_2</i> &#x2014; Cupertino icon named "chat_bubble_2". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chat_bubble_2 = IconData(0xf8bc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chat_bubble_2_fill</i> &#x2014; Cupertino icon named "chat_bubble_2_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chat_bubble_2_fill = IconData(0xf8bd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chat_bubble_fill</i> &#x2014; Cupertino icon named "chat_bubble_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chat_bubble_fill = IconData(0xf8be, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chat_bubble_text</i> &#x2014; Cupertino icon named "chat_bubble_text". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chat_bubble_text = IconData(0xf8bf, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chat_bubble_text_fill</i> &#x2014; Cupertino icon named "chat_bubble_text_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chat_bubble_text_fill = IconData(0xf8c0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>checkmark</i> &#x2014; Cupertino icon named "checkmark". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [check_mark] which is available in cupertino_icons 0.1.3.
  static const IconData checkmark = IconData(0xf3fd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>checkmark_alt</i> &#x2014; Cupertino icon named "checkmark_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData checkmark_alt = IconData(0xf8c1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>checkmark_alt_circle</i> &#x2014; Cupertino icon named "checkmark_alt_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData checkmark_alt_circle = IconData(0xf8c2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>checkmark_alt_circle_fill</i> &#x2014; Cupertino icon named "checkmark_alt_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData checkmark_alt_circle_fill = IconData(0xf8c3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>checkmark_circle</i> &#x2014; Cupertino icon named "checkmark_circle". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [check_mark_circled] which is available in cupertino_icons 0.1.3.
  static const IconData checkmark_circle = IconData(0xf3fe, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>checkmark_circle_fill</i> &#x2014; Cupertino icon named "checkmark_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [check_mark_circled_solid] which is available in cupertino_icons 0.1.3.
  static const IconData checkmark_circle_fill = IconData(0xf3ff, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>checkmark_rectangle</i> &#x2014; Cupertino icon named "checkmark_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData checkmark_rectangle = IconData(0xf5c9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>checkmark_rectangle_fill</i> &#x2014; Cupertino icon named "checkmark_rectangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData checkmark_rectangle_fill = IconData(0xf5ca, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>checkmark_seal</i> &#x2014; Cupertino icon named "checkmark_seal". Available on cupertino_icons package 1.0.0+ only.
  static const IconData checkmark_seal = IconData(0xf5cb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>checkmark_seal_fill</i> &#x2014; Cupertino icon named "checkmark_seal_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData checkmark_seal_fill = IconData(0xf5cc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>checkmark_shield</i> &#x2014; Cupertino icon named "checkmark_shield". Available on cupertino_icons package 1.0.0+ only.
  static const IconData checkmark_shield = IconData(0xf5cd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>checkmark_shield_fill</i> &#x2014; Cupertino icon named "checkmark_shield_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData checkmark_shield_fill = IconData(0xf5ce, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>checkmark_square</i> &#x2014; Cupertino icon named "checkmark_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData checkmark_square = IconData(0xf5cf, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>checkmark_square_fill</i> &#x2014; Cupertino icon named "checkmark_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData checkmark_square_fill = IconData(0xf5d0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_back</i> &#x2014; Cupertino icon named "chevron_back". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [back] which is available in cupertino_icons 0.1.3.
  static const IconData chevron_back = IconData(0xf3cf, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_compact_down</i> &#x2014; Cupertino icon named "chevron_compact_down". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_compact_down = IconData(0xf5d1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_compact_left</i> &#x2014; Cupertino icon named "chevron_compact_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_compact_left = IconData(0xf5d2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_compact_right</i> &#x2014; Cupertino icon named "chevron_compact_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_compact_right = IconData(0xf5d3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_compact_up</i> &#x2014; Cupertino icon named "chevron_compact_up". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_compact_up = IconData(0xf5d4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_down</i> &#x2014; Cupertino icon named "chevron_down". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_down = IconData(0xf5d5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_down_circle</i> &#x2014; Cupertino icon named "chevron_down_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_down_circle = IconData(0xf5d6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_down_circle_fill</i> &#x2014; Cupertino icon named "chevron_down_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_down_circle_fill = IconData(0xf5d7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_down_square</i> &#x2014; Cupertino icon named "chevron_down_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_down_square = IconData(0xf5d8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_down_square_fill</i> &#x2014; Cupertino icon named "chevron_down_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_down_square_fill = IconData(0xf5d9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_forward</i> &#x2014; Cupertino icon named "chevron_forward". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [forward] which is available in cupertino_icons 0.1.3.
  static const IconData chevron_forward = IconData(0xf3d1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_left</i> &#x2014; Cupertino icon named "chevron_left". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [left_chevron] which is available in cupertino_icons 0.1.3.
  static const IconData chevron_left = IconData(0xf3d2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_left_2</i> &#x2014; Cupertino icon named "chevron_left_2". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_left_2 = IconData(0xf5da, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_left_circle</i> &#x2014; Cupertino icon named "chevron_left_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_left_circle = IconData(0xf5db, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_left_circle_fill</i> &#x2014; Cupertino icon named "chevron_left_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_left_circle_fill = IconData(0xf5dc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_left_slash_chevron_right</i> &#x2014; Cupertino icon named "chevron_left_slash_chevron_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_left_slash_chevron_right = IconData(0xf5dd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_left_square</i> &#x2014; Cupertino icon named "chevron_left_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_left_square = IconData(0xf5de, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_left_square_fill</i> &#x2014; Cupertino icon named "chevron_left_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_left_square_fill = IconData(0xf5df, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_right</i> &#x2014; Cupertino icon named "chevron_right". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [right_chevron] which is available in cupertino_icons 0.1.3.
  static const IconData chevron_right = IconData(0xf3d3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_right_2</i> &#x2014; Cupertino icon named "chevron_right_2". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_right_2 = IconData(0xf5e0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_right_circle</i> &#x2014; Cupertino icon named "chevron_right_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_right_circle = IconData(0xf5e1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_right_circle_fill</i> &#x2014; Cupertino icon named "chevron_right_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_right_circle_fill = IconData(0xf5e2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_right_square</i> &#x2014; Cupertino icon named "chevron_right_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_right_square = IconData(0xf5e3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_right_square_fill</i> &#x2014; Cupertino icon named "chevron_right_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_right_square_fill = IconData(0xf5e4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_up</i> &#x2014; Cupertino icon named "chevron_up". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_up = IconData(0xf5e5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_up_chevron_down</i> &#x2014; Cupertino icon named "chevron_up_chevron_down". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_up_chevron_down = IconData(0xf5e6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_up_circle</i> &#x2014; Cupertino icon named "chevron_up_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_up_circle = IconData(0xf5e7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_up_circle_fill</i> &#x2014; Cupertino icon named "chevron_up_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_up_circle_fill = IconData(0xf5e8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_up_square</i> &#x2014; Cupertino icon named "chevron_up_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_up_square = IconData(0xf5e9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>chevron_up_square_fill</i> &#x2014; Cupertino icon named "chevron_up_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData chevron_up_square_fill = IconData(0xf5ea, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>circle_bottomthird_split</i> &#x2014; Cupertino icon named "circle_bottomthird_split". Available on cupertino_icons package 1.0.0+ only.
  static const IconData circle_bottomthird_split = IconData(0xf5eb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>circle_fill</i> &#x2014; Cupertino icon named "circle_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [circle_filled] which is available in cupertino_icons 0.1.3.
  static const IconData circle_fill = IconData(0xf400, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>circle_grid_3x3</i> &#x2014; Cupertino icon named "circle_grid_3x3". Available on cupertino_icons package 1.0.0+ only.
  static const IconData circle_grid_3x3 = IconData(0xf5ec, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>circle_grid_3x3_fill</i> &#x2014; Cupertino icon named "circle_grid_3x3_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData circle_grid_3x3_fill = IconData(0xf5ed, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>circle_grid_hex</i> &#x2014; Cupertino icon named "circle_grid_hex". Available on cupertino_icons package 1.0.0+ only.
  static const IconData circle_grid_hex = IconData(0xf5ee, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>circle_grid_hex_fill</i> &#x2014; Cupertino icon named "circle_grid_hex_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData circle_grid_hex_fill = IconData(0xf5ef, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>circle_lefthalf_fill</i> &#x2014; Cupertino icon named "circle_lefthalf_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData circle_lefthalf_fill = IconData(0xf5f0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>circle_righthalf_fill</i> &#x2014; Cupertino icon named "circle_righthalf_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData circle_righthalf_fill = IconData(0xf5f1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>clear_fill</i> &#x2014; Cupertino icon named "clear_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData clear_fill = IconData(0xf5f3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>clock_fill</i> &#x2014; Cupertino icon named "clock_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [clock_solid] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [time_solid] which is available in cupertino_icons 0.1.3.
  static const IconData clock_fill = IconData(0xf403, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud</i> &#x2014; Cupertino icon named "cloud". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud = IconData(0xf5f4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_bolt</i> &#x2014; Cupertino icon named "cloud_bolt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_bolt = IconData(0xf5f5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_bolt_fill</i> &#x2014; Cupertino icon named "cloud_bolt_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_bolt_fill = IconData(0xf5f6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_bolt_rain</i> &#x2014; Cupertino icon named "cloud_bolt_rain". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_bolt_rain = IconData(0xf5f7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_bolt_rain_fill</i> &#x2014; Cupertino icon named "cloud_bolt_rain_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_bolt_rain_fill = IconData(0xf5f8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_download</i> &#x2014; Cupertino icon named "cloud_download". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_download = IconData(0xf8c4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_download_fill</i> &#x2014; Cupertino icon named "cloud_download_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_download_fill = IconData(0xf8c5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_drizzle</i> &#x2014; Cupertino icon named "cloud_drizzle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_drizzle = IconData(0xf5f9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_drizzle_fill</i> &#x2014; Cupertino icon named "cloud_drizzle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_drizzle_fill = IconData(0xf5fa, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_fill</i> &#x2014; Cupertino icon named "cloud_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_fill = IconData(0xf5fb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_fog</i> &#x2014; Cupertino icon named "cloud_fog". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_fog = IconData(0xf5fc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_fog_fill</i> &#x2014; Cupertino icon named "cloud_fog_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_fog_fill = IconData(0xf5fd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_hail</i> &#x2014; Cupertino icon named "cloud_hail". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_hail = IconData(0xf5fe, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_hail_fill</i> &#x2014; Cupertino icon named "cloud_hail_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_hail_fill = IconData(0xf5ff, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_heavyrain</i> &#x2014; Cupertino icon named "cloud_heavyrain". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_heavyrain = IconData(0xf600, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_heavyrain_fill</i> &#x2014; Cupertino icon named "cloud_heavyrain_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_heavyrain_fill = IconData(0xf601, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_moon</i> &#x2014; Cupertino icon named "cloud_moon". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_moon = IconData(0xf602, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_moon_bolt</i> &#x2014; Cupertino icon named "cloud_moon_bolt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_moon_bolt = IconData(0xf603, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_moon_bolt_fill</i> &#x2014; Cupertino icon named "cloud_moon_bolt_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_moon_bolt_fill = IconData(0xf604, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_moon_fill</i> &#x2014; Cupertino icon named "cloud_moon_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_moon_fill = IconData(0xf605, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_moon_rain</i> &#x2014; Cupertino icon named "cloud_moon_rain". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_moon_rain = IconData(0xf606, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_moon_rain_fill</i> &#x2014; Cupertino icon named "cloud_moon_rain_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_moon_rain_fill = IconData(0xf607, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_rain</i> &#x2014; Cupertino icon named "cloud_rain". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_rain = IconData(0xf608, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_rain_fill</i> &#x2014; Cupertino icon named "cloud_rain_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_rain_fill = IconData(0xf609, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_sleet</i> &#x2014; Cupertino icon named "cloud_sleet". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_sleet = IconData(0xf60a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_sleet_fill</i> &#x2014; Cupertino icon named "cloud_sleet_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_sleet_fill = IconData(0xf60b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_snow</i> &#x2014; Cupertino icon named "cloud_snow". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_snow = IconData(0xf60c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_snow_fill</i> &#x2014; Cupertino icon named "cloud_snow_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_snow_fill = IconData(0xf60d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_sun</i> &#x2014; Cupertino icon named "cloud_sun". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_sun = IconData(0xf60e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_sun_bolt</i> &#x2014; Cupertino icon named "cloud_sun_bolt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_sun_bolt = IconData(0xf60f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_sun_bolt_fill</i> &#x2014; Cupertino icon named "cloud_sun_bolt_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_sun_bolt_fill = IconData(0xf610, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_sun_fill</i> &#x2014; Cupertino icon named "cloud_sun_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_sun_fill = IconData(0xf611, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_sun_rain</i> &#x2014; Cupertino icon named "cloud_sun_rain". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_sun_rain = IconData(0xf612, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_sun_rain_fill</i> &#x2014; Cupertino icon named "cloud_sun_rain_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_sun_rain_fill = IconData(0xf613, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_upload</i> &#x2014; Cupertino icon named "cloud_upload". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_upload = IconData(0xf8c6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cloud_upload_fill</i> &#x2014; Cupertino icon named "cloud_upload_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cloud_upload_fill = IconData(0xf8c7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>color_filter</i> &#x2014; Cupertino icon named "color_filter". Available on cupertino_icons package 1.0.0+ only.
  static const IconData color_filter = IconData(0xf8c8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>color_filter_fill</i> &#x2014; Cupertino icon named "color_filter_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData color_filter_fill = IconData(0xf8c9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>command</i> &#x2014; Cupertino icon named "command". Available on cupertino_icons package 1.0.0+ only.
  static const IconData command = IconData(0xf614, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>compass</i> &#x2014; Cupertino icon named "compass". Available on cupertino_icons package 1.0.0+ only.
  static const IconData compass = IconData(0xf8ca, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>compass_fill</i> &#x2014; Cupertino icon named "compass_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData compass_fill = IconData(0xf8cb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>control</i> &#x2014; Cupertino icon named "control". Available on cupertino_icons package 1.0.0+ only.
  static const IconData control = IconData(0xf615, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>creditcard</i> &#x2014; Cupertino icon named "creditcard". Available on cupertino_icons package 1.0.0+ only.
  static const IconData creditcard = IconData(0xf616, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>creditcard_fill</i> &#x2014; Cupertino icon named "creditcard_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData creditcard_fill = IconData(0xf617, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>crop</i> &#x2014; Cupertino icon named "crop". Available on cupertino_icons package 1.0.0+ only.
  static const IconData crop = IconData(0xf618, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>crop_rotate</i> &#x2014; Cupertino icon named "crop_rotate". Available on cupertino_icons package 1.0.0+ only.
  static const IconData crop_rotate = IconData(0xf619, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cube</i> &#x2014; Cupertino icon named "cube". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cube = IconData(0xf61a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cube_box</i> &#x2014; Cupertino icon named "cube_box". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cube_box = IconData(0xf61b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cube_box_fill</i> &#x2014; Cupertino icon named "cube_box_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cube_box_fill = IconData(0xf61c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cube_fill</i> &#x2014; Cupertino icon named "cube_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cube_fill = IconData(0xf61d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>cursor_rays</i> &#x2014; Cupertino icon named "cursor_rays". Available on cupertino_icons package 1.0.0+ only.
  static const IconData cursor_rays = IconData(0xf61e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>decrease_indent</i> &#x2014; Cupertino icon named "decrease_indent". Available on cupertino_icons package 1.0.0+ only.
  static const IconData decrease_indent = IconData(0xf61f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>decrease_quotelevel</i> &#x2014; Cupertino icon named "decrease_quotelevel". Available on cupertino_icons package 1.0.0+ only.
  static const IconData decrease_quotelevel = IconData(0xf620, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>delete_left</i> &#x2014; Cupertino icon named "delete_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData delete_left = IconData(0xf621, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>delete_left_fill</i> &#x2014; Cupertino icon named "delete_left_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData delete_left_fill = IconData(0xf622, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>delete_right</i> &#x2014; Cupertino icon named "delete_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData delete_right = IconData(0xf623, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>delete_right_fill</i> &#x2014; Cupertino icon named "delete_right_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData delete_right_fill = IconData(0xf624, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>desktopcomputer</i> &#x2014; Cupertino icon named "desktopcomputer". Available on cupertino_icons package 1.0.0+ only.
  static const IconData desktopcomputer = IconData(0xf625, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>device_desktop</i> &#x2014; Cupertino icon named "device_desktop". Available on cupertino_icons package 1.0.0+ only.
  static const IconData device_desktop = IconData(0xf8cc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>device_laptop</i> &#x2014; Cupertino icon named "device_laptop". Available on cupertino_icons package 1.0.0+ only.
  static const IconData device_laptop = IconData(0xf8cd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>device_phone_landscape</i> &#x2014; Cupertino icon named "device_phone_landscape". Available on cupertino_icons package 1.0.0+ only.
  static const IconData device_phone_landscape = IconData(0xf8ce, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>device_phone_portrait</i> &#x2014; Cupertino icon named "device_phone_portrait". Available on cupertino_icons package 1.0.0+ only.
  static const IconData device_phone_portrait = IconData(0xf8cf, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>dial</i> &#x2014; Cupertino icon named "dial". Available on cupertino_icons package 1.0.0+ only.
  static const IconData dial = IconData(0xf626, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>dial_fill</i> &#x2014; Cupertino icon named "dial_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData dial_fill = IconData(0xf627, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>divide</i> &#x2014; Cupertino icon named "divide". Available on cupertino_icons package 1.0.0+ only.
  static const IconData divide = IconData(0xf628, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>divide_circle</i> &#x2014; Cupertino icon named "divide_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData divide_circle = IconData(0xf629, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>divide_circle_fill</i> &#x2014; Cupertino icon named "divide_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData divide_circle_fill = IconData(0xf62a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>divide_square</i> &#x2014; Cupertino icon named "divide_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData divide_square = IconData(0xf62b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>divide_square_fill</i> &#x2014; Cupertino icon named "divide_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData divide_square_fill = IconData(0xf62c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc</i> &#x2014; Cupertino icon named "doc". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc = IconData(0xf62d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_append</i> &#x2014; Cupertino icon named "doc_append". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_append = IconData(0xf62e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_chart</i> &#x2014; Cupertino icon named "doc_chart". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_chart = IconData(0xf8d0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_chart_fill</i> &#x2014; Cupertino icon named "doc_chart_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_chart_fill = IconData(0xf8d1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_checkmark</i> &#x2014; Cupertino icon named "doc_checkmark". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_checkmark = IconData(0xf8d2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_checkmark_fill</i> &#x2014; Cupertino icon named "doc_checkmark_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_checkmark_fill = IconData(0xf8d3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_circle</i> &#x2014; Cupertino icon named "doc_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_circle = IconData(0xf62f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_circle_fill</i> &#x2014; Cupertino icon named "doc_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_circle_fill = IconData(0xf630, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_fill</i> &#x2014; Cupertino icon named "doc_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_fill = IconData(0xf631, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_on_clipboard</i> &#x2014; Cupertino icon named "doc_on_clipboard". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_on_clipboard = IconData(0xf632, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_on_clipboard_fill</i> &#x2014; Cupertino icon named "doc_on_clipboard_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_on_clipboard_fill = IconData(0xf633, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_on_doc</i> &#x2014; Cupertino icon named "doc_on_doc". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_on_doc = IconData(0xf634, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_on_doc_fill</i> &#x2014; Cupertino icon named "doc_on_doc_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_on_doc_fill = IconData(0xf635, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_person</i> &#x2014; Cupertino icon named "doc_person". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_person = IconData(0xf8d4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_person_fill</i> &#x2014; Cupertino icon named "doc_person_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_person_fill = IconData(0xf8d5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_plaintext</i> &#x2014; Cupertino icon named "doc_plaintext". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_plaintext = IconData(0xf636, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_richtext</i> &#x2014; Cupertino icon named "doc_richtext". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_richtext = IconData(0xf637, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_text</i> &#x2014; Cupertino icon named "doc_text". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_text = IconData(0xf638, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_text_fill</i> &#x2014; Cupertino icon named "doc_text_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_text_fill = IconData(0xf639, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_text_search</i> &#x2014; Cupertino icon named "doc_text_search". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_text_search = IconData(0xf63a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>doc_text_viewfinder</i> &#x2014; Cupertino icon named "doc_text_viewfinder". Available on cupertino_icons package 1.0.0+ only.
  static const IconData doc_text_viewfinder = IconData(0xf63b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>dot_radiowaves_left_right</i> &#x2014; Cupertino icon named "dot_radiowaves_left_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData dot_radiowaves_left_right = IconData(0xf63c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>dot_radiowaves_right</i> &#x2014; Cupertino icon named "dot_radiowaves_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData dot_radiowaves_right = IconData(0xf63d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>dot_square</i> &#x2014; Cupertino icon named "dot_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData dot_square = IconData(0xf63e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>dot_square_fill</i> &#x2014; Cupertino icon named "dot_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData dot_square_fill = IconData(0xf63f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>download_circle</i> &#x2014; Cupertino icon named "download_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData download_circle = IconData(0xf8d6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>download_circle_fill</i> &#x2014; Cupertino icon named "download_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData download_circle_fill = IconData(0xf8d7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>drop</i> &#x2014; Cupertino icon named "drop". Available on cupertino_icons package 1.0.0+ only.
  static const IconData drop = IconData(0xf8d8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>drop_fill</i> &#x2014; Cupertino icon named "drop_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData drop_fill = IconData(0xf8d9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>drop_triangle</i> &#x2014; Cupertino icon named "drop_triangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData drop_triangle = IconData(0xf640, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>drop_triangle_fill</i> &#x2014; Cupertino icon named "drop_triangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData drop_triangle_fill = IconData(0xf641, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>ear</i> &#x2014; Cupertino icon named "ear". Available on cupertino_icons package 1.0.0+ only.
  static const IconData ear = IconData(0xf642, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>eject</i> &#x2014; Cupertino icon named "eject". Available on cupertino_icons package 1.0.0+ only.
  static const IconData eject = IconData(0xf643, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>eject_fill</i> &#x2014; Cupertino icon named "eject_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData eject_fill = IconData(0xf644, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>ellipses_bubble</i> &#x2014; Cupertino icon named "ellipses_bubble". Available on cupertino_icons package 1.0.0+ only.
  static const IconData ellipses_bubble = IconData(0xf645, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>ellipses_bubble_fill</i> &#x2014; Cupertino icon named "ellipses_bubble_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData ellipses_bubble_fill = IconData(0xf646, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>ellipsis_circle</i> &#x2014; Cupertino icon named "ellipsis_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData ellipsis_circle = IconData(0xf647, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>ellipsis_circle_fill</i> &#x2014; Cupertino icon named "ellipsis_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData ellipsis_circle_fill = IconData(0xf648, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>ellipsis_vertical</i> &#x2014; Cupertino icon named "ellipsis_vertical". Available on cupertino_icons package 1.0.0+ only.
  static const IconData ellipsis_vertical = IconData(0xf8da, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>ellipsis_vertical_circle</i> &#x2014; Cupertino icon named "ellipsis_vertical_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData ellipsis_vertical_circle = IconData(0xf8db, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>ellipsis_vertical_circle_fill</i> &#x2014; Cupertino icon named "ellipsis_vertical_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData ellipsis_vertical_circle_fill = IconData(0xf8dc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>envelope</i> &#x2014; Cupertino icon named "envelope". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [mail] which is available in cupertino_icons 0.1.3.
  static const IconData envelope = IconData(0xf422, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>envelope_badge</i> &#x2014; Cupertino icon named "envelope_badge". Available on cupertino_icons package 1.0.0+ only.
  static const IconData envelope_badge = IconData(0xf649, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>envelope_badge_fill</i> &#x2014; Cupertino icon named "envelope_badge_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData envelope_badge_fill = IconData(0xf64a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>envelope_circle</i> &#x2014; Cupertino icon named "envelope_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData envelope_circle = IconData(0xf64b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>envelope_circle_fill</i> &#x2014; Cupertino icon named "envelope_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData envelope_circle_fill = IconData(0xf64c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>envelope_fill</i> &#x2014; Cupertino icon named "envelope_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [mail_solid] which is available in cupertino_icons 0.1.3.
  static const IconData envelope_fill = IconData(0xf423, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>envelope_open</i> &#x2014; Cupertino icon named "envelope_open". Available on cupertino_icons package 1.0.0+ only.
  static const IconData envelope_open = IconData(0xf64d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>envelope_open_fill</i> &#x2014; Cupertino icon named "envelope_open_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData envelope_open_fill = IconData(0xf64e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>equal</i> &#x2014; Cupertino icon named "equal". Available on cupertino_icons package 1.0.0+ only.
  static const IconData equal = IconData(0xf64f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>equal_circle</i> &#x2014; Cupertino icon named "equal_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData equal_circle = IconData(0xf650, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>equal_circle_fill</i> &#x2014; Cupertino icon named "equal_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData equal_circle_fill = IconData(0xf651, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>equal_square</i> &#x2014; Cupertino icon named "equal_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData equal_square = IconData(0xf652, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>equal_square_fill</i> &#x2014; Cupertino icon named "equal_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData equal_square_fill = IconData(0xf653, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>escape</i> &#x2014; Cupertino icon named "escape". Available on cupertino_icons package 1.0.0+ only.
  static const IconData escape = IconData(0xf654, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>exclamationmark</i> &#x2014; Cupertino icon named "exclamationmark". Available on cupertino_icons package 1.0.0+ only.
  static const IconData exclamationmark = IconData(0xf655, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>exclamationmark_bubble</i> &#x2014; Cupertino icon named "exclamationmark_bubble". Available on cupertino_icons package 1.0.0+ only.
  static const IconData exclamationmark_bubble = IconData(0xf656, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>exclamationmark_bubble_fill</i> &#x2014; Cupertino icon named "exclamationmark_bubble_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData exclamationmark_bubble_fill = IconData(0xf657, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>exclamationmark_circle</i> &#x2014; Cupertino icon named "exclamationmark_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData exclamationmark_circle = IconData(0xf658, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>exclamationmark_circle_fill</i> &#x2014; Cupertino icon named "exclamationmark_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData exclamationmark_circle_fill = IconData(0xf659, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>exclamationmark_octagon</i> &#x2014; Cupertino icon named "exclamationmark_octagon". Available on cupertino_icons package 1.0.0+ only.
  static const IconData exclamationmark_octagon = IconData(0xf65a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>exclamationmark_octagon_fill</i> &#x2014; Cupertino icon named "exclamationmark_octagon_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData exclamationmark_octagon_fill = IconData(0xf65b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>exclamationmark_shield</i> &#x2014; Cupertino icon named "exclamationmark_shield". Available on cupertino_icons package 1.0.0+ only.
  static const IconData exclamationmark_shield = IconData(0xf65c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>exclamationmark_shield_fill</i> &#x2014; Cupertino icon named "exclamationmark_shield_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData exclamationmark_shield_fill = IconData(0xf65d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>exclamationmark_square</i> &#x2014; Cupertino icon named "exclamationmark_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData exclamationmark_square = IconData(0xf65e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>exclamationmark_square_fill</i> &#x2014; Cupertino icon named "exclamationmark_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData exclamationmark_square_fill = IconData(0xf65f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>exclamationmark_triangle</i> &#x2014; Cupertino icon named "exclamationmark_triangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData exclamationmark_triangle = IconData(0xf660, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>exclamationmark_triangle_fill</i> &#x2014; Cupertino icon named "exclamationmark_triangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData exclamationmark_triangle_fill = IconData(0xf661, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>eye_fill</i> &#x2014; Cupertino icon named "eye_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [eye_solid] which is available in cupertino_icons 0.1.3.
  static const IconData eye_fill = IconData(0xf425, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>eye_slash</i> &#x2014; Cupertino icon named "eye_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData eye_slash = IconData(0xf662, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>eye_slash_fill</i> &#x2014; Cupertino icon named "eye_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData eye_slash_fill = IconData(0xf663, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>eyedropper</i> &#x2014; Cupertino icon named "eyedropper". Available on cupertino_icons package 1.0.0+ only.
  static const IconData eyedropper = IconData(0xf664, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>eyedropper_full</i> &#x2014; Cupertino icon named "eyedropper_full". Available on cupertino_icons package 1.0.0+ only.
  static const IconData eyedropper_full = IconData(0xf665, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>eyedropper_halffull</i> &#x2014; Cupertino icon named "eyedropper_halffull". Available on cupertino_icons package 1.0.0+ only.
  static const IconData eyedropper_halffull = IconData(0xf666, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>eyeglasses</i> &#x2014; Cupertino icon named "eyeglasses". Available on cupertino_icons package 1.0.0+ only.
  static const IconData eyeglasses = IconData(0xf667, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>f_cursive</i> &#x2014; Cupertino icon named "f_cursive". Available on cupertino_icons package 1.0.0+ only.
  static const IconData f_cursive = IconData(0xf668, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>f_cursive_circle</i> &#x2014; Cupertino icon named "f_cursive_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData f_cursive_circle = IconData(0xf669, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>f_cursive_circle_fill</i> &#x2014; Cupertino icon named "f_cursive_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData f_cursive_circle_fill = IconData(0xf66a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>film</i> &#x2014; Cupertino icon named "film". Available on cupertino_icons package 1.0.0+ only.
  static const IconData film = IconData(0xf66b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>film_fill</i> &#x2014; Cupertino icon named "film_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData film_fill = IconData(0xf66c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>flag_circle</i> &#x2014; Cupertino icon named "flag_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData flag_circle = IconData(0xf66d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>flag_circle_fill</i> &#x2014; Cupertino icon named "flag_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData flag_circle_fill = IconData(0xf66e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>flag_fill</i> &#x2014; Cupertino icon named "flag_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData flag_fill = IconData(0xf66f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>flag_slash</i> &#x2014; Cupertino icon named "flag_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData flag_slash = IconData(0xf670, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>flag_slash_fill</i> &#x2014; Cupertino icon named "flag_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData flag_slash_fill = IconData(0xf671, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>flame</i> &#x2014; Cupertino icon named "flame". Available on cupertino_icons package 1.0.0+ only.
  static const IconData flame = IconData(0xf672, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>flame_fill</i> &#x2014; Cupertino icon named "flame_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData flame_fill = IconData(0xf673, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>floppy_disk</i> &#x2014; Cupertino icon named "floppy_disk". Available on cupertino_icons package 1.0.0+ only.
  static const IconData floppy_disk = IconData(0xf8dd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>flowchart</i> &#x2014; Cupertino icon named "flowchart". Available on cupertino_icons package 1.0.0+ only.
  static const IconData flowchart = IconData(0xf674, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>flowchart_fill</i> &#x2014; Cupertino icon named "flowchart_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData flowchart_fill = IconData(0xf675, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>folder_badge_minus</i> &#x2014; Cupertino icon named "folder_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData folder_badge_minus = IconData(0xf676, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>folder_badge_person_crop</i> &#x2014; Cupertino icon named "folder_badge_person_crop". Available on cupertino_icons package 1.0.0+ only.
  static const IconData folder_badge_person_crop = IconData(0xf677, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>folder_badge_plus</i> &#x2014; Cupertino icon named "folder_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData folder_badge_plus = IconData(0xf678, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>folder_circle</i> &#x2014; Cupertino icon named "folder_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData folder_circle = IconData(0xf679, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>folder_circle_fill</i> &#x2014; Cupertino icon named "folder_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData folder_circle_fill = IconData(0xf67a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>folder_fill</i> &#x2014; Cupertino icon named "folder_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [folder_solid] which is available in cupertino_icons 0.1.3.
  static const IconData folder_fill = IconData(0xf435, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>folder_fill_badge_minus</i> &#x2014; Cupertino icon named "folder_fill_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData folder_fill_badge_minus = IconData(0xf67b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>folder_fill_badge_person_crop</i> &#x2014; Cupertino icon named "folder_fill_badge_person_crop". Available on cupertino_icons package 1.0.0+ only.
  static const IconData folder_fill_badge_person_crop = IconData(0xf67c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>folder_fill_badge_plus</i> &#x2014; Cupertino icon named "folder_fill_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData folder_fill_badge_plus = IconData(0xf67d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>forward_end</i> &#x2014; Cupertino icon named "forward_end". Available on cupertino_icons package 1.0.0+ only.
  static const IconData forward_end = IconData(0xf67f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>forward_end_alt</i> &#x2014; Cupertino icon named "forward_end_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData forward_end_alt = IconData(0xf680, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>forward_end_alt_fill</i> &#x2014; Cupertino icon named "forward_end_alt_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData forward_end_alt_fill = IconData(0xf681, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>forward_end_fill</i> &#x2014; Cupertino icon named "forward_end_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData forward_end_fill = IconData(0xf682, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>forward_fill</i> &#x2014; Cupertino icon named "forward_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData forward_fill = IconData(0xf683, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>function</i> &#x2014; Cupertino icon named "function". Available on cupertino_icons package 1.0.0+ only.
  static const IconData function = IconData(0xf684, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>fx</i> &#x2014; Cupertino icon named "fx". Available on cupertino_icons package 1.0.0+ only.
  static const IconData fx = IconData(0xf685, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gamecontroller</i> &#x2014; Cupertino icon named "gamecontroller". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [game_controller] which is available in cupertino_icons 0.1.3.
  static const IconData gamecontroller = IconData(0xf43a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gamecontroller_alt_fill</i> &#x2014; Cupertino icon named "gamecontroller_alt_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gamecontroller_alt_fill = IconData(0xf8de, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gamecontroller_fill</i> &#x2014; Cupertino icon named "gamecontroller_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [game_controller_solid] which is available in cupertino_icons 0.1.3.
  static const IconData gamecontroller_fill = IconData(0xf43b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gauge</i> &#x2014; Cupertino icon named "gauge". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gauge = IconData(0xf686, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gauge_badge_minus</i> &#x2014; Cupertino icon named "gauge_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gauge_badge_minus = IconData(0xf687, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gauge_badge_plus</i> &#x2014; Cupertino icon named "gauge_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gauge_badge_plus = IconData(0xf688, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gear_alt</i> &#x2014; Cupertino icon named "gear_alt". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [gear] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [gear_big] which is available in cupertino_icons 0.1.3.
  static const IconData gear_alt = IconData(0xf43c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gear_alt_fill</i> &#x2014; Cupertino icon named "gear_alt_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [gear_solid] which is available in cupertino_icons 0.1.3.
  static const IconData gear_alt_fill = IconData(0xf43d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gift</i> &#x2014; Cupertino icon named "gift". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gift = IconData(0xf689, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gift_alt</i> &#x2014; Cupertino icon named "gift_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gift_alt = IconData(0xf68a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gift_alt_fill</i> &#x2014; Cupertino icon named "gift_alt_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gift_alt_fill = IconData(0xf68b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gift_fill</i> &#x2014; Cupertino icon named "gift_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gift_fill = IconData(0xf68c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>globe</i> &#x2014; Cupertino icon named "globe". Available on cupertino_icons package 1.0.0+ only.
  static const IconData globe = IconData(0xf68d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gobackward</i> &#x2014; Cupertino icon named "gobackward". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gobackward = IconData(0xf68e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gobackward_10</i> &#x2014; Cupertino icon named "gobackward_10". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gobackward_10 = IconData(0xf68f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gobackward_15</i> &#x2014; Cupertino icon named "gobackward_15". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gobackward_15 = IconData(0xf690, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gobackward_30</i> &#x2014; Cupertino icon named "gobackward_30". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gobackward_30 = IconData(0xf691, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gobackward_45</i> &#x2014; Cupertino icon named "gobackward_45". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gobackward_45 = IconData(0xf692, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gobackward_60</i> &#x2014; Cupertino icon named "gobackward_60". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gobackward_60 = IconData(0xf693, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gobackward_75</i> &#x2014; Cupertino icon named "gobackward_75". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gobackward_75 = IconData(0xf694, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gobackward_90</i> &#x2014; Cupertino icon named "gobackward_90". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gobackward_90 = IconData(0xf695, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>gobackward_minus</i> &#x2014; Cupertino icon named "gobackward_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData gobackward_minus = IconData(0xf696, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>goforward</i> &#x2014; Cupertino icon named "goforward". Available on cupertino_icons package 1.0.0+ only.
  static const IconData goforward = IconData(0xf697, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>goforward_10</i> &#x2014; Cupertino icon named "goforward_10". Available on cupertino_icons package 1.0.0+ only.
  static const IconData goforward_10 = IconData(0xf698, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>goforward_15</i> &#x2014; Cupertino icon named "goforward_15". Available on cupertino_icons package 1.0.0+ only.
  static const IconData goforward_15 = IconData(0xf699, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>goforward_30</i> &#x2014; Cupertino icon named "goforward_30". Available on cupertino_icons package 1.0.0+ only.
  static const IconData goforward_30 = IconData(0xf69a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>goforward_45</i> &#x2014; Cupertino icon named "goforward_45". Available on cupertino_icons package 1.0.0+ only.
  static const IconData goforward_45 = IconData(0xf69b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>goforward_60</i> &#x2014; Cupertino icon named "goforward_60". Available on cupertino_icons package 1.0.0+ only.
  static const IconData goforward_60 = IconData(0xf69c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>goforward_75</i> &#x2014; Cupertino icon named "goforward_75". Available on cupertino_icons package 1.0.0+ only.
  static const IconData goforward_75 = IconData(0xf69d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>goforward_90</i> &#x2014; Cupertino icon named "goforward_90". Available on cupertino_icons package 1.0.0+ only.
  static const IconData goforward_90 = IconData(0xf69e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>goforward_plus</i> &#x2014; Cupertino icon named "goforward_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData goforward_plus = IconData(0xf69f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>graph_circle</i> &#x2014; Cupertino icon named "graph_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData graph_circle = IconData(0xf8df, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>graph_circle_fill</i> &#x2014; Cupertino icon named "graph_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData graph_circle_fill = IconData(0xf8e0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>graph_square</i> &#x2014; Cupertino icon named "graph_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData graph_square = IconData(0xf8e1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>graph_square_fill</i> &#x2014; Cupertino icon named "graph_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData graph_square_fill = IconData(0xf8e2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>greaterthan</i> &#x2014; Cupertino icon named "greaterthan". Available on cupertino_icons package 1.0.0+ only.
  static const IconData greaterthan = IconData(0xf6a0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>greaterthan_circle</i> &#x2014; Cupertino icon named "greaterthan_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData greaterthan_circle = IconData(0xf6a1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>greaterthan_circle_fill</i> &#x2014; Cupertino icon named "greaterthan_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData greaterthan_circle_fill = IconData(0xf6a2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>greaterthan_square</i> &#x2014; Cupertino icon named "greaterthan_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData greaterthan_square = IconData(0xf6a3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>greaterthan_square_fill</i> &#x2014; Cupertino icon named "greaterthan_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData greaterthan_square_fill = IconData(0xf6a4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>grid</i> &#x2014; Cupertino icon named "grid". Available on cupertino_icons package 1.0.0+ only.
  static const IconData grid = IconData(0xf6a5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>grid_circle</i> &#x2014; Cupertino icon named "grid_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData grid_circle = IconData(0xf6a6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>grid_circle_fill</i> &#x2014; Cupertino icon named "grid_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData grid_circle_fill = IconData(0xf6a7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>guitars</i> &#x2014; Cupertino icon named "guitars". Available on cupertino_icons package 1.0.0+ only.
  static const IconData guitars = IconData(0xf6a8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hammer</i> &#x2014; Cupertino icon named "hammer". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hammer = IconData(0xf6a9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hammer_fill</i> &#x2014; Cupertino icon named "hammer_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hammer_fill = IconData(0xf6aa, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hand_draw</i> &#x2014; Cupertino icon named "hand_draw". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hand_draw = IconData(0xf6ab, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hand_draw_fill</i> &#x2014; Cupertino icon named "hand_draw_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hand_draw_fill = IconData(0xf6ac, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hand_point_left</i> &#x2014; Cupertino icon named "hand_point_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hand_point_left = IconData(0xf6ad, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hand_point_left_fill</i> &#x2014; Cupertino icon named "hand_point_left_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hand_point_left_fill = IconData(0xf6ae, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hand_point_right</i> &#x2014; Cupertino icon named "hand_point_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hand_point_right = IconData(0xf6af, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hand_point_right_fill</i> &#x2014; Cupertino icon named "hand_point_right_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hand_point_right_fill = IconData(0xf6b0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hand_raised</i> &#x2014; Cupertino icon named "hand_raised". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hand_raised = IconData(0xf6b1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hand_raised_fill</i> &#x2014; Cupertino icon named "hand_raised_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hand_raised_fill = IconData(0xf6b2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hand_raised_slash</i> &#x2014; Cupertino icon named "hand_raised_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hand_raised_slash = IconData(0xf6b3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hand_raised_slash_fill</i> &#x2014; Cupertino icon named "hand_raised_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hand_raised_slash_fill = IconData(0xf6b4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hand_thumbsdown</i> &#x2014; Cupertino icon named "hand_thumbsdown". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hand_thumbsdown = IconData(0xf6b5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hand_thumbsdown_fill</i> &#x2014; Cupertino icon named "hand_thumbsdown_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hand_thumbsdown_fill = IconData(0xf6b6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hand_thumbsup</i> &#x2014; Cupertino icon named "hand_thumbsup". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hand_thumbsup = IconData(0xf6b7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hand_thumbsup_fill</i> &#x2014; Cupertino icon named "hand_thumbsup_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hand_thumbsup_fill = IconData(0xf6b8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hare</i> &#x2014; Cupertino icon named "hare". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hare = IconData(0xf6b9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hare_fill</i> &#x2014; Cupertino icon named "hare_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hare_fill = IconData(0xf6ba, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>headphones</i> &#x2014; Cupertino icon named "headphones". Available on cupertino_icons package 1.0.0+ only.
  static const IconData headphones = IconData(0xf6bb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>heart_circle</i> &#x2014; Cupertino icon named "heart_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData heart_circle = IconData(0xf6bc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>heart_circle_fill</i> &#x2014; Cupertino icon named "heart_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData heart_circle_fill = IconData(0xf6bd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>heart_fill</i> &#x2014; Cupertino icon named "heart_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [heart_solid] which is available in cupertino_icons 0.1.3.
  static const IconData heart_fill = IconData(0xf443, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>heart_slash</i> &#x2014; Cupertino icon named "heart_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData heart_slash = IconData(0xf6be, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>heart_slash_circle</i> &#x2014; Cupertino icon named "heart_slash_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData heart_slash_circle = IconData(0xf6bf, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>heart_slash_circle_fill</i> &#x2014; Cupertino icon named "heart_slash_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData heart_slash_circle_fill = IconData(0xf6c0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>heart_slash_fill</i> &#x2014; Cupertino icon named "heart_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData heart_slash_fill = IconData(0xf6c1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>helm</i> &#x2014; Cupertino icon named "helm". Available on cupertino_icons package 1.0.0+ only.
  static const IconData helm = IconData(0xf6c2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hexagon</i> &#x2014; Cupertino icon named "hexagon". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hexagon = IconData(0xf6c3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hexagon_fill</i> &#x2014; Cupertino icon named "hexagon_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hexagon_fill = IconData(0xf6c4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hifispeaker</i> &#x2014; Cupertino icon named "hifispeaker". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hifispeaker = IconData(0xf6c5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hifispeaker_fill</i> &#x2014; Cupertino icon named "hifispeaker_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hifispeaker_fill = IconData(0xf6c6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hourglass</i> &#x2014; Cupertino icon named "hourglass". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hourglass = IconData(0xf6c7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hourglass_bottomhalf_fill</i> &#x2014; Cupertino icon named "hourglass_bottomhalf_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hourglass_bottomhalf_fill = IconData(0xf6c8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hourglass_tophalf_fill</i> &#x2014; Cupertino icon named "hourglass_tophalf_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hourglass_tophalf_fill = IconData(0xf6c9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>house</i> &#x2014; Cupertino icon named "house". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [home] which is available in cupertino_icons 0.1.3.
  static const IconData house = IconData(0xf447, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>house_alt</i> &#x2014; Cupertino icon named "house_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData house_alt = IconData(0xf8e3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>house_alt_fill</i> &#x2014; Cupertino icon named "house_alt_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData house_alt_fill = IconData(0xf8e4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>house_fill</i> &#x2014; Cupertino icon named "house_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData house_fill = IconData(0xf6ca, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>hurricane</i> &#x2014; Cupertino icon named "hurricane". Available on cupertino_icons package 1.0.0+ only.
  static const IconData hurricane = IconData(0xf6cb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>increase_indent</i> &#x2014; Cupertino icon named "increase_indent". Available on cupertino_icons package 1.0.0+ only.
  static const IconData increase_indent = IconData(0xf6cc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>increase_quotelevel</i> &#x2014; Cupertino icon named "increase_quotelevel". Available on cupertino_icons package 1.0.0+ only.
  static const IconData increase_quotelevel = IconData(0xf6cd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>infinite</i> &#x2014; Cupertino icon named "infinite". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [loop] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [loop_thick] which is available in cupertino_icons 0.1.3.
  static const IconData infinite = IconData(0xf449, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>info_circle</i> &#x2014; Cupertino icon named "info_circle". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [info] which is available in cupertino_icons 0.1.3.
  static const IconData info_circle = IconData(0xf44c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>info_circle_fill</i> &#x2014; Cupertino icon named "info_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData info_circle_fill = IconData(0xf6cf, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>italic</i> &#x2014; Cupertino icon named "italic". Available on cupertino_icons package 1.0.0+ only.
  static const IconData italic = IconData(0xf6d0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>keyboard</i> &#x2014; Cupertino icon named "keyboard". Available on cupertino_icons package 1.0.0+ only.
  static const IconData keyboard = IconData(0xf6d1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>keyboard_chevron_compact_down</i> &#x2014; Cupertino icon named "keyboard_chevron_compact_down". Available on cupertino_icons package 1.0.0+ only.
  static const IconData keyboard_chevron_compact_down = IconData(0xf6d2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>largecircle_fill_circle</i> &#x2014; Cupertino icon named "largecircle_fill_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData largecircle_fill_circle = IconData(0xf6d3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lasso</i> &#x2014; Cupertino icon named "lasso". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lasso = IconData(0xf6d4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>layers</i> &#x2014; Cupertino icon named "layers". Available on cupertino_icons package 1.0.0+ only.
  static const IconData layers = IconData(0xf8e5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>layers_alt</i> &#x2014; Cupertino icon named "layers_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData layers_alt = IconData(0xf8e6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>layers_alt_fill</i> &#x2014; Cupertino icon named "layers_alt_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData layers_alt_fill = IconData(0xf8e7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>layers_fill</i> &#x2014; Cupertino icon named "layers_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData layers_fill = IconData(0xf8e8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>leaf_arrow_circlepath</i> &#x2014; Cupertino icon named "leaf_arrow_circlepath". Available on cupertino_icons package 1.0.0+ only.
  static const IconData leaf_arrow_circlepath = IconData(0xf6d5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lessthan</i> &#x2014; Cupertino icon named "lessthan". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lessthan = IconData(0xf6d6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lessthan_circle</i> &#x2014; Cupertino icon named "lessthan_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lessthan_circle = IconData(0xf6d7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lessthan_circle_fill</i> &#x2014; Cupertino icon named "lessthan_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lessthan_circle_fill = IconData(0xf6d8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lessthan_square</i> &#x2014; Cupertino icon named "lessthan_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lessthan_square = IconData(0xf6d9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lessthan_square_fill</i> &#x2014; Cupertino icon named "lessthan_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lessthan_square_fill = IconData(0xf6da, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>light_max</i> &#x2014; Cupertino icon named "light_max". Available on cupertino_icons package 1.0.0+ only.
  static const IconData light_max = IconData(0xf6db, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>light_min</i> &#x2014; Cupertino icon named "light_min". Available on cupertino_icons package 1.0.0+ only.
  static const IconData light_min = IconData(0xf6dc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lightbulb</i> &#x2014; Cupertino icon named "lightbulb". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lightbulb = IconData(0xf6dd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lightbulb_fill</i> &#x2014; Cupertino icon named "lightbulb_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lightbulb_fill = IconData(0xf6de, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lightbulb_slash</i> &#x2014; Cupertino icon named "lightbulb_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lightbulb_slash = IconData(0xf6df, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lightbulb_slash_fill</i> &#x2014; Cupertino icon named "lightbulb_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lightbulb_slash_fill = IconData(0xf6e0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>line_horizontal_3</i> &#x2014; Cupertino icon named "line_horizontal_3". Available on cupertino_icons package 1.0.0+ only.
  static const IconData line_horizontal_3 = IconData(0xf6e1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>line_horizontal_3_decrease</i> &#x2014; Cupertino icon named "line_horizontal_3_decrease". Available on cupertino_icons package 1.0.0+ only.
  static const IconData line_horizontal_3_decrease = IconData(0xf6e2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>line_horizontal_3_decrease_circle</i> &#x2014; Cupertino icon named "line_horizontal_3_decrease_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData line_horizontal_3_decrease_circle = IconData(0xf6e3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>line_horizontal_3_decrease_circle_fill</i> &#x2014; Cupertino icon named "line_horizontal_3_decrease_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData line_horizontal_3_decrease_circle_fill = IconData(0xf6e4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>link</i> &#x2014; Cupertino icon named "link". Available on cupertino_icons package 1.0.0+ only.
  static const IconData link = IconData(0xf6e5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>link_circle</i> &#x2014; Cupertino icon named "link_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData link_circle = IconData(0xf6e6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>link_circle_fill</i> &#x2014; Cupertino icon named "link_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData link_circle_fill = IconData(0xf6e7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>list_bullet</i> &#x2014; Cupertino icon named "list_bullet". Available on cupertino_icons package 1.0.0+ only.
  static const IconData list_bullet = IconData(0xf6e8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>list_bullet_below_rectangle</i> &#x2014; Cupertino icon named "list_bullet_below_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData list_bullet_below_rectangle = IconData(0xf6e9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>list_bullet_indent</i> &#x2014; Cupertino icon named "list_bullet_indent". Available on cupertino_icons package 1.0.0+ only.
  static const IconData list_bullet_indent = IconData(0xf6ea, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>list_dash</i> &#x2014; Cupertino icon named "list_dash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData list_dash = IconData(0xf6eb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>list_number</i> &#x2014; Cupertino icon named "list_number". Available on cupertino_icons package 1.0.0+ only.
  static const IconData list_number = IconData(0xf6ec, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>list_number_rtl</i> &#x2014; Cupertino icon named "list_number_rtl". Available on cupertino_icons package 1.0.0+ only.
  static const IconData list_number_rtl = IconData(0xf6ed, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>location_circle</i> &#x2014; Cupertino icon named "location_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData location_circle = IconData(0xf6ef, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>location_circle_fill</i> &#x2014; Cupertino icon named "location_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData location_circle_fill = IconData(0xf6f0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>location_fill</i> &#x2014; Cupertino icon named "location_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData location_fill = IconData(0xf6f1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>location_north</i> &#x2014; Cupertino icon named "location_north". Available on cupertino_icons package 1.0.0+ only.
  static const IconData location_north = IconData(0xf6f2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>location_north_fill</i> &#x2014; Cupertino icon named "location_north_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData location_north_fill = IconData(0xf6f3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>location_north_line</i> &#x2014; Cupertino icon named "location_north_line". Available on cupertino_icons package 1.0.0+ only.
  static const IconData location_north_line = IconData(0xf6f4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>location_north_line_fill</i> &#x2014; Cupertino icon named "location_north_line_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData location_north_line_fill = IconData(0xf6f5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>location_slash</i> &#x2014; Cupertino icon named "location_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData location_slash = IconData(0xf6f6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>location_slash_fill</i> &#x2014; Cupertino icon named "location_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData location_slash_fill = IconData(0xf6f7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lock</i> &#x2014; Cupertino icon named "lock". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [padlock] which is available in cupertino_icons 0.1.3.
  static const IconData lock = IconData(0xf4c8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lock_circle</i> &#x2014; Cupertino icon named "lock_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lock_circle = IconData(0xf6f8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lock_circle_fill</i> &#x2014; Cupertino icon named "lock_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lock_circle_fill = IconData(0xf6f9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lock_fill</i> &#x2014; Cupertino icon named "lock_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [padlock_solid] which is available in cupertino_icons 0.1.3.
  static const IconData lock_fill = IconData(0xf4c9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lock_open</i> &#x2014; Cupertino icon named "lock_open". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lock_open = IconData(0xf6fa, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lock_open_fill</i> &#x2014; Cupertino icon named "lock_open_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lock_open_fill = IconData(0xf6fb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lock_rotation</i> &#x2014; Cupertino icon named "lock_rotation". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lock_rotation = IconData(0xf6fc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lock_rotation_open</i> &#x2014; Cupertino icon named "lock_rotation_open". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lock_rotation_open = IconData(0xf6fd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lock_shield</i> &#x2014; Cupertino icon named "lock_shield". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lock_shield = IconData(0xf6fe, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lock_shield_fill</i> &#x2014; Cupertino icon named "lock_shield_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lock_shield_fill = IconData(0xf6ff, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lock_slash</i> &#x2014; Cupertino icon named "lock_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lock_slash = IconData(0xf700, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>lock_slash_fill</i> &#x2014; Cupertino icon named "lock_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData lock_slash_fill = IconData(0xf701, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>macwindow</i> &#x2014; Cupertino icon named "macwindow". Available on cupertino_icons package 1.0.0+ only.
  static const IconData macwindow = IconData(0xf702, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>map</i> &#x2014; Cupertino icon named "map". Available on cupertino_icons package 1.0.0+ only.
  static const IconData map = IconData(0xf703, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>map_fill</i> &#x2014; Cupertino icon named "map_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData map_fill = IconData(0xf704, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>map_pin</i> &#x2014; Cupertino icon named "map_pin". Available on cupertino_icons package 1.0.0+ only.
  static const IconData map_pin = IconData(0xf705, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>map_pin_ellipse</i> &#x2014; Cupertino icon named "map_pin_ellipse". Available on cupertino_icons package 1.0.0+ only.
  static const IconData map_pin_ellipse = IconData(0xf706, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>map_pin_slash</i> &#x2014; Cupertino icon named "map_pin_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData map_pin_slash = IconData(0xf707, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>memories</i> &#x2014; Cupertino icon named "memories". Available on cupertino_icons package 1.0.0+ only.
  static const IconData memories = IconData(0xf708, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>memories_badge_minus</i> &#x2014; Cupertino icon named "memories_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData memories_badge_minus = IconData(0xf709, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>memories_badge_plus</i> &#x2014; Cupertino icon named "memories_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData memories_badge_plus = IconData(0xf70a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>metronome</i> &#x2014; Cupertino icon named "metronome". Available on cupertino_icons package 1.0.0+ only.
  static const IconData metronome = IconData(0xf70b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>mic_circle</i> &#x2014; Cupertino icon named "mic_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData mic_circle = IconData(0xf70c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>mic_circle_fill</i> &#x2014; Cupertino icon named "mic_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData mic_circle_fill = IconData(0xf70d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>mic_fill</i> &#x2014; Cupertino icon named "mic_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [mic_solid] which is available in cupertino_icons 0.1.3.
  static const IconData mic_fill = IconData(0xf461, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>mic_slash</i> &#x2014; Cupertino icon named "mic_slash". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [mic_off] which is available in cupertino_icons 0.1.3.
  static const IconData mic_slash = IconData(0xf45f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>mic_slash_fill</i> &#x2014; Cupertino icon named "mic_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData mic_slash_fill = IconData(0xf70e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>minus</i> &#x2014; Cupertino icon named "minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData minus = IconData(0xf70f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>minus_circle</i> &#x2014; Cupertino icon named "minus_circle". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [minus_circled] which is available in cupertino_icons 0.1.3.
  static const IconData minus_circle = IconData(0xf463, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>minus_circle_fill</i> &#x2014; Cupertino icon named "minus_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData minus_circle_fill = IconData(0xf710, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>minus_rectangle</i> &#x2014; Cupertino icon named "minus_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData minus_rectangle = IconData(0xf711, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>minus_rectangle_fill</i> &#x2014; Cupertino icon named "minus_rectangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData minus_rectangle_fill = IconData(0xf712, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>minus_slash_plus</i> &#x2014; Cupertino icon named "minus_slash_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData minus_slash_plus = IconData(0xf713, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>minus_square</i> &#x2014; Cupertino icon named "minus_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData minus_square = IconData(0xf714, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>minus_square_fill</i> &#x2014; Cupertino icon named "minus_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData minus_square_fill = IconData(0xf715, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_dollar</i> &#x2014; Cupertino icon named "money_dollar". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_dollar = IconData(0xf8e9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_dollar_circle</i> &#x2014; Cupertino icon named "money_dollar_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_dollar_circle = IconData(0xf8ea, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_dollar_circle_fill</i> &#x2014; Cupertino icon named "money_dollar_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_dollar_circle_fill = IconData(0xf8eb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_euro</i> &#x2014; Cupertino icon named "money_euro". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_euro = IconData(0xf8ec, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_euro_circle</i> &#x2014; Cupertino icon named "money_euro_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_euro_circle = IconData(0xf8ed, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_euro_circle_fill</i> &#x2014; Cupertino icon named "money_euro_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_euro_circle_fill = IconData(0xf8ee, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_pound</i> &#x2014; Cupertino icon named "money_pound". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_pound = IconData(0xf8ef, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_pound_circle</i> &#x2014; Cupertino icon named "money_pound_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_pound_circle = IconData(0xf8f0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_pound_circle_fill</i> &#x2014; Cupertino icon named "money_pound_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_pound_circle_fill = IconData(0xf8f1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_rubl</i> &#x2014; Cupertino icon named "money_rubl". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_rubl = IconData(0xf8f2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_rubl_circle</i> &#x2014; Cupertino icon named "money_rubl_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_rubl_circle = IconData(0xf8f3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_rubl_circle_fill</i> &#x2014; Cupertino icon named "money_rubl_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_rubl_circle_fill = IconData(0xf8f4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_yen</i> &#x2014; Cupertino icon named "money_yen". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_yen = IconData(0xf8f5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_yen_circle</i> &#x2014; Cupertino icon named "money_yen_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_yen_circle = IconData(0xf8f6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>money_yen_circle_fill</i> &#x2014; Cupertino icon named "money_yen_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData money_yen_circle_fill = IconData(0xf8f7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>moon</i> &#x2014; Cupertino icon named "moon". Available on cupertino_icons package 1.0.0+ only.
  static const IconData moon = IconData(0xf716, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>moon_circle</i> &#x2014; Cupertino icon named "moon_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData moon_circle = IconData(0xf717, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>moon_circle_fill</i> &#x2014; Cupertino icon named "moon_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData moon_circle_fill = IconData(0xf718, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>moon_fill</i> &#x2014; Cupertino icon named "moon_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData moon_fill = IconData(0xf719, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>moon_stars</i> &#x2014; Cupertino icon named "moon_stars". Available on cupertino_icons package 1.0.0+ only.
  static const IconData moon_stars = IconData(0xf71a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>moon_stars_fill</i> &#x2014; Cupertino icon named "moon_stars_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData moon_stars_fill = IconData(0xf71b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>moon_zzz</i> &#x2014; Cupertino icon named "moon_zzz". Available on cupertino_icons package 1.0.0+ only.
  static const IconData moon_zzz = IconData(0xf71c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>moon_zzz_fill</i> &#x2014; Cupertino icon named "moon_zzz_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData moon_zzz_fill = IconData(0xf71d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>move</i> &#x2014; Cupertino icon named "move". Available on cupertino_icons package 1.0.0+ only.
  static const IconData move = IconData(0xf8f8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>multiply</i> &#x2014; Cupertino icon named "multiply". Available on cupertino_icons package 1.0.0+ only.
  static const IconData multiply = IconData(0xf71e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>multiply_circle</i> &#x2014; Cupertino icon named "multiply_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData multiply_circle = IconData(0xf71f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>multiply_circle_fill</i> &#x2014; Cupertino icon named "multiply_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData multiply_circle_fill = IconData(0xf720, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>multiply_square</i> &#x2014; Cupertino icon named "multiply_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData multiply_square = IconData(0xf721, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>multiply_square_fill</i> &#x2014; Cupertino icon named "multiply_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData multiply_square_fill = IconData(0xf722, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>music_albums</i> &#x2014; Cupertino icon named "music_albums". Available on cupertino_icons package 1.0.0+ only.
  static const IconData music_albums = IconData(0xf8f9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>music_albums_fill</i> &#x2014; Cupertino icon named "music_albums_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData music_albums_fill = IconData(0xf8fa, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>music_house</i> &#x2014; Cupertino icon named "music_house". Available on cupertino_icons package 1.0.0+ only.
  static const IconData music_house = IconData(0xf723, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>music_house_fill</i> &#x2014; Cupertino icon named "music_house_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData music_house_fill = IconData(0xf724, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>music_mic</i> &#x2014; Cupertino icon named "music_mic". Available on cupertino_icons package 1.0.0+ only.
  static const IconData music_mic = IconData(0xf725, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>music_note_2</i> &#x2014; Cupertino icon named "music_note_2". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [double_music_note] which is available in cupertino_icons 0.1.3.
  static const IconData music_note_2 = IconData(0xf46c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>music_note_list</i> &#x2014; Cupertino icon named "music_note_list". Available on cupertino_icons package 1.0.0+ only.
  static const IconData music_note_list = IconData(0xf726, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>nosign</i> &#x2014; Cupertino icon named "nosign". Available on cupertino_icons package 1.0.0+ only.
  static const IconData nosign = IconData(0xf727, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>number</i> &#x2014; Cupertino icon named "number". Available on cupertino_icons package 1.0.0+ only.
  static const IconData number = IconData(0xf728, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>number_circle</i> &#x2014; Cupertino icon named "number_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData number_circle = IconData(0xf729, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>number_circle_fill</i> &#x2014; Cupertino icon named "number_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData number_circle_fill = IconData(0xf72a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>number_square</i> &#x2014; Cupertino icon named "number_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData number_square = IconData(0xf72b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>number_square_fill</i> &#x2014; Cupertino icon named "number_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData number_square_fill = IconData(0xf72c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>option</i> &#x2014; Cupertino icon named "option". Available on cupertino_icons package 1.0.0+ only.
  static const IconData option = IconData(0xf72d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>paintbrush</i> &#x2014; Cupertino icon named "paintbrush". Available on cupertino_icons package 1.0.0+ only.
  static const IconData paintbrush = IconData(0xf72e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>paintbrush_fill</i> &#x2014; Cupertino icon named "paintbrush_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData paintbrush_fill = IconData(0xf72f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pano</i> &#x2014; Cupertino icon named "pano". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pano = IconData(0xf730, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pano_fill</i> &#x2014; Cupertino icon named "pano_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pano_fill = IconData(0xf731, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>paperclip</i> &#x2014; Cupertino icon named "paperclip". Available on cupertino_icons package 1.0.0+ only.
  static const IconData paperclip = IconData(0xf732, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>paperplane</i> &#x2014; Cupertino icon named "paperplane". Available on cupertino_icons package 1.0.0+ only.
  static const IconData paperplane = IconData(0xf733, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>paperplane_fill</i> &#x2014; Cupertino icon named "paperplane_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData paperplane_fill = IconData(0xf734, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>paragraph</i> &#x2014; Cupertino icon named "paragraph". Available on cupertino_icons package 1.0.0+ only.
  static const IconData paragraph = IconData(0xf735, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pause_circle</i> &#x2014; Cupertino icon named "pause_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pause_circle = IconData(0xf736, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pause_circle_fill</i> &#x2014; Cupertino icon named "pause_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pause_circle_fill = IconData(0xf737, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pause_fill</i> &#x2014; Cupertino icon named "pause_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [pause_solid] which is available in cupertino_icons 0.1.3.
  static const IconData pause_fill = IconData(0xf478, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pause_rectangle</i> &#x2014; Cupertino icon named "pause_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pause_rectangle = IconData(0xf738, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pause_rectangle_fill</i> &#x2014; Cupertino icon named "pause_rectangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pause_rectangle_fill = IconData(0xf739, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pencil_circle</i> &#x2014; Cupertino icon named "pencil_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pencil_circle = IconData(0xf73a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pencil_circle_fill</i> &#x2014; Cupertino icon named "pencil_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pencil_circle_fill = IconData(0xf73b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pencil_ellipsis_rectangle</i> &#x2014; Cupertino icon named "pencil_ellipsis_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pencil_ellipsis_rectangle = IconData(0xf73c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pencil_outline</i> &#x2014; Cupertino icon named "pencil_outline". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pencil_outline = IconData(0xf73d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pencil_slash</i> &#x2014; Cupertino icon named "pencil_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pencil_slash = IconData(0xf73e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>percent</i> &#x2014; Cupertino icon named "percent". Available on cupertino_icons package 1.0.0+ only.
  static const IconData percent = IconData(0xf73f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_2</i> &#x2014; Cupertino icon named "person_2". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_2 = IconData(0xf740, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_2_alt</i> &#x2014; Cupertino icon named "person_2_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_2_alt = IconData(0xf8fb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_2_fill</i> &#x2014; Cupertino icon named "person_2_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_2_fill = IconData(0xf741, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_2_square_stack</i> &#x2014; Cupertino icon named "person_2_square_stack". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_2_square_stack = IconData(0xf742, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_2_square_stack_fill</i> &#x2014; Cupertino icon named "person_2_square_stack_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_2_square_stack_fill = IconData(0xf743, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_3</i> &#x2014; Cupertino icon named "person_3". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [group] which is available in cupertino_icons 0.1.3.
  static const IconData person_3 = IconData(0xf47b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_3_fill</i> &#x2014; Cupertino icon named "person_3_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [group_solid] which is available in cupertino_icons 0.1.3.
  static const IconData person_3_fill = IconData(0xf47c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_alt</i> &#x2014; Cupertino icon named "person_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_alt = IconData(0xf8fc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_alt_circle</i> &#x2014; Cupertino icon named "person_alt_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_alt_circle = IconData(0xf8fd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_alt_circle_fill</i> &#x2014; Cupertino icon named "person_alt_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_alt_circle_fill = IconData(0xf8fe, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_badge_minus</i> &#x2014; Cupertino icon named "person_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_badge_minus = IconData(0xf744, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_badge_minus_fill</i> &#x2014; Cupertino icon named "person_badge_minus_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_badge_minus_fill = IconData(0xf745, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_badge_plus</i> &#x2014; Cupertino icon named "person_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [person_add] which is available in cupertino_icons 0.1.3.
  static const IconData person_badge_plus = IconData(0xf47f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_badge_plus_fill</i> &#x2014; Cupertino icon named "person_badge_plus_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [person_add_solid] which is available in cupertino_icons 0.1.3.
  static const IconData person_badge_plus_fill = IconData(0xf480, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_circle</i> &#x2014; Cupertino icon named "person_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_circle = IconData(0xf746, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_circle_fill</i> &#x2014; Cupertino icon named "person_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_circle_fill = IconData(0xf747, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_circle</i> &#x2014; Cupertino icon named "person_crop_circle". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [profile_circled] which is available in cupertino_icons 0.1.3.
  static const IconData person_crop_circle = IconData(0xf419, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_circle_badge_checkmark</i> &#x2014; Cupertino icon named "person_crop_circle_badge_checkmark". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_circle_badge_checkmark = IconData(0xf748, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_circle_badge_exclam</i> &#x2014; Cupertino icon named "person_crop_circle_badge_exclam". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_circle_badge_exclam = IconData(0xf749, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_circle_badge_minus</i> &#x2014; Cupertino icon named "person_crop_circle_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_circle_badge_minus = IconData(0xf74a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_circle_badge_plus</i> &#x2014; Cupertino icon named "person_crop_circle_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_circle_badge_plus = IconData(0xf74b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_circle_badge_xmark</i> &#x2014; Cupertino icon named "person_crop_circle_badge_xmark". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_circle_badge_xmark = IconData(0xf74c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_circle_fill</i> &#x2014; Cupertino icon named "person_crop_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_circle_fill = IconData(0xf74d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_circle_fill_badge_checkmark</i> &#x2014; Cupertino icon named "person_crop_circle_fill_badge_checkmark". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_circle_fill_badge_checkmark = IconData(0xf74e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_circle_fill_badge_exclam</i> &#x2014; Cupertino icon named "person_crop_circle_fill_badge_exclam". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_circle_fill_badge_exclam = IconData(0xf74f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_circle_fill_badge_minus</i> &#x2014; Cupertino icon named "person_crop_circle_fill_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_circle_fill_badge_minus = IconData(0xf750, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_circle_fill_badge_plus</i> &#x2014; Cupertino icon named "person_crop_circle_fill_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_circle_fill_badge_plus = IconData(0xf751, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_circle_fill_badge_xmark</i> &#x2014; Cupertino icon named "person_crop_circle_fill_badge_xmark". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_circle_fill_badge_xmark = IconData(0xf752, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_rectangle</i> &#x2014; Cupertino icon named "person_crop_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_rectangle = IconData(0xf753, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_rectangle_fill</i> &#x2014; Cupertino icon named "person_crop_rectangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_rectangle_fill = IconData(0xf754, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_square</i> &#x2014; Cupertino icon named "person_crop_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_square = IconData(0xf755, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_crop_square_fill</i> &#x2014; Cupertino icon named "person_crop_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData person_crop_square_fill = IconData(0xf756, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>person_fill</i> &#x2014; Cupertino icon named "person_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [person_solid] which is available in cupertino_icons 0.1.3.
  static const IconData person_fill = IconData(0xf47e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>personalhotspot</i> &#x2014; Cupertino icon named "personalhotspot". Available on cupertino_icons package 1.0.0+ only.
  static const IconData personalhotspot = IconData(0xf757, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>perspective</i> &#x2014; Cupertino icon named "perspective". Available on cupertino_icons package 1.0.0+ only.
  static const IconData perspective = IconData(0xf758, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_arrow_down_left</i> &#x2014; Cupertino icon named "phone_arrow_down_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData phone_arrow_down_left = IconData(0xf759, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_arrow_right</i> &#x2014; Cupertino icon named "phone_arrow_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData phone_arrow_right = IconData(0xf75a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_arrow_up_right</i> &#x2014; Cupertino icon named "phone_arrow_up_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData phone_arrow_up_right = IconData(0xf75b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_badge_plus</i> &#x2014; Cupertino icon named "phone_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData phone_badge_plus = IconData(0xf75c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_circle</i> &#x2014; Cupertino icon named "phone_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData phone_circle = IconData(0xf75d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_circle_fill</i> &#x2014; Cupertino icon named "phone_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData phone_circle_fill = IconData(0xf75e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_down</i> &#x2014; Cupertino icon named "phone_down". Available on cupertino_icons package 1.0.0+ only.
  static const IconData phone_down = IconData(0xf75f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_down_circle</i> &#x2014; Cupertino icon named "phone_down_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData phone_down_circle = IconData(0xf760, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_down_circle_fill</i> &#x2014; Cupertino icon named "phone_down_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData phone_down_circle_fill = IconData(0xf761, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_down_fill</i> &#x2014; Cupertino icon named "phone_down_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData phone_down_fill = IconData(0xf762, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_fill</i> &#x2014; Cupertino icon named "phone_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [phone_solid] which is available in cupertino_icons 0.1.3.
  static const IconData phone_fill = IconData(0xf4b9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_fill_arrow_down_left</i> &#x2014; Cupertino icon named "phone_fill_arrow_down_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData phone_fill_arrow_down_left = IconData(0xf763, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_fill_arrow_right</i> &#x2014; Cupertino icon named "phone_fill_arrow_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData phone_fill_arrow_right = IconData(0xf764, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_fill_arrow_up_right</i> &#x2014; Cupertino icon named "phone_fill_arrow_up_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData phone_fill_arrow_up_right = IconData(0xf765, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>phone_fill_badge_plus</i> &#x2014; Cupertino icon named "phone_fill_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData phone_fill_badge_plus = IconData(0xf766, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>photo</i> &#x2014; Cupertino icon named "photo". Available on cupertino_icons package 1.0.0+ only.
  static const IconData photo = IconData(0xf767, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>photo_fill</i> &#x2014; Cupertino icon named "photo_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData photo_fill = IconData(0xf768, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>photo_fill_on_rectangle_fill</i> &#x2014; Cupertino icon named "photo_fill_on_rectangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData photo_fill_on_rectangle_fill = IconData(0xf769, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>photo_on_rectangle</i> &#x2014; Cupertino icon named "photo_on_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData photo_on_rectangle = IconData(0xf76a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>piano</i> &#x2014; Cupertino icon named "piano". Available on cupertino_icons package 1.0.0+ only.
  static const IconData piano = IconData(0xf8ff, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pin</i> &#x2014; Cupertino icon named "pin". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pin = IconData(0xf76b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pin_fill</i> &#x2014; Cupertino icon named "pin_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pin_fill = IconData(0xf76c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pin_slash</i> &#x2014; Cupertino icon named "pin_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pin_slash = IconData(0xf76d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>pin_slash_fill</i> &#x2014; Cupertino icon named "pin_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData pin_slash_fill = IconData(0xf76e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>placemark</i> &#x2014; Cupertino icon named "placemark". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [location] which is available in cupertino_icons 0.1.3.
  static const IconData placemark = IconData(0xf455, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>placemark_fill</i> &#x2014; Cupertino icon named "placemark_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [location_solid] which is available in cupertino_icons 0.1.3.
  static const IconData placemark_fill = IconData(0xf456, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>play</i> &#x2014; Cupertino icon named "play". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [play_arrow] which is available in cupertino_icons 0.1.3.
  static const IconData play = IconData(0xf487, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>play_circle</i> &#x2014; Cupertino icon named "play_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData play_circle = IconData(0xf76f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>play_circle_fill</i> &#x2014; Cupertino icon named "play_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData play_circle_fill = IconData(0xf770, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>play_fill</i> &#x2014; Cupertino icon named "play_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [play_arrow_solid] which is available in cupertino_icons 0.1.3.
  static const IconData play_fill = IconData(0xf488, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>play_rectangle</i> &#x2014; Cupertino icon named "play_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData play_rectangle = IconData(0xf771, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>play_rectangle_fill</i> &#x2014; Cupertino icon named "play_rectangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData play_rectangle_fill = IconData(0xf772, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>playpause</i> &#x2014; Cupertino icon named "playpause". Available on cupertino_icons package 1.0.0+ only.
  static const IconData playpause = IconData(0xf773, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>playpause_fill</i> &#x2014; Cupertino icon named "playpause_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData playpause_fill = IconData(0xf774, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus</i> &#x2014; Cupertino icon named "plus". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [add] which is available in cupertino_icons 0.1.3.
  static const IconData plus = IconData(0xf489, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_app</i> &#x2014; Cupertino icon named "plus_app". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plus_app = IconData(0xf775, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_app_fill</i> &#x2014; Cupertino icon named "plus_app_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plus_app_fill = IconData(0xf776, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_bubble</i> &#x2014; Cupertino icon named "plus_bubble". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plus_bubble = IconData(0xf777, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_bubble_fill</i> &#x2014; Cupertino icon named "plus_bubble_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plus_bubble_fill = IconData(0xf778, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_circle</i> &#x2014; Cupertino icon named "plus_circle". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [plus_circled] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [add_circled] which is available in cupertino_icons 0.1.3.
  static const IconData plus_circle = IconData(0xf48a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_circle_fill</i> &#x2014; Cupertino icon named "plus_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [add_circled_solid] which is available in cupertino_icons 0.1.3.
  static const IconData plus_circle_fill = IconData(0xf48b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_rectangle</i> &#x2014; Cupertino icon named "plus_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plus_rectangle = IconData(0xf779, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_rectangle_fill</i> &#x2014; Cupertino icon named "plus_rectangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plus_rectangle_fill = IconData(0xf77a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_rectangle_fill_on_rectangle_fill</i> &#x2014; Cupertino icon named "plus_rectangle_fill_on_rectangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plus_rectangle_fill_on_rectangle_fill = IconData(0xf77b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_rectangle_on_rectangle</i> &#x2014; Cupertino icon named "plus_rectangle_on_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plus_rectangle_on_rectangle = IconData(0xf77c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_slash_minus</i> &#x2014; Cupertino icon named "plus_slash_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plus_slash_minus = IconData(0xf77d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_square</i> &#x2014; Cupertino icon named "plus_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plus_square = IconData(0xf77e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_square_fill</i> &#x2014; Cupertino icon named "plus_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plus_square_fill = IconData(0xf77f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_square_fill_on_square_fill</i> &#x2014; Cupertino icon named "plus_square_fill_on_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plus_square_fill_on_square_fill = IconData(0xf780, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plus_square_on_square</i> &#x2014; Cupertino icon named "plus_square_on_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plus_square_on_square = IconData(0xf781, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plusminus</i> &#x2014; Cupertino icon named "plusminus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plusminus = IconData(0xf782, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plusminus_circle</i> &#x2014; Cupertino icon named "plusminus_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plusminus_circle = IconData(0xf783, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>plusminus_circle_fill</i> &#x2014; Cupertino icon named "plusminus_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData plusminus_circle_fill = IconData(0xf784, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>power</i> &#x2014; Cupertino icon named "power". Available on cupertino_icons package 1.0.0+ only.
  static const IconData power = IconData(0xf785, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>printer</i> &#x2014; Cupertino icon named "printer". Available on cupertino_icons package 1.0.0+ only.
  static const IconData printer = IconData(0xf786, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>printer_fill</i> &#x2014; Cupertino icon named "printer_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData printer_fill = IconData(0xf787, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>projective</i> &#x2014; Cupertino icon named "projective". Available on cupertino_icons package 1.0.0+ only.
  static const IconData projective = IconData(0xf788, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>purchased</i> &#x2014; Cupertino icon named "purchased". Available on cupertino_icons package 1.0.0+ only.
  static const IconData purchased = IconData(0xf789, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>purchased_circle</i> &#x2014; Cupertino icon named "purchased_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData purchased_circle = IconData(0xf78a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>purchased_circle_fill</i> &#x2014; Cupertino icon named "purchased_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData purchased_circle_fill = IconData(0xf78b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>qrcode</i> &#x2014; Cupertino icon named "qrcode". Available on cupertino_icons package 1.0.0+ only.
  static const IconData qrcode = IconData(0xf78c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>qrcode_viewfinder</i> &#x2014; Cupertino icon named "qrcode_viewfinder". Available on cupertino_icons package 1.0.0+ only.
  static const IconData qrcode_viewfinder = IconData(0xf78d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>question</i> &#x2014; Cupertino icon named "question". Available on cupertino_icons package 1.0.0+ only.
  static const IconData question = IconData(0xf78e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>question_circle</i> &#x2014; Cupertino icon named "question_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData question_circle = IconData(0xf78f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>question_circle_fill</i> &#x2014; Cupertino icon named "question_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData question_circle_fill = IconData(0xf790, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>question_diamond</i> &#x2014; Cupertino icon named "question_diamond". Available on cupertino_icons package 1.0.0+ only.
  static const IconData question_diamond = IconData(0xf791, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>question_diamond_fill</i> &#x2014; Cupertino icon named "question_diamond_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData question_diamond_fill = IconData(0xf792, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>question_square</i> &#x2014; Cupertino icon named "question_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData question_square = IconData(0xf793, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>question_square_fill</i> &#x2014; Cupertino icon named "question_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData question_square_fill = IconData(0xf794, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>quote_bubble</i> &#x2014; Cupertino icon named "quote_bubble". Available on cupertino_icons package 1.0.0+ only.
  static const IconData quote_bubble = IconData(0xf795, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>quote_bubble_fill</i> &#x2014; Cupertino icon named "quote_bubble_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData quote_bubble_fill = IconData(0xf796, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>radiowaves_left</i> &#x2014; Cupertino icon named "radiowaves_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData radiowaves_left = IconData(0xf797, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>radiowaves_right</i> &#x2014; Cupertino icon named "radiowaves_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData radiowaves_right = IconData(0xf798, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rays</i> &#x2014; Cupertino icon named "rays". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rays = IconData(0xf799, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>recordingtape</i> &#x2014; Cupertino icon named "recordingtape". Available on cupertino_icons package 1.0.0+ only.
  static const IconData recordingtape = IconData(0xf79a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle</i> &#x2014; Cupertino icon named "rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle = IconData(0xf79b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_3_offgrid</i> &#x2014; Cupertino icon named "rectangle_3_offgrid". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_3_offgrid = IconData(0xf79c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_3_offgrid_fill</i> &#x2014; Cupertino icon named "rectangle_3_offgrid_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_3_offgrid_fill = IconData(0xf79d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_arrow_up_right_arrow_down_left</i> &#x2014; Cupertino icon named "rectangle_arrow_up_right_arrow_down_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_arrow_up_right_arrow_down_left = IconData(0xf79e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_arrow_up_right_arrow_down_left_slash</i> &#x2014; Cupertino icon named "rectangle_arrow_up_right_arrow_down_left_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_arrow_up_right_arrow_down_left_slash = IconData(0xf79f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_badge_checkmark</i> &#x2014; Cupertino icon named "rectangle_badge_checkmark". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_badge_checkmark = IconData(0xf7a0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_badge_xmark</i> &#x2014; Cupertino icon named "rectangle_badge_xmark". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_badge_xmark = IconData(0xf7a1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_compress_vertical</i> &#x2014; Cupertino icon named "rectangle_compress_vertical". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_compress_vertical = IconData(0xf7a2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_dock</i> &#x2014; Cupertino icon named "rectangle_dock". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_dock = IconData(0xf7a3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_expand_vertical</i> &#x2014; Cupertino icon named "rectangle_expand_vertical". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_expand_vertical = IconData(0xf7a4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_fill</i> &#x2014; Cupertino icon named "rectangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_fill = IconData(0xf7a5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_fill_badge_checkmark</i> &#x2014; Cupertino icon named "rectangle_fill_badge_checkmark". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_fill_badge_checkmark = IconData(0xf7a6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_fill_badge_xmark</i> &#x2014; Cupertino icon named "rectangle_fill_badge_xmark". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_fill_badge_xmark = IconData(0xf7a7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_fill_on_rectangle_angled_fill</i> &#x2014; Cupertino icon named "rectangle_fill_on_rectangle_angled_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_fill_on_rectangle_angled_fill = IconData(0xf7a8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_fill_on_rectangle_fill</i> &#x2014; Cupertino icon named "rectangle_fill_on_rectangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_fill_on_rectangle_fill = IconData(0xf7a9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_grid_1x2</i> &#x2014; Cupertino icon named "rectangle_grid_1x2". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_grid_1x2 = IconData(0xf7aa, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_grid_1x2_fill</i> &#x2014; Cupertino icon named "rectangle_grid_1x2_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_grid_1x2_fill = IconData(0xf7ab, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_grid_2x2</i> &#x2014; Cupertino icon named "rectangle_grid_2x2". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_grid_2x2 = IconData(0xf7ac, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_grid_2x2_fill</i> &#x2014; Cupertino icon named "rectangle_grid_2x2_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_grid_2x2_fill = IconData(0xf7ad, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_grid_3x2</i> &#x2014; Cupertino icon named "rectangle_grid_3x2". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_grid_3x2 = IconData(0xf7ae, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_grid_3x2_fill</i> &#x2014; Cupertino icon named "rectangle_grid_3x2_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_grid_3x2_fill = IconData(0xf7af, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_on_rectangle</i> &#x2014; Cupertino icon named "rectangle_on_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_on_rectangle = IconData(0xf7b0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_on_rectangle_angled</i> &#x2014; Cupertino icon named "rectangle_on_rectangle_angled". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_on_rectangle_angled = IconData(0xf7b1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_paperclip</i> &#x2014; Cupertino icon named "rectangle_paperclip". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_paperclip = IconData(0xf7b2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_split_3x1</i> &#x2014; Cupertino icon named "rectangle_split_3x1". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_split_3x1 = IconData(0xf7b3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_split_3x1_fill</i> &#x2014; Cupertino icon named "rectangle_split_3x1_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_split_3x1_fill = IconData(0xf7b4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_split_3x3</i> &#x2014; Cupertino icon named "rectangle_split_3x3". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_split_3x3 = IconData(0xf7b5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_split_3x3_fill</i> &#x2014; Cupertino icon named "rectangle_split_3x3_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_split_3x3_fill = IconData(0xf7b6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_stack</i> &#x2014; Cupertino icon named "rectangle_stack". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [collections] which is available in cupertino_icons 0.1.3.
  static const IconData rectangle_stack = IconData(0xf3c9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_stack_badge_minus</i> &#x2014; Cupertino icon named "rectangle_stack_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_stack_badge_minus = IconData(0xf7b7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_stack_badge_person_crop</i> &#x2014; Cupertino icon named "rectangle_stack_badge_person_crop". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_stack_badge_person_crop = IconData(0xf7b8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_stack_badge_plus</i> &#x2014; Cupertino icon named "rectangle_stack_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_stack_badge_plus = IconData(0xf7b9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_stack_fill</i> &#x2014; Cupertino icon named "rectangle_stack_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [collections_solid] which is available in cupertino_icons 0.1.3.
  static const IconData rectangle_stack_fill = IconData(0xf3ca, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_stack_fill_badge_minus</i> &#x2014; Cupertino icon named "rectangle_stack_fill_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_stack_fill_badge_minus = IconData(0xf7ba, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_stack_fill_badge_person_crop</i> &#x2014; Cupertino icon named "rectangle_stack_fill_badge_person_crop". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_stack_fill_badge_person_crop = IconData(0xf7bb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_stack_fill_badge_plus</i> &#x2014; Cupertino icon named "rectangle_stack_fill_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_stack_fill_badge_plus = IconData(0xf7bc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_stack_person_crop</i> &#x2014; Cupertino icon named "rectangle_stack_person_crop". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_stack_person_crop = IconData(0xf7bd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rectangle_stack_person_crop_fill</i> &#x2014; Cupertino icon named "rectangle_stack_person_crop_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rectangle_stack_person_crop_fill = IconData(0xf7be, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>repeat</i> &#x2014; Cupertino icon named "repeat". Available on cupertino_icons package 1.0.0+ only.
  static const IconData repeat = IconData(0xf7bf, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>repeat_1</i> &#x2014; Cupertino icon named "repeat_1". Available on cupertino_icons package 1.0.0+ only.
  static const IconData repeat_1 = IconData(0xf7c0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>resize</i> &#x2014; Cupertino icon named "resize". Available on cupertino_icons package 1.0.0+ only.
  static const IconData resize = IconData(0xf900, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>resize_h</i> &#x2014; Cupertino icon named "resize_h". Available on cupertino_icons package 1.0.0+ only.
  static const IconData resize_h = IconData(0xf901, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>resize_v</i> &#x2014; Cupertino icon named "resize_v". Available on cupertino_icons package 1.0.0+ only.
  static const IconData resize_v = IconData(0xf902, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>return_icon</i> &#x2014; Cupertino icon named "return_icon". Available on cupertino_icons package 1.0.0+ only.
  static const IconData return_icon = IconData(0xf7c1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rhombus</i> &#x2014; Cupertino icon named "rhombus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rhombus = IconData(0xf7c2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rhombus_fill</i> &#x2014; Cupertino icon named "rhombus_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rhombus_fill = IconData(0xf7c3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rocket</i> &#x2014; Cupertino icon named "rocket". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rocket = IconData(0xf903, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rocket_fill</i> &#x2014; Cupertino icon named "rocket_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rocket_fill = IconData(0xf904, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rosette</i> &#x2014; Cupertino icon named "rosette". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rosette = IconData(0xf7c4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rotate_left</i> &#x2014; Cupertino icon named "rotate_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rotate_left = IconData(0xf7c5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rotate_left_fill</i> &#x2014; Cupertino icon named "rotate_left_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rotate_left_fill = IconData(0xf7c6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rotate_right</i> &#x2014; Cupertino icon named "rotate_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rotate_right = IconData(0xf7c7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>rotate_right_fill</i> &#x2014; Cupertino icon named "rotate_right_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData rotate_right_fill = IconData(0xf7c8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>scissors</i> &#x2014; Cupertino icon named "scissors". Available on cupertino_icons package 1.0.0+ only.
  static const IconData scissors = IconData(0xf7c9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>scissors_alt</i> &#x2014; Cupertino icon named "scissors_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData scissors_alt = IconData(0xf905, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>scope</i> &#x2014; Cupertino icon named "scope". Available on cupertino_icons package 1.0.0+ only.
  static const IconData scope = IconData(0xf7ca, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>scribble</i> &#x2014; Cupertino icon named "scribble". Available on cupertino_icons package 1.0.0+ only.
  static const IconData scribble = IconData(0xf7cb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>search_circle</i> &#x2014; Cupertino icon named "search_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData search_circle = IconData(0xf7cc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>search_circle_fill</i> &#x2014; Cupertino icon named "search_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData search_circle_fill = IconData(0xf7cd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>selection_pin_in_out</i> &#x2014; Cupertino icon named "selection_pin_in_out". Available on cupertino_icons package 1.0.0+ only.
  static const IconData selection_pin_in_out = IconData(0xf7ce, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>shield</i> &#x2014; Cupertino icon named "shield". Available on cupertino_icons package 1.0.0+ only.
  static const IconData shield = IconData(0xf7cf, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>shield_fill</i> &#x2014; Cupertino icon named "shield_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData shield_fill = IconData(0xf7d0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>shield_lefthalf_fill</i> &#x2014; Cupertino icon named "shield_lefthalf_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData shield_lefthalf_fill = IconData(0xf7d1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>shield_slash</i> &#x2014; Cupertino icon named "shield_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData shield_slash = IconData(0xf7d2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>shield_slash_fill</i> &#x2014; Cupertino icon named "shield_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData shield_slash_fill = IconData(0xf7d3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>shift</i> &#x2014; Cupertino icon named "shift". Available on cupertino_icons package 1.0.0+ only.
  static const IconData shift = IconData(0xf7d4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>shift_fill</i> &#x2014; Cupertino icon named "shift_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData shift_fill = IconData(0xf7d5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sidebar_left</i> &#x2014; Cupertino icon named "sidebar_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sidebar_left = IconData(0xf7d6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sidebar_right</i> &#x2014; Cupertino icon named "sidebar_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sidebar_right = IconData(0xf7d7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>signature</i> &#x2014; Cupertino icon named "signature". Available on cupertino_icons package 1.0.0+ only.
  static const IconData signature = IconData(0xf7d8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>skew</i> &#x2014; Cupertino icon named "skew". Available on cupertino_icons package 1.0.0+ only.
  static const IconData skew = IconData(0xf7d9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>slash_circle</i> &#x2014; Cupertino icon named "slash_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData slash_circle = IconData(0xf7da, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>slash_circle_fill</i> &#x2014; Cupertino icon named "slash_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData slash_circle_fill = IconData(0xf7db, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>slider_horizontal_3</i> &#x2014; Cupertino icon named "slider_horizontal_3". Available on cupertino_icons package 1.0.0+ only.
  static const IconData slider_horizontal_3 = IconData(0xf7dc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>slider_horizontal_below_rectangle</i> &#x2014; Cupertino icon named "slider_horizontal_below_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData slider_horizontal_below_rectangle = IconData(0xf7dd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>slowmo</i> &#x2014; Cupertino icon named "slowmo". Available on cupertino_icons package 1.0.0+ only.
  static const IconData slowmo = IconData(0xf7de, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>smallcircle_circle</i> &#x2014; Cupertino icon named "smallcircle_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData smallcircle_circle = IconData(0xf7df, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>smallcircle_circle_fill</i> &#x2014; Cupertino icon named "smallcircle_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData smallcircle_circle_fill = IconData(0xf7e0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>smallcircle_fill_circle</i> &#x2014; Cupertino icon named "smallcircle_fill_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData smallcircle_fill_circle = IconData(0xf7e1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>smallcircle_fill_circle_fill</i> &#x2014; Cupertino icon named "smallcircle_fill_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData smallcircle_fill_circle_fill = IconData(0xf7e2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>smiley</i> &#x2014; Cupertino icon named "smiley". Available on cupertino_icons package 1.0.0+ only.
  static const IconData smiley = IconData(0xf7e3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>smiley_fill</i> &#x2014; Cupertino icon named "smiley_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData smiley_fill = IconData(0xf7e4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>smoke</i> &#x2014; Cupertino icon named "smoke". Available on cupertino_icons package 1.0.0+ only.
  static const IconData smoke = IconData(0xf7e5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>smoke_fill</i> &#x2014; Cupertino icon named "smoke_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData smoke_fill = IconData(0xf7e6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>snow</i> &#x2014; Cupertino icon named "snow". Available on cupertino_icons package 1.0.0+ only.
  static const IconData snow = IconData(0xf7e7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sort_down</i> &#x2014; Cupertino icon named "sort_down". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sort_down = IconData(0xf906, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sort_down_circle</i> &#x2014; Cupertino icon named "sort_down_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sort_down_circle = IconData(0xf907, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sort_down_circle_fill</i> &#x2014; Cupertino icon named "sort_down_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sort_down_circle_fill = IconData(0xf908, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sort_up</i> &#x2014; Cupertino icon named "sort_up". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sort_up = IconData(0xf909, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sort_up_circle</i> &#x2014; Cupertino icon named "sort_up_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sort_up_circle = IconData(0xf90a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sort_up_circle_fill</i> &#x2014; Cupertino icon named "sort_up_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sort_up_circle_fill = IconData(0xf90b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sparkles</i> &#x2014; Cupertino icon named "sparkles". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sparkles = IconData(0xf7e8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker</i> &#x2014; Cupertino icon named "speaker". Available on cupertino_icons package 1.0.0+ only.
  static const IconData speaker = IconData(0xf7e9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_1</i> &#x2014; Cupertino icon named "speaker_1". Available on cupertino_icons package 1.0.0+ only.
  static const IconData speaker_1 = IconData(0xf7ea, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_1_fill</i> &#x2014; Cupertino icon named "speaker_1_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [volume_down] which is available in cupertino_icons 0.1.3.
  static const IconData speaker_1_fill = IconData(0xf3b7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_2</i> &#x2014; Cupertino icon named "speaker_2". Available on cupertino_icons package 1.0.0+ only.
  static const IconData speaker_2 = IconData(0xf7eb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_2_fill</i> &#x2014; Cupertino icon named "speaker_2_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData speaker_2_fill = IconData(0xf7ec, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_3</i> &#x2014; Cupertino icon named "speaker_3". Available on cupertino_icons package 1.0.0+ only.
  static const IconData speaker_3 = IconData(0xf7ed, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_3_fill</i> &#x2014; Cupertino icon named "speaker_3_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [volume_up] which is available in cupertino_icons 0.1.3.
  static const IconData speaker_3_fill = IconData(0xf3ba, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_fill</i> &#x2014; Cupertino icon named "speaker_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [volume_mute] which is available in cupertino_icons 0.1.3.
  static const IconData speaker_fill = IconData(0xf3b8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_slash</i> &#x2014; Cupertino icon named "speaker_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData speaker_slash = IconData(0xf7ee, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_slash_fill</i> &#x2014; Cupertino icon named "speaker_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [volume_off] which is available in cupertino_icons 0.1.3.
  static const IconData speaker_slash_fill = IconData(0xf3b9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_slash_fill_rtl</i> &#x2014; Cupertino icon named "speaker_slash_fill_rtl". Available on cupertino_icons package 1.0.0+ only.
  static const IconData speaker_slash_fill_rtl = IconData(0xf7ef, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_slash_rtl</i> &#x2014; Cupertino icon named "speaker_slash_rtl". Available on cupertino_icons package 1.0.0+ only.
  static const IconData speaker_slash_rtl = IconData(0xf7f0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_zzz</i> &#x2014; Cupertino icon named "speaker_zzz". Available on cupertino_icons package 1.0.0+ only.
  static const IconData speaker_zzz = IconData(0xf7f1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_zzz_fill</i> &#x2014; Cupertino icon named "speaker_zzz_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData speaker_zzz_fill = IconData(0xf7f2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_zzz_fill_rtl</i> &#x2014; Cupertino icon named "speaker_zzz_fill_rtl". Available on cupertino_icons package 1.0.0+ only.
  static const IconData speaker_zzz_fill_rtl = IconData(0xf7f3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speaker_zzz_rtl</i> &#x2014; Cupertino icon named "speaker_zzz_rtl". Available on cupertino_icons package 1.0.0+ only.
  static const IconData speaker_zzz_rtl = IconData(0xf7f4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>speedometer</i> &#x2014; Cupertino icon named "speedometer". Available on cupertino_icons package 1.0.0+ only.
  static const IconData speedometer = IconData(0xf7f5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sportscourt</i> &#x2014; Cupertino icon named "sportscourt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sportscourt = IconData(0xf7f6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sportscourt_fill</i> &#x2014; Cupertino icon named "sportscourt_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sportscourt_fill = IconData(0xf7f7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square</i> &#x2014; Cupertino icon named "square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square = IconData(0xf7f8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_arrow_down</i> &#x2014; Cupertino icon named "square_arrow_down". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_arrow_down = IconData(0xf7f9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_arrow_down_fill</i> &#x2014; Cupertino icon named "square_arrow_down_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_arrow_down_fill = IconData(0xf7fa, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_arrow_down_on_square</i> &#x2014; Cupertino icon named "square_arrow_down_on_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_arrow_down_on_square = IconData(0xf7fb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_arrow_down_on_square_fill</i> &#x2014; Cupertino icon named "square_arrow_down_on_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_arrow_down_on_square_fill = IconData(0xf7fc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_arrow_left</i> &#x2014; Cupertino icon named "square_arrow_left". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_arrow_left = IconData(0xf90c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_arrow_left_fill</i> &#x2014; Cupertino icon named "square_arrow_left_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_arrow_left_fill = IconData(0xf90d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_arrow_right</i> &#x2014; Cupertino icon named "square_arrow_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_arrow_right = IconData(0xf90e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_arrow_right_fill</i> &#x2014; Cupertino icon named "square_arrow_right_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_arrow_right_fill = IconData(0xf90f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_arrow_up</i> &#x2014; Cupertino icon named "square_arrow_up". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [share] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [share_up] which is available in cupertino_icons 0.1.3.
  static const IconData square_arrow_up = IconData(0xf4ca, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_arrow_up_fill</i> &#x2014; Cupertino icon named "square_arrow_up_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [share_solid] which is available in cupertino_icons 0.1.3.
  static const IconData square_arrow_up_fill = IconData(0xf4cb, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_arrow_up_on_square</i> &#x2014; Cupertino icon named "square_arrow_up_on_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_arrow_up_on_square = IconData(0xf7fd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_arrow_up_on_square_fill</i> &#x2014; Cupertino icon named "square_arrow_up_on_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_arrow_up_on_square_fill = IconData(0xf7fe, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_favorites</i> &#x2014; Cupertino icon named "square_favorites". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_favorites = IconData(0xf910, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_favorites_alt</i> &#x2014; Cupertino icon named "square_favorites_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_favorites_alt = IconData(0xf911, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_favorites_alt_fill</i> &#x2014; Cupertino icon named "square_favorites_alt_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_favorites_alt_fill = IconData(0xf912, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_favorites_fill</i> &#x2014; Cupertino icon named "square_favorites_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_favorites_fill = IconData(0xf913, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_fill</i> &#x2014; Cupertino icon named "square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_fill = IconData(0xf7ff, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_fill_line_vertical_square</i> &#x2014; Cupertino icon named "square_fill_line_vertical_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_fill_line_vertical_square = IconData(0xf800, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_fill_line_vertical_square_fill</i> &#x2014; Cupertino icon named "square_fill_line_vertical_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_fill_line_vertical_square_fill = IconData(0xf801, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_fill_on_circle_fill</i> &#x2014; Cupertino icon named "square_fill_on_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_fill_on_circle_fill = IconData(0xf802, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_fill_on_square_fill</i> &#x2014; Cupertino icon named "square_fill_on_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_fill_on_square_fill = IconData(0xf803, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_grid_2x2</i> &#x2014; Cupertino icon named "square_grid_2x2". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_grid_2x2 = IconData(0xf804, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_grid_2x2_fill</i> &#x2014; Cupertino icon named "square_grid_2x2_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_grid_2x2_fill = IconData(0xf805, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_grid_3x2</i> &#x2014; Cupertino icon named "square_grid_3x2". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_grid_3x2 = IconData(0xf806, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_grid_3x2_fill</i> &#x2014; Cupertino icon named "square_grid_3x2_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_grid_3x2_fill = IconData(0xf807, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_grid_4x3_fill</i> &#x2014; Cupertino icon named "square_grid_4x3_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_grid_4x3_fill = IconData(0xf808, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_lefthalf_fill</i> &#x2014; Cupertino icon named "square_lefthalf_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_lefthalf_fill = IconData(0xf809, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_line_vertical_square</i> &#x2014; Cupertino icon named "square_line_vertical_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_line_vertical_square = IconData(0xf80a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_line_vertical_square_fill</i> &#x2014; Cupertino icon named "square_line_vertical_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_line_vertical_square_fill = IconData(0xf80b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_list</i> &#x2014; Cupertino icon named "square_list". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_list = IconData(0xf914, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_list_fill</i> &#x2014; Cupertino icon named "square_list_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_list_fill = IconData(0xf915, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_on_circle</i> &#x2014; Cupertino icon named "square_on_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_on_circle = IconData(0xf80c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_on_square</i> &#x2014; Cupertino icon named "square_on_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_on_square = IconData(0xf80d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_pencil</i> &#x2014; Cupertino icon named "square_pencil". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [create] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [create_solid] which is available in cupertino_icons 0.1.3.
  static const IconData square_pencil = IconData(0xf417, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_pencil_fill</i> &#x2014; Cupertino icon named "square_pencil_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [create] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [create_solid] which is available in cupertino_icons 0.1.3.
  static const IconData square_pencil_fill = IconData(0xf417, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_righthalf_fill</i> &#x2014; Cupertino icon named "square_righthalf_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_righthalf_fill = IconData(0xf80e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_split_1x2</i> &#x2014; Cupertino icon named "square_split_1x2". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_split_1x2 = IconData(0xf80f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_split_1x2_fill</i> &#x2014; Cupertino icon named "square_split_1x2_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_split_1x2_fill = IconData(0xf810, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_split_2x1</i> &#x2014; Cupertino icon named "square_split_2x1". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_split_2x1 = IconData(0xf811, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_split_2x1_fill</i> &#x2014; Cupertino icon named "square_split_2x1_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_split_2x1_fill = IconData(0xf812, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_split_2x2</i> &#x2014; Cupertino icon named "square_split_2x2". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_split_2x2 = IconData(0xf813, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_split_2x2_fill</i> &#x2014; Cupertino icon named "square_split_2x2_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_split_2x2_fill = IconData(0xf814, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_stack</i> &#x2014; Cupertino icon named "square_stack". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_stack = IconData(0xf815, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_stack_3d_down_dottedline</i> &#x2014; Cupertino icon named "square_stack_3d_down_dottedline". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_stack_3d_down_dottedline = IconData(0xf816, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_stack_3d_down_right</i> &#x2014; Cupertino icon named "square_stack_3d_down_right". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_stack_3d_down_right = IconData(0xf817, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_stack_3d_down_right_fill</i> &#x2014; Cupertino icon named "square_stack_3d_down_right_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_stack_3d_down_right_fill = IconData(0xf818, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_stack_3d_up</i> &#x2014; Cupertino icon named "square_stack_3d_up". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_stack_3d_up = IconData(0xf819, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_stack_3d_up_fill</i> &#x2014; Cupertino icon named "square_stack_3d_up_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_stack_3d_up_fill = IconData(0xf81a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_stack_3d_up_slash</i> &#x2014; Cupertino icon named "square_stack_3d_up_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_stack_3d_up_slash = IconData(0xf81b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_stack_3d_up_slash_fill</i> &#x2014; Cupertino icon named "square_stack_3d_up_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_stack_3d_up_slash_fill = IconData(0xf81c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>square_stack_fill</i> &#x2014; Cupertino icon named "square_stack_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData square_stack_fill = IconData(0xf81d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>squares_below_rectangle</i> &#x2014; Cupertino icon named "squares_below_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData squares_below_rectangle = IconData(0xf81e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>star</i> &#x2014; Cupertino icon named "star". Available on cupertino_icons package 1.0.0+ only.
  static const IconData star = IconData(0xf81f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>star_circle</i> &#x2014; Cupertino icon named "star_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData star_circle = IconData(0xf820, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>star_circle_fill</i> &#x2014; Cupertino icon named "star_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData star_circle_fill = IconData(0xf821, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>star_fill</i> &#x2014; Cupertino icon named "star_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData star_fill = IconData(0xf822, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>star_lefthalf_fill</i> &#x2014; Cupertino icon named "star_lefthalf_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData star_lefthalf_fill = IconData(0xf823, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>star_slash</i> &#x2014; Cupertino icon named "star_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData star_slash = IconData(0xf824, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>star_slash_fill</i> &#x2014; Cupertino icon named "star_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData star_slash_fill = IconData(0xf825, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>staroflife</i> &#x2014; Cupertino icon named "staroflife". Available on cupertino_icons package 1.0.0+ only.
  static const IconData staroflife = IconData(0xf826, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>staroflife_fill</i> &#x2014; Cupertino icon named "staroflife_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData staroflife_fill = IconData(0xf827, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>stop</i> &#x2014; Cupertino icon named "stop". Available on cupertino_icons package 1.0.0+ only.
  static const IconData stop = IconData(0xf828, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>stop_circle</i> &#x2014; Cupertino icon named "stop_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData stop_circle = IconData(0xf829, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>stop_circle_fill</i> &#x2014; Cupertino icon named "stop_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData stop_circle_fill = IconData(0xf82a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>stop_fill</i> &#x2014; Cupertino icon named "stop_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData stop_fill = IconData(0xf82b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>stopwatch</i> &#x2014; Cupertino icon named "stopwatch". Available on cupertino_icons package 1.0.0+ only.
  static const IconData stopwatch = IconData(0xf82c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>stopwatch_fill</i> &#x2014; Cupertino icon named "stopwatch_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData stopwatch_fill = IconData(0xf82d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>strikethrough</i> &#x2014; Cupertino icon named "strikethrough". Available on cupertino_icons package 1.0.0+ only.
  static const IconData strikethrough = IconData(0xf82e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>suit_club</i> &#x2014; Cupertino icon named "suit_club". Available on cupertino_icons package 1.0.0+ only.
  static const IconData suit_club = IconData(0xf82f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>suit_club_fill</i> &#x2014; Cupertino icon named "suit_club_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData suit_club_fill = IconData(0xf830, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>suit_diamond</i> &#x2014; Cupertino icon named "suit_diamond". Available on cupertino_icons package 1.0.0+ only.
  static const IconData suit_diamond = IconData(0xf831, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>suit_diamond_fill</i> &#x2014; Cupertino icon named "suit_diamond_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData suit_diamond_fill = IconData(0xf832, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>suit_heart</i> &#x2014; Cupertino icon named "suit_heart". Available on cupertino_icons package 1.0.0+ only.
  static const IconData suit_heart = IconData(0xf833, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>suit_heart_fill</i> &#x2014; Cupertino icon named "suit_heart_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData suit_heart_fill = IconData(0xf834, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>suit_spade</i> &#x2014; Cupertino icon named "suit_spade". Available on cupertino_icons package 1.0.0+ only.
  static const IconData suit_spade = IconData(0xf835, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>suit_spade_fill</i> &#x2014; Cupertino icon named "suit_spade_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData suit_spade_fill = IconData(0xf836, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sum</i> &#x2014; Cupertino icon named "sum". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sum = IconData(0xf837, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sun_dust</i> &#x2014; Cupertino icon named "sun_dust". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sun_dust = IconData(0xf838, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sun_dust_fill</i> &#x2014; Cupertino icon named "sun_dust_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sun_dust_fill = IconData(0xf839, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sun_haze</i> &#x2014; Cupertino icon named "sun_haze". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sun_haze = IconData(0xf83a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sun_haze_fill</i> &#x2014; Cupertino icon named "sun_haze_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sun_haze_fill = IconData(0xf83b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sun_max</i> &#x2014; Cupertino icon named "sun_max". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [brightness] which is available in cupertino_icons 0.1.3.
  static const IconData sun_max = IconData(0xf4b6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sun_max_fill</i> &#x2014; Cupertino icon named "sun_max_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [brightness_solid] which is available in cupertino_icons 0.1.3.
  static const IconData sun_max_fill = IconData(0xf4b7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sun_min</i> &#x2014; Cupertino icon named "sun_min". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sun_min = IconData(0xf83c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sun_min_fill</i> &#x2014; Cupertino icon named "sun_min_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sun_min_fill = IconData(0xf83d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sunrise</i> &#x2014; Cupertino icon named "sunrise". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sunrise = IconData(0xf83e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sunrise_fill</i> &#x2014; Cupertino icon named "sunrise_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sunrise_fill = IconData(0xf83f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sunset</i> &#x2014; Cupertino icon named "sunset". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sunset = IconData(0xf840, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>sunset_fill</i> &#x2014; Cupertino icon named "sunset_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData sunset_fill = IconData(0xf841, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>t_bubble</i> &#x2014; Cupertino icon named "t_bubble". Available on cupertino_icons package 1.0.0+ only.
  static const IconData t_bubble = IconData(0xf842, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>t_bubble_fill</i> &#x2014; Cupertino icon named "t_bubble_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData t_bubble_fill = IconData(0xf843, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>table</i> &#x2014; Cupertino icon named "table". Available on cupertino_icons package 1.0.0+ only.
  static const IconData table = IconData(0xf844, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>table_badge_more</i> &#x2014; Cupertino icon named "table_badge_more". Available on cupertino_icons package 1.0.0+ only.
  static const IconData table_badge_more = IconData(0xf845, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>table_badge_more_fill</i> &#x2014; Cupertino icon named "table_badge_more_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData table_badge_more_fill = IconData(0xf846, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>table_fill</i> &#x2014; Cupertino icon named "table_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData table_fill = IconData(0xf847, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tag_circle</i> &#x2014; Cupertino icon named "tag_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tag_circle = IconData(0xf848, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tag_circle_fill</i> &#x2014; Cupertino icon named "tag_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tag_circle_fill = IconData(0xf849, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tag_fill</i> &#x2014; Cupertino icon named "tag_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [tag_solid] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [tags_solid] which is available in cupertino_icons 0.1.3.
  static const IconData tag_fill = IconData(0xf48d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_aligncenter</i> &#x2014; Cupertino icon named "text_aligncenter". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_aligncenter = IconData(0xf84a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_alignleft</i> &#x2014; Cupertino icon named "text_alignleft". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_alignleft = IconData(0xf84b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_alignright</i> &#x2014; Cupertino icon named "text_alignright". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_alignright = IconData(0xf84c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_append</i> &#x2014; Cupertino icon named "text_append". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_append = IconData(0xf84d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_badge_checkmark</i> &#x2014; Cupertino icon named "text_badge_checkmark". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_badge_checkmark = IconData(0xf84e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_badge_minus</i> &#x2014; Cupertino icon named "text_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_badge_minus = IconData(0xf84f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_badge_plus</i> &#x2014; Cupertino icon named "text_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_badge_plus = IconData(0xf850, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_badge_star</i> &#x2014; Cupertino icon named "text_badge_star". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_badge_star = IconData(0xf851, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_badge_xmark</i> &#x2014; Cupertino icon named "text_badge_xmark". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_badge_xmark = IconData(0xf852, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_bubble</i> &#x2014; Cupertino icon named "text_bubble". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_bubble = IconData(0xf853, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_bubble_fill</i> &#x2014; Cupertino icon named "text_bubble_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_bubble_fill = IconData(0xf854, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_cursor</i> &#x2014; Cupertino icon named "text_cursor". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_cursor = IconData(0xf855, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_insert</i> &#x2014; Cupertino icon named "text_insert". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_insert = IconData(0xf856, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_justify</i> &#x2014; Cupertino icon named "text_justify". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_justify = IconData(0xf857, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_justifyleft</i> &#x2014; Cupertino icon named "text_justifyleft". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_justifyleft = IconData(0xf858, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_justifyright</i> &#x2014; Cupertino icon named "text_justifyright". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_justifyright = IconData(0xf859, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>text_quote</i> &#x2014; Cupertino icon named "text_quote". Available on cupertino_icons package 1.0.0+ only.
  static const IconData text_quote = IconData(0xf85a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>textbox</i> &#x2014; Cupertino icon named "textbox". Available on cupertino_icons package 1.0.0+ only.
  static const IconData textbox = IconData(0xf85b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>textformat</i> &#x2014; Cupertino icon named "textformat". Available on cupertino_icons package 1.0.0+ only.
  static const IconData textformat = IconData(0xf85c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>textformat_123</i> &#x2014; Cupertino icon named "textformat_123". Available on cupertino_icons package 1.0.0+ only.
  static const IconData textformat_123 = IconData(0xf85d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>textformat_abc</i> &#x2014; Cupertino icon named "textformat_abc". Available on cupertino_icons package 1.0.0+ only.
  static const IconData textformat_abc = IconData(0xf85e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>textformat_abc_dottedunderline</i> &#x2014; Cupertino icon named "textformat_abc_dottedunderline". Available on cupertino_icons package 1.0.0+ only.
  static const IconData textformat_abc_dottedunderline = IconData(0xf85f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>textformat_alt</i> &#x2014; Cupertino icon named "textformat_alt". Available on cupertino_icons package 1.0.0+ only.
  static const IconData textformat_alt = IconData(0xf860, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>textformat_size</i> &#x2014; Cupertino icon named "textformat_size". Available on cupertino_icons package 1.0.0+ only.
  static const IconData textformat_size = IconData(0xf861, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>textformat_subscript</i> &#x2014; Cupertino icon named "textformat_subscript". Available on cupertino_icons package 1.0.0+ only.
  static const IconData textformat_subscript = IconData(0xf862, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>textformat_superscript</i> &#x2014; Cupertino icon named "textformat_superscript". Available on cupertino_icons package 1.0.0+ only.
  static const IconData textformat_superscript = IconData(0xf863, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>thermometer</i> &#x2014; Cupertino icon named "thermometer". Available on cupertino_icons package 1.0.0+ only.
  static const IconData thermometer = IconData(0xf864, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>thermometer_snowflake</i> &#x2014; Cupertino icon named "thermometer_snowflake". Available on cupertino_icons package 1.0.0+ only.
  static const IconData thermometer_snowflake = IconData(0xf865, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>thermometer_sun</i> &#x2014; Cupertino icon named "thermometer_sun". Available on cupertino_icons package 1.0.0+ only.
  static const IconData thermometer_sun = IconData(0xf866, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>ticket</i> &#x2014; Cupertino icon named "ticket". Available on cupertino_icons package 1.0.0+ only.
  static const IconData ticket = IconData(0xf916, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>ticket_fill</i> &#x2014; Cupertino icon named "ticket_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData ticket_fill = IconData(0xf917, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tickets</i> &#x2014; Cupertino icon named "tickets". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tickets = IconData(0xf918, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tickets_fill</i> &#x2014; Cupertino icon named "tickets_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tickets_fill = IconData(0xf919, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>timelapse</i> &#x2014; Cupertino icon named "timelapse". Available on cupertino_icons package 1.0.0+ only.
  static const IconData timelapse = IconData(0xf867, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>timer</i> &#x2014; Cupertino icon named "timer". Available on cupertino_icons package 1.0.0+ only.
  static const IconData timer = IconData(0xf868, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>timer_fill</i> &#x2014; Cupertino icon named "timer_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData timer_fill = IconData(0xf91a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>today</i> &#x2014; Cupertino icon named "today". Available on cupertino_icons package 1.0.0+ only.
  static const IconData today = IconData(0xf91b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>today_fill</i> &#x2014; Cupertino icon named "today_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData today_fill = IconData(0xf91c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tornado</i> &#x2014; Cupertino icon named "tornado". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tornado = IconData(0xf869, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tortoise</i> &#x2014; Cupertino icon named "tortoise". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tortoise = IconData(0xf86a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tortoise_fill</i> &#x2014; Cupertino icon named "tortoise_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tortoise_fill = IconData(0xf86b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tram_fill</i> &#x2014; Cupertino icon named "tram_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tram_fill = IconData(0xf86c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>trash</i> &#x2014; Cupertino icon named "trash". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [delete] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [delete_simple] which is available in cupertino_icons 0.1.3.
  static const IconData trash = IconData(0xf4c4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>trash_circle</i> &#x2014; Cupertino icon named "trash_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData trash_circle = IconData(0xf86d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>trash_circle_fill</i> &#x2014; Cupertino icon named "trash_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData trash_circle_fill = IconData(0xf86e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>trash_fill</i> &#x2014; Cupertino icon named "trash_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [delete_solid] which is available in cupertino_icons 0.1.3.
  static const IconData trash_fill = IconData(0xf4c5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>trash_slash</i> &#x2014; Cupertino icon named "trash_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData trash_slash = IconData(0xf86f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>trash_slash_fill</i> &#x2014; Cupertino icon named "trash_slash_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData trash_slash_fill = IconData(0xf870, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tray</i> &#x2014; Cupertino icon named "tray". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tray = IconData(0xf871, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tray_2</i> &#x2014; Cupertino icon named "tray_2". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tray_2 = IconData(0xf872, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tray_2_fill</i> &#x2014; Cupertino icon named "tray_2_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tray_2_fill = IconData(0xf873, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tray_arrow_down</i> &#x2014; Cupertino icon named "tray_arrow_down". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tray_arrow_down = IconData(0xf874, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tray_arrow_down_fill</i> &#x2014; Cupertino icon named "tray_arrow_down_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tray_arrow_down_fill = IconData(0xf875, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tray_arrow_up</i> &#x2014; Cupertino icon named "tray_arrow_up". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tray_arrow_up = IconData(0xf876, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tray_arrow_up_fill</i> &#x2014; Cupertino icon named "tray_arrow_up_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tray_arrow_up_fill = IconData(0xf877, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tray_fill</i> &#x2014; Cupertino icon named "tray_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tray_fill = IconData(0xf878, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tray_full</i> &#x2014; Cupertino icon named "tray_full". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tray_full = IconData(0xf879, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tray_full_fill</i> &#x2014; Cupertino icon named "tray_full_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tray_full_fill = IconData(0xf87a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tree</i> &#x2014; Cupertino icon named "tree". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tree = IconData(0xf91d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>triangle</i> &#x2014; Cupertino icon named "triangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData triangle = IconData(0xf87b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>triangle_fill</i> &#x2014; Cupertino icon named "triangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData triangle_fill = IconData(0xf87c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>triangle_lefthalf_fill</i> &#x2014; Cupertino icon named "triangle_lefthalf_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData triangle_lefthalf_fill = IconData(0xf87d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>triangle_righthalf_fill</i> &#x2014; Cupertino icon named "triangle_righthalf_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData triangle_righthalf_fill = IconData(0xf87e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tropicalstorm</i> &#x2014; Cupertino icon named "tropicalstorm". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tropicalstorm = IconData(0xf87f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tuningfork</i> &#x2014; Cupertino icon named "tuningfork". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tuningfork = IconData(0xf880, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tv</i> &#x2014; Cupertino icon named "tv". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tv = IconData(0xf881, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tv_circle</i> &#x2014; Cupertino icon named "tv_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tv_circle = IconData(0xf882, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tv_circle_fill</i> &#x2014; Cupertino icon named "tv_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tv_circle_fill = IconData(0xf883, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tv_fill</i> &#x2014; Cupertino icon named "tv_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tv_fill = IconData(0xf884, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tv_music_note</i> &#x2014; Cupertino icon named "tv_music_note". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tv_music_note = IconData(0xf885, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>tv_music_note_fill</i> &#x2014; Cupertino icon named "tv_music_note_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData tv_music_note_fill = IconData(0xf886, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>uiwindow_split_2x1</i> &#x2014; Cupertino icon named "uiwindow_split_2x1". Available on cupertino_icons package 1.0.0+ only.
  static const IconData uiwindow_split_2x1 = IconData(0xf887, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>umbrella</i> &#x2014; Cupertino icon named "umbrella". Available on cupertino_icons package 1.0.0+ only.
  static const IconData umbrella = IconData(0xf888, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>umbrella_fill</i> &#x2014; Cupertino icon named "umbrella_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData umbrella_fill = IconData(0xf889, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>underline</i> &#x2014; Cupertino icon named "underline". Available on cupertino_icons package 1.0.0+ only.
  static const IconData underline = IconData(0xf88a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>upload_circle</i> &#x2014; Cupertino icon named "upload_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData upload_circle = IconData(0xf91e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>upload_circle_fill</i> &#x2014; Cupertino icon named "upload_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData upload_circle_fill = IconData(0xf91f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>videocam</i> &#x2014; Cupertino icon named "videocam". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [video_camera] which is available in cupertino_icons 0.1.3.
  static const IconData videocam = IconData(0xf4cc, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>videocam_circle</i> &#x2014; Cupertino icon named "videocam_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData videocam_circle = IconData(0xf920, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>videocam_circle_fill</i> &#x2014; Cupertino icon named "videocam_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData videocam_circle_fill = IconData(0xf921, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>videocam_fill</i> &#x2014; Cupertino icon named "videocam_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [video_camera_solid] which is available in cupertino_icons 0.1.3.
  static const IconData videocam_fill = IconData(0xf4cd, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>view_2d</i> &#x2014; Cupertino icon named "view_2d". Available on cupertino_icons package 1.0.0+ only.
  static const IconData view_2d = IconData(0xf88b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>view_3d</i> &#x2014; Cupertino icon named "view_3d". Available on cupertino_icons package 1.0.0+ only.
  static const IconData view_3d = IconData(0xf88c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>viewfinder</i> &#x2014; Cupertino icon named "viewfinder". Available on cupertino_icons package 1.0.0+ only.
  static const IconData viewfinder = IconData(0xf88d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>viewfinder_circle</i> &#x2014; Cupertino icon named "viewfinder_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData viewfinder_circle = IconData(0xf88e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>viewfinder_circle_fill</i> &#x2014; Cupertino icon named "viewfinder_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData viewfinder_circle_fill = IconData(0xf88f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>wand_rays</i> &#x2014; Cupertino icon named "wand_rays". Available on cupertino_icons package 1.0.0+ only.
  static const IconData wand_rays = IconData(0xf890, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>wand_rays_inverse</i> &#x2014; Cupertino icon named "wand_rays_inverse". Available on cupertino_icons package 1.0.0+ only.
  static const IconData wand_rays_inverse = IconData(0xf891, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>wand_stars</i> &#x2014; Cupertino icon named "wand_stars". Available on cupertino_icons package 1.0.0+ only.
  static const IconData wand_stars = IconData(0xf892, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>wand_stars_inverse</i> &#x2014; Cupertino icon named "wand_stars_inverse". Available on cupertino_icons package 1.0.0+ only.
  static const IconData wand_stars_inverse = IconData(0xf893, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>waveform</i> &#x2014; Cupertino icon named "waveform". Available on cupertino_icons package 1.0.0+ only.
  static const IconData waveform = IconData(0xf894, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>waveform_circle</i> &#x2014; Cupertino icon named "waveform_circle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData waveform_circle = IconData(0xf895, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>waveform_circle_fill</i> &#x2014; Cupertino icon named "waveform_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData waveform_circle_fill = IconData(0xf896, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>waveform_path</i> &#x2014; Cupertino icon named "waveform_path". Available on cupertino_icons package 1.0.0+ only.
  static const IconData waveform_path = IconData(0xf897, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>waveform_path_badge_minus</i> &#x2014; Cupertino icon named "waveform_path_badge_minus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData waveform_path_badge_minus = IconData(0xf898, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>waveform_path_badge_plus</i> &#x2014; Cupertino icon named "waveform_path_badge_plus". Available on cupertino_icons package 1.0.0+ only.
  static const IconData waveform_path_badge_plus = IconData(0xf899, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>waveform_path_ecg</i> &#x2014; Cupertino icon named "waveform_path_ecg". Available on cupertino_icons package 1.0.0+ only.
  static const IconData waveform_path_ecg = IconData(0xf89a, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>wifi</i> &#x2014; Cupertino icon named "wifi". Available on cupertino_icons package 1.0.0+ only.
  static const IconData wifi = IconData(0xf89b, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>wifi_exclamationmark</i> &#x2014; Cupertino icon named "wifi_exclamationmark". Available on cupertino_icons package 1.0.0+ only.
  static const IconData wifi_exclamationmark = IconData(0xf89c, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>wifi_slash</i> &#x2014; Cupertino icon named "wifi_slash". Available on cupertino_icons package 1.0.0+ only.
  static const IconData wifi_slash = IconData(0xf89d, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>wind</i> &#x2014; Cupertino icon named "wind". Available on cupertino_icons package 1.0.0+ only.
  static const IconData wind = IconData(0xf89e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>wind_snow</i> &#x2014; Cupertino icon named "wind_snow". Available on cupertino_icons package 1.0.0+ only.
  static const IconData wind_snow = IconData(0xf89f, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>wrench</i> &#x2014; Cupertino icon named "wrench". Available on cupertino_icons package 1.0.0+ only.
  static const IconData wrench = IconData(0xf8a0, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>wrench_fill</i> &#x2014; Cupertino icon named "wrench_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData wrench_fill = IconData(0xf8a1, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>xmark</i> &#x2014; Cupertino icon named "xmark". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [clear_thick] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [clear] which is available in cupertino_icons 0.1.3.
  static const IconData xmark = IconData(0xf404, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>xmark_circle</i> &#x2014; Cupertino icon named "xmark_circle". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [clear_circled] which is available in cupertino_icons 0.1.3.
  static const IconData xmark_circle = IconData(0xf405, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>xmark_circle_fill</i> &#x2014; Cupertino icon named "xmark_circle_fill". Available on cupertino_icons package 1.0.0+ only.
  /// This is the same icon as [clear_thick_circled] which is available in cupertino_icons 0.1.3.
  /// This is the same icon as [clear_circled_solid] which is available in cupertino_icons 0.1.3.
  static const IconData xmark_circle_fill = IconData(0xf36e, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>xmark_octagon</i> &#x2014; Cupertino icon named "xmark_octagon". Available on cupertino_icons package 1.0.0+ only.
  static const IconData xmark_octagon = IconData(0xf8a2, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>xmark_octagon_fill</i> &#x2014; Cupertino icon named "xmark_octagon_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData xmark_octagon_fill = IconData(0xf8a3, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>xmark_rectangle</i> &#x2014; Cupertino icon named "xmark_rectangle". Available on cupertino_icons package 1.0.0+ only.
  static const IconData xmark_rectangle = IconData(0xf8a4, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>xmark_rectangle_fill</i> &#x2014; Cupertino icon named "xmark_rectangle_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData xmark_rectangle_fill = IconData(0xf8a5, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>xmark_seal</i> &#x2014; Cupertino icon named "xmark_seal". Available on cupertino_icons package 1.0.0+ only.
  static const IconData xmark_seal = IconData(0xf8a6, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>xmark_seal_fill</i> &#x2014; Cupertino icon named "xmark_seal_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData xmark_seal_fill = IconData(0xf8a7, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>xmark_shield</i> &#x2014; Cupertino icon named "xmark_shield". Available on cupertino_icons package 1.0.0+ only.
  static const IconData xmark_shield = IconData(0xf8a8, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>xmark_shield_fill</i> &#x2014; Cupertino icon named "xmark_shield_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData xmark_shield_fill = IconData(0xf8a9, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>xmark_square</i> &#x2014; Cupertino icon named "xmark_square". Available on cupertino_icons package 1.0.0+ only.
  static const IconData xmark_square = IconData(0xf8aa, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>xmark_square_fill</i> &#x2014; Cupertino icon named "xmark_square_fill". Available on cupertino_icons package 1.0.0+ only.
  static const IconData xmark_square_fill = IconData(0xf8ab, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>zoom_in</i> &#x2014; Cupertino icon named "zoom_in". Available on cupertino_icons package 1.0.0+ only.
  static const IconData zoom_in = IconData(0xf8ac, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>zoom_out</i> &#x2014; Cupertino icon named "zoom_out". Available on cupertino_icons package 1.0.0+ only.
  static const IconData zoom_out = IconData(0xf8ad, fontFamily: iconFont, fontPackage: iconFontPackage);
  /// <i class='cupertino-icons md-36'>zzz</i> &#x2014; Cupertino icon named "zzz". Available on cupertino_icons package 1.0.0+ only.
  static const IconData zzz = IconData(0xf8ae, fontFamily: iconFont, fontPackage: iconFontPackage);
  // END GENERATED SF SYMBOLS NAMES
  // ===========================================================================
}
