// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'page.dart';
import 'simple_platform_view.dart';

MethodChannel channel = const MethodChannel('android_views_integration');

/// Testing the mutation composition of the platform views
///
/// We use this page to generate screenshot to perform a golden test.
/// The page contains mutation compositions:
///   1. clip rect.
///   2. clip rrect.
///   3. clip path.
///   4. opacity.
///   5. translate.
///   6. scale.
///   7. rotation.
///   8. complex composition.
/// A set of `Container` widgets are shown next to the platform views with the same mutation composition for the manual sanity test purpose.
class MutationCompositionPage extends Page {
  const MutationCompositionPage()
      : super('Mutation Composition Tests',
            const ValueKey<String>('MutationPageListTile'));

  @override
  Widget build(BuildContext context) {
    return const MutationCompositionBody();
  }
}

/// The widget to be tested containing several widgets that have different types of mutations.
class MutationCompositionBody extends StatefulWidget {
  const MutationCompositionBody()
      : super(key: const ValueKey<String>('MutationPage'));

  @override
  State createState() => MutationCompositionBodyState();
}

class MutationCompositionBodyState extends State<MutationCompositionBody> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        child: Row(
          children: <Column>[
            Column(
              children: <Widget>[
                _container(_compositionClipRect(_platformViewToMutate('0'))),
                _container(_compositionClipRRect(_platformViewToMutate('1'))),
                _container(_compositionClipPath(_platformViewToMutate('2'))),
                _container(_compositionComplex(_platformViewToMutate('3')))
              ],
            ),
            Column(
              children: <Widget>[
                _container(_compositionTranslate(_platformViewToMutate('4'))),
                _container(_compositionScale(_platformViewToMutate('5'))),
                _container(_compositionRotate(_platformViewToMutate('6'))),
                _container(_compositionOpacity(_platformViewToMutate('7')))
              ],
            )
          ],
        ),
        padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
      ),
      Center(
          child: FlatButton(
        key: const ValueKey<String>('back'),
        child: const Text('back'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ))
    ]);
  }

  Widget _container(Widget child) {
    return Container(child: child, padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),);
  }

  Widget _compositionComplex(Widget child) {
    return Transform.scale(
      scale: 0.5,
      child: Opacity(
        opacity: 0.2,
        child: Opacity(
            opacity: 0.5,
            child: Transform.rotate(
              angle: 1,
              child: ClipRect(
                clipper: RectClipper(),
                child: Transform.translate(
                  offset: const Offset(0, 10),
                  child: child,
                ),
              ),
            )),
      ),
    );
  }

  Widget _compositionClipRect(Widget child) {
    return ClipRect(
      clipper: RectClipper(),
      child: child,
    );
  }

  Widget _compositionClipRRect(Widget child) {
    return ClipRRect(clipper: RRectClipper(), child: child);
  }

  Widget _compositionClipPath(Widget child) {
    return ClipPath(clipper: PathClipper(), child: child);
  }

  Widget _compositionTranslate(Widget child) {
    return Transform.translate(
                  offset: const Offset(0, 30),
                  child: child,);
  }

  Widget _compositionScale(Widget child) {
    return Transform.scale(scale: 0.5, child:child);
  }

  Widget _compositionRotate(Widget child) {
    return Transform.rotate(angle: 2, child: child);
  }

  Widget _compositionOpacity(Widget child) {
    return Opacity(opacity: 0.5, child: child);
  }

  // A `Container` widget that matches the testing platform view.
  Widget _containerToMutate() {
    return Container(
        width: 75,
        height: 75,
        child: Container(color: const Color(0xFF0000FF)));
  }

  Widget _platformViewToMutate(String id) {
    return Container(
        width: 75,
        height: 75,
        child: SimplePlatformView(key: ValueKey<String>('PlatformView$id')));
  }
}

/// A sample `PathClipper` used for testing.
class PathClipper extends CustomClipper<Path> {
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(37, 0);
    path.lineTo(0, 100);
    path.quadraticBezierTo(16, 75, 27, 50);
    path.lineTo(0, 50);
    path.cubicTo(45, 75, 60, 65, 75, 50);
    path.close();
    return path;
  }
}

/// A sample `RectClipper` used for testing.
class RectClipper extends CustomClipper<Rect> {
  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

  @override
  Rect getClip(Size size) {
    return const Rect.fromLTRB(5, 5, 50, 50);
  }
}

/// A sample `RRectClipper` used for testing.
class RRectClipper extends CustomClipper<RRect> {
  @override
  bool shouldReclip(CustomClipper<RRect> oldClipper) {
    return true;
  }

  @override
  RRect getClip(Size size) {
    return RRect.fromLTRBAndCorners(5, 5, 50, 50,
        topLeft: const Radius.circular(10),
        bottomRight: const Radius.circular(10));
  }
}
