import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/pixel_adventure/pixel_adventure.dart';

class BackgroundTile extends ParallaxComponent<PixelAdventure> {
  // SpriteComponent with HasGameRef<PixelAdventure> {
  BackgroundTile({this.color = 'Gray', super.position});
  final String color;

  final double scrollspeed = 40;

  @override
  FutureOr<void> onLoad() async {
    priority = -10;
    size = Vector2.all(64);
    parallax = await game.loadParallax(
      [ParallaxImageData('Background/$color.png')],
      baseVelocity: Vector2(0, -scrollspeed),
      repeat: ImageRepeat.repeat,
      fill: LayerFill.none,
    );
    return super.onLoad();
  }

  // final double  scrollspeed = .4;

  // @override
  // FutureOr<void> onLoad() {
  //   priority = -1;
  //   size = Vector2.all(64.6);
  //   sprite = Sprite(game.images.fromCache('Background/$color.png'));
  //   return super.onLoad();
  // }

  // @override
  // void update(double dt) {
  //   position.y += scrollspeed;
  //   double tileSize = 64;
  //   int scrollHeight = (game.size.y / tileSize).floor();
  //   if (position.y > scrollHeight * tileSize) {
  //     position.y = -tileSize;
  //   }
  //   super.update(dt);
  // }
}
