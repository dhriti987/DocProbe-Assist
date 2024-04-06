class UserModel {
  final int id;
  final String name;
  final String username;
  final bool isAdmin;
  final String email;
  final bool isActive;

  UserModel(
      {required this.id,
      required this.name,
      required this.username,
      required this.isAdmin,
      required this.email,
      this.isActive = true});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['first_name'],
      username: json['username'] ?? '',
      isAdmin: json['is_staff'] ?? '',
      email: json['email'] ?? '',
      isActive: json['is_active'] ?? '',
    );
  }

  static List<UserModel> listFromJson(List<dynamic> data) =>
      List.from(data.map((e) => UserModel.fromJson(e)));
}
