import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:doc_probe_assist/core/exceptions/api_exceptions.dart';
import 'package:doc_probe_assist/core/services/api_service.dart';
import 'package:doc_probe_assist/models/directory_model.dart';
import 'package:doc_probe_assist/models/document_model.dart';
import 'package:doc_probe_assist/models/feedback_model.dart';
import 'package:doc_probe_assist/models/user_model.dart';

class AdminRepository {
  final ApiService apiService;

  // Analytics
  final String getAnalyticsDataUrl = '/api/chatbot/analytics/';
  // User
  final String getUsersUrl = '/api/auth/users/';
  final String updateUserAccessUrl = '/api/auth/update-user/';
  final String deleteUserUrl = '/api/auth/delete-user/';
  // Document
  final String getAndUploadDocuments = '/api/chatbot/doc/';
  final String updateDocumentUrl = '/api/chatbot/update-doc/';
  final String directoryUrl = '/api/chatbot/directory/';
  // Feedback
  final String getFeedbacksUrl = '/api/chatbot/feedback/';

  AdminRepository({
    required this.apiService,
  });

// Analytics
  Future<Map<String, dynamic>> getAnalyticsData() async {
    Dio api = apiService.getApi();
    try {
      var response = await api.get(getAnalyticsDataUrl);
      return response.data;
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
    }
  }

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
      return Document.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
    }
  }

  Future<MyDirectory> createDirectory(String dirName) async {
    Dio api = apiService.getApi();
    try {
      var response = await api.post(directoryUrl, data: {"name": dirName});
      return MyDirectory.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e,
          error: ['Unexpected Error', 'Error uploading Document.']);
    }
  }

  Future<Document> uploadDocument(
      Uint8List file, String fileName, int? dirId) async {
    Dio api = apiService.getApi();
    try {
      Map<String, dynamic> data = {
        "file": MultipartFile.fromBytes(file, filename: fileName),
        "name": fileName
      };
      if (dirId != null) {
        data['directory'] = dirId;
      }
      FormData formData = FormData.fromMap(data);

      var response = await api.post(getAndUploadDocuments, data: formData);
      return Document.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e,
          error: ['Unexpected Error', 'Error uploading Document.']);
    }
  }

  Future<List<MyDirectory>> getDirectories() async {
    Dio api = apiService.getApi();
    try {
      var response = await api.get(directoryUrl);
      return MyDirectory.listFromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
    }
  }

  Future<void> deleteDirectory(int id) async {
    Dio api = apiService.getApi();
    try {
      await api.delete(directoryUrl + id.toString());
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
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
