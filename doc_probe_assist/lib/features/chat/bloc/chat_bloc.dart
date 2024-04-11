import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doc_probe_assist/core/exceptions/api_exceptions.dart';
import 'package:doc_probe_assist/features/chat/repository/chat_repository.dart';
import 'package:doc_probe_assist/features/login/repository/login_repository.dart';
import 'package:doc_probe_assist/models/chat_message_model.dart';
import 'package:doc_probe_assist/models/chat_model.dart';
import 'package:doc_probe_assist/models/document_model.dart';
import 'package:doc_probe_assist/models/user_model.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final chatRepository = sl.get<ChatRepository>();
  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) {});
    on<FetchDataEvent>(onFetchDataEvent);
    on<ChatTileClickedEvent>(onChatTileClickedEvent);
    on<NewChatClickedEvent>(onNewChatClickedEvent);
    on<RenameChatOptionClickedEvent>(onRenameChatOptionClickedEvent);
    on<DeleteChatOptionClickedEvent>(onDeleteChatOptionClickedEvent);
    on<ResolveQueryEvent>(onResolveQueryEvent);
    on<LogoutButtonClickedEvent>(onLogoutButtonClickedEvent);
  }

  FutureOr<void> onFetchDataEvent(
      FetchDataEvent event, Emitter<ChatState> emit) async {
    emit(ChatPageLoadingState());
    List<Document> documents = await chatRepository.getAllDocuments();
    UserModel user = await chatRepository.getUser();
    List<ChatModel> chats = await chatRepository.getAllChats();
    emit(ChatPageLoadingSuccessState(
        user: user, chats: chats, documents: documents));
  }

  FutureOr<void> onChatTileClickedEvent(
      ChatTileClickedEvent event, Emitter<ChatState> emit) {
    emit(ChangeChatState(index: event.index));
  }

  FutureOr<void> onNewChatClickedEvent(
      NewChatClickedEvent event, Emitter<ChatState> emit) async {
    try {
      var data = await chatRepository.createChat(event.user.id, event.chatName);
      emit(NewChatCreatedState(
          chat: ChatModel(
              id: data.id,
              chatName: data.chatName,
              chatMessages: [],
              reference: [])));
    } on ApiException catch (e) {
      emit(ChatErrorState(title: e.error[0], message: e.error[1]));
      // print(e.exception.response?.data);
    }
  }

  FutureOr<void> onRenameChatOptionClickedEvent(
      RenameChatOptionClickedEvent event, Emitter<ChatState> emit) async {
    try {
      await chatRepository.updateChatName(event.chat.id, event.newChatName);
      event.chat.chatName = event.newChatName;
      emit(ChatRenameState());
    } on ApiException catch (e) {
      emit(ChatErrorState(title: e.error[0], message: e.error[1]));
    }
  }

  FutureOr<void> onDeleteChatOptionClickedEvent(
      DeleteChatOptionClickedEvent event, Emitter<ChatState> emit) async {
    try {
      await chatRepository.deleteChat(event.chatId);
      emit(ChatDeleteState(index: event.index));
    } on ApiException catch (e) {
      emit(ChatErrorState(title: e.error[0], message: e.error[1]));
    }
  }

  FutureOr<void> onResolveQueryEvent(
      ResolveQueryEvent event, Emitter<ChatState> emit) async {
    emit(NewChatMessageState(
        chatMessage: ChatMessage(
            id: -1,
            query: event.query,
            response: "",
            chatId: event.chatIndex,
            time: "12/12/12",
            loading: true)));
    await Future.delayed(const Duration(seconds: 10), () {
      emit(
        NewChatMessageState(
          chatMessage: ChatMessage(
              id: 3,
              query: event.query,
              response:
                  "Aye Mate DocProbe Assist will be available soon to help you. ",
              chatId: event.chatIndex,
              time: "12/12/12",
              animate: true),
        ),
      );
    });
  }

  FutureOr<void> onLogoutButtonClickedEvent(
      LogoutButtonClickedEvent event, Emitter<ChatState> emit) async {
    await sl.get<LoginRepository>().logout();
    emit(LogoutState());
  }
}
