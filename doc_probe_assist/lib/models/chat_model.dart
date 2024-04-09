import 'package:doc_probe_assist/models/chat_message_model.dart';
import 'package:doc_probe_assist/models/reference_model.dart';

class ChatModel {
  final int id;
  String chatName;
  final List<ChatMessage> chatMessages;
  final List<Reference> reference;

  ChatModel({
    required this.id,
    required this.chatName,
    required this.chatMessages,
    required this.reference,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
      id: json['id'],
      chatName: json['name'],
      chatMessages: ChatMessage.listFromJson(json['queries']),
      reference: Reference.listFromJson(json['reference']));

  static List<ChatModel> listFromJson(List<dynamic> data) =>
      List.from(data.map((e) => ChatModel.fromJson(e)));
}
