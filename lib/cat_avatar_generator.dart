library cat_avatar_generator;

import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart';

class Meowatar {
  static Map<int, Image> imageCache = {};
  static Map<int, List<int>> pngCache = {};

  int _seed;

  int _random({max = 128, min = 0}) {
    int v = 16807 * (this._seed % 127773) - 2836 * (this._seed ~/ 127773);
    if (v < 0) v += 2147483647;
    return min + (this._seed = v) % (max - min + 1);
  }

  Future<Image> _getPart(String name, int n) async {
    return decodePng((await rootBundle.load(
            "packages/cat_avatar_generator/assets/avatars/" +
                name +
                "_" +
                n.toString() +
                ".png"))
        .buffer
        .asUint8List());
  }

  Future<Image> draw(int seed) async {
    if (imageCache.containsKey(seed)) return imageCache[seed];

    this._seed = seed;
    Image body = await _getPart("body", _random(min: 1, max: 15));
    Image fur = await _getPart("fur", _random(min: 1, max: 10));
    Image eyes = await _getPart("eyes", _random(min: 1, max: 15));
    Image mouth = await _getPart("mouth", _random(min: 1, max: 10));
    Image accessorie = await _getPart("accessorie", _random(min: 1, max: 20));

    return imageCache[seed] = drawImage(
        drawImage(drawImage(drawImage(body, fur), eyes), mouth), accessorie);
  }

  Future<List<int>> asBytes(int seed) async {
    if (pngCache.containsKey(seed)) return pngCache[seed];
    return pngCache[seed] = encodePng(await draw(seed), level: 0);
  }
}
