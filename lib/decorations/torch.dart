import 'package:bonfire/bonfire.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flutter/material.dart';
import 'package:petgamejam/maps/start.dart';

class Torch extends GameDecoration with Lighting {
  Torch(Position position)
      : super.animation(
          FlameAnimation.Animation.sequenced(
            "itens/torch_spritesheet.png",
            6,
            textureWidth: 16,
            textureHeight: 16,
          ),
          width: DungeonMap.tileSize,
          height: DungeonMap.tileSize,
          initPosition: position,
        ) {
    lightingConfig = LightingConfig(
      radius: width * 1.5,
      blurBorder: width * 1.5,
      color: Colors.deepOrangeAccent.withOpacity(0.2),
    );
  }
}
