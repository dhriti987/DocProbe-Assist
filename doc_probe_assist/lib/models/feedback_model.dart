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
}
