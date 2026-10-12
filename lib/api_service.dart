import 'dart:convert';
import 'package:http/http.dart' as http;
import 'country_model.dart';
import 'fact_model.dart';

class ApiService {
  // A 6-second timeout ensures the app throws an error instead of freezing if wifi is off
  static const int timeoutSeconds = 6;

  Future<List<Country>> fetchAsianCountries() async {
    final url = Uri.parse('https://restcountries.com/v3.1/region/asia');
    
    // Calling the API with a timeout
    final response = await http.get(url).timeout(const Duration(seconds: timeoutSeconds));
    
    // Status code 200 means OK
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => Country.fromJson(item)).toList();
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  Future<UselessFact> fetchRandomFact() async {
    final url = Uri.parse('https://uselessfacts.jsph.pl/api/v2/facts/random');
    
    final response = await http.get(url).timeout(const Duration(seconds: timeoutSeconds));
    
    if (response.statusCode == 200) {
      return UselessFact.fromJson(json.decode(response.body));
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}