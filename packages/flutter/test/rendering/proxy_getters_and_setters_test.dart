// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test/test.dart';

void main() {
  test('RenderConstrainedBox getters and setters', () {
    RenderConstrainedBox box = new RenderConstrainedBox(additionalConstraints: new BoxConstraints.tightFor(height: 10.0));
    expect(box.additionalConstraints, new BoxConstraints(minHeight: 10.0, maxHeight: 10.0));
    box.additionalConstraints = new BoxConstraints.tightFor(width: 10.0);
    expect(box.additionalConstraints, new BoxConstraints(minWidth: 10.0, maxWidth: 10.0));
  });

  test('RenderLimitedBox getters and setters', () {
    RenderLimitedBox box = new RenderLimitedBox();
    expect(box.maxWidth, double.INFINITY);
    expect(box.maxHeight, double.INFINITY);
    box.maxWidth = 0.0;
    box.maxHeight = 1.0;
    expect(box.maxHeight, 1.0);
    expect(box.maxWidth, 0.0);
  });

  test('RenderAspectRatio getters and setters', () {
    RenderAspectRatio box = new RenderAspectRatio(aspectRatio: 1.0);
    expect(box.aspectRatio, 1.0);
    box.aspectRatio = 0.2;
    expect(box.aspectRatio, 0.2);
    box.aspectRatio = 1.2;
    expect(box.aspectRatio, 1.2);
  });

  test('RenderIntrinsicWidth getters and setters', () {
    RenderIntrinsicWidth box = new RenderIntrinsicWidth();
    expect(box.stepWidth, isNull);
    box.stepWidth = 10.0;
    expect(box.stepWidth, 10.0);
    expect(box.stepHeight, isNull);
    box.stepHeight = 10.0;
    expect(box.stepHeight, 10.0);
  });

  test('RenderOpacity getters and setters', () {
    RenderOpacity box = new RenderOpacity();
    expect(box.opacity, 1.0);
    box.opacity = 0.0;
    expect(box.opacity, 0.0);
  });

  test('RenderShaderMask getters and setters', () {
    ShaderCallback callback1 = (Rect bounds) => null;
    ShaderCallback callback2 = (Rect bounds) => null;
    RenderShaderMask box = new RenderShaderMask(shaderCallback: callback1);
    expect(box.shaderCallback, equals(callback1));
    box.shaderCallback = callback2;
    expect(box.shaderCallback, equals(callback2));
    expect(box.blendMode, BlendMode.modulate);
    box.blendMode = BlendMode.colorBurn;
    expect(box.blendMode, BlendMode.colorBurn);
  });
}
