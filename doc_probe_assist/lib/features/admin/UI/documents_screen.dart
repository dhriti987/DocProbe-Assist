import 'package:doc_probe_assist/models/document_model.dart';
import 'package:flutter/material.dart';
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
    List<Document> requestedDocs = [
      Document(
          id: 1,
          docName: "Document 1",
          time: "12/12/23",
          empId: "54321",
          url:
              "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"),
      Document(
          id: 1,
          docName: "Document 2",
          time: "12/12/23",
          empId: "54321",
          url:
              "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"),
      Document(
          id: 1,
          docName: "Document 3",
          time: "12/12/23",
          empId: "54321",
          url:
              "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"),
      Document(
          id: 1,
          docName: "Document 4",
          time: "12/12/23",
          empId: "54321",
          url:
              "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"),
      Document(
          id: 1,
          docName: "Document 5",
          time: "12/12/23",
          empId: "54321",
          url:
              "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"),
    ];
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
              ),
              DocumentTab(docs: requestedDocs)
            ],
          ),
        )
      ],
    );
  }
}

class DocumentTab extends StatelessWidget {
  const DocumentTab({
    super.key,
    required this.docs,
    this.isRequested = false,
  });

  final List<Document> docs;
  final bool isRequested;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
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
                  label: Text("Date"),
                ),
                DataColumn(
                  label: Text("Document Name"),
                ),
                DataColumn(
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
                DataColumn(
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
                          Text(e.key.toString()),
                        ),
                        DataCell(
                          Text(e.value.empId),
                        ),
                        DataCell(
                          Text(e.value.time),
                        ),
                        DataCell(
                          Text(e.value.docName),
                        ),
                        DataCell(
                          TextButton(
                            onPressed: () async {
                              var uri = Uri.parse(e.value.url);
                              await launchUrl(uri);
                            },
                            child: Text(
                              "View",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                        (isRequested)
                            ? DataCell(Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {},
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
                                onPressed: () {},
                                icon: const Icon(Icons.delete_rounded),
                                color: Colors.red,
                              )),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
