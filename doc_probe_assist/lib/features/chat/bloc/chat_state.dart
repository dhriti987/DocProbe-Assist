part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

sealed class ChatActionState extends ChatState {}

final class ChatInitial extends ChatState {}

class ChatPageLoadingState extends ChatState {}

class ChatPageLoadingSuccessState extends ChatState {
  final List<ChatModel> chats;
  final List<Document> documents;
  final List<MyDirectory> dirs;
  final UserModel user;

  ChatPageLoadingSuccessState(
      {required this.chats,
      required this.documents,
      required this.user,
      required this.dirs});
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
  final List<Reference> references;

  NewChatMessageState({required this.chatMessage, required this.references});
}

class RegenerateAnswerState extends ChatState {
  final ChatMessage chatMessage;

  RegenerateAnswerState({required this.chatMessage});
}

class LogoutState extends ChatActionState {}

class ChatErrorState extends ChatActionState {
  final String title;
  final String message;

  ChatErrorState({required this.title, required this.message});
}

class RatingChangedState extends ChatState {
  final double rating;

  RatingChangedState({required this.rating});
}

class ResponseSuccessState extends ChatState {}

class ResponseFailedState extends ChatState {
  final String title;
  final String message;

  ResponseFailedState({required this.title, required this.message});
}

class NewDocumentSelectedState extends ChatActionState {
  final String fileName;
  final Uint8List file;

  NewDocumentSelectedState({required this.fileName, required this.file});
}

class NewDirectorySelectedState extends ChatActionState {
  final int? selectedDirectory;

  NewDirectorySelectedState({required this.selectedDirectory});
}

class UploadDocumentSuccessState extends ChatActionState {}

class UploadDocumentFailedState extends ChatActionState {}

class FeedbackSuccessState extends ChatState {}

class FeedbackFailedState extends ChatState {
  final String message;

  FeedbackFailedState({required this.message});
}
