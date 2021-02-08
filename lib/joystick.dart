import 'dart:math';

import 'package:bonfire/base/rpg_game.dart';
import 'package:bonfire/joystick/joystick_action.dart';
import 'package:bonfire/joystick/joystick_controller.dart';
import 'package:bonfire/joystick/joystick_directional.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum DIRECTIONS {
  DOWN,
  LEFT,
  RIGHT,
  UP,
}

class CustomJoystick extends JoystickController {
  final List<JoystickAction> actions;
  final JoystickDirectional directional;
  final bool keyboardEnable;
  final _pressedDirections = [false, false, false, false];

  CustomJoystick({
    this.actions,
    this.directional,
    this.keyboardEnable = false,
  });

  void initialize(Size size) async {
    if (directional != null) directional.initialize(size, this);
    if (actions != null)
      actions.forEach((action) => action.initialize(size, this));
  }

  void addAction(JoystickAction action) {
    if (actions != null && gameRef?.size != null) {
      action.initialize(gameRef.size, this);
      actions.add(action);
    }
  }

  void removeAction(dynamic actionId) {
    if (actions != null)
      actions.removeWhere((action) => action.actionId == actionId);
  }

  void render(Canvas canvas) {
    if (directional != null) directional.render(canvas);
    if (actions != null) actions.forEach((action) => action.render(canvas));
  }

  void update(double t) {
    if (gameRef.isGamePaused) {
      _pressedDirections[0] = false;
      _pressedDirections[1] = false;
      _pressedDirections[2] = false;
      _pressedDirections[3] = false;
      joystickChangeDirectional(
        JoystickDirectionalEvent(
          directional: JoystickMoveDirectional.IDLE,
          intensity: 1.0,
          radAngle: 0.0,
        ),
      );
      return;
    }
    if (directional != null) directional.update(t);
    if (actions != null) actions.forEach((action) => action.update(t));
  }

  @override
  void resize(Size size) {
    initialize(size);
    super.resize(size);
  }

  void onPointerDown(PointerDownEvent event) {
    if (gameRef.isGamePaused) return;
    if (directional != null)
      directional.directionalDown(event.pointer, event.localPosition);
    if (actions != null)
      actions.forEach(
          (action) => action.actionDown(event.pointer, event.localPosition));

    final rpgGameRef = gameRef as RPGGame;
    if (rpgGameRef.player != null) {
      final playerPosition = rpgGameRef.gameCamera
          .worldPositionToScreen(rpgGameRef.player.position.center);
      final pointerPosition = event.localPosition;
      joystickAction(
        JoystickActionEvent(
          id: event.buttons,
          radAngle: atan2(
            pointerPosition.dy - playerPosition.dy,
            pointerPosition.dx - playerPosition.dx,
          ),
        ),
      );
    }
  }

  void onPointerMove(PointerMoveEvent event) {
    if (actions != null)
      actions.forEach(
          (action) => action.actionMove(event.pointer, event.localPosition));
    if (directional != null)
      directional.directionalMove(event.pointer, event.localPosition);
  }

  void onPointerUp(PointerUpEvent event) {
    if (actions != null)
      actions.forEach((action) => action.actionUp(event.pointer));

    if (directional != null) directional.directionalUp(event.pointer);
  }

  void onPointerCancel(PointerCancelEvent event) {
    if (actions != null)
      actions.forEach((action) => action.actionUp(event.pointer));
    if (directional != null) directional.directionalUp(event.pointer);
  }

  JoystickMoveDirectional _moveDirectional() {
    if (_pressedDirections[DIRECTIONS.UP.index] &&
        _pressedDirections[DIRECTIONS.RIGHT.index]) {
      return JoystickMoveDirectional.MOVE_UP_RIGHT;
    } else if (_pressedDirections[DIRECTIONS.UP.index] &&
        _pressedDirections[DIRECTIONS.LEFT.index]) {
      return JoystickMoveDirectional.MOVE_UP_LEFT;
    } else if (_pressedDirections[DIRECTIONS.DOWN.index] &&
        _pressedDirections[DIRECTIONS.LEFT.index]) {
      return JoystickMoveDirectional.MOVE_DOWN_LEFT;
    } else if (_pressedDirections[DIRECTIONS.DOWN.index] &&
        _pressedDirections[DIRECTIONS.RIGHT.index]) {
      return JoystickMoveDirectional.MOVE_DOWN_RIGHT;
    } else if (_pressedDirections[DIRECTIONS.UP.index]) {
      return JoystickMoveDirectional.MOVE_UP;
    } else if (_pressedDirections[DIRECTIONS.DOWN.index]) {
      return JoystickMoveDirectional.MOVE_DOWN;
    } else if (_pressedDirections[DIRECTIONS.RIGHT.index]) {
      return JoystickMoveDirectional.MOVE_RIGHT;
    } else if (_pressedDirections[DIRECTIONS.LEFT.index]) {
      return JoystickMoveDirectional.MOVE_LEFT;
    }

    return JoystickMoveDirectional.IDLE;
  }

  @override
  void onKeyboard(RawKeyEvent event) {
    if (!keyboardEnable || gameRef.isGamePaused) return;

    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.keyS) {
        _pressedDirections[DIRECTIONS.DOWN.index] = true;
        joystickChangeDirectional(JoystickDirectionalEvent(
          directional: _moveDirectional(),
          intensity: 1.0,
          radAngle: 0.0,
        ));
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.keyW) {
        _pressedDirections[DIRECTIONS.UP.index] = true;
        joystickChangeDirectional(JoystickDirectionalEvent(
          directional: _moveDirectional(),
          intensity: 1.0,
          radAngle: 0.0,
        ));
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.keyA) {
        _pressedDirections[DIRECTIONS.LEFT.index] = true;
        joystickChangeDirectional(JoystickDirectionalEvent(
          directional: _moveDirectional(),
          intensity: 1.0,
          radAngle: 0.0,
        ));
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.keyD) {
        _pressedDirections[DIRECTIONS.RIGHT.index] = true;
        joystickChangeDirectional(JoystickDirectionalEvent(
          directional: _moveDirectional(),
          intensity: 1.0,
          radAngle: 0.0,
        ));
      }

      joystickAction(JoystickActionEvent(
        id: event.logicalKey.keyId,
      ));
    } else if (event is RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.keyS) {
        _pressedDirections[DIRECTIONS.DOWN.index] = false;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.keyA) {
        _pressedDirections[DIRECTIONS.LEFT.index] = false;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.keyD) {
        _pressedDirections[DIRECTIONS.RIGHT.index] = false;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.keyW) {
        _pressedDirections[DIRECTIONS.UP.index] = false;
      }
      joystickChangeDirectional(JoystickDirectionalEvent(
        directional: _moveDirectional(),
        intensity: 0.0,
        radAngle: 0.0,
      ));
    }
  }
}
