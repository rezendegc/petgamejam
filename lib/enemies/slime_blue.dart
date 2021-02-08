import 'package:bonfire/bonfire.dart';
import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petgamejam/maps/start.dart';
import 'package:petgamejam/player.dart';
import 'package:petgamejam/utils/bslime_sprite_sheet.dart';
import 'package:petgamejam/utils/common_spirte_sheet.dart';

class SlimeBlue extends SimpleEnemy {
  double attack = 15;

  SlimeBlue(Position initPosition)
      : super(
          animation: BlueSlimeSpriteSheet.simpleDirectionAnimation,
          initPosition: initPosition,
          width: DungeonMap.tileSize * 0.8,
          height: DungeonMap.tileSize * 0.8,
          speed: DungeonMap.tileSize * 1.3,
          life: 70,
          collision: Collision(
            height: DungeonMap.tileSize * 0.4,
            width: DungeonMap.tileSize * 0.4,
            align: Offset(
              DungeonMap.tileSize * 0.2,
              DungeonMap.tileSize * 0.4,
            ),
          ),
        );

  @override
  void update(double dt) {
    super.update(dt);
    if (this.isDead) return;
    if (gameRef.isGamePaused) return;

    this.seePlayer(
      observed: (player) {
        this.seeAndMoveToPlayer(
          closePlayer: (player) {
            execAttack();
          },
          radiusVision: DungeonMap.tileSize * 3.5,
        );
      },
      radiusVision: DungeonMap.tileSize * 3.5,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    this.drawDefaultLifeBar(canvas);
  }

  @override
  void die() {
    gameRef.add(
      AnimatedObjectOnce(
        animation: CommonSpriteSheet.smokeExplosion,
        position: position,
      ),
    );
    remove();
    (gameRef.player as MainPlayer).kills++;
    super.die();
  }

  void execAttack() {
    if (gameRef.isGamePaused) return;
    if (gameRef.player != null && gameRef.player.isDead) return;
    this.simpleAttackMelee(
      heightArea: width,
      widthArea: width,
      damage: attack / 2,
      interval: 400,
      withPush: true,
      sizePush: width / 2,
      attackEffectBottomAnim: CommonSpriteSheet.blackAttackEffectBottom,
      attackEffectLeftAnim: CommonSpriteSheet.blackAttackEffectLeft,
      attackEffectRightAnim: CommonSpriteSheet.blackAttackEffectRight,
      attackEffectTopAnim: CommonSpriteSheet.blackAttackEffectTop,
    );
  }

  @override
  void receiveDamage(double damage, dynamic from) {
    this.showDamage(
      damage,
      config: TextConfig(
        fontSize: width / 3,
        color: Colors.white,
      ),
    );
    super.receiveDamage(damage, from);
  }
}
