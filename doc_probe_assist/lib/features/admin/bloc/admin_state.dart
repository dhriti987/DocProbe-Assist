part of 'admin_bloc.dart';

@immutable
sealed class AdminState {}

sealed class AdminActionState extends AdminState {}

final class AdminInitial extends AdminState {}

// Analytics

final class AnalyticsDataLoadingState extends AdminState {}

final class AnalyticsDataLoadingSuccessState extends AdminState {
  final Map<String, dynamic> weeklyFeedback;
  final int totalDocuments;
  final int embeddedDocuments;
  final int totalUsers;
  final int weeklyTotalQuestions;
  final int totalQuestions;
  final int goodResponse;
  final int badResponse;

  AnalyticsDataLoadingSuccessState({
    required this.totalDocuments,
    required this.embeddedDocuments,
    required this.totalUsers,
    required this.weeklyTotalQuestions,
    required this.weeklyFeedback,
    required this.totalQuestions,
    required this.goodResponse,
    required this.badResponse,
  });
}

final class AnalyticsDataLoadingFailedState extends AdminState {}

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
  final List<MyDirectory> directories;

  DocumentLoadingSuccessState(
      {required this.documents, required this.directories});
}

final class DocumentLoadingFailedState extends AdminState {}

final class DirectoryLoadingSuccessState extends AdminState {
  final List<Document> directory;

  DirectoryLoadingSuccessState({required this.directory});
}

final class DirectoryLoadingFailedState extends AdminState {}

class DocumentDeleteState extends AdminState {
  final Document document;

  DocumentDeleteState({required this.document});
}

class DocumentDeleteFailedState extends AdminState {}

class DirectoryDeleteState extends AdminState {
  final MyDirectory directory;

  DirectoryDeleteState({required this.directory});
}

class DirectoryDeleteFailedState extends AdminActionState {}

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

class UploadDocumentFailedState extends AdminActionState {}

class CreateDirectorySuccessState extends AdminState {
  final MyDirectory directory;

  CreateDirectorySuccessState({required this.directory});
}

class CreateDirectoryFailedState extends AdminActionState {}

// Feedback

class FeedbackLoadingState extends AdminState {}

class FeedbackLoadingSuccessState extends AdminState {
  final List<FeedBackModel> feedbacks;

  FeedbackLoadingSuccessState({required this.feedbacks});
}

class FeedbackLoadingFailedState extends AdminState {}
