import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';
import 'package:petgamejam/maps/start.dart';
import 'package:petgamejam/player.dart';

class SecondSword extends GameDecoration with Sensor {
  final Position initPosition;

  SecondSword(this.initPosition)
      : super.sprite(
          Sprite('itens/sword2.png'),
          initPosition: initPosition,
          width: DungeonMap.tileSize / 1.5 * (12 / 15),
          height: DungeonMap.tileSize / 1.5 * (18 / 15),
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
          "Você encontrou uma espada mais forte, o que te deixa muito feliz. Quem diria, era apenas um camponês...",
          Container(),
        ),
      ],
      finish: () {
        (gameRef.player as MainPlayer).updateMeleeAttack(25);
        (gameRef.player as MainPlayer).updateMaxStamina(75);

        gameRef.resume();
        this.remove();
        this.destroy();
      },
    );
  }
}
