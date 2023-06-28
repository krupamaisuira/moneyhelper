import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
      title: 'MoneyHelper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('MoneyHelper'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Button press logic
            },
            child: Text('Get Started'),
          ),
        ),
      ),
    );
  }
}

