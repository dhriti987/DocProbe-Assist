import 'package:doc_probe_assist/features/chat/UI/chat_window.dart';
import 'package:doc_probe_assist/features/chat/UI/left_chat_tab.dart';
import 'package:doc_probe_assist/features/chat/UI/reference_tab.dart';
import 'package:doc_probe_assist/features/chat/bloc/chat_bloc.dart';
import 'package:doc_probe_assist/models/chat_model.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatBloc chatBloc = sl.get<ChatBloc>();
  List<ChatModel> chats = [];

  @override
  Widget build(BuildContext context) {
    Widget screen = Row(
      children: [
        Expanded(flex: 1, child: LeftChatTab(chatBloc: chatBloc)),
        SizedBox(
          width: 20,
        ),
        Container(
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x880B74B0),
                Color(0x8875479C),
                Color(0x88BD3861),
              ],
            ),
          ),
          height: 800,
          width: 5,
        ),
        Expanded(flex: 4, child: ChatWidget(chatBloc: chatBloc)),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x880B74B0),
                Color(0x8875479C),
                Color(0x88BD3861),
              ],
            ),
          ),
          height: 800,
          width: 5,
        ),
        Expanded(
          flex: 1,
          child: ReferenceTab(chatBloc: chatBloc),
        ),
      ],
    );
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [
            //     Color(0x880B74B0),
            //     Color(0x8875479C),
            //     Color(0x88BD3861),
            //   ],
            // ),
            ),
        child: BlocBuilder<ChatBloc, ChatState>(
          bloc: chatBloc,
          buildWhen: (previous, current) {
            return (current is ChatInitial) ||
                (current is ChatPageLoadingState) ||
                (current is ChatPageLoadingFailedState) ||
                (current is ChatPageLoadingSuccessState);
          },
          builder: (context, state) {
            if (state is ChatInitial) {
              chatBloc.add(FetchDataEvent());
            } else if (state is ChatPageLoadingState) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/animations/robo_loading.gif"),
                    Text(
                      "Please Wait While we are Intializing Your Contents..",
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  ],
                ),
              );
            } else if (state is ChatPageLoadingFailedState) {
            } else if (state is ChatPageLoadingSuccessState) {
              return screen;
            }
            return const SizedBox();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
