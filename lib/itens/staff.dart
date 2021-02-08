import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';
import 'package:petgamejam/decorations/map4_ladder.dart';
import 'package:petgamejam/maps/start.dart';
import 'package:petgamejam/player.dart';

class InitialStaff extends GameDecoration with Sensor {
  final Position initPosition;

  InitialStaff(this.initPosition)
      : super.sprite(
          Sprite('itens/staff.png'),
          initPosition: initPosition,
          width: DungeonMap.tileSize / 1.5 * (8 / 15),
          height: DungeonMap.tileSize / 1.5 * (22 / 15),
        );

  @override
  void onContact(ObjectCollision collision) {
    gameRef.joystickController
        .joystickChangeDirectional(JoystickDirectionalEvent(
      directional: JoystickMoveDirectional.IDLE,
      intensity: 1.0,
      radAngle: 0.0,
    ));
    gameRef.pause();
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          "Você agora possui uma varinha mágica! Use o botão direito do mouse para soltar um poder...",
          Container(),
        ),
      ],
      finish: () {
        (gameRef.player as MainPlayer).updateRangeAttack(20);
        (gameRef.player as MainPlayer).updateMaxStamina(60);
        gameRef.addGameComponent(
          MapFourLadder(
            Position(
              12 * DungeonMap.tileSize,
              35 * DungeonMap.tileSize,
            ),
          ),
        );

        gameRef.resume();
        this.remove();
        this.destroy();
      },
    );
  }
}
