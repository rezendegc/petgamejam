import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/decoration/decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:petgamejam/game.dart';
import 'package:petgamejam/itens/staff.dart';
import 'package:petgamejam/maps/start.dart';
import 'package:petgamejam/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dialogs = [
  "Parece que conseguimos deter a maiorias dos monstros, agora eles não devem mais nos incomodar...",
  "Mas.. O q-que? Já?",
  "Vamos voltar para a cidade para conversarmos melhor... Vou teletransportar você para sua casa"
];

class DungeonNPCTwo extends GameDecoration {
  bool _isTalking = false;
  bool _alerted = false;

  DungeonNPCTwo(Position initPosition)
      : super.sprite(
          Sprite('npcs/sensei.png'),
          initPosition: initPosition,
          width: DungeonMap.tileSize,
          height: DungeonMap.tileSize,
          collision: Collision(
            width: DungeonMap.tileSize * 0.6,
            height: DungeonMap.tileSize * 0.8,
            align: Offset(
              DungeonMap.tileSize * 0.2,
              0,
            ),
          ),
        );

  @override
  void update(double dt) {
    Player player = gameRef.player;
    if (!_isTalking && player != null && this.position != null) {
      double radiusVision = DungeonMap.tileSize;
      double vision = radiusVision * 2;

      Rect fieldOfVision = Rect.fromLTWH(
        this.position.center.dx - radiusVision,
        this.position.center.dy - radiusVision,
        vision,
        vision,
      );

      if (fieldOfVision.overlaps(player.rectCollision)) {
        if (!_alerted && (player as MainPlayer).kills < 26) {
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
        } else if ((player as MainPlayer).kills >= 26) {
          gameRef.joystickController
              .joystickChangeDirectional(JoystickDirectionalEvent(
            directional: JoystickMoveDirectional.IDLE,
            intensity: 1.0,
            radAngle: 0.0,
          ));
          _isTalking = true;
          gameRef.pause();
          TalkDialog.show(
            gameRef.context,
            dialogs
                .map(
                  (dialog) => Say(
                    dialog,
                    Transform(
                      transform: Matrix4.rotationY(pi),
                      alignment: Alignment.center,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(dialogs.indexOf(dialog) % 2 == 0
                                ? 'images/npcs/sensei.png'
                                : 'images/player/gabe_idle_left.png'),
                            fit: BoxFit.fill,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    personDirection: dialogs.indexOf(dialog) % 2 == 0
                        ? PersonDirection.RIGHT
                        : PersonDirection.LEFT,
                  ),
                )
                .toList(),
            finish: () {
              gameRef.resume();
              SharedPreferences.getInstance().then((pref) async {
                await pref.setInt('@JAM:MAP', 5);
                Get.to(GameTiledMap(map: 5), preventDuplicates: false);
              });
            },
          );
        }
      }
    }

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
