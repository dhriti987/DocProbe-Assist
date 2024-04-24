part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class FetchDataEvent extends ChatEvent {}

// Left Tab Events

class NewChatClickedEvent extends ChatEvent {
  final String chatName;
  final UserModel user;

  NewChatClickedEvent({required this.chatName, required this.user});
}

class ChatTileClickedEvent extends ChatEvent {
  final int index;

  ChatTileClickedEvent({required this.index});
}

class DeleteChatOptionClickedEvent extends ChatEvent {
  final int index;
  final int chatId;

  DeleteChatOptionClickedEvent({required this.index, required this.chatId});
}

class RenameChatOptionClickedEvent extends ChatEvent {
  final ChatModel chat;
  final String newChatName;

  RenameChatOptionClickedEvent({required this.chat, required this.newChatName});
}

class LogoutButtonClickedEvent extends ChatEvent {}

class AdminPanelButtonClickedEvent extends ChatEvent {}

class SettingsButtonClickedEvent extends ChatEvent {}

class AboutUsButtonClickedEvent extends ChatEvent {}

class UploadDocumentButtonClickedEvent extends ChatEvent {
  final Uint8List? file;
  final String name;
  final String fileName;

  UploadDocumentButtonClickedEvent(
      {required this.file, required this.name, required this.fileName});
}

class NewDocumentSelectedEvent extends ChatEvent {
  final Uint8List file;
  final String name;

  NewDocumentSelectedEvent({required this.file, required this.name});
}

// Chat Window Event

class ResolveQueryEvent extends ChatEvent {
  final int chatIndex;
  final String query;
  final int? docId;

  ResolveQueryEvent({required this.chatIndex, required this.query, this.docId});
}

class RegenerateResponseEvent extends ChatEvent {
  final ChatMessage chatMessage;

  RegenerateResponseEvent({required this.chatMessage});
}

class BadResponseEvent extends ChatEvent {}

class ResponseFeedBackEvent extends ChatEvent {}

class FeedbackSubmitEvent extends ChatEvent {
  final int queryId;
  final int rating;
  final String feedback;
  final String expectedResponse;

  FeedbackSubmitEvent(
      {required this.queryId,
      required this.rating,
      required this.feedback,
      required this.expectedResponse});
}

class RatingChangedEvent extends ChatEvent {
  final double rating;

  RatingChangedEvent({required this.rating});
}

// References Tab Events

class ReferenceClickedEvent extends ChatEvent {}
