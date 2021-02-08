import 'package:bonfire/bonfire.dart';
import 'package:bonfire/decoration/decoration.dart';
import 'package:flutter/material.dart';
import 'package:petgamejam/maps/start.dart';

class BarrelDraggable extends GameDecoration with DragGesture {
  TextConfig _textConfig;
  BarrelDraggable(Position initPosition)
      : super.sprite(
          Sprite('itens/barrel.png'),
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
        ) {
    _textConfig = TextConfig(color: Colors.white, fontSize: width / 4);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _textConfig.render(
      canvas,
      'Drag',
      Position(this.position.left + width / 5, this.position.top - width / 3),
    );
  }
}
