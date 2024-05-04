import 'dart:typed_data';

import 'package:doc_probe_assist/features/chat/bloc/chat_bloc.dart';
import 'package:doc_probe_assist/models/chat_model.dart';
import 'package:doc_probe_assist/models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      listenWhen: (previous, current) => current is ChatActionState,
      buildWhen: (previous, current) => current is! ChatActionState,
      listener: (context, state) {
        if (state is ChatErrorState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(state.title),
              content: Text(state.message),
            ),
          );
        } else if (state is UploadDocumentSuccessState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text('Document Uploded Successfully.'),
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
            ),
          );
        } else if (state is UploadDocumentFailedState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text('Document Uploded Failed. Please try Again Later.'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Ok',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 10),
                    ))
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ChatPageLoadingSuccessState) {
          chats = state.chats;
          user = state.user;
        } else if (state is NewChatCreatedState) {
          chats.add(state.chat);
        } else if (state is ChatDeleteState) {
          chats.removeAt(state.index);
        }
        return Container(
          decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   // colors: [
              //   //   Color(0x990B74B0),
              //   //   Color(0x9975479C),
              //   //   Color(0x99BD3861),
              //   // ],
              // ),
              ),
          child: Column(
            children: [
              UserWidget(
                  user: user,
                  onLogout: () => chatBloc.add(LogoutButtonClickedEvent()),
                  chatBloc: chatBloc),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("New Chat"),
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
              Container(
                height: 500,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return ChatTile(
                      chat: chats[index],
                      chatBloc: chatBloc,
                      index: index,
                    );
                  },
                  itemCount: chats.length,
                ),
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
      required this.user,
      required this.onLogout,
      required this.chatBloc});

  final UserModel? user;
  final void Function() onLogout;

  final ChatBloc chatBloc;

  @override
  Widget build(BuildContext context) {
    TextEditingController documentNameTextEditingController =
        TextEditingController();
    FilePickerResult? result;
    return PopupMenuButton(
      offset: const Offset(20, 40),
      tooltip: user?.name,
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
                user!.name.isEmpty ? "A" : user!.name[0],
                style: const TextStyle(fontWeight: FontWeight.w900),
                overflow: TextOverflow.fade,
              )),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                user!.name.isEmpty ? "Anonymous User" : user!.name,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
      color: Colors.white,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () => context.push('/about-us'),
            child: Text(
              "About us",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          PopupMenuItem(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  var fileName = 'No File Choosen';
                  Uint8List? file;
                  return AlertDialog(
                    title: const Text("Upload Document"),
                    content: SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: documentNameTextEditingController,
                            decoration: const InputDecoration(
                              labelText: "Enter Document Name:",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  width: 150,
                                  child: BlocBuilder<ChatBloc, ChatState>(
                                    bloc: chatBloc,
                                    buildWhen: (previous, current) =>
                                        current is NewDocumentSelectedState,
                                    builder: (context, state) {
                                      return Text(fileName,
                                          overflow: TextOverflow.ellipsis);
                                    },
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['pdf'],
                                    );
                                    if (result != null) {
                                      var fileObject = result!.files.first;
                                      fileName = fileObject.name;
                                      file = fileObject.bytes;
                                      chatBloc.add(NewDocumentSelectedEvent(
                                          file: file!, name: fileName));
                                      // // sl.get<ChatRepository>().uploadDocument(
                                      // //     _paths.bytes!, _paths.name);
                                    } else {
                                      // User canceled the picker
                                      print('result null');
                                    }
                                  },
                                  child: Text(
                                    'Choose File',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(fontSize: 10),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            if (file != null) {
                              chatBloc.add(UploadDocumentButtonClickedEvent(
                                  file: file,
                                  fileName: fileName,
                                  name:
                                      documentNameTextEditingController.text));
                              file = null;
                              documentNameTextEditingController.text = "";
                              fileName = "No Document Selected";
                              context.pop();
                            } else {
                              print('file null');
                            }

                            // Navigator.of(context).pop();
                          },
                          child: const Text("Upload")),
                      TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: const Text("Cancel")),
                    ],
                  );
                },
              );
              // showDialog(
              //   context: context,
              //   builder: (context) {
              //     var fileName = 'No File Choosen';
              //     Uint8List? file;
              //     return BlocConsumer<ChatBloc, ChatState>(
              //       bloc: chatBloc,
              //       listener: (context, state) {},
              //       builder: (context, state) {
              //         if (state is NewDocumentSelectedState) {
              //           fileName = state.fileName;
              //           file = state.file;
              //         }
              //         if (state is UploadDocumentSuccessState) {
              //           return AlertDialog(
              //             content: Text('Document Uploded Successfully.'),
              //             actions: [
              //               ElevatedButton(
              //                   onPressed: () {
              //                     Navigator.of(context).pop();
              //                   },
              //                   child: Text(
              //                     'Ok',
              //                     style: Theme.of(context)
              //                         .textTheme
              //                         .titleMedium
              //                         ?.copyWith(fontSize: 10),
              //                   ))
              //             ],
              //           );
              //         }
              //         if (state is UploadDocumentFailedState) {
              //           return AlertDialog(
              //             content: Text(
              //                 'Document Uploded Failed. Please try Again Later.'),
              //             actions: [
              //               ElevatedButton(
              //                   onPressed: () {
              //                     Navigator.pop(context);
              //                   },
              //                   child: Text(
              //                     'Ok',
              //                     style: Theme.of(context)
              //                         .textTheme
              //                         .titleMedium
              //                         ?.copyWith(fontSize: 10),
              //                   ))
              //             ],
              //           );
              //         }
              //         return AlertDialog(
              //           title: const Text("Upload Document"),
              //           content: SizedBox(
              //             width: 300,
              //             child: Column(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 TextField(
              //                   controller: documentNameTextEditingController,
              //                   decoration: const InputDecoration(
              //                     labelText: "Enter Document Name:",
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   height: 20,
              //                 ),
              //                 Row(
              //                   children: [
              //                     SizedBox(
              //                         width: 150,
              //                         child: Text(fileName,
              //                             overflow: TextOverflow.ellipsis)),
              //                     SizedBox(
              //                       width: 20,
              //                     ),
              //                     ElevatedButton(
              //                         onPressed: () async {
              //                           result =
              //                               await FilePicker.platform.pickFiles(
              //                             type: FileType.custom,
              //                             allowedExtensions: ['pdf'],
              //                           );
              //                           if (result != null) {
              //                             var _paths = result!.files.first;

              //                             chatBloc.add(NewDocumentSelectedEvent(
              //                                 file: _paths.bytes!,
              //                                 name: _paths.name));
              //                             // sl.get<ChatRepository>().uploadDocument(
              //                             //     _paths.bytes!, _paths.name);
              //                           } else {
              //                             // User canceled the picker
              //                             print('result null');
              //                           }
              //                         },
              //                         child: Text(
              //                           'Choose File',
              //                           style: Theme.of(context)
              //                               .textTheme
              //                               .displayMedium
              //                               ?.copyWith(fontSize: 10),
              //                         ))
              //                   ],
              //                 )
              //               ],
              //             ),
              //           ),
              //           actions: [
              //             TextButton(
              //                 onPressed: () {
              //                   if (file != null) {
              //                     chatBloc.add(UploadDocumentButtonClickedEvent(
              //                         file: file, name: fileName));
              //                   } else {
              //                     print('file null');
              //                   }

              //                   // Navigator.of(context).pop();
              //                 },
              //                 child: const Text("Upload")),
              //             TextButton(
              //                 onPressed: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: const Text("Cancel")),
              //           ],
              //         );
              //       },
              //     );
              //   },
              // );
            },
            child: Text(
              "Upload Document",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          PopupMenuItem(
            enabled: user?.isAdmin ?? false,
            onTap: () => context.push('/admin', extra: user),
            child: Text(
              "Admin Panel",
              style: (user?.isAdmin ?? false)
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
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
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
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Chat"),
                      content: Text(
                          "Sure want to Delete Chat ${widget.chat.chatName}?"),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              widget.chatBloc.add(DeleteChatOptionClickedEvent(
                                  index: widget.index, chatId: widget.chat.id));
                              context.pop();
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            )),
                        ElevatedButton(
                            onPressed: () => context.pop(),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  ),
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
                          title: const Text("Update Chat"),
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
