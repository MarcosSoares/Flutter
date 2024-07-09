// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// Flutter code sample for [MaterialStateOutlinedBorder].

void main() => runApp(const MaterialStateOutlinedBorderExampleApp());

class MaterialStateOutlinedBorderExampleApp extends StatelessWidget {
  const MaterialStateOutlinedBorderExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MaterialStateOutlinedBorderExample(),
    );
  }
}

class MaterialStateOutlinedBorderExample extends StatefulWidget {
  const MaterialStateOutlinedBorderExample({super.key});

  @override
  State<MaterialStateOutlinedBorderExample> createState() => _MaterialStateOutlinedBorderExampleState();
}

class _MaterialStateOutlinedBorderExampleState extends State<MaterialStateOutlinedBorderExample> {
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FilterChip(
        label: const Text('Select chip'),
        selected: isSelected,
        onSelected: (bool value) {
          setState(() {
            isSelected = value;
          });
        },
        shape: WidgetStateOutlinedBorder.resolveWith(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const RoundedRectangleBorder();
            }
            return null; // Defer to default value on the theme or widget.
          },
        ),
      ),
    );
  }
}
