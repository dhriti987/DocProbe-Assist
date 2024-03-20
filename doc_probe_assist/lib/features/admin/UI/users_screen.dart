import 'package:doc_probe_assist/models/user_model.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<UserModel> users = [
      UserModel(
          name: "Hetvi Kumari",
          username: "54321",
          isAdmin: true,
          email: "intern.hetvi@adani.com"),
      UserModel(
          name: "Dhritiman Bharadwaj",
          username: "54321",
          isAdmin: false,
          email: "intern.dhritiman@adani.com"),
      UserModel(
          name: "Muskaan Acharya",
          username: "54321",
          isAdmin: true,
          email: "intern.muskan@adani.com"),
    ];
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        elevation: 10,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text("Sr No."),
            ),
            DataColumn(
              label: Text("Emp ID"),
            ),
            DataColumn(
              label: Text("Name"),
            ),
            DataColumn(
              label: Text("email"),
            ),
            DataColumn(
              label: Text("User Type"),
            ),
            DataColumn(
              label: Text("Actions"),
            ),
          ],
          rows: users
              .asMap()
              .entries
              .map((e) => DataRow(cells: [
                    DataCell(Text(e.key.toString())),
                    DataCell(Text(e.value.username)),
                    DataCell(Text(e.value.name)),
                    DataCell(Text(e.value.email)),
                    DataCell(Text(
                      e.value.isAdmin ? "Admin" : "Common",
                      style: TextStyle(
                          color: e.value.isAdmin ? Colors.green : Colors.grey),
                    )),
                    DataCell(Text("Actions")),
                  ]))
              .toList(),
        ),
      ),
    );
  }
}
