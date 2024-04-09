import 'package:doc_probe_assist/features/admin/bloc/admin_bloc.dart';
import 'package:doc_probe_assist/models/document_model.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final adminBloc = sl.get<AdminBloc>();
    List<Document> allDocs = [];
    List<Document> requestedDocs = [];

    return BlocConsumer<AdminBloc, AdminState>(
      bloc: adminBloc,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is AdminInitial) {
          adminBloc.add(AllDocumentFetchEvent());
          adminBloc.add(RequestedDocumentFetchEvent());
        } else if (state is DocumentLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DocumentLoadingSuccessState) {
          allDocs = state.documents['all_doc']!;
          requestedDocs = state.documents['req_doc']!;
        } else if (state is DocumentLoadingFailedState) {
          return AlertDialog(
            content:
                const Text('Something went wrong. Please Try again later.'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Ok'))
            ],
          );
        } else if (state is DocumentDeleteState) {
          allDocs.removeAt(
              allDocs.indexWhere((element) => element.id == state.document.id));
        } else if (state is DocumentDeleteFailedState) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text('Problem deleting this document'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Ok'))
                ],
              );
            },
          );
        } else if (state is DocumentApprovedState) {
          allDocs.add(state.document);
          requestedDocs.removeAt(requestedDocs
              .indexWhere((element) => element.id == state.document.id));
        } else if (state is DocumentApproveFailedState) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text('Problem approving this document'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Ok'))
                ],
              );
            },
          );
        }
        return Column(
          children: [
            TabBar(
              tabs: [
                Text(
                  "Requested Documents",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "All Documents",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
              controller: _tabController,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  DocumentTab(
                    docs: requestedDocs,
                    isRequested: true,
                    adminBloc: adminBloc,
                  ),
                  DocumentTab(
                    docs: allDocs,
                    adminBloc: adminBloc,
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class DocumentTab extends StatelessWidget {
  const DocumentTab(
      {super.key,
      required this.docs,
      this.isRequested = false,
      required this.adminBloc});

  final List<Document> docs;
  final bool isRequested;
  final AdminBloc adminBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              !isRequested
                  ? ElevatedButton(
                      onPressed: () {},
                      child: Text('+ Add Document'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ))
                  : SizedBox(),
              Card(
                elevation: 10,
                child: DataTable(
                  columns: [
                    const DataColumn(
                      label: Text("Sr No."),
                    ),
                    const DataColumn(
                      label: Text("Emp ID"),
                    ),
                    const DataColumn(
                      label: Text("Date"),
                    ),
                    const DataColumn(
                      label: SizedBox(
                          width: 200,
                          child: Text(
                            "Document Name",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                    ),
                    DataColumn(
                      label: !isRequested
                          ? const Text("Status")
                          : const SizedBox(
                              width: 1,
                            ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Link",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(" "),
                    ),
                  ],
                  rows: docs
                      .asMap()
                      .entries
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(
                              Text((e.key + 1).toString()),
                            ),
                            DataCell(
                              Text(e.value.empId),
                            ),
                            DataCell(
                              Text(e.value.time),
                            ),
                            DataCell(
                              SizedBox(
                                  width: 200,
                                  child: Text(
                                    e.value.docName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  )),
                            ),
                            DataCell(
                              !isRequested
                                  ? Text(e.value.embeddingStatus)
                                  : const SizedBox(
                                      width: 1,
                                    ),
                            ),
                            DataCell(
                              TextButton(
                                onPressed: () async {
                                  var uri = Uri.parse(e.value.url);
                                  await launchUrl(uri);
                                },
                                child: Text(
                                  "View",
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                            ),
                            (isRequested)
                                ? DataCell(Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          adminBloc.add(ApproveDocumentEvent(
                                              document: e.value));
                                        },
                                        icon: const Icon(Icons.check_sharp),
                                        color: Colors.green,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.close_sharp),
                                        color: Colors.red,
                                      )
                                    ],
                                  ))
                                : DataCell(IconButton(
                                    onPressed: () {
                                      adminBloc.add(DeleteDocumentEvent(
                                          document: e.value));
                                    },
                                    icon: const Icon(Icons.delete_rounded),
                                    color: Colors.red,
                                  )),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
