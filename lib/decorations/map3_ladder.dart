import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/route_manager.dart';
import 'package:petgamejam/game.dart';
import 'package:petgamejam/maps/start.dart';
import 'package:petgamejam/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapThreeLadder extends GameDecoration with Sensor {
  final Position initPosition;
  bool _hasTeleported = false;
  bool _alerted = false;

  MapThreeLadder(this.initPosition)
      : super.sprite(
          Sprite('itens/floor_ladder.png'),
          initPosition: initPosition,
          width: DungeonMap.tileSize,
          height: DungeonMap.tileSize,
        );

  @override
  void onContact(ObjectCollision collision) {
    if (!_alerted && (gameRef.player as MainPlayer).kills < 4) {
      _alerted = true;
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
            "Você ainda não eliminou todos os inimigos da caverna",
            Container(),
          ),
        ],
        finish: () {
          gameRef.resume();
        },
      );
    } else if (!_hasTeleported && (gameRef.player as MainPlayer).kills >= 4) {
      _hasTeleported = true;
      SharedPreferences.getInstance().then((pref) async {
        await pref.setInt('@JAM:MAP', 3);
        Get.to(GameTiledMap(map: 3, life: gameRef.player.life),
            preventDuplicates: false);
      });
    }
  }
}
