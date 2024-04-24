import 'package:doc_probe_assist/features/admin/UI/analytics_screen.dart';
import 'package:doc_probe_assist/features/admin/UI/documents_screen.dart';
import 'package:doc_probe_assist/features/admin/UI/feedback_screen.dart';
import 'package:doc_probe_assist/features/admin/UI/users_screen.dart';
import 'package:doc_probe_assist/features/admin/bloc/admin_bloc.dart';
import 'package:doc_probe_assist/features/chat/bloc/chat_bloc.dart';
import 'package:doc_probe_assist/models/user_model.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key, required this.user});
  final UserModel user;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final adminBloc = sl.get<AdminBloc>();
  final chatBloc = sl.get<ChatBloc>();

  late List<Widget> screens;
  int index = 0;
  @override
  void initState() {
    screens = [
      const AnalyticsScreen(),
      UserScreen(
        currentUser: widget.user,
      ),
      const DocumentScreen(),
      const FeedBackScreen()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      bloc: chatBloc,
      listener: (context, state) {
        if (state is LogoutState) {
          context.go('/');
        }
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Center(
                      child: Text(
                        widget.user.name.isEmpty ? "A" : widget.user.name[0],
                        style: const TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.user.name.isEmpty
                        ? "Anonymous User"
                        : widget.user.name,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              )),
              ListTile(
                onTap: () {
                  setState(() {
                    index = 0;
                  });
                  Navigator.pop(context);
                },
                title: const Text("Home"),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    index = 1;
                  });
                  Navigator.pop(context);
                },
                title: const Text("Users"),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    index = 2;
                  });
                  Navigator.pop(context);
                },
                title: const Text("Documents"),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    index = 3;
                  });
                  Navigator.pop(context);
                },
                title: const Text("Feedbacks"),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    chatBloc.add(LogoutButtonClickedEvent());
                  });
                },
                title: Text(
                  "Logout",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            "Admin Panel",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: true,
        ),
        body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0x880B74B0),
                Color(0x8875479C),
                Color(0x88BD3861),
              ],
            ),
          ),
          child: screens[index],
        ),
      ),
    );
  }
}
