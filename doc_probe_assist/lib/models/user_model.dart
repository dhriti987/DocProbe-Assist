class UserModel {
  final String name;
  final String username;
  final bool isAdmin;
  final String email;
  final bool isActive;

  UserModel(
      {required this.name,
      required this.username,
      required this.isAdmin,
      required this.email,
      this.isActive = true});
}
