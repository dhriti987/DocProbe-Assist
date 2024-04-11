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
