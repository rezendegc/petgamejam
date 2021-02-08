import 'package:bonfire/bonfire.dart';

class PlayerSpriteSheet {
  static Animation get idleLeft => Animation.sequenced(
        "player/gabe_idle_left.png",
        1,
        textureWidth: 24,
        textureHeight: 24,
      );

  static Animation get idleRight => Animation.sequenced(
        "player/gabe_idle.png",
        1,
        textureWidth: 24,
        textureHeight: 24,
      );

  static Animation get runRight => Animation.sequenced(
        "player/gabe_run.png",
        5,
        textureWidth: 24,
        textureHeight: 24,
      );

  static Animation get runLeft => Animation.sequenced(
        "player/gabe_run_left.png",
        5,
        textureWidth: 24,
        textureHeight: 24,
      ).reversed();

  static SimpleDirectionAnimation get simpleDirectionAnimation =>
      SimpleDirectionAnimation(
        idleLeft: idleLeft,
        idleRight: idleRight,
        runLeft: runLeft,
        runRight: runRight,
      );
}
