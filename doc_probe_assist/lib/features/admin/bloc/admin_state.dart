part of 'admin_bloc.dart';

@immutable
sealed class AdminState {}

sealed class AdminActionState extends AdminState {}

final class AdminInitial extends AdminState {}

// User

final class UserLoadingState extends AdminState {}

final class UserLoadingSuccessState extends AdminState {
  final List<UserModel> users;

  UserLoadingSuccessState({required this.users});
}

final class UserLoadingFailedState extends AdminState {}

class DeletedUserSuccessState extends AdminState {
  final UserModel user;

  DeletedUserSuccessState({required this.user});
}

class UpdateUserState extends AdminState {
  final UserModel user;

  UpdateUserState({required this.user});
}

class UpdateUserFailedState extends AdminState {}

// Document
class DocumentDeleteState extends AdminState {
  final Document document;

  DocumentDeleteState({required this.document});
}

class DocumentApprovedState extends AdminState {
  final Document document;

  DocumentApprovedState({required this.document});
}
