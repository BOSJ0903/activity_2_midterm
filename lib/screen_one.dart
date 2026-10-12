import 'package:flutter/material.dart';
import 'api_service.dart';
import 'country_model.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({super.key});

  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  late Future<List<Country>> _countriesFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadCountries(); // Fetches data exactly once on load
  }

  void _loadCountries() {
    setState(() {
      _countriesFuture = _apiService.fetchAsianCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asian Countries')),
      body: FutureBuilder<List<Country>>(
        future: _countriesFuture,
        builder: (context, snapshot) {
          // State 1: Showing a spinner while waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          // State 2: Showing an error message and a Retry button
          else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load data.', style: TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _loadCountries,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } 
          // State 3: Showing an "empty" message if the list is blank
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No countries found.'));
          } 
          // State 4: Showing the real data in a list
          else {
            final countries = snapshot.data!;
            return ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.public),
                  title: Text(countries[index].name),
                  subtitle: Text('Capital: ${countries[index].capital}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}