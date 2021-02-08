import 'package:bonfire/bonfire.dart';
import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petgamejam/maps/start.dart';
import 'package:petgamejam/player.dart';
import 'package:petgamejam/utils/common_spirte_sheet.dart';
import 'package:petgamejam/utils/gslime_sprite_sheet.dart';

class SlimeGreen extends SimpleEnemy {
  double attack = 10;

  SlimeGreen(Position initPosition)
      : super(
          animation: GreenSlimeSpriteSheet.simpleDirectionAnimation,
          initPosition: initPosition,
          width: DungeonMap.tileSize * 0.8,
          height: DungeonMap.tileSize * 0.8,
          speed: DungeonMap.tileSize * 1.2,
          life: 50,
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
          radiusVision: DungeonMap.tileSize * 4,
        );
      },
      radiusVision: DungeonMap.tileSize * 4,
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
    (gameRef.player as MainPlayer).kills++;
    remove();
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
      attackEffectBottomAnim: CommonSpriteSheet.blackAttackEffectBottom,
      attackEffectLeftAnim: CommonSpriteSheet.blackAttackEffectLeft,
      attackEffectRightAnim: CommonSpriteSheet.blackAttackEffectRight,
      attackEffectTopAnim: CommonSpriteSheet.blackAttackEffectTop,
    );
  }

  @override
  void receiveDamage(double damage, dynamic from) {
    Flame.audio.play('slime_hit1.wav');
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
