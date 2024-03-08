part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class FetchDataEvent extends ChatEvent {}

// Left Tab Events

class NewChatClickedEvent extends ChatEvent {
  final String chatName;

  NewChatClickedEvent({required this.chatName});
}

class ChatTileClickedEvent extends ChatEvent {
  final int index;

  ChatTileClickedEvent({required this.index});
}

class DeleteChatOptionClickedEvent extends ChatEvent {
  final int index;

  DeleteChatOptionClickedEvent({required this.index});
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

// Chat Window Event

class ResolveQueryEvent extends ChatEvent {
  final int chatIndex;
  final String query;
  final int? docId;

  ResolveQueryEvent({required this.chatIndex, required this.query, this.docId});
}

class RegenerateResponseEvent extends ChatEvent {}

class GoodResponseEvent extends ChatEvent {}

class BadResponseEvent extends ChatEvent {}

class ResponseFeedBackEvent extends ChatEvent {}

// References Tab Events

class ReferenceClickedEvent extends ChatEvent {}
