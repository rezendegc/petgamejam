import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:petgamejam/decorations/barrel.dart';
import 'package:petgamejam/decorations/chest.dart';
import 'package:petgamejam/decorations/chestsw.dart';
import 'package:petgamejam/decorations/map3_ladder.dart';
import 'package:petgamejam/decorations/spike.dart';
import 'package:petgamejam/decorations/torch.dart';
import 'package:petgamejam/enemies/goblin.dart';
import 'package:petgamejam/enemies/slime_blue.dart';
import 'package:petgamejam/enemies/slime_green.dart';
import 'package:petgamejam/enemies/slime_orange.dart';
import 'package:petgamejam/interfaces/mainplayer_interface.dart';
import 'package:petgamejam/joystick.dart';
import 'package:petgamejam/maps/start.dart';
import 'package:petgamejam/npcs/dg_npc_1.dart';
import 'package:petgamejam/npcs/dg_npc_2.dart';
import 'package:petgamejam/npcs/village_npc.dart';
import 'package:petgamejam/npcs/village_npc_2.dart';
import 'package:petgamejam/player.dart';

final initialPositions = [
  Position(0, 0),
  Position(37, 24),
  Position(8, 5),
  Position(8, 5),
  Position(6, 35),
  Position(37, 24),
];

class GameTiledMap extends StatelessWidget {
  final int map;
  const GameTiledMap({Key key, this.map = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        DungeonMap.tileSize = max(constraints.maxHeight, constraints.maxWidth) /
            (kIsWeb ? 25 : 22);

        return BonfireTiledWidget(
          joystick: CustomJoystick(
            keyboardEnable: true,
          ),
          player: MainPlayer(
            Position((initialPositions[map ?? 1].x * DungeonMap.tileSize),
                (initialPositions[map ?? 1].y * DungeonMap.tileSize)),
            showInitDialog: map == null,
            firstDung: map == 2,
          ),
          interface: PlayerInterface(),
          map: TiledWorldMap(
            'tiled/map${map ?? 1}.json',
            forceTileSize: Size(DungeonMap.tileSize, DungeonMap.tileSize),
          )
            ..registerObject(
                'goblin', (x, y, width, height) => Goblin(Position(x, y)))
            ..registerObject(
                'gslime', (x, y, width, height) => SlimeGreen(Position(x, y)))
            ..registerObject(
                'bslime', (x, y, width, height) => SlimeBlue(Position(x, y)))
            ..registerObject(
                'oslime', (x, y, width, height) => SlimeOrange(Position(x, y)))
            ..registerObject(
                'torch', (x, y, width, height) => Torch(Position(x, y)))
            ..registerObject(
                'npc1', (x, y, width, height) => VillageNPC(Position(x, y)))
            ..registerObject(
                'npc2', (x, y, width, height) => VillageNPCTwo(Position(x, y)))
            ..registerObject('dgnpc1',
                (x, y, width, height) => DungeonNPCOne(Position(x, y)))
            ..registerObject('dgnpc2',
                (x, y, width, height) => DungeonNPCTwo(Position(x, y)))
            ..registerObject(
                'lvl3', (x, y, width, height) => MapThreeLadder(Position(x, y)))
            ..registerObject('barrel',
                (x, y, width, height) => BarrelDraggable(Position(x, y)))
            ..registerObject(
                'spike', (x, y, width, height) => Spikes(Position(x, y)))
            ..registerObject(
                'chest', (x, y, width, height) => Chest(Position(x, y)))
            ..registerObject('chestsw2',
                (x, y, width, height) => ChestSword(Position(x, y))),
          background: BackgroundColorGame(Colors.blueGrey[900]),
          lightingColorGame: Colors.black.withOpacity(0.3),
          cameraZoom: 1.0,
        );
      },
    );
  }
}
