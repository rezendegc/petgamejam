import 'package:bonfire/bonfire.dart';
import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petgamejam/maps/start.dart';
import 'package:petgamejam/player.dart';
import 'package:petgamejam/utils/common_spirte_sheet.dart';
import 'package:petgamejam/utils/enemy_sprite_sheet.dart';

class Goblin extends SimpleEnemy {
  double attackM = 25;
  double attackR = 20;
  bool _seePlayerClose = false;

  Goblin(Position initPosition)
      : super(
            animation: EnemySpriteSheet.simpleDirectionAnimation,
            initPosition: initPosition,
            width: DungeonMap.tileSize * 0.8,
            height: DungeonMap.tileSize * 0.8,
            speed: DungeonMap.tileSize * 1.6,
            life: 65,
            collision: Collision(
                height: DungeonMap.tileSize * 0.4,
                width: DungeonMap.tileSize * 0.4,
                align: Offset(
                  DungeonMap.tileSize * 0.2,
                  DungeonMap.tileSize * 0.4,
                )));

  @override
  void update(double dt) {
    super.update(dt);
    if (this.isDead) return;

    _seePlayerClose = false;
    this.seePlayer(
      observed: (player) {
        _seePlayerClose = true;
        this.seeAndMoveToPlayer(
          closePlayer: (player) {
            execAttack();
          },
          radiusVision: DungeonMap.tileSize * 3,
        );
      },
      radiusVision: DungeonMap.tileSize * 3,
    );

    if (!_seePlayerClose) {
      this.seeAndMoveToAttackRange(
        minDistanceFromPlayer: DungeonMap.tileSize * 5,
        positioned: (p) {
          execAttackRange();
        },
        radiusVision: DungeonMap.tileSize * 6,
      );
    }
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

  void execAttackRange() {
    if (gameRef.player != null && gameRef.player.isDead) return;
    this.simpleAttackRange(
      animationRight: CommonSpriteSheet.fireBallRight,
      animationLeft: CommonSpriteSheet.fireBallLeft,
      animationTop: CommonSpriteSheet.fireBallTop,
      animationBottom: CommonSpriteSheet.fireBallBottom,
      animationDestroy: CommonSpriteSheet.explosionAnimation,
      id: 35,
      width: width * 0.9,
      height: width * 0.9,
      damage: attackR,
      speed: DungeonMap.tileSize * 3,
      collision: Collision(
        width: width / 2,
        height: width / 2,
        align: Offset(
          width * 0.2,
          width * 0.2,
        ),
      ),
      lightingConfig: LightingConfig(
        radius: width,
        blurBorder: width * 0.5,
      ),
    );
  }

  void execAttack() {
    if (gameRef.player != null && gameRef.player.isDead) return;
    this.simpleAttackMelee(
      heightArea: width,
      widthArea: width,
      damage: attackM / 2,
      interval: 400,
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
