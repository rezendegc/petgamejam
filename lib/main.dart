import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:petgamejam/game.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final map = prefs.getInt('@JAM:MAP');
  Flame.bgm.initialize();
  Flame.audio.loadAll([
    'dungeon.mp3',
    'village.mp3',
    'fireball.wav',
    'swing.wav',
    'slime_hit1.wav',
    'slime_hit2.wav',
    'slime_hit3.wav',
    'goblin_hit.wav',
  ]);

  runApp(
    GetMaterialApp(
      home: Menu(map: map),
    ),
  );
}

class Menu extends StatelessWidget {
  final int map;

  const Menu({this.map});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[900],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Bonfire',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                child: Text('Começar Jogo'),
                onPressed: () => Get.to(GameTiledMap(map: map)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
