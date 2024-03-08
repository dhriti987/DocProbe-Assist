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
}
