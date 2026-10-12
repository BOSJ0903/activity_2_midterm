// country_model.dart
class Country {
  final String name;
  final String capital;

  Country({required this.name, required this.capital});

  factory Country.fromJson(Map<String, dynamic> json) {
    String countryName = 'Unknown';
    if (json['name'] != null && json['name']['common'] != null) {
      countryName = json['name']['common'];
    }

    String countryCapital = 'No capital';
    if (json['capital'] != null && (json['capital'] as List).isNotEmpty) {
      countryCapital = json['capital'][0];
    }

    return Country(
      name: countryName,
      capital: countryCapital,
    );
  }
}