import 'package:game_template/src/pixel_adventure/components/collision_block.dart';
import 'package:game_template/src/pixel_adventure/components/player.dart';

bool checkCollision(Player player, CollisionBlock block) {
  final hibox = player.hitbox;
  final playerX = player.position.x + hibox.offsetX;
  final playerY = player.position.y + hibox.offsetY;
  final playerWidth = hibox.width;
  final playerHeigth = hibox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeigth = block.height;

  final fixedX = player.scale.x < 0 ? playerX - hibox.offsetX * 2 - playerWidth : playerX;
  final fixedY = block.isPlatform ? playerY + playerHeigth : playerY;

  return (fixedY < blockY + blockHeigth &&
      //TODO: проверить мб тут надо playerY
      fixedY + playerHeigth > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
