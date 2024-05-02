import 'package:doc_probe_assist/features/chat/bloc/chat_bloc.dart';
import 'package:doc_probe_assist/models/chat_message_model.dart';
import 'package:doc_probe_assist/models/chat_model.dart';
import 'package:doc_probe_assist/models/document_model.dart';
// import 'package:doc_probe_assist/models/user_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
    bool sendChat = true;

    // UserModel? user;
    return BlocConsumer<ChatBloc, ChatState>(
      bloc: chatBloc,
      listener: (context, state) {
        if (state is LogoutState) {
          context.go('/');
        }
        if (state is FeedbackSuccessState) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('Feedback successfully added.'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Ok',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 10),
                        ))
                  ],
                );
              });
        }
        if (state is FeedbackFailedState) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(state.message),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Ok',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 10),
                        ))
                  ],
                );
              });
        }
      },
      builder: (context, state) {
        if (state is ChatPageLoadingSuccessState) {
          chats = List.from(state.chats);
          documents = state.documents;
          // user = state.user;
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
            sendChat = true;
          } else {
            chats[chatIndex].chatMessages.add(state.chatMessage);
          }
          print(chats[chatIndex].chatMessages.length);
        } else if (state is RegenerateAnswerState) {
          int chatIndex = chats
              .indexWhere((element) => element.id == state.chatMessage.chatId);
          chats[chatIndex].chatMessages[chats[chatIndex]
                  .chatMessages
                  .indexWhere(
                      (element) => element.id == state.chatMessage.id)] =
              state.chatMessage;
        }
        Future.delayed(const Duration(milliseconds: 50), () {
          scrollController.animateTo(
              scrollController.position.maxScrollExtent * 2,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        });

        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.05,
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
                            .map((e) =>
                                createChatMessageWidget(context, e, chatBloc))
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      readOnly: !sendChat,
                      focusNode: FocusNode(
                        onKeyEvent: (FocusNode node, KeyEvent evt) {
                          final shiftWithEnter = evt is KeyDownEvent &&
                              evt.physicalKey == PhysicalKeyboardKey.enter &&
                              HardwareKeyboard.instance.isShiftPressed;
                          print(HardwareKeyboard.instance.isShiftPressed);
                          if (shiftWithEnter) {
                            if (index != null &&
                                sendChat &&
                                textEditingController.text.isNotEmpty) {
                              chatBloc.add(ResolveQueryEvent(
                                  chatIndex: chats[index!].id,
                                  query: textEditingController.text,
                                  docId: selectedDocument));
                              textEditingController.text = "";
                              sendChat = false;
                            }
                            return KeyEventResult.handled;
                          }
                          return KeyEventResult.ignored;
                        },
                      ),
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: "Type your Query Here",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            print(index);
                            if (index != null &&
                                sendChat &&
                                textEditingController.text.isNotEmpty) {
                              chatBloc.add(ResolveQueryEvent(
                                  chatIndex: chats[index!].id,
                                  query: textEditingController.text,
                                  docId: selectedDocument));
                              textEditingController.text = "";
                              sendChat = false;
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
      BuildContext context, ChatMessage chatMessage, ChatBloc chatBloc) {
    TextEditingController feedbackEditingController = TextEditingController();
    TextEditingController expectedResponseEditingController =
        TextEditingController();

    double _rating = 3;
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
                  child: SelectableText(
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
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TypeWriterText(
                              maintainSize: false,
                              alignment: Alignment.topLeft,
                              text: Text(
                                chatMessage.response,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              duration: Duration(microseconds: 1),
                              play: toAnimate(chatMessage),
                            ),
                            Row(children: [
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text: chatMessage.response));
                                },
                                icon: Icon(Icons.copy_rounded),
                                iconSize: 20,
                              ),
                              SizedBox(
                                width: 15,
                                height: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  chatBloc.add(RegenerateResponseEvent(
                                      chatMessage: chatMessage));
                                },
                                iconSize: 20,
                                icon: Icon(
                                  Icons.replay_rounded,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                                height: 10,
                              ),
                              IconButton(
                                  iconSize: 20,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Feedback"),
                                          content: SizedBox(
                                            width: 300,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                RatingBar.builder(
                                                  initialRating: _rating,
                                                  itemCount: 5,
                                                  itemBuilder:
                                                      (context, index) {
                                                    switch (index) {
                                                      case 0:
                                                        return Icon(
                                                          Icons
                                                              .sentiment_very_dissatisfied,
                                                          color: Colors.red,
                                                        );
                                                      case 1:
                                                        return Icon(
                                                          Icons
                                                              .sentiment_dissatisfied,
                                                          color:
                                                              Colors.redAccent,
                                                        );
                                                      case 2:
                                                        return Icon(
                                                          Icons
                                                              .sentiment_neutral,
                                                          color: Colors.amber,
                                                        );
                                                      case 3:
                                                        return Icon(
                                                          Icons
                                                              .sentiment_satisfied,
                                                          color:
                                                              Colors.lightGreen,
                                                        );
                                                      case 4:
                                                        return Icon(
                                                          Icons
                                                              .sentiment_very_satisfied,
                                                          color: Colors.green,
                                                        );
                                                    }

                                                    return Text('');
                                                  },
                                                  onRatingUpdate: (rating) {
                                                    chatBloc.add(
                                                        RatingChangedEvent(
                                                            rating: rating));
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        "Enter feedback:",
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  maxLines: 5,
                                                  controller:
                                                      feedbackEditingController,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                BlocBuilder(
                                                  bloc: chatBloc,
                                                  builder: (context, state) {
                                                    if (state
                                                        is RatingChangedState) {
                                                      _rating = state.rating;
                                                    }
                                                    if (_rating < 4) {
                                                      return TextField(
                                                        textAlign:
                                                            TextAlign.start,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Enter Expected Response:",
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        maxLines: 5,
                                                        controller:
                                                            expectedResponseEditingController,
                                                      );
                                                    }
                                                    return SizedBox();
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  chatBloc.add(FeedbackSubmitEvent(
                                                      queryId: chatMessage.id,
                                                      rating: (_rating).toInt(),
                                                      feedback:
                                                          feedbackEditingController
                                                              .text,
                                                      expectedResponse:
                                                          expectedResponseEditingController
                                                              .text));

                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Submit")),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Cancel")),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.feedback_rounded))
                            ]),
                          ],
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
