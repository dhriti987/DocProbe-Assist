import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:doc_probe_assist/core/exceptions/api_exceptions.dart';
import 'package:doc_probe_assist/features/admin/repository/admin_repository.dart';
import 'package:doc_probe_assist/models/document_model.dart';
import 'package:doc_probe_assist/models/feedback_model.dart';
import 'package:doc_probe_assist/models/user_model.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:meta/meta.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final adminRepository = sl.get<AdminRepository>();

  AdminBloc() : super(AdminInitial()) {
    on<AdminEvent>((event, emit) {
      // TODO: implement event handler
    });

    //  Analytics
    on<LoadAnalyticsEvent>(onLoadAnalyticsEvent);

    // User
    on<UsersFetchEvent>(onUsersFetchEvent);
    on<GiveAdminAcessUserEvent>(onGiveAdminAcessUserEvent);
    on<RevokeAdminAcessUserEvent>(onRevokeAdminAcessUserEvent);
    on<BlockUserEvent>(onBlockUserEvent);
    on<UnBlockUserEvent>(onUnBlockUserEvent);
    on<DeleteUserEvent>(onDeleteUserEvent);

    // Document
    on<AllDocumentFetchEvent>(onAllDocumentFetchEvent);
    on<DeleteDocumentEvent>(onDeleteDocumentEvent);
    on<ApproveDocumentEvent>(onApproveDocumentEvent);
    on<UploadDocumentButtonClickedEvent>(onUploadDocumentButtonClickedEvent);
    on<NewDocumentSelectedEvent>(onNewDocumentSelectedEvent);

    //Feedback
    on<AllFeedbackFetchEvent>(onAllFeedbackFetchEvent);
  }

  Future<FutureOr<void>> onLoadAnalyticsEvent(
      LoadAnalyticsEvent event, Emitter<AdminState> emit) async {
    emit(AnalyticsDataLoadingState());
    try {
      var data = await adminRepository.getAnalyticsData();
      var weeklyFeedback = data['weekly_feedback'];
      var totalDocuments = data['total_documents'];
      var embeddedDocuments = data['embedded_documents'];
      var totalUsers = data['total_users'];
      var weeklyTotalQuestions = data['weekly_total_questions'];
      var totalQuestions = data['total_questions'];
      var goodBadResponse = data['good_bad_response'];
      // var totalQuestions = 30;
      // var goodBadResponse = [0, 0];
      emit(AnalyticsDataLoadingSuccessState(
        weeklyFeedback: weeklyFeedback,
        totalDocuments: totalDocuments,
        embeddedDocuments: embeddedDocuments,
        totalUsers: totalUsers,
        weeklyTotalQuestions: weeklyTotalQuestions,
        totalQuestions: totalQuestions,
        goodResponse: goodBadResponse['good_resp'],
        badResponse: goodBadResponse['bad_resp'],
      ));
    } catch (e) {
      emit(AnalyticsDataLoadingFailedState());
    }
  }

  FutureOr<void> onUsersFetchEvent(
      UsersFetchEvent event, Emitter<AdminState> emit) async {
    emit(UserLoadingState());
    try {
      var users = await adminRepository.getUsers();
      emit(UserLoadingSuccessState(users: users));
    } catch (e) {
      emit(UserLoadingFailedState());
    }
  }

  FutureOr<void> onGiveAdminAcessUserEvent(
      GiveAdminAcessUserEvent event, Emitter<AdminState> emit) async {
    try {
      var user = await adminRepository.updateUserAccess(
          true, event.user.isActive, event.user.id);
      emit(UpdateUserState(user: user));
    } catch (e) {
      emit(UpdateUserFailedState());
    }
  }

  Future<FutureOr<void>> onRevokeAdminAcessUserEvent(
      RevokeAdminAcessUserEvent event, Emitter<AdminState> emit) async {
    try {
      var user = await adminRepository.updateUserAccess(
          false, event.user.isActive, event.user.id);
      emit(UpdateUserState(user: user));
    } catch (e) {
      emit(UpdateUserFailedState());
    }
  }

  FutureOr<void> onBlockUserEvent(
      BlockUserEvent event, Emitter<AdminState> emit) async {
    try {
      var user = await adminRepository.updateUserAccess(
          event.user.isAdmin, false, event.user.id);
      emit(UpdateUserState(user: user));
    } catch (e) {
      emit(UpdateUserFailedState());
    }
  }

  FutureOr<void> onUnBlockUserEvent(
      UnBlockUserEvent event, Emitter<AdminState> emit) async {
    try {
      var user = await adminRepository.updateUserAccess(
          event.user.isAdmin, true, event.user.id);
      emit(UpdateUserState(user: user));
    } catch (e) {
      emit(UpdateUserFailedState());
    }
  }

  FutureOr<void> onDeleteUserEvent(
      DeleteUserEvent event, Emitter<AdminState> emit) async {
    try {
      await adminRepository.deleteUser(event.user.id);
      emit(DeletedUserSuccessState(user: event.user));
    } catch (e) {
      emit(UpdateUserFailedState());
    }
  }

  FutureOr<void> onAllDocumentFetchEvent(
      AllDocumentFetchEvent event, Emitter<AdminState> emit) async {
    emit(DocumentLoadingState());
    try {
      var allDocuments = await adminRepository.getAllDocuments();
      var requestedDocuments = await adminRepository.getRequestedDocuments();
      var documents = {'all_doc': allDocuments, 'req_doc': requestedDocuments};
      emit(DocumentLoadingSuccessState(documents: documents));
    } catch (e) {
      emit(DocumentLoadingFailedState());
    }
  }

  Future<FutureOr<void>> onDeleteDocumentEvent(
      DeleteDocumentEvent event, Emitter<AdminState> emit) async {
    try {
      await adminRepository.deleteDocument(event.document.id);
      emit(DocumentDeleteState(document: event.document));
    } catch (e) {
      emit(DocumentDeleteFailedState());
    }
  }

  FutureOr<void> onApproveDocumentEvent(
      ApproveDocumentEvent event, Emitter<AdminState> emit) async {
    try {
      var document = await adminRepository.approveDocument(event.document.id);
      emit(DocumentApprovedState(document: document));
    } catch (e) {
      emit(DocumentApproveFailedState());
    }
  }

  Future<FutureOr<void>> onUploadDocumentButtonClickedEvent(
      UploadDocumentButtonClickedEvent event, Emitter<AdminState> emit) async {
    try {
      Document doc =
          await adminRepository.uploadDocument(event.file!, event.name);
      emit(UploadDocumentSuccessState(document: doc));
    } on ApiException catch (e) {
      print(e.error);
      emit(UploadDocumentFailedState());
    }
  }

  FutureOr<void> onNewDocumentSelectedEvent(
      NewDocumentSelectedEvent event, Emitter<AdminState> emit) {
    emit(NewDocumentSelectedState(fileName: event.name, file: event.file));
  }

  Future<FutureOr<void>> onAllFeedbackFetchEvent(
      AllFeedbackFetchEvent event, Emitter<AdminState> emit) async {
    emit(FeedbackLoadingState());
    try {
      List<FeedBackModel> feedbacks = await adminRepository.getFeedback();
      emit(FeedbackLoadingSuccessState(feedbacks: feedbacks));
    } on ApiException catch (e) {
      print(e.error);
      emit(FeedbackLoadingFailedState());
    }
  }
}
