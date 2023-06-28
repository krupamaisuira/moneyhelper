import 'package:flutter/material.dart';

void main() {
  runApp(MyDashboardPage());
}

class MyDashboardPage extends StatefulWidget {
  const MyDashboardPage({super.key});

  @override
  State<MyDashboardPage> createState() => _MyDashboardPageState();
}

class _MyDashboardPageState extends State<MyDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MoneyHelper'),
      ),
      body: Center(
        child: Text(
          'Hello, World!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
