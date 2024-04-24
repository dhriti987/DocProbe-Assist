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
final class DocumentLoadingState extends AdminState {}

final class DocumentLoadingSuccessState extends AdminState {
  final Map<String, List<Document>> documents;

  DocumentLoadingSuccessState({required this.documents});
}

final class DocumentLoadingFailedState extends AdminState {}

class DocumentDeleteState extends AdminState {
  final Document document;

  DocumentDeleteState({required this.document});
}

class DocumentDeleteFailedState extends AdminState {}

class DocumentApprovedState extends AdminState {
  final Document document;

  DocumentApprovedState({required this.document});
}

class DocumentApproveFailedState extends AdminState {}

class NewDocumentSelectedState extends AdminState {
  final String fileName;
  final Uint8List file;

  NewDocumentSelectedState({required this.fileName, required this.file});
}

class UploadDocumentSuccessState extends AdminState {
  final Document document;

  UploadDocumentSuccessState({required this.document});
}

class UploadDocumentFailedState extends AdminState {}

// Feedback

class FeedbackLoadingState extends AdminState {}

class FeedbackLoadingSuccessState extends AdminState {
  final List<FeedBackModel> feedbacks;

  FeedbackLoadingSuccessState({required this.feedbacks});
}

class FeedbackLoadingFailedState extends AdminState {}
