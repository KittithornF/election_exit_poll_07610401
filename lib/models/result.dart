class Result {
  final int number;
  final String title;
  final String fullName;
  final int score;

  Result({
    required this.number,
    required this.title,
    required this.fullName,
    required this.score
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      number: json['number'],
      title: json['title'],
      fullName: json['fullName'],
      score: json['score'],
    );
  }
}