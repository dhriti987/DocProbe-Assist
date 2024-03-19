import 'package:doc_probe_assist/features/admin/UI/documents_screen.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  final String name = "Muskan Acharya";
  final List<Widget> screens = const [DocumentScreen()];
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    int index = 0;
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
              onTap: () {},
              title: const Text("Users"),
            ),
            ListTile(
              onTap: () {},
              title: const Text("Documents"),
            ),
            ListTile(
              onTap: () {},
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
