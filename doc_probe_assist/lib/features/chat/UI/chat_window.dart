import 'package:doc_probe_assist/features/chat/bloc/chat_bloc.dart';
import 'package:doc_probe_assist/features/chat/repository/chat_repository.dart';
import 'package:doc_probe_assist/models/chat_message_model.dart';
import 'package:doc_probe_assist/models/chat_model.dart';
import 'package:doc_probe_assist/models/document_model.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:typewritertext/typewritertext.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.chatBloc,
  });

  final ChatBloc chatBloc;

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    List<ChatModel> chats = [];
    List<ChatMessage> messages = [];
    int? index;
    int? selectedDocument;
    List<Document> documents = [];
    ScrollController scrollController = ScrollController();
    return BlocConsumer<ChatBloc, ChatState>(
      bloc: chatBloc,
      listener: (context, state) {
        if (state is LogoutState) {
          context.go('/');
        }
      },
      builder: (context, state) {
        if (state is ChatPageLoadingSuccessState) {
          chats = List.from(state.chats);
          documents = state.documents;
        } else if (state is ChangeChatState) {
          messages = chats[state.index].chatMessages;
          index = state.index;
        } else if (state is NewChatCreatedState) {
          chats.add(state.chat);
        } else if (state is ChatDeleteState) {
          chats.removeAt(state.index);
        } else if (state is NewChatMessageState) {
          int chatIndex = chats
              .indexWhere((element) => element.id == state.chatMessage.chatId);
          if (state.chatMessage.id != -1) {
            chats[chatIndex].chatMessages[chats[chatIndex]
                .chatMessages
                .indexWhere((element) => element.id == -1)] = state.chatMessage;
          } else {
            chats[chatIndex].chatMessages.add(state.chatMessage);
          }
        }
        Future.delayed(const Duration(milliseconds: 100), () {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        });

        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.1,
              fit: BoxFit.contain,
              image: AssetImage("assets/doc_probe_logo.png"),
            ),
          ),
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 65,
                  ),
                  SizedBox(
                    width: 300,
                    child: DropdownSearch<Document>(
                      popupProps: const PopupProps.menu(
                        fit: FlexFit.loose,
                        showSearchBox: true,
                      ),
                      onChanged: (value) => selectedDocument = value?.id,
                      items: documents,
                      itemAsString: (item) => item.docName,
                      filterFn: (item, filter) {
                        return item.docName.startsWith(filter);
                      },
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            labelText: "Filter by Document",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 1, 49, 121),
                            ),
                            contentPadding: EdgeInsets.zero),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: ListView(
                        controller: scrollController,
                        shrinkWrap: true,
                        children: messages
                            .map((e) => createChatMessageWidget(context, e))
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      // textAlign: TextAlign.center,
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: "Type your Query Here",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            sl.get<ChatRepository>().getAllDocuments();
                            if (index != null) {
                              chatBloc.add(ResolveQueryEvent(
                                  chatIndex: chats[index!].id,
                                  query: textEditingController.text,
                                  docId: selectedDocument));
                              textEditingController.text = "";
                            }
                          },
                          icon: const Icon(Icons.arrow_upward_rounded),
                        ),
                      ),
                      maxLines: 5,
                      minLines: 1,
                    ),
                    Text(
                      "DocProbe Assist isn't flawless. It's wise to verify critical information",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget createChatMessageWidget(
      BuildContext context, ChatMessage chatMessage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 30,
              child: Icon(Icons.person_rounded),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    "User",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Flexible(
                  child: Text(
                    chatMessage.query,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Flexible(
                  child: Text(
                    "\n",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 30,
              child: Image.asset("assets/doc_probe_robo.png"),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    "DocProbe Assist",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Flexible(
                  child: (chatMessage.loading)
                      ? Image.asset(
                          "assets/animations/robo_thinking.gif",
                          height: 100,
                        )
                      : TypeWriterText(
                          text: Text(
                            chatMessage.response,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          duration: const Duration(milliseconds: 1),
                          play: toAnimate(chatMessage),
                        ),
                ),
                Flexible(
                  child: Text(
                    "\n",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ))
          ],
        ),
      ],
    );
  }

  bool toAnimate(ChatMessage chatMessage) {
    var value = chatMessage.animate;
    chatMessage.animate = false;
    return value;
  }
}
