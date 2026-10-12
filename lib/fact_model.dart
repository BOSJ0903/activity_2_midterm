class UselessFact {
  final String text;

  UselessFact({required this.text});

  factory UselessFact.fromJson(Map<String, dynamic> json) {
    return UselessFact(
      text: json['text'] ?? json['fact'] ?? 'No fact found',
    );
  }
}