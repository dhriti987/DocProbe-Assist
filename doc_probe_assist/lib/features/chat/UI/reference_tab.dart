import 'package:doc_probe_assist/features/chat/bloc/chat_bloc.dart';
import 'package:doc_probe_assist/models/chat_model.dart';
import 'package:doc_probe_assist/models/reference_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReferenceTab extends StatelessWidget {
  const ReferenceTab({
    super.key,
    required this.chatBloc,
  });

  final ChatBloc chatBloc;

  @override
  Widget build(BuildContext context) {
    List<ChatModel> chats = [];
    List<Reference> references = [];
    return BlocConsumer<ChatBloc, ChatState>(
      bloc: chatBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ChatPageLoadingSuccessState) {
          chats = List.from(state.chats);
        } else if (state is ChangeChatState) {
          references = chats[state.index].reference;
        } else if (state is NewChatCreatedState) {
          chats.add(state.chat);
        } else if (state is ChatDeleteState) {
          chats.removeAt(state.index);
        } else if (state is NewChatMessageState) {
          references = state.references;
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
              ListTile(
                title: Text(
                  "References",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      references[index].docName,
                    ),
                    subtitle: Text(
                      "Page No: ${references[index].pageNumber + 1}",
                    ),
                    onTap: () => launchUrlString(
                        '${dotenv.env['SERVER_URL'] ?? 'http://127.0.0.1:8000'}/${references[index].url}#page=${references[index].pageNumber + 1}'),
                  );
                },
                itemCount: references.length,
              ),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: Image.asset("assets/adani_power.png"),
              )
            ],
          ),
        );
      },
    );
  }
}
