import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:doc_probe_assist/core/exceptions/api_exceptions.dart';
import 'package:doc_probe_assist/core/services/api_service.dart';
import 'package:doc_probe_assist/models/document_model.dart';
import 'package:doc_probe_assist/models/feedback_model.dart';
import 'package:doc_probe_assist/models/user_model.dart';

class AdminRepository {
  final ApiService apiService;
  // User
  final String getUsersUrl = '/auth/users/';
  final String updateUserAccessUrl = '/auth/update-user/';
  final String deleteUserUrl = '/auth/delete-user/';
  // Document
  final String getAndUploadDocuments = '/chatbot/doc/';
  final String updateDocumentUrl = '/chatbot/update-doc/';
  // Feedback
  final String getFeedbacksUrl = '/chatbot/feedback/';

  AdminRepository({
    required this.apiService,
  });

// User
  Future<List<UserModel>> getUsers() async {
    Dio api = apiService.getApi();
    try {
      var response = await api.get(getUsersUrl);

      return UserModel.listFromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
    }
  }

  Future<UserModel> updateUserAccess(
      bool isAdmin, bool isActive, int id) async {
    Dio api = apiService.getApi();
    try {
      var response = await api.patch(updateUserAccessUrl + id.toString(),
          data: FormData.fromMap({'is_staff': isAdmin, 'is_active': isActive}));
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
    }
  }

  Future<void> deleteUser(int id) async {
    Dio api = apiService.getApi();
    try {
      await api.delete(deleteUserUrl + id.toString());
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
    }
  }

// Document
  Future<List<Document>> getAllDocuments() async {
    Dio api = apiService.getApi();
    try {
      var response = await api.get(getAndUploadDocuments);
      return Document.listFromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
    }
  }

  Future<List<Document>> getRequestedDocuments() async {
    Dio api = apiService.getApi();
    try {
      var response = await api
          .get(getAndUploadDocuments, queryParameters: {'isNotVerified': true});
      return Document.listFromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
    }
  }

  Future<void> deleteDocument(int id) async {
    Dio api = apiService.getApi();
    try {
      await api.delete(updateDocumentUrl + id.toString());
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
    }
  }

  Future<Document> approveDocument(int id) async {
    Dio api = apiService.getApi();
    try {
      var response = await api
          .patch(updateDocumentUrl + id.toString(), data: {'isVerified': true});
      print(response.data);
      return Document.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
    }
  }

  Future<Document> uploadDocument(Uint8List file, String fileName) async {
    Dio api = apiService.getApi();
    try {
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(file, filename: fileName),
        "name": fileName
      });

      var response = await api.post(getAndUploadDocuments, data: formData);
      return Document.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e,
          error: ['Unexpected Error', 'Error uploading Document.']);
    }
  }

  // Feedback
  Future<List<FeedBackModel>> getFeedback() async {
    Dio api = apiService.getApi();
    try {
      var response = await api.get(getFeedbacksUrl);
      return FeedBackModel.listFromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
    }
  }
}
