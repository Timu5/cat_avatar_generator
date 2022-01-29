# Cat Avatar Generator

Generate awesome cat avatars from mails, names, anything on the fly!

<p align="center">
<img src="https://user-images.githubusercontent.com/5563731/103439379-b1394000-4c3c-11eb-8c9f-92ddfb7a2681.png"/>
</p>

## Usage

Add to pubspec.yaml:

```yaml
dependencies:
  cat_avatar_generator: ^0.1.0
```

Add import:
```dart
import 'package:cat_avatar_generator/cat_avatar_generator.dart';
```

Generate avatar:
```dart
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Image(image: MeowatarImage.fromString("a@a.com")));
  }
```

## License

Artworks © by [David Revoy](https://www.davidrevoy.com/)

Artworks is licensed under a Creative Commons Attribution 4.0 International License.

Code © by Mateusz Muszyński

Code is licensed under a The 3-Clause BSD License.
