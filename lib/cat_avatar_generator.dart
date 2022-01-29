library cat_avatar_generator;

import 'dart:typed_data';
import 'dart:ui' as ui show Codec;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;

class Meowatar {
  /// [img.Image] cache.
  static Map<int, img.Image> imageCache = {};

  /// PNG cache.
  static Map<int, List<int>> pngCache = {};

  int _seed = 0;

  int _random({max = 128, min = 0}) {
    int v = 16807 * (this._seed % 127773) - 2836 * (this._seed ~/ 127773);
    if (v < 0) v += 2147483647;
    return min + (this._seed = v) % (max - min + 1);
  }

  Future<img.Image?> _getPart(String name, int n) async {
    return img.decodePng((await rootBundle.load(
            "packages/cat_avatar_generator/assets/avatars/" +
                name +
                "_" +
                n.toString() +
                ".png"))
        .buffer
        .asUint8List());
  }

  /// Convert seed into [img.Image]
  Future<img.Image?> draw(int seed) async {
    if (imageCache.containsKey(seed)) return imageCache[seed];

    this._seed = seed;
    img.Image? body = await (_getPart("body", _random(min: 1, max: 15)));
    img.Image? fur = await (_getPart("fur", _random(min: 1, max: 10)));
    img.Image? eyes = await (_getPart("eyes", _random(min: 1, max: 15)));
    img.Image? mouth = await (_getPart("mouth", _random(min: 1, max: 10)));
    img.Image? accessorie =
        await (_getPart("accessorie", _random(min: 1, max: 20)));

    if (body == null ||
        fur == null ||
        eyes == null ||
        mouth == null ||
        accessorie == null) return null;

    return imageCache[seed] = img.drawImage(
        img.drawImage(img.drawImage(img.drawImage(body, fur), eyes), mouth),
        accessorie);
  }

  /// Generate png as a list of ints from seed value
  Future<List<int>> asBytes(int seed) async {
    var cache = pngCache[seed];
    if (cache != null) {
      return cache;
    }
    var image = await draw(seed);
    if (image != null) {
      return pngCache[seed] = img.encodePng(image, level: 0);
    }
    // return 1x1 transparent image as fallback
    return base64
        .decode(
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=")
        .toList();
  }
}

@immutable
class MeowatarImage extends ImageProvider<MeowatarImage> {
  /// Creates an object that converts seed value into an image.
  const MeowatarImage(this.seed, {this.scale = 1.0});

  /// Creates an object that converts string value into an image.
  MeowatarImage.fromString(String text, {this.scale = 1.0})
      : seed = text.hashCode;

  /// Seed used to generate avatar
  final int seed;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  @override
  Future<MeowatarImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<MeowatarImage>(this);
  }

  @override
  ImageStreamCompleter load(MeowatarImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: 'MeowatarImage(${key.seed})',
    );
  }

  Future<ui.Codec> _loadAsync(MeowatarImage key, DecoderCallback decode) async {
    assert(key == this);
    var data = await Meowatar().asBytes(seed);
    return decode(Uint8List.fromList(data));
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is MeowatarImage && other.seed == seed && other.scale == scale;
  }

  @override
  int get hashCode => hashValues(seed, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'MeowatarImage')}($seed, scale: $scale)';
}
