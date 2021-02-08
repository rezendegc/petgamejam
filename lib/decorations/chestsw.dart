import 'package:bonfire/bonfire.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:petgamejam/itens/potion_life.dart';
import 'package:petgamejam/itens/sword2.dart';
import 'package:petgamejam/maps/start.dart';

class ChestSword extends GameDecoration with TapGesture {
  final Position initPosition;
  bool _observedPlayer = false;

  TextConfig _textConfig;
  ChestSword(this.initPosition)
      : super.animation(
          FlameAnimation.Animation.sequenced(
            "itens/chest_spritesheet.png",
            8,
            textureWidth: 16,
            textureHeight: 16,
          ),
          width: DungeonMap.tileSize * 0.6,
          height: DungeonMap.tileSize * 0.6,
          initPosition: initPosition,
        ) {
    _textConfig = TextConfig(
      color: Colors.white,
      fontSize: width / 2,
    );
  }

  @override
  void update(double dt) {
    this.seePlayer(
      observed: (player) {
        if (!_observedPlayer) {
          _observedPlayer = true;
          _showEmote();
        }
      },
      notObserved: () {
        _observedPlayer = false;
      },
      visionCells: 1,
    );
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_observedPlayer) {
      _textConfig.render(
        canvas,
        'Clique para abrir',
        Position(
            position.left - width / 1.5, position.center.dy - (height + 5)),
      );
    }
  }

  @override
  void onTap() {
    if (_observedPlayer) {
      _addPotions();
      remove();
    }
  }

  void _addPotions() {
    gameRef.addGameComponent(
      SecondSword(
        Position(
          position.left,
          position.bottom,
        ),
      ),
    );

    gameRef.add(
      AnimatedObjectOnce(
        animation: FlameAnimation.Animation.sequenced(
          "smoke_explosin.png",
          6,
          textureWidth: 16,
          textureHeight: 16,
        ),
        position: position,
      ),
    );
  }

  void _showEmote() {
    gameRef.add(
      AnimatedFollowerObject(
        animation: FlameAnimation.Animation.sequenced(
          'player/emote_exclamacao.png',
          8,
          textureWidth: 32,
          textureHeight: 32,
        ),
        target: this,
        positionFromTarget: Rect.fromLTWH(18, -6, 16, 16),
      ),
    );
  }
}
