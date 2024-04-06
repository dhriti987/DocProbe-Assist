import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doc_probe_assist/features/chat/repository/chat_repository.dart';
import 'package:doc_probe_assist/features/login/repository/login_repository.dart';
import 'package:doc_probe_assist/models/chat_message_model.dart';
import 'package:doc_probe_assist/models/chat_model.dart';
import 'package:doc_probe_assist/models/document_model.dart';
import 'package:doc_probe_assist/models/reference_model.dart';
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
    List<Document> documents = await chatRepository.getDocuments();
    UserModel user = await chatRepository.getUser();
    emit(ChatPageLoadingSuccessState(
        user: user,
        chats: [
          ChatModel(id: 1, chatName: "Chat 1", chatMessages: [
            ChatMessage(
                id: 1,
                query: "Hello how are you?",
                response: "I am Good",
                chatId: 1,
                time: "12/11/23"),
            ChatMessage(
                id: 1,
                query: "How can you assist me?",
                response: "I can you assist you with several type of queries.",
                chatId: 1,
                time: "12/11/23"),
          ], reference: [
            Reference(
                docName: "Document 1",
                pageNumber: 42,
                url: "https://www.clickdimensions.com/links/TestPDFfile.pdf")
          ]),
          ChatModel(id: 2, chatName: "Chat 2", chatMessages: [
            ChatMessage(
                id: 1,
                query: "how can you help me?",
                response:
                    "ayw mate, I can help you with what you need to know.",
                chatId: 2,
                time: "12/11/23")
          ], reference: [
            Reference(
                docName: "Document 2",
                pageNumber: 42,
                url: "https://www.clickdimensions.com/links/TestPDFfile.pdf")
          ])
        ],
        documents: documents));
  }

  FutureOr<void> onChatTileClickedEvent(
      ChatTileClickedEvent event, Emitter<ChatState> emit) {
    emit(ChangeChatState(index: event.index));
  }

  FutureOr<void> onNewChatClickedEvent(
      NewChatClickedEvent event, Emitter<ChatState> emit) {
    emit(NewChatCreatedState(
        chat: ChatModel(
            id: 10,
            chatName: event.chatName,
            chatMessages: [],
            reference: [])));
  }

  FutureOr<void> onRenameChatOptionClickedEvent(
      RenameChatOptionClickedEvent event, Emitter<ChatState> emit) {
    event.chat.chatName = event.newChatName;
    emit(ChatRenameState());
  }

  FutureOr<void> onDeleteChatOptionClickedEvent(
      DeleteChatOptionClickedEvent event, Emitter<ChatState> emit) {
    emit(ChatDeleteState(index: event.index));
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
