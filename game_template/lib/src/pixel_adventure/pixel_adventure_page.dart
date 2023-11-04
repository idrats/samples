import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/pixel_adventure/pixel_adventure.dart';

class PixelAdventurePage extends StatelessWidget {
  const PixelAdventurePage({super.key});
  static const routeName = 'pixelAdventure';

  @override
  Widget build(BuildContext context) {
    final game = PixelAdventure();
    return Scaffold(
      body: GameWidget(
        game: kReleaseMode ? game : PixelAdventure(),
      ),
    );
  }
}
