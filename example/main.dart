import 'package:flutter/material.dart';
import 'package:cat_avatar_generator/cat_avatar_generator.dart';

void main() {
  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Image(image: MeowatarImage.fromString("a@a.com")));
  }
}
