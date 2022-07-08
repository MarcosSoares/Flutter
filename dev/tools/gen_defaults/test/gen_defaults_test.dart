// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:gen_defaults/template.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  test('Templates will append to the end of a file', () {
    final Directory tempDir = Directory.systemTemp.createTempSync('gen_defaults');
    try {
      // Create a temporary file with some content.
      final File tempFile = File(path.join(tempDir.path, 'test_template.txt'));
      tempFile.createSync();
      tempFile.writeAsStringSync('''
// This is a file with stuff in it.
// This part shouldn't be changed by
// the template.
''');

      // Have a test template append new parameterized content to the end of
      // the file.
      final Map<String, dynamic> tokens = <String, dynamic>{'foo': 'Foobar', 'bar': 'Barfoo'};
      TestTemplate('Test', tempFile.path, tokens).updateFile();

      expect(tempFile.readAsStringSync(), '''
// This is a file with stuff in it.
// This part shouldn't be changed by
// the template.

// BEGIN GENERATED TOKEN PROPERTIES - Test

// Generated code to the end of this file. Do not edit by hand.
// These defaults are generated from the Material Design Token
// database by the script dev/tools/gen_defaults/bin/gen_defaults.dart.

static final String tokenFoo = 'Foobar';
static final String tokenBar = 'Barfoo';

// END GENERATED TOKEN PROPERTIES - Test
''');

    } finally {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('Templates will update over previously generated code at the end of a file', () {
    final Directory tempDir = Directory.systemTemp.createTempSync('gen_defaults');
    try {
      // Create a temporary file with some content.
      final File tempFile = File(path.join(tempDir.path, 'test_template.txt'));
      tempFile.createSync();
      tempFile.writeAsStringSync('''
// This is a file with stuff in it.
// This part shouldn't be changed by
// the template.

// BEGIN GENERATED TOKEN PROPERTIES - Test

// Generated code to the end of this file. Do not edit by hand.
// These defaults are generated from the Material Design Token
// database by the script dev/tools/gen_defaults/bin/gen_defaults.dart.

static final String tokenFoo = 'Foobar';
static final String tokenBar = 'Barfoo';

// END GENERATED TOKEN PROPERTIES - Test
''');

      // Have a test template append new parameterized content to the end of
      // the file.
      final Map<String, dynamic> tokens = <String, dynamic>{'foo': 'foo', 'bar': 'bar'};
      TestTemplate('Test', tempFile.path, tokens).updateFile();

      expect(tempFile.readAsStringSync(), '''
// This is a file with stuff in it.
// This part shouldn't be changed by
// the template.

// BEGIN GENERATED TOKEN PROPERTIES - Test

// Generated code to the end of this file. Do not edit by hand.
// These defaults are generated from the Material Design Token
// database by the script dev/tools/gen_defaults/bin/gen_defaults.dart.

static final String tokenFoo = 'foo';
static final String tokenBar = 'bar';

// END GENERATED TOKEN PROPERTIES - Test
''');

    } finally {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('Multiple templates can modify different code chunks in the same file', () {
    final Directory tempDir = Directory.systemTemp.createTempSync('gen_defaults');
    try {
      // Create a temporary file with some content.
      final File tempFile = File(path.join(tempDir.path, 'test_template.txt'));
      tempFile.createSync();
      tempFile.writeAsStringSync('''
// This is a file with stuff in it.
// This part shouldn't be changed by
// the template.
''');

      // Update file with a template for 'Chunk 1'
      {
        final Map<String, dynamic> tokens = <String, dynamic>{'foo': 'foo', 'bar': 'bar'};
        TestTemplate('Chunk 1', tempFile.path, tokens).updateFile();
      }
      expect(tempFile.readAsStringSync(), '''
// This is a file with stuff in it.
// This part shouldn't be changed by
// the template.

// BEGIN GENERATED TOKEN PROPERTIES - Chunk 1

// Generated code to the end of this file. Do not edit by hand.
// These defaults are generated from the Material Design Token
// database by the script dev/tools/gen_defaults/bin/gen_defaults.dart.

static final String tokenFoo = 'foo';
static final String tokenBar = 'bar';

// END GENERATED TOKEN PROPERTIES - Chunk 1
''');

      // Update file with a template for 'Chunk 2', which should append but not
      // disturb the code in 'Chunk 1'.
      {
        final Map<String, dynamic> tokens = <String, dynamic>{'foo': 'bar', 'bar': 'foo'};
        TestTemplate('Chunk 2', tempFile.path, tokens).updateFile();
      }
      expect(tempFile.readAsStringSync(), '''
// This is a file with stuff in it.
// This part shouldn't be changed by
// the template.

// BEGIN GENERATED TOKEN PROPERTIES - Chunk 1

// Generated code to the end of this file. Do not edit by hand.
// These defaults are generated from the Material Design Token
// database by the script dev/tools/gen_defaults/bin/gen_defaults.dart.

static final String tokenFoo = 'foo';
static final String tokenBar = 'bar';

// END GENERATED TOKEN PROPERTIES - Chunk 1

// BEGIN GENERATED TOKEN PROPERTIES - Chunk 2

// Generated code to the end of this file. Do not edit by hand.
// These defaults are generated from the Material Design Token
// database by the script dev/tools/gen_defaults/bin/gen_defaults.dart.

static final String tokenFoo = 'bar';
static final String tokenBar = 'foo';

// END GENERATED TOKEN PROPERTIES - Chunk 2
''');

      // Update 'Chunk 1' again which should just update that chunk,
      // leaving 'Chunk 2' undisturbed.
      {
        final Map<String, dynamic> tokens = <String, dynamic>{'foo': 'FOO', 'bar': 'BAR'};
        TestTemplate('Chunk 1', tempFile.path, tokens).updateFile();
      }
      expect(tempFile.readAsStringSync(), '''
// This is a file with stuff in it.
// This part shouldn't be changed by
// the template.

// BEGIN GENERATED TOKEN PROPERTIES - Chunk 1

// Generated code to the end of this file. Do not edit by hand.
// These defaults are generated from the Material Design Token
// database by the script dev/tools/gen_defaults/bin/gen_defaults.dart.

static final String tokenFoo = 'FOO';
static final String tokenBar = 'BAR';

// END GENERATED TOKEN PROPERTIES - Chunk 1

// BEGIN GENERATED TOKEN PROPERTIES - Chunk 2

// Generated code to the end of this file. Do not edit by hand.
// These defaults are generated from the Material Design Token
// database by the script dev/tools/gen_defaults/bin/gen_defaults.dart.

static final String tokenFoo = 'bar';
static final String tokenBar = 'foo';

// END GENERATED TOKEN PROPERTIES - Chunk 2
''');

    } finally {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('Templates can get proper shapes from given data', () {
    const Map<String, dynamic> tokens = <String, dynamic>{
      'foo.shape': 'shape.large',
      'bar.shape': 'shape.full',
      'shape.large': <String, dynamic>{
        'family': 'SHAPE_FAMILY_ROUNDED_CORNERS',
        'topLeft': 1.0,
        'topRight': 2.0,
        'bottomLeft': 3.0,
        'bottomRight': 4.0,
      },
      'shape.full': <String, dynamic>{
        'family': 'SHAPE_FAMILY_CIRCULAR',
      },
    };
    final TestTemplate template = TestTemplate('Test', 'foobar.dart', tokens);
    expect(template.shape('foo'), 'const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(1.0), topRight: Radius.circular(2.0), bottomLeft: Radius.circular(3.0), bottomRight: Radius.circular(4.0)))');
    expect(template.shape('bar'), 'const StadiumBorder()');
  });
}

class TestTemplate extends TokenTemplate {
  TestTemplate(super.chunkTag, super.fileName, super.tokens);

  @override
  String generate() => '''
static final String tokenFoo = '${tokens['foo']}';
static final String tokenBar = '${tokens['bar']}';
''';
}
