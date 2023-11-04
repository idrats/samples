import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:game_template/src/pixel_adventure/components/jump_button.dart';
import 'package:game_template/src/pixel_adventure/components/player.dart';
import 'package:game_template/src/pixel_adventure/components/level.dart';

class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late CameraComponent cam;
  Player player = Player(character: 'Ninja Frog');
  bool showControls = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  late JoystickComponent joystick;
  List<String> levelNames = ['level-1', 'level-1'];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    //Загрузка в кеш всех изображений
    await images.loadAllImages();
    _loadLevel();

    if (showControls) {
      addJoystick();
      await Future.delayed(const Duration(milliseconds: 100), () => add(JumpButton()));
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('buttons/Knob.png')),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('buttons/Joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel() {
    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      //TODO: go to WinGameScreen
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(
        name: levelNames[currentLevelIndex],
        player: player,
      );
      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 640,
        height: 368,
      );
      cam.viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);
    });
  }
}
