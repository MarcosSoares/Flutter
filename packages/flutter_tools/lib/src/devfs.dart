// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:json_rpc_2/json_rpc_2.dart' as rpc;
import 'package:meta/meta.dart';

import 'asset.dart';
import 'base/common.dart';
import 'base/context.dart';
import 'base/file_system.dart';
import 'base/io.dart';
import 'build_info.dart';
import 'bundle.dart';
import 'compile.dart';
import 'convert.dart' show base64, utf8;
import 'dart/package_map.dart';
import 'globals.dart';
import 'vmservice.dart';

class DevFSConfig {
  /// Should DevFS assume that symlink targets are stable?
  bool cacheSymlinks = false;
  /// Should DevFS assume that there are no symlinks to directories?
  bool noDirectorySymlinks = false;
}

DevFSConfig get devFSConfig => context.get<DevFSConfig>();

/// Common superclass for content copied to the device.
abstract class DevFSContent {
  /// Return true if this is the first time this method is called
  /// or if the entry has been modified since this method was last called.
  bool get isModified;

  /// Return true if this is the first time this method is called
  /// or if the entry has been modified after the given time
  /// or if the given time is null.
  bool isModifiedAfter(DateTime time);

  /// The number of bytes in this file.
  int get size;

  /// Returns the raw bytes of this file.
  List<int> contentsAsBytes();

  /// Returns a gzipped representation of the contents of this file.
  List<int> contentsAsCompressedBytes() {
    return gzip.encode(contentsAsBytes().cast<int>());
  }
}

/// File content to be copied to the device.
class DevFSFileContent extends DevFSContent {
  DevFSFileContent(this.file);

  final FileSystemEntity file;
  FileSystemEntity _linkTarget;
  FileStat _fileStat;

  File _getFile() {
    if (_linkTarget != null) {
      return _linkTarget;
    }
    if (file is Link) {
      // The link target.
      return fs.file(file.resolveSymbolicLinksSync());
    }
    return file;
  }

  void _stat() {
    if (_linkTarget != null) {
      // Stat the cached symlink target.
      final FileStat fileStat = _linkTarget.statSync();
      if (fileStat.type == FileSystemEntityType.notFound) {
        _linkTarget = null;
      } else {
        _fileStat = fileStat;
        return;
      }
    }
    final FileStat fileStat = file.statSync();
    _fileStat = fileStat.type == FileSystemEntityType.notFound ? null : fileStat;
    if (_fileStat != null && _fileStat.type == FileSystemEntityType.link) {
      // Resolve, stat, and maybe cache the symlink target.
      final String resolved = file.resolveSymbolicLinksSync();
      final FileSystemEntity linkTarget = fs.file(resolved);
      // Stat the link target.
      final FileStat fileStat = linkTarget.statSync();
      if (fileStat.type == FileSystemEntityType.notFound) {
        _fileStat = null;
        _linkTarget = null;
      } else if (devFSConfig.cacheSymlinks) {
        _linkTarget = linkTarget;
      }
    }
    if (_fileStat == null) {
      printError('Unable to get status of file "${file.path}": file not found.');
    }
  }

  @override
  bool get isModified {
    final FileStat _oldFileStat = _fileStat;
    _stat();
    if (_oldFileStat == null && _fileStat == null)
      return false;
    return _oldFileStat == null || _fileStat == null || _fileStat.modified.isAfter(_oldFileStat.modified);
  }

  @override
  bool isModifiedAfter(DateTime time) {
    final FileStat _oldFileStat = _fileStat;
    _stat();
    if (_oldFileStat == null && _fileStat == null)
      return false;
    return time == null
        || _oldFileStat == null
        || _fileStat == null
        || _fileStat.modified.isAfter(time);
  }

  @override
  int get size {
    if (_fileStat == null)
      _stat();
    // Can still be null if the file wasn't found.
    return _fileStat?.size ?? 0;
  }

