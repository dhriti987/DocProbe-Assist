class Reference {
  final String docName;
  final int pageNumber;
  final String url;

  Reference({
    required this.docName,
    required this.pageNumber,
    required this.url,
  });

  factory Reference.fromJson(Map<String, dynamic> json) => Reference(
      docName: json['docName'],
      pageNumber: json['pageNumber'],
      url: json['url']);

  static List<Reference> listFromJson(List<dynamic> data) =>
      List.from(data.map((e) => Reference.fromJson(e)));
}
