import 'package:doc_probe_assist/models/document_model.dart';
import 'package:flutter/material.dart';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

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
    return DefaultTabController(length: 2, child: Column());
  }
}

class RequestedDocumentTab extends StatelessWidget {
  const RequestedDocumentTab({
    super.key,
    required this.docs,
  });

  final List<Document> docs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
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
                label: Text("Link"),
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
                          onPressed: () {},
                          child: Text(
                            "Link",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ),
                      DataCell(Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.check_sharp),
                            color: Colors.green,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.close_sharp),
                            color: Colors.red,
                          )
                        ],
                      )),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
