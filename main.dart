import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter USB Test'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              print('Button pressed!');
            },
            child: const Text('Press me'),
          ),
        ),
      ),
    );
  }
}
