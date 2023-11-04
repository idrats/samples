import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game_template/src/pixel_adventure/components/background_tile.dart';
import 'package:game_template/src/pixel_adventure/components/checkpoint.dart';
import 'package:game_template/src/pixel_adventure/components/collision_block.dart';
import 'package:game_template/src/pixel_adventure/components/fruit.dart';
import 'package:game_template/src/pixel_adventure/components/player.dart';
import 'package:game_template/src/pixel_adventure/pixel_adventure.dart';

import 'saw.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  Level({required this.name, required this.player});

  final String name;
  final Player player;
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$name.tmx', Vector2.all(16));

    add(level);

    _scrollingBackground();
    _spawningObjects();
    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');

    if (backgroundLayer != null) {
      final backgrgroundColor = backgroundLayer.properties.getValue('BackgroundColor');

      final backgroundTile = BackgroundTile(
        color: backgrgroundColor ?? 'Gray',
        position: Vector2.zero(),
      );
      add(backgroundTile);
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    if (spawnPointsLayer != null) {
      for (final spawnpoint in spawnPointsLayer.objects) {
        switch (spawnpoint.class_) {
          case 'Player':
            player.position = Vector2(spawnpoint.x, spawnpoint.y);
            player.scale.x = 1;
            add(player);
            break;
          case 'Fruit':
            final fruit = Fruit(
              fruit: spawnpoint.name,
              position: Vector2(spawnpoint.x, spawnpoint.y),
              size: Vector2(spawnpoint.width, spawnpoint.height),
            );
            add(fruit);
            break;
          case 'Saw':
            final offNeg = spawnpoint.properties.getValue('offNeg');
            final offPos = spawnpoint.properties.getValue('offPos');
            final isVertical = spawnpoint.properties.getValue('isVertical');
            final saw = Saw(
              isVerical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnpoint.x, spawnpoint.y),
              size: Vector2(spawnpoint.width, spawnpoint.height),
            );
            add(saw);
            break;
          case 'Checkpoint':
            final checkpoint = Checkpoint(
              position: Vector2(spawnpoint.x, spawnpoint.y),
              size: Vector2(spawnpoint.width, spawnpoint.height),
            );
            add(checkpoint);
            break;

          default:
        }
      }
    }
  }
}
