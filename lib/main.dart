import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:flame/effects.dart';

void main() {
  runApp(
    GameWidget(
      game: TiledGame(),
    ),
  );
}

class TiledGame extends FlameGame with KeyboardEvents {
  late TiledComponent mapComponent;

  late Player player;

  TiledGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: 32 * 30,
            height: 32 * 20,
          ),
        );

  @override
  Future<void> onLoad() async {
    camera.viewfinder
      ..zoom = 1
      ..anchor = Anchor.topLeft;

    mapComponent = await TiledComponent.load('map.tmx', Vector2.all(32));
    world.add(mapComponent);

    final playerImage = await images.load('player.png');
    player = Player(size / 2, Sprite(playerImage));
    add(player);
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        // Move the player to the right
        player.moveRight();
      } else if (event.logicalKey == LogicalKeyboardKey.keyA) {
        // Move the player to the left
        player.moveLeft();
      }
    } else if (event is RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyA ||
          event.logicalKey == LogicalKeyboardKey.keyD) {
        // Stop player movement when the key is released
        player.moveStop();
      }
    }
    return KeyEventResult.ignored;
  }
}

class Player extends SpriteComponent with HasGameRef {
  static const playerSpeed = 5;
  static const squareSize = 64.0;
  static const indicatorSize = 6.0;

  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();
  Sprite playerSprite;

  int movement = 0;

  Player(Vector2 position, Sprite player)
      : playerSprite = player,
        super(
          sprite: player,
          position: position,
          size: Vector2.all(squareSize),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    //angle += speed * dt;
    //angle %= 2 * math.pi;
    position.x += movement * playerSpeed;
  }

  void moveLeft() {
    //position.x -= playerSpeed;
    movement = -1;
  }

  void moveRight() {
    movement = 1;
  }

  void moveStop() {
    movement = 0;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //add(this);
  }
}
