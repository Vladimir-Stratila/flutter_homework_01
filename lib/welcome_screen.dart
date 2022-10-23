import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
              child: const Text(
                'Вітаю!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )
        )
    );
  }
}
