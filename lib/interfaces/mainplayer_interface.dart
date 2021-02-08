import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:petgamejam/interfaces/life_bar_component.dart';

class PlayerInterface extends GameInterface {
  @override
  void resize(Size size) {
    add(BarLifeComponent());
    super.resize(size);
  }
}
