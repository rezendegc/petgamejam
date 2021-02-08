import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:flame/position.dart';
import 'package:get/route_manager.dart';
import 'package:petgamejam/game.dart';
import 'package:petgamejam/maps/start.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapFourLadder extends GameDecoration with Sensor {
  final Position initPosition;
  bool _hasTeleported = false;

  MapFourLadder(this.initPosition)
      : super.sprite(
          Sprite('itens/floor_ladder.png'),
          initPosition: initPosition,
          width: DungeonMap.tileSize,
          height: DungeonMap.tileSize,
        );

  @override
  void onContact(ObjectCollision collision) {
    if (!_hasTeleported) {
      _hasTeleported = true;
      SharedPreferences.getInstance().then((pref) async {
        await pref.setInt('@JAM:MAP', 4);
        Get.to(GameTiledMap(map: 4), preventDuplicates: false);
      });
    }
  }
}
