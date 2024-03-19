class Document {
  final int id;
  final String docName;
  String time;
  String empId;
  String url;

  Document(
      {required this.id,
      required this.docName,
      this.time = "",
      this.empId = "",
      this.url = ""});
}
