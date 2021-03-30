import 'dart:typed_data';

import 'package:flutter/widgets.dart';

/// Representation of a user image
class Photo {
  final Uint8List _bytes;

  Photo(this._bytes);

  factory Photo.fromMap(Map<dynamic, dynamic> map) =>
      Photo((map['photo'] ?? Uint8List(0)) as Uint8List);

  /// Returns the Image as an [ImageProvider]
  /// See [Image]
  ImageProvider asProvider() => MemoryImage(_bytes);

  /// Returns the Image as an [ResizeImage]
  /// See [Image.memory]
  ImageProvider asResizedProvider({
    double scale = 1.0,
    int? cacheWidth,
    int? cacheHeight,
  }) =>
      ResizeImage.resizeIfNeeded(
          cacheWidth, cacheHeight, MemoryImage(_bytes, scale: scale));

  /// Returns the Image as an [Image]
  /// See [Image.memory]
  Image asWidget({
    double scale = 1.0,
    int? cacheWidth,
    int? cacheHeight,
  }) =>
      Image.memory(
        _bytes,
        scale: scale,
        cacheHeight: cacheHeight,
        cacheWidth: cacheWidth,
      );
}