  @override
  List<int> contentsAsBytes() => _getFile().readAsBytesSync();
}

/// Byte content to be copied to the device.
class DevFSByteContent extends DevFSContent {
  DevFSByteContent(this._bytes);

  List<int> _bytes;

  bool _isModified = true;
  DateTime _modificationTime = DateTime.now();

  List<int> get bytes => _bytes;

  set bytes(List<int> value) {
    _bytes = value;
    _isModified = true;
    _modificationTime = DateTime.now();
  }

  /// Return true only once so that the content is written to the device only once.
  @override
  bool get isModified {
    final bool modified = _isModified;
    _isModified = false;
    return modified;
  }

  @override
  bool isModifiedAfter(DateTime time) {
    return time == null || _modificationTime.isAfter(time);
  }

  @override
  int get size => _bytes.length;

  @override
  List<int> contentsAsBytes() => _bytes;
}

/// String content to be copied to the device encoded as utf8.
class DevFSStringContent extends DevFSByteContent {
  DevFSStringContent(String string)
    : _string = string,
      super(utf8.encode(string));

  String _string;

  String get string => _string;

  set string(String value) {
    _string = value;
    super.bytes = utf8.encode(_string);
  }

  @override
  set bytes(List<int> value) {
    string = utf8.decode(value);
  }
}

/// Abstract DevFS operations interface.
abstract class DevFSOperations {
  Future<Uri> create(String fsName);

  Future<dynamic> destroy(String fsName);
}

/// An implementation of [DevFSOperations] that speaks to the
/// vm service.
class ServiceProtocolDevFSOperations implements DevFSOperations {
  ServiceProtocolDevFSOperations(this.vmService);

  final VMService vmService;

  @override
  Future<Uri> create(String fsName) async {
    final Map<String, dynamic> response = await vmService.vm.createDevFS(fsName);
    return Uri.parse(response['uri']);
  }

  @override
  Future<dynamic> destroy(String fsName) async {
    await vmService.vm.deleteDevFS(fsName);
  }
}

class DevFSException implements Exception {
  DevFSException(this.message, [this.error, this.stackTrace]);
  final String message;
  final dynamic error;
  final StackTrace stackTrace;
}

class _DevFSHttpWriter {
  _DevFSHttpWriter(this.fsName, VMService serviceProtocol)
    : httpAddress = serviceProtocol.httpAddress;

  final String fsName;
  final Uri httpAddress;

  static const int kMaxInFlight = 6;
  static const int kMaxRetries = 3;

  int _inFlight = 0;
  Map<Uri, DevFSContent> _outstanding;
  Completer<void> _completer;
  final HttpClient _client = HttpClient();

  Future<void> write(Map<Uri, DevFSContent> entries) async {
    _client.maxConnectionsPerHost = kMaxInFlight;
    _completer = Completer<void>();
    _outstanding = Map<Uri, DevFSContent>.from(entries);
    _scheduleWrites();
    await _completer.future;
  }

  void _scheduleWrites() {
    while (_inFlight < kMaxInFlight) {
      if (_outstanding.isEmpty) {
        // Finished.
        break;
      }
      final Uri deviceUri = _outstanding.keys.first;
      final DevFSContent content = _outstanding.remove(deviceUri);
      _scheduleWrite(deviceUri, content);
      _inFlight++;
    }
  }

  Future<void> _scheduleWrite(
    Uri deviceUri,
    DevFSContent content, [
    int retry = 0,
  ]) async {
    try {
      final HttpClientRequest request = await _client.putUrl(httpAddress);
      request.headers.removeAll(HttpHeaders.acceptEncodingHeader);
      request.headers.add('dev_fs_name', fsName);
      request.headers.add('dev_fs_uri_b64',
          base64.encode(utf8.encode(deviceUri.toString())));
      request.add(content.contentsAsCompressedBytes());
      final HttpClientResponse response = await request.close();
      await response.drain<void>();
    } on SocketException catch (socketException, stackTrace) {
      // We have one completer and can get up to kMaxInFlight errors.
      if (!_completer.isCompleted)
        _completer.completeError(socketException, stackTrace);
      return;
    } catch (e) {
      if (retry < kMaxRetries) {
        printTrace('Retrying writing "$deviceUri" to DevFS due to error: $e');
        // Synchronization is handled by the _completer below.
        unawaited(_scheduleWrite(deviceUri, content, retry + 1));
        return;
      } else {
        printError('Error writing "$deviceUri" to DevFS: $e');
      }
    }
    _inFlight--;
    if ((_outstanding.isEmpty) && (_inFlight == 0)) {
      _completer.complete();
    } else {
      _scheduleWrites();
    }
  }
}

// Basic statistics for DevFS update operation.
class UpdateFSReport {
  UpdateFSReport({
    bool success = false,
    int invalidatedSourcesCount = 0,
    int syncedBytes = 0,
  }) {
    _success = success;
    _invalidatedSourcesCount = invalidatedSourcesCount;
    _syncedBytes = syncedBytes;
  }

  bool get success => _success;
  int get invalidatedSourcesCount => _invalidatedSourcesCount;
  int get syncedBytes => _syncedBytes;

  void incorporateResults(UpdateFSReport report) {
    if (!report._success) {
      _success = false;
    }
    _invalidatedSourcesCount += report._invalidatedSourcesCount;
    _syncedBytes += report._syncedBytes;
  }

  bool _success;
  int _invalidatedSourcesCount;
  int _syncedBytes;
}

class DevFS {
  /// Create a [DevFS] named [fsName] for the local files in [rootDirectory].
  DevFS(
    VMService serviceProtocol,
    this.fsName,
    this.rootDirectory, {
    String packagesFilePath,
  }) : _operations = ServiceProtocolDevFSOperations(serviceProtocol),
       _httpWriter = _DevFSHttpWriter(fsName, serviceProtocol),
       _packagesFilePath = packagesFilePath ?? fs.path.join(rootDirectory.path, kPackagesFileName);

  DevFS.operations(
    this._operations,
    this.fsName,
    this.rootDirectory, {
    String packagesFilePath,
  }) : _httpWriter = null,
       _packagesFilePath = packagesFilePath ?? fs.path.join(rootDirectory.path, kPackagesFileName);

  final DevFSOperations _operations;
  final _DevFSHttpWriter _httpWriter;
  final String fsName;
  final Directory rootDirectory;
  String _packagesFilePath;
  final Set<String> assetPathsToEvict = <String>{};
  List<Uri> sources = <Uri>[];
  DateTime lastCompiled;

  Uri _baseUri;
  Uri get baseUri => _baseUri;

  Uri deviceUriToHostUri(Uri deviceUri) {
    final String deviceUriString = deviceUri.toString();
    final String baseUriString = baseUri.toString();
    if (deviceUriString.startsWith(baseUriString)) {
      final String deviceUriSuffix = deviceUriString.substring(baseUriString.length);
      return rootDirectory.uri.resolve(deviceUriSuffix);
    }
    return deviceUri;
  }

  Future<Uri> create() async {
    printTrace('DevFS: Creating new filesystem on the device ($_baseUri)');
    try {
      _baseUri = await _operations.create(fsName);
    } on rpc.RpcException catch (rpcException) {
      // 1001 is kFileSystemAlreadyExists in //dart/runtime/vm/json_stream.h
      if (rpcException.code != 1001)
        rethrow;
      printTrace('DevFS: Creating failed. Destroying and trying again');
      await destroy();
      _baseUri = await _operations.create(fsName);
    }
    printTrace('DevFS: Created new filesystem on the device ($_baseUri)');
    return _baseUri;
  }

  Future<void> destroy() async {
    printTrace('DevFS: Deleting filesystem on the device ($_baseUri)');
    await _operations.destroy(fsName);
    printTrace('DevFS: Deleted filesystem on the device ($_baseUri)');
  }

  /// Updates files on the device.
  ///
  /// Returns the number of bytes synced.
  Future<UpdateFSReport> update({
    @required String mainPath,
    String target,
    AssetBundle bundle,
    DateTime firstBuildTime,
    bool bundleFirstUpload = false,
    @required ResidentCompiler generator,
    String dillOutputPath,
    @required bool trackWidgetCreation,
    bool fullRestart = false,
    String projectRootPath,
    @required String pathToReload,
    @required List<Uri> invalidatedFiles,
  }) async {
    assert(trackWidgetCreation != null);
    assert(generator != null);

    // Update modified files
    final String assetBuildDirPrefix = _asUriPath(getAssetBuildDirectory());
    final Map<Uri, DevFSContent> dirtyEntries = <Uri, DevFSContent>{};

    int syncedBytes = 0;
    if (bundle != null) {
      printTrace('Scanning asset files');
      // We write the assets into the AssetBundle working dir so that they
      // are in the same location in DevFS and the iOS simulator.
      final String assetDirectory = getAssetBuildDirectory();
      bundle.entries.forEach((String archivePath, DevFSContent content) {
        final Uri deviceUri = fs.path.toUri(fs.path.join(assetDirectory, archivePath));
        if (deviceUri.path.startsWith(assetBuildDirPrefix)) {
          archivePath = deviceUri.path.substring(assetBuildDirPrefix.length);
        }
        // Only update assets if they have been modified, or if this is the
        // first upload of the asset bundle.
        if (content.isModified || (bundleFirstUpload && archivePath != null)) {
          dirtyEntries[deviceUri] = content;
          syncedBytes += content.size;
          if (archivePath != null && !bundleFirstUpload) {
            assetPathsToEvict.add(archivePath);
          }
        }
      });
    }
    if (fullRestart) {
      generator.reset();
    }
    printTrace('Compiling dart to kernel with ${invalidatedFiles.length} updated files');
    lastCompiled = DateTime.now();
    final CompilerOutput compilerOutput = await generator.recompile(
      mainPath,
      invalidatedFiles,
      outputPath:  dillOutputPath ?? getDefaultApplicationKernelPath(trackWidgetCreation: trackWidgetCreation),
      packagesFilePath : _packagesFilePath,
    );
    if (compilerOutput == null) {
      return UpdateFSReport(success: false);
    }
    // list of sources that needs to be monitored are in [compilerOutput.sources]
    sources = compilerOutput.sources;
    //
    // Don't send full kernel file that would overwrite what VM already
    // started loading from.
    if (!bundleFirstUpload) {
      final String compiledBinary = compilerOutput?.outputFilename;
      if (compiledBinary != null && compiledBinary.isNotEmpty) {
        final Uri entryUri = fs.path.toUri(projectRootPath != null
          ? fs.path.relative(pathToReload, from: projectRootPath)
          : pathToReload,
        );
        final DevFSFileContent content = DevFSFileContent(fs.file(compiledBinary));
        syncedBytes += content.size;
        dirtyEntries[entryUri] = content;
      }
    }
    printTrace('Updating files');
    if (dirtyEntries.isNotEmpty) {
      try {
        await _httpWriter.write(dirtyEntries);
      } on SocketException catch (socketException, stackTrace) {
        printTrace('DevFS sync failed. Lost connection to device: $socketException');
        throw DevFSException('Lost connection to device.', socketException, stackTrace);
      } catch (exception, stackTrace) {
        printError('Could not update files on device: $exception');
        throw DevFSException('Sync failed', exception, stackTrace);
      }
    }
    printTrace('DevFS: Sync finished');
    return UpdateFSReport(success: true, syncedBytes: syncedBytes,
         invalidatedSourcesCount: invalidatedFiles.length);
  }
}

/// Converts a platform-specific file path to a platform-independent Uri path.
String _asUriPath(String filePath) => fs.path.toUri(filePath).path + '/';
