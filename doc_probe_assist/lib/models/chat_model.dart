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
}
