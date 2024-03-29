part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

sealed class ChatActionState extends ChatState {}

final class ChatInitial extends ChatState {}

class ChatPageLoadingState extends ChatState {}

class ChatPageLoadingSuccessState extends ChatState {
  final List<ChatModel> chats;
  final List<Document> documents;

  ChatPageLoadingSuccessState({required this.chats, required this.documents});
}

class ChatPageLoadingFailedState extends ChatState {}

class ChangeChatState extends ChatState {
  final int index;

  ChangeChatState({required this.index});
}

class NewChatCreatedState extends ChatState {
  final ChatModel chat;

  NewChatCreatedState({required this.chat});
}

class ChatDeleteState extends ChatState {
  final int index;

  ChatDeleteState({required this.index});
}

class ChatRenameState extends ChatState {}

class NewChatMessageState extends ChatState {
  final ChatMessage chatMessage;

  NewChatMessageState({required this.chatMessage});
}
