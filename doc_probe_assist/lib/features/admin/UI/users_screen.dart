import 'package:doc_probe_assist/features/admin/bloc/admin_bloc.dart';
import 'package:doc_probe_assist/models/user_model.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminBloc = sl.get<AdminBloc>();
    List<UserModel> users = [
      UserModel(
          id: 1,
          name: "Hetvi Kumari",
          username: "54321",
          isAdmin: true,
          email: "intern.hetvi@adani.com"),
      UserModel(
          id: 2,
          name: "Dhritiman Bharadwaj",
          username: "54321",
          isAdmin: false,
          isActive: false,
          email: "intern.dhritiman@adani.com"),
      UserModel(
          id: 3,
          name: "Muskaan Acharya",
          username: "54321",
          isAdmin: true,
          email: "intern.muskan@adani.com"),
    ];
    return Padding(
      padding: EdgeInsets.all(20),
      child: BlocConsumer<AdminBloc, AdminState>(
        bloc: adminBloc,
        buildWhen: (previous, current) => current is! AdminActionState,
        listenWhen: (previous, current) => current is AdminActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AdminInitial) {
            adminBloc.add(UsersFetchEvent());
          } else if (state is UserLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserLoadingSuccessState) {
            users = state.users;
          } else if (state is UserLoadingFailedState) {
            return Dialog(
              child: Text("Error"),
            );
          } else if (state is UpdateUserState) {
            users[users.indexWhere((element) => element.id == state.user.id)] =
                state.user;
          } else if (state is DeletedUserSuccessState) {
            users.removeAt(
                users.indexWhere((element) => element.id == state.user.id));
          }

          return Card(
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
                              color:
                                  e.value.isAdmin ? Colors.green : Colors.grey),
                        )),
                        DataCell(Row(
                          children: [
                            IconButton(
                              tooltip: e.value.isAdmin
                                  ? "Revoke Admin Access"
                                  : "Give Admin Access",
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text('Admin Access'),
                                          content: e.value.isAdmin
                                              ? Text(
                                                  'Revoke admin access from ${e.value.name}(${e.value.username})?')
                                              : Text(
                                                  'Give admin access to ${e.value.name}(${e.value.username})?'),
                                          actions: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey[200]),
                                                onPressed: () {
                                                  e.value.isAdmin
                                                      ? adminBloc.add(
                                                          RevokeAdminAcessUserEvent(
                                                              user: e.value))
                                                      : adminBloc.add(
                                                          GiveAdminAcessUserEvent(
                                                              user: e.value));
                                                  context.pop();
                                                },
                                                child: Text('Yes')),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey[200]),
                                                onPressed: () {
                                                  context.pop();
                                                },
                                                child: Text('No')),
                                          ],
                                        ));

                                // e.value.isAdmin
                                //     ? adminBloc.add(RevokeAdminAcessUserEvent(
                                //         user: e.value))
                                //     : adminBloc.add(
                                //         GiveAdminAcessUserEvent(user: e.value));
                              },
                              icon: Icon(
                                Icons.admin_panel_settings_rounded,
                                color:
                                    e.value.isAdmin ? Colors.red : Colors.green,
                              ),
                            ),
                            IconButton(
                              tooltip: e.value.isActive
                                  ? "Block User"
                                  : "Unblock User",
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          content: e.value.isActive
                                              ? Text(
                                                  'You want to block ${e.value.name} (${e.value.username}). Are you sure?')
                                              : Text(
                                                  'You want to unblock ${e.value.name} (${e.value.username}). Are you sure?'),
                                          actions: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey[200]),
                                                onPressed: () {
                                                  e.value.isActive
                                                      ? adminBloc.add(
                                                          BlockUserEvent(
                                                              user: e.value))
                                                      : adminBloc.add(
                                                          UnBlockUserEvent(
                                                              user: e.value));
                                                  context.pop();
                                                },
                                                child: e.value.isActive
                                                    ? Text('Block')
                                                    : Text('Unblock')),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey[200]),
                                                onPressed: () {
                                                  context.pop();
                                                },
                                                child: Text('Cancle')),
                                          ],
                                        ));

                                // e.value.isActive
                                //     ? adminBloc
                                //         .add(BlockUserEvent(user: e.value))
                                //     : adminBloc
                                //         .add(UnBlockUserEvent(user: e.value));
                              },
                              icon: Icon(
                                e.value.isActive
                                    ? Icons.person_off_rounded
                                    : Icons.person,
                                color: e.value.isActive
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                            IconButton(
                              tooltip: "Delete User",
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text('Delete User'),
                                          content: Text(
                                              'Are you sure you want to delete ${e.value.name}(${e.value.username})?'),
                                          actions: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.red[200]),
                                                onPressed: () {
                                                  adminBloc.add(DeleteUserEvent(
                                                      user: e.value));
                                                  context.pop();
                                                },
                                                child: Text('Delete')),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey[200]),
                                                onPressed: () {
                                                  context.pop();
                                                },
                                                child: Text('No')),
                                          ],
                                        ));
                              },
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        )),
                      ]))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
