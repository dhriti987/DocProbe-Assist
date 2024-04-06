import 'package:doc_probe_assist/features/admin/UI/documents_screen.dart';
import 'package:doc_probe_assist/features/admin/UI/feedback_screen.dart';
import 'package:doc_probe_assist/features/admin/UI/users_screen.dart';
import 'package:doc_probe_assist/features/admin/bloc/admin_bloc.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final String name = "Muskan Acharya";
  final adminBloc = sl.get<AdminBloc>();

  final List<Widget> screens = const [
    SizedBox(),
    UserScreen(),
    DocumentScreen(),
    FeedBackScreen()
  ];
  int index = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      name[0],
                      style: const TextStyle(fontSize: 50),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            )),
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
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Admin Panel"),
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
    );
  }
}
