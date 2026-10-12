import 'dart:async';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'fact_model.dart';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({super.key});

  @override
  _ScreenTwoState createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  final ApiService _apiService = ApiService();
  
  // A StreamController lets us manually push data or errors into our stream
  final StreamController<UselessFact> _streamController = StreamController<UselessFact>();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startFetchingFacts();
  }

  void _startFetchingFacts() {
    // 1. Fetch immediately when the screen opens
    _fetchSingleFact();
    
    // 2. Set up a repeating timer to fetch a new fact every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchSingleFact();
    });
  }

  Future<void> _fetchSingleFact() async {
    try {
      final newFact = await _apiService.fetchRandomFact();
      if (!_streamController.isClosed) {
        _streamController.add(newFact); // Push the successful data to the screen
      }
    } catch (error) {
      if (!_streamController.isClosed) {
        // Push the error to the screen, but DO NOT stop the timer
        // This ensures the stream survives the airplane-mode test
        _streamController.addError(error); 
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Always clean up your timers and streams when leaving the screen
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Random Facts Belt')),
      body: StreamBuilder<UselessFact>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          // State 1: Loading state before the first fact arrives
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          // State 2: Error state if the device goes offline
          else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Network error. Waiting for next fact...\n(The belt is still running!)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[700], fontSize: 16),
                ),
              ),
            );
          } 
          // State 3: Displaying the changing data
          else if (snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lightbulb_outline, size: 50, color: Colors.orange),
                    const SizedBox(height: 20),
                    Text(
                      snapshot.data!.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 40),
                    const CircularProgressIndicator(strokeWidth: 2), 
                    const SizedBox(height: 10),
                    const Text('Next fact on the way...', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data yet.'));
          }
        },
      ),
    );
  }
}