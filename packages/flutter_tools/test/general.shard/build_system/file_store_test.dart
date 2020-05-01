// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

import 'package:file/memory.dart';
import 'package:file_testing/file_testing.dart';
import 'package:flutter_tools/src/artifacts.dart';
import 'package:flutter_tools/src/base/file_system.dart';
import 'package:flutter_tools/src/base/logger.dart';
import 'package:flutter_tools/src/build_system/file_store.dart';
import 'package:mockito/mockito.dart';

import '../../src/common.dart';

void main() {
  test('FileStore initializes file cache', () {
    final FileSystem fileSystem = MemoryFileSystem.test();
    final File cacheFile = fileSystem.file(FileStore.kFileCache);
    final FileStore fileCache = FileStore(
      cacheFile: cacheFile,
      logger: BufferLogger.test(),
    );
    fileCache.initialize();
    fileCache.persist();

    expect(cacheFile, exists);

    final Uint8List buffer = cacheFile.readAsBytesSync();
    final FileStorage fileStorage = FileStorage.fromBuffer(buffer);

    expect(fileStorage.files, isEmpty);
    expect(fileStorage.version, 2);
  });

  test('FileStore can use timestamp strategy', () async {
    final FileSystem fileSystem = MemoryFileSystem.test();
    final File cacheFile = fileSystem.file(FileStore.kFileCache);
    final FileStore fileCache = FileStore(
      cacheFile: cacheFile,
      logger: BufferLogger.test(),
    );
    fileCache.initialize();
    final File file = fileSystem.file('test')..createSync();

    // Initial run does not contain any timestamps for file.
    expect(await fileCache.diffFileList(<File>[file]), hasLength(1));

    // Swap current timestamps to previous timestamps.
    fileCache.persistIncremental();

    // timestamp matches previous timestamp.
    expect(await fileCache.diffFileList(<File>[file]), isEmpty);

    // clear current timestamp list.
    fileCache.persistIncremental();

    // modify the time stamp.
    file.writeAsStringSync('foo');

    // verify the file is marked as dirty again.
    expect(await fileCache.diffFileList(<File>[file]), hasLength(1));
  });

  test('FileStore saves and restores to file cache', () async {
    final FileSystem fileSystem = MemoryFileSystem.test();
    final File cacheFile = fileSystem.file(FileStore.kFileCache);
    final FileStore fileCache = FileStore(
      cacheFile: cacheFile,
      logger: BufferLogger.test(),
    );
    final File file = fileSystem.file('foo.dart')
      ..createSync()
      ..writeAsStringSync('hello');

    fileCache.initialize();
    await fileCache.diffFileList(<File>[file]);
    fileCache.persist();
    final String currentHash =  fileCache.currentAssetKeys[file.path];
    final Uint8List buffer = cacheFile
        .readAsBytesSync();
    FileStorage fileStorage = FileStorage.fromBuffer(buffer);

    expect(fileStorage.files.single.hash, currentHash);
    expect(fileStorage.files.single.path, file.path);


    final FileStore newfileCache = FileStore(
      cacheFile: cacheFile,
      logger: BufferLogger.test(),
    );
    newfileCache.initialize();
    expect(newfileCache.currentAssetKeys, isEmpty);
    expect(newfileCache.previousAssetKeys['foo.dart'],  currentHash);
    newfileCache.persist();

    // Still persisted correctly.
    fileStorage = FileStorage.fromBuffer(buffer);

    expect(fileStorage.files.single.hash, currentHash);
    expect(fileStorage.files.single.path, file.path);
  });

  test('FileStore handles persisting with a missing build directory', () async {
    final FileSystem fileSystem = MemoryFileSystem.test();
    final File cacheFile = fileSystem
      .directory('example')
      .childFile(FileStore.kFileCache)
      ..createSync(recursive: true);
    final FileStore fileCache = FileStore(
      cacheFile: cacheFile,
      logger: BufferLogger.test(),
    );
    final File file = fileSystem.file('foo.dart')
      ..createSync()
      ..writeAsStringSync('hello');
    fileCache.initialize();

    cacheFile.parent.deleteSync(recursive: true);

    await fileCache.diffFileList(<File>[file]);

    expect(() => fileCache.persist(), returnsNormally);
  });

  test('FileStore handles hashing missing files', () async {
    final FileSystem fileSystem = MemoryFileSystem.test();
    final File cacheFile = fileSystem.file(FileStore.kFileCache);
    final FileStore fileCache = FileStore(
      cacheFile: cacheFile,
      logger: BufferLogger.test(),
    );
    fileCache.initialize();

    final List<File> results = await fileCache.diffFileList(<File>[fileSystem.file('hello.dart')]);

    expect(results, hasLength(1));
    expect(results.single.path, 'hello.dart');
    expect(fileCache.currentAssetKeys, isNot(contains(fileSystem.path.absolute('hello.dart'))));
  });

  test('FileStore handles failure to persist file cache', () async {
    final MockFile mockFile = MockFile();
    final BufferLogger logger = BufferLogger.test();
    when(mockFile.writeAsBytesSync(any)).thenThrow(const FileSystemException('Out of space!'));
    when(mockFile.readAsBytesSync()).thenReturn(Uint8List(0));
    when(mockFile.existsSync()).thenReturn(true);

    final FileStore fileCache = FileStore(
      cacheFile: mockFile,
      logger: logger,
    );

    fileCache.initialize();
    fileCache.persist();

    expect(logger.errorText, contains('Out of space!'));
  });

  test('FileStore handles failure to restore file cache', () async {
    final MockFile mockFile = MockFile();
    final BufferLogger logger = BufferLogger.test();
    when(mockFile.readAsBytesSync()).thenThrow(const FileSystemException('Out of space!'));
    when(mockFile.existsSync()).thenReturn(true);

    final FileStore fileCache = FileStore(
      cacheFile: mockFile,
      logger: logger,
    );

    fileCache.initialize();

    expect(logger.errorText, contains('Out of space!'));
  });
}

class MockFile extends Mock implements File {}
class MockArtifacts extends Mock implements Artifacts {}
