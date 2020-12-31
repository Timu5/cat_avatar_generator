# Cat Avatar Generator

Generate awesome cat avatars from mails, names, anything on fly!

## Usage

Add to pubspec.yaml:

```yaml
dependencies:
  cat_avatar_generator: ^0.0.1
```

Add import:
```dart
import 'package:cat_avatar_generator/cat_avatar_generator.dart';
```

Generate avatar:
```dart
  List<int> avatarData;

  void generateAvatar() async {
    Meowatar avatar = Meowatar();
    avatarData = await avatar.asBytes("a@a.com".hashCode);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    generateAvatar();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: avatarData == null ? null : Image.memory(avatarData));
  }
```

## License

Artworks © by [David Revoy](https://www.davidrevoy.com/)

Artworks is licensed under a Creative Commons Attribution 4.0 International License.

Code © by Mateusz Muszyński

Code is licensed under a The 3-Clause BSD License.