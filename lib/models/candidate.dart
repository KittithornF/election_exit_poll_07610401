class Candidate {
  final int number;
  final String title;
  final String fullName;

  Candidate({
    required this.number,
    required this.title,
    required this.fullName,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      number: json['number'],
      title: json['title'],
      fullName: json['fullName'],
    );
  }
}