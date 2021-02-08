import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:flame/position.dart';
import 'package:petgamejam/maps/start.dart';

class Spikes extends GameDecoration with Sensor {
  final Position initPosition;
  Timer timer;

  bool isTick = false;

  Spikes(this.initPosition)
      : super.sprite(
          Sprite('itens/spikes.png'),
          initPosition: initPosition,
          width: DungeonMap.tileSize / 1.5,
          height: DungeonMap.tileSize / 1.5,
        );

  @override
  void onContact(ObjectCollision collision) {
    if (timer == null) {
      if (collision is Attackable) {
        (collision as Attackable).receiveDamage(10, 1);
        timer = Timer(Duration(milliseconds: 500), () {
          timer = null;
        });
      }
    }
  }
}
