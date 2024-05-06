class Document {
  final int id;
  final String docName;
  String time;
  String empId;
  String url;
  String? directory;
  int? directoryId;
  String embeddingStatus;

  Document(
      {required this.id,
      required this.docName,
      this.time = "",
      this.empId = "",
      this.url = "",
      this.directory = "",
      required this.directoryId,
      this.embeddingStatus = ""});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      docName: json['name'],
      url: json['file'] ?? '',
      empId: json['username'] ?? '',
      time: json['date'] ?? '',
      directory: json['directory_name'],
      directoryId: json['directory'],
      embeddingStatus: json['embeddingStatus'] ?? '',
    );
  }

  static List<Document> listFromJson(List<dynamic> data) =>
      List.from(data.map((e) => Document.fromJson(e)));
}
