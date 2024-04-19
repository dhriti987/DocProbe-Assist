class FeedBackModel {
  final String question;
  final String answer;
  final String username;
  final bool isGood;
  final String feedback;
  final String date;
  final int rating;

  FeedBackModel(
      {required this.question,
      required this.answer,
      required this.username,
      required this.isGood,
      required this.feedback,
      required this.date,
      this.rating = 0});

  factory FeedBackModel.fromJson(Map<String, dynamic> json) {
    return FeedBackModel(
      question: json['question'],
      answer: json['answer'],
      username: json['username'] ?? 'Anonymous',
      isGood: json['isGood'] ?? false,
      feedback: json['feedback'] ?? '',
      date: json['date'] ?? '',
      rating: json['rating'] ?? 0,
    );
  }

  static List<FeedBackModel> listFromJson(List<dynamic> data) =>
      List.from(data.map((e) => FeedBackModel.fromJson(e)));
}
