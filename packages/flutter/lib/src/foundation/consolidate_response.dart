// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Signature for getting notified when chunks of bytes are received while
/// consolidating the bytes of an [HttpClientResponse] into a [Uint8List].
///
/// The `cumulative` parameter will contain the total number of bytes received
/// thus far.
///
/// The `total` parameter will contain the _expected_ total number of bytes to
/// be received (extracted from the value of the `Content-Length` HTTP response
/// header), or -1 if the size of the response body is not known in advance.
///
/// This is used in [consolidateHttpClientResponseBytes].
typedef BytesReceivedCallback = void Function(int cumulative, int total);

/// Efficiently converts the response body of an [HttpClientResponse] into a
/// [Uint8List].
///
/// The future returned will forward all errors emitted by [response].
///
/// The [onBytesReceived] callback, if specified, will be invoked for every
/// chunk of bytes that are received while consolidating the response bytes.
/// For more information on how to interpret the parameters to the callback,
/// see the documentation on [BytesReceivedCallback].
///
/// If the [response] is gzipped, this will automatically un-compress the
/// bytes in the returned list (whether this was done automatically via
/// [HttpClient.autoUncompress] or not).
// TODO(tvolkert): Remove the [client] param once https://github.com/dart-lang/sdk/issues/36971 is fixed.
Future<Uint8List> consolidateHttpClientResponseBytes(
  HttpClient client,
  HttpClientResponse response, {
  BytesReceivedCallback onBytesReceived,
}) {
  final Completer<Uint8List> completer = Completer<Uint8List>.sync();

  final _OutputBuffer output = _OutputBuffer();
  ByteConversionSink sink = output;
  int expectedContentLength = response.contentLength;
  if (response.headers?.value(HttpHeaders.contentEncodingHeader) == 'gzip') {
    if (client.autoUncompress) {
      // response.contentLength will not match our bytes stream, so we declare
      // that we don't know the expected content length.
      expectedContentLength = -1;
    } else {
      // We need to un-compress the bytes as they come in.
      sink = gzip.decoder.startChunkedConversion(output);
    }
  }

  int bytesReceived = 0;
  response.listen((List<int> chunk) {
    sink.add(chunk);
    if (onBytesReceived != null) {
      bytesReceived += chunk.length;
      onBytesReceived(bytesReceived, expectedContentLength);
    }
  }, onDone: () {
    sink.close();
    completer.complete(output.bytes);
  }, onError: completer.completeError, cancelOnError: true);

  return completer.future;
}

class _OutputBuffer extends ByteConversionSinkBase {
  List<List<int>> _chunks = <List<int>>[];
  int _contentLength = 0;
  Uint8List _bytes;

  @override
  void add(List<int> chunk) {
    assert(_bytes == null);
    _chunks.add(chunk);
    _contentLength += chunk.length;
  }

  @override
  void close() {
    if(_bytes != null) {
      // We've already been closed; this is a no-op
      return;
    }
    _bytes = Uint8List(_contentLength);
    int offset = 0;
    for (List<int> chunk in _chunks) {
      _bytes.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    _chunks = null;
  }

  Uint8List get bytes {
    assert(_bytes != null);
    return _bytes;
  }
}
