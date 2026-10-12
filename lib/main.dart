// main.dart
import 'package:flutter/material.dart';
import 'screen_one.dart';
import 'screen_two.dart';

void main() {
  runApp(const MidtermApp());
}

class MidtermApp extends StatelessWidget {
  const MidtermApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Midterm Activity',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CC 105: API Integration')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScreenOne()),
                );
              },
              child: const Text('Open Screen 1 (Future)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScreenTwo()),
                );
              },
              child: const Text('Open Screen 2 (Stream)'),
            ),
          ],
        ),
      ),
    );
  }
}