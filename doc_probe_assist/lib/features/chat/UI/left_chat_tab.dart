import 'package:doc_probe_assist/features/chat/bloc/chat_bloc.dart';
import 'package:doc_probe_assist/models/chat_model.dart';
import 'package:doc_probe_assist/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LeftChatTab extends StatelessWidget {
  LeftChatTab({
    super.key,
    required this.chatBloc,
  });

  final ChatBloc chatBloc;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<ChatModel> chats = [];
    UserModel? user;
    return BlocConsumer<ChatBloc, ChatState>(
      bloc: chatBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ChatPageLoadingSuccessState) {
          chats = List.from(state.chats);
          user = state.user;
        } else if (state is NewChatCreatedState) {
          chats.add(state.chat);
        } else if (state is ChatDeleteState) {
          chats.removeAt(state.index);
        }
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x990B74B0),
                Color(0x9975479C),
                Color(0x99BD3861),
              ],
            ),
          ),
          child: Column(
            children: [
              UserWidget(
                name: user?.name ?? "Unknown User",
                isAdmin: user?.isAdmin ?? false,
                onLogout: () => chatBloc.add(LogoutButtonClickedEvent()),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("New Chat"),
                        content: SizedBox(
                          width: 300,
                          child: TextField(
                            controller: textEditingController,
                            decoration: const InputDecoration(
                              labelText: "Enter Chat Name:",
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                chatBloc.add(NewChatClickedEvent(
                                    chatName: textEditingController.text,
                                    user: user!));
                                textEditingController.text = "";
                                Navigator.of(context).pop();
                              },
                              child: const Text("Create")),
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
                child: ListTile(
                  title: Text(
                    "New Chat",
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  trailing: const Icon(Icons.chat),
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatTile(
                    chat: chats[index],
                    chatBloc: chatBloc,
                    index: index,
                  );
                },
                itemCount: chats.length,
              ),
              const Spacer(),
              SizedBox(
                height: 65,
                child: Image.asset("assets/acoe_logo.png"),
              ),
            ],
          ),
        );
      },
    );
  }
}

class UserWidget extends StatelessWidget {
  const UserWidget(
      {super.key,
      required this.name,
      required this.isAdmin,
      required this.onLogout});

  final String name;
  final bool isAdmin;
  final void Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(20, 40),
      tooltip: name,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.lightBlue,
              child: Center(
                  child: Text(
                name[0],
                style: const TextStyle(fontWeight: FontWeight.w900),
                overflow: TextOverflow.fade,
              )),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () => context.push('/about-us'),
            child: Text(
              "About us",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          // PopupMenuItem(
          //   child: Text(
          //     "Settings",
          //     style: Theme.of(context).textTheme.labelMedium,
          //   ),
          // ),
          PopupMenuItem(
            enabled: isAdmin,
            onTap: () => context.push('/admin'),
            child: Text(
              "Admin Panel",
              style: isAdmin
                  ? Theme.of(context).textTheme.labelMedium
                  : Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.grey),
            ),
          ),
          PopupMenuItem(
            onTap: onLogout,
            child: Text(
              "Logout",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ];
      },
    );
  }
}

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    required this.chat,
    required this.chatBloc,
    required this.index,
  });

  final ChatModel chat;
  final ChatBloc chatBloc;
  final int index;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TextEditingController textEditingController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.chatBloc.add(ChatTileClickedEvent(index: widget.index));
      },
      onHover: (value) {
        if (value) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
      child: ListTile(
        title: Text(
          widget.chat.chatName,
        ),
        subtitle: (widget.chat.chatMessages.isNotEmpty)
            ? Text("Last Updated: ${widget.chat.chatMessages.last.time}")
            : null,
        trailing: FadeTransition(
          opacity: _animation,
          child: PopupMenuButton(
            tooltip: "Options",
            icon: const Icon(Icons.more_horiz),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () => widget.chatBloc
                      .add(DeleteChatOptionClickedEvent(index: widget.index)),
                  child: Text(
                    "Delete",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    textEditingController.text = widget.chat.chatName;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Update Chat"),
                          content: SizedBox(
                            width: 300,
                            child: TextField(
                              controller: textEditingController,
                              decoration: const InputDecoration(
                                labelText: "Enter Chat Name:",
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  widget.chatBloc.add(
                                      RenameChatOptionClickedEvent(
                                          chat: widget.chat,
                                          newChatName:
                                              textEditingController.text));
                                  textEditingController.text = "";
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Rename")),
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
                  child: Text(
                    "Rename",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ];
            },
          ),
        ),
      ),
    );
  }
}
