import 'package:bonfire/bonfire.dart';

class OrangeSlimeSpriteSheet {
  static Animation get idleLeft => Animation.sequenced(
        "enemy/slime_orange.png",
        4,
        textureWidth: 16,
        textureHeight: 24,
      );

  static Animation get idleRight => Animation.sequenced(
        "enemy/slime_orange.png",
        4,
        textureWidth: 16,
        textureHeight: 24,
      );

  static Animation get runRight => Animation.sequenced(
        "enemy/slime_orange.png",
        4,
        textureWidth: 16,
        textureHeight: 24,
      );

  static Animation get runLeft => Animation.sequenced(
        "enemy/slime_orange.png",
        4,
        textureWidth: 16,
        textureHeight: 24,
      );

  static SimpleDirectionAnimation get simpleDirectionAnimation =>
      SimpleDirectionAnimation(
        idleLeft: idleLeft,
        idleRight: idleRight,
        runLeft: runLeft,
        runRight: runRight,
      );
}
