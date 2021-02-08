import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';
import 'package:petgamejam/decorations/dungeonEntrance.dart';
import 'package:petgamejam/maps/start.dart';
import 'package:petgamejam/player.dart';

class InitialSword extends GameDecoration with Sensor {
  final Position initPosition;

  InitialSword(this.initPosition)
      : super.sprite(
          Sprite('itens/sword.png'),
          initPosition: initPosition,
          width: DungeonMap.tileSize / 1.5,
          height: DungeonMap.tileSize / 1.5,
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
          "Você agora possui uma espada! Use o botão esquerdo do mouse para atacar os inimigos, porém cuidado com a sua energia...",
          Container(),
        ),
      ],
      finish: () {
        (gameRef.player as MainPlayer).updateMeleeAttack(10);
        (gameRef.player as MainPlayer).updateMaxStamina(50);
        gameRef.addGameComponent(
          DungeonEntrance(
            Position(
              10 * DungeonMap.tileSize,
              36 * DungeonMap.tileSize,
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
