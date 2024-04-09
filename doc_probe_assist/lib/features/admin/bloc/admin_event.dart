part of 'admin_bloc.dart';

@immutable
sealed class AdminEvent {}

//Users Panel
class UsersFetchEvent extends AdminEvent {}

class BlockUserEvent extends AdminEvent {
  final UserModel user;

  BlockUserEvent({required this.user});
}

class UnBlockUserEvent extends AdminEvent {
  final UserModel user;

  UnBlockUserEvent({required this.user});
}

class DeleteUserEvent extends AdminEvent {
  final UserModel user;

  DeleteUserEvent({required this.user});
}

class GiveAdminAcessUserEvent extends AdminEvent {
  final UserModel user;

  GiveAdminAcessUserEvent({required this.user});
}

class RevokeAdminAcessUserEvent extends AdminEvent {
  final UserModel user;

  RevokeAdminAcessUserEvent({required this.user});
}

// Document Panel
class AllDocumentFetchEvent extends AdminEvent {}

class RequestedDocumentFetchEvent extends AdminEvent {}

class ApproveDocumentEvent extends AdminEvent {
  final Document document;

  ApproveDocumentEvent({required this.document});
}

class DeleteDocumentEvent extends AdminEvent {
  final Document document;

  DeleteDocumentEvent({required this.document});
}
