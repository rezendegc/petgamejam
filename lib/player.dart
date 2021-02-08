import 'dart:math';
import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petgamejam/maps/start.dart';
import 'package:petgamejam/utils/common_spirte_sheet.dart';
import 'package:petgamejam/utils/player_sprite_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPlayer extends SimplePlayer with Lighting {
  final Position initPosition;
  double initialLife = 175;
  double meleeAttack = 0;
  double rangedAttack = 0;
  double stamina = 0;
  double maxStamina = 0;
  int kills = 0;
  double initSpeed = DungeonMap.tileSize * 3;
  IntervalTick _timerStamina = IntervalTick(100);
  IntervalTick _timerAttackRange = IntervalTick(100);
  IntervalTick _timerSeeEnemy = IntervalTick(500);
  bool showObserveEnemy = false;
  bool showTalk = false;
  bool initialDialog = false;
  double initialDialogTimer = 0.0;
  double angleRadAttack = 0.0;
  Rect rectDirectionAttack;
  Sprite spriteDirectionAttack;
  bool showDirection = false;
  bool showInitDialog = true;
  bool firstDung = true;

  MainPlayer(this.initPosition,
      {this.showInitDialog, this.firstDung, this.initialLife})
      : super(
          animation: PlayerSpriteSheet.simpleDirectionAnimation,
          width: DungeonMap.tileSize,
          height: DungeonMap.tileSize,
          initPosition: initPosition,
          life: 175,
          speed: DungeonMap.tileSize * 3,
          collision: Collision(
            height: DungeonMap.tileSize / 2,
            width: DungeonMap.tileSize / 1.8,
            align: Offset(DungeonMap.tileSize / 3.5, DungeonMap.tileSize / 2),
          ),
        ) {
    spriteDirectionAttack = Sprite('direction_attack.png');
    lightingConfig = LightingConfig(
      radius: width * 1.5,
      blurBorder: width * 1.5,
    );
    this.life = initialLife ?? this.life;
    SharedPreferences.getInstance().then((prefs) {
      final mAtk = prefs.getDouble('@MATTACK');
      final rAtk = prefs.getDouble('@RATTACK');
      final stm = prefs.getDouble('@STAMINA');
      if (mAtk != null) meleeAttack = mAtk;
      if (rAtk != null) rangedAttack = rAtk;
      if (stm != null) maxStamina = stm;
    });
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    if (isDead || gameRef.isGamePaused) return;

    if (gameRef.joystickController.keyboardEnable) {
      if (event.id == LogicalKeyboardKey.space.keyId) {
        actionAttack();
      }
    }

    if (event.id == kPrimaryMouseButton) {
      Direction direction;
      if (event.radAngle >= -pi / 4 && event.radAngle < pi / 4)
        direction = Direction.right;
      else if (event.radAngle >= pi / 4 && event.radAngle < 3 * pi / 4)
        direction = Direction.bottom;
      else if (event.radAngle >= 3 * pi / 4 || event.radAngle < -3 * pi / 4)
        direction = Direction.left;
      else if (event.radAngle >= -3 * pi / 4 && event.radAngle < -pi / 4)
        direction = Direction.top;
      actionAttack(direction);
    } else if (event.id == kSecondaryMouseButton) {
      angleRadAttack = event.radAngle;
      actionAttackRange();
    }

    if (event.id == 1) {
      if (event.event == ActionEvent.MOVE) {
        showDirection = true;
        angleRadAttack = event.radAngle;
        if (_timerAttackRange.update(dtUpdate)) actionAttackRange();
      }
      if (event.event == ActionEvent.UP) {
        showDirection = false;
        actionAttackRange();
      }
    }

    super.joystickAction(event);
  }

  @override
  void die() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
    });
    remove();
    gameRef.addGameComponent(
      GameDecoration(
        initPosition: Position(
          position.left,
          position.top,
        ),
        height: DungeonMap.tileSize,
        width: DungeonMap.tileSize,
        sprite: Sprite('player/crypt.png'),
      ),
    );
    super.die();
  }

  void actionAttack([Direction direction]) {
    if (stamina < 15 || meleeAttack == 0) return;

    Flame.audio.play('swing.wav');
    decrementStamina(15);
    this.simpleAttackMelee(
      damage: meleeAttack,
      direction: direction,
      animationBottom: CommonSpriteSheet.whiteAttackEffectBottom,
      animationLeft: CommonSpriteSheet.whiteAttackEffectLeft,
      animationRight: CommonSpriteSheet.whiteAttackEffectRight,
      animationTop: CommonSpriteSheet.whiteAttackEffectTop,
      heightArea: DungeonMap.tileSize,
      widthArea: DungeonMap.tileSize,
    );
  }

  void actionAttackRange() {
    if (stamina < 25 || rangedAttack == 0) return;

    Flame.audio.play('fireball.wav');
    decrementStamina(25);
    this.simpleAttackRangeByAngle(
      id: {'ddd': 'kkkkk'},
      animationTop: CommonSpriteSheet.fireBallTop,
      animationDestroy: CommonSpriteSheet.explosionAnimation,
      radAngleDirection: angleRadAttack,
      width: width * 0.7,
      height: width * 0.7,
      maxTravelDistance: DungeonMap.tileSize * 3.5,
      damage: rangedAttack,
      speed: initSpeed * 2,
      collision: Collision(
        width: width / 2,
        height: width / 2,
        align: Offset(width * 0.1, 0),
      ),
      lightingConfig: LightingConfig(
        radius: width * 0.5,
        blurBorder: width,
      ),
    );
  }

  @override
  void update(double dt) {
    if (this.isDead || gameRef?.size == null || gameRef.isGamePaused) return;
    _verifyStamina(dt);

    if (firstDung && _timerSeeEnemy.update(dt) && !showObserveEnemy) {
      this.seeEnemy(
        radiusVision: width * 5,
        notObserved: () {
          showObserveEnemy = false;
        },
        observed: (enemies) {
          showObserveEnemy = true;
          showEmote();
          if (!showTalk) {
            showTalk = true;
            _showTalk(enemies.first);
          }
        },
      );
    }

    if (!initialDialog && showInitDialog) {
      initialDialogTimer += dt;

      if (initialDialogTimer > .2) {
        initialDialog = true;
        gameRef.joystickController
            .joystickChangeDirectional(JoystickDirectionalEvent(
          directional: JoystickMoveDirectional.IDLE,
          intensity: 1.0,
          radAngle: 0.0,
        ));
        gameRef.pause();
        TalkDialog.show(gameRef.context, [
          Say(
            "Mais um dia nessa vila pacata, tomara que hoje seja diferente...",
            Container(
              width: 50,
              height: 50,
              child: AnimationWidget(
                animation: animation.current,
                playing: true,
              ),
            ),
          ),
        ], finish: () {
          gameRef.resume();
        });
      }
    }

    super.update(dt);
  }

  @override
  void render(Canvas c) {
    _drawDirectionAttack(c);
    super.render(c);
  }

  void _verifyStamina(double dt) {
    if (_timerStamina.update(dt) && stamina < maxStamina) {
      stamina += 2;
      if (stamina > maxStamina) {
        stamina = maxStamina;
      }
    }
  }

  void decrementStamina(int i) {
    stamina -= i;
    if (stamina < 0) {
      stamina = 0;
    }
  }

  void updateMeleeAttack(double attack) async {
    this.meleeAttack = attack;
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('@MATTACK', attack);
  }

  void updateRangeAttack(double attack) async {
    this.rangedAttack = attack;
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('@RATTACK', attack);
  }

  void updateMaxStamina(double stamina) async {
    this.maxStamina = stamina;
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('@STAMINA', stamina);
  }

  @override
  void receiveDamage(double damage, dynamic from) {
    this.showDamage(damage,
        config: TextConfig(
          fontSize: width / 3,
          color: Colors.red,
        ));
    super.receiveDamage(damage, from);
  }

  void showEmote() {
    gameRef.add(
      AnimatedFollowerObject(
        animation: CommonSpriteSheet.emote,
        target: this,
        positionFromTarget: Rect.fromLTWH(18, -6, width / 2, height / 2),
      ),
    );
  }

  void _showTalk(Enemy first) {
    gameRef.gameCamera.moveToTargetAnimated(first, zoom: 2, finish: () {
      gameRef.joystickController
          .joystickChangeDirectional(JoystickDirectionalEvent(
        directional: JoystickMoveDirectional.IDLE,
        intensity: 1.0,
        radAngle: 0.0,
      ));
      gameRef.pause();
      TalkDialog.show(gameRef.context, [
        Say(
          "Olha, o meu primeiro inimigo! Espero que dê tudo certo, estou morrendo de medo...",
          Container(
            width: 50,
            height: 50,
            child: AnimationWidget(
              animation: animation.current,
              playing: true,
            ),
          ),
        ),
      ], finish: () {
        gameRef.resume();
        gameRef.gameCamera.moveToPlayerAnimated(finish: () {});
      });
    });
  }

  void _drawDirectionAttack(Canvas c) {
    if (showDirection) {
      double radius = position.height;
      rectDirectionAttack = Rect.fromLTWH(position.center.dx - radius,
          position.center.dy - radius, radius * 2, radius * 2);
      renderSpriteByRadAngle(
        c,
        angleRadAttack,
        rectDirectionAttack,
        spriteDirectionAttack,
      );
    }
  }
}
