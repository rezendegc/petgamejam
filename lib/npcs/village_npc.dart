import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/decoration/decoration.dart';
import 'package:flutter/material.dart';
import 'package:petgamejam/itens/sword.dart';
import 'package:petgamejam/maps/start.dart';

final dialogs = [
  "Que bom que você me encontrou! Qual o seu nome?",
  "Eu me chamo Gabe, sou um morador dessa vila... E quem é você que eu nunca te vi por aqui?",
  "Quem eu sou agora não interessa, mas essa vila corre grandes perigos! Quero saber se você pode me ajudar a defendê-la...",
  "E-eu... Eu nunca fiz nada além de cortar lenha e capinar durante toda minha vida, eu não sei se consigo...",
  "Eu não tenho mais tempo, assim que entrar no calabouço você irá mudar... eu sinto isso em você! Pegue essa espada e vá para o sul, você irá encontrar diversos monstros"
];

class VillageNPC extends GameDecoration {
  bool _isTalking = false;

  VillageNPC(Position initPosition)
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
            gameRef.addGameComponent(InitialSword(this.initPosition));
            this.remove();
            this.destroy();
          },
        );
      }
    }

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
