class MyDirectory {
  final int id;
  final String dirName;

  MyDirectory({required this.id, required this.dirName});

  factory MyDirectory.fromJson(Map<String, dynamic> json) {
    return MyDirectory(
      id: json['id'],
      dirName: json['name'],
    );
  }

  static List<MyDirectory> listFromJson(List<dynamic> data) =>
      List.from(data.map((e) => MyDirectory.fromJson(e)));
}
