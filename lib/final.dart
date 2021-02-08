import 'package:flutter/material.dart';

class FinalScreen extends StatelessWidget {
  const FinalScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[900],
      body: Center(
        child: Text(
          'Muito obrigato por jogar!',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      bottomNavigationBar: Container(
        height: 40,
        child: Center(
          child: Text(
            'Desenvolvido por Gabriel Rezende',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
