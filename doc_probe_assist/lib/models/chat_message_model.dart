class ChatMessage {
  final int id;
  final String query;
  final String response;
  final int chatId;
  final String time;
  bool loading;
  bool animate;

  ChatMessage({
    required this.id,
    required this.query,
    required this.response,
    required this.chatId,
    required this.time,
    this.loading = false,
    this.animate = false,
  });
  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
      id: json['id'],
      query: json['question'],
      response: json['response'],
      chatId: json['chat'],
      time: json['time']);

  static List<ChatMessage> listFromJson(List<dynamic> data) =>
      List.from(data.map((e) => ChatMessage.fromJson(e)));
}
