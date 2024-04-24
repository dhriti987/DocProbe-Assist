import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:doc_probe_assist/core/exceptions/api_exceptions.dart';
import 'package:doc_probe_assist/core/services/api_service.dart';
import 'package:doc_probe_assist/models/chat_message_model.dart';
import 'package:doc_probe_assist/models/chat_model.dart';
import 'package:doc_probe_assist/models/document_model.dart';
import 'package:doc_probe_assist/models/reference_model.dart';
import 'package:doc_probe_assist/models/user_model.dart';

class ChatRepository {
  final ApiService apiService;
  final getDocumentUrl = "/chatbot/doc/?embedded=true";
  final getUserUrl = "/auth/user-info/";
  final chatsURL = '/chatbot/chats/';
  final chatsUpdateDeleteURL = '/chatbot/edit_chats/';
  final uploadDocumentURL = '/chatbot/doc/';
  final feedbackURL = '/chatbot/feedback/';
  final createAnswerURL = '/chatbot/answer/';
  final regenerateAnswerURL = '/chatbot/regenerate_answer/';

  ChatRepository({required this.apiService});

  Future<List<Document>> getAllDocuments() async {
    Dio api = apiService.getApi();

    try {
      var response = await api.get(getDocumentUrl);
      return Document.listFromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e,
          error: ['Unexpected Error', 'Error fetching documents']);
    }
  }

  Future<UserModel> getUser() async {
    Dio api = apiService.getApi();

    try {
      var response = await api.get(getUserUrl);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Error getting User']);
    }
  }

  Future<ChatModel> createChat(int userId, String chatName) async {
    Dio api = apiService.getApi();
    try {
      var response = await api.post(chatsURL,
          data: FormData.fromMap({"user": userId, "name": chatName}));
      return ChatModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ApiException(
            exception: e,
            error: ['Unique Chat Name', 'Chat Name Must be Unique']);
      }
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Error Creating new Chat']);
    }
  }

  Future<List<ChatModel>> getAllChats() async {
    Dio api = apiService.getApi();
    try {
      var response = await api.get(chatsURL);
      return ChatModel.listFromJson(response.data);
    } on DioException catch (e) {
      print(e);
      throw ApiException(exception: e, error: ['error', '']);
    }
  }

  Future<void> deleteChat(int id) async {
    Dio api = apiService.getApi();
    try {
      await api.delete(chatsUpdateDeleteURL + id.toString());
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Error Deleting Chat']);
    }
  }

  Future<void> updateChatName(int id, String newChatName) async {
    Dio api = apiService.getApi();
    try {
      await api.patch(chatsUpdateDeleteURL + id.toString(),
          data: FormData.fromMap({"name": newChatName}));
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ApiException(
            exception: e,
            error: ['Unique Chat Name', 'Chat Name Must be Unique']);
      }
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Error Creating new Chat']);
    }
  }

  Future<void> uploadDocument(
      Uint8List file, String name, String fileName) async {
    Dio api = apiService.getApi();
    try {
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(file, filename: fileName),
        "name": name
      });

      await api.post(uploadDocumentURL, data: formData);
    } on DioException catch (e) {
      throw ApiException(
          exception: e,
          error: ['Unexpected Error', 'Error uploading Document.']);
    }
  }

  Future<void> submitFeedback(
      int id, int rating, String feedback, String expectedResponse) async {
    Dio api = apiService.getApi();
    try {
      await api.post(feedbackURL,
          data: FormData.fromMap({
            "query": id,
            "rating": rating,
            "feedback": feedback,
            "expected_response": expectedResponse
          }));
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ApiException(exception: e, error: [
          'Feedback already submitted.',
          'Feedback already submitted.'
        ]);
      }
      throw ApiException(
          exception: e,
          error: ['Unexpected Error', 'Error submiting feedback']);
    }
  }

  Future<Map<String, dynamic>> createAnswer(
      int chatId, int? docId, String question) async {
    Dio api = apiService.getApi();
    api.options.connectTimeout = null;
    var data = {
      "id": chatId,
      "query": question,
    };
    if (docId != null) {
      data.putIfAbsent('doc_id', () => docId);
    }
    try {
      var response =
          await api.post(createAnswerURL, data: FormData.fromMap(data));
      return {
        'chat': ChatMessage.fromJson(response.data['query']),
        'references': Reference.listFromJson(response.data['references'])
      };
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Error creating answer']);
    }
  }

  Future<Map<String, dynamic>> regenerateAnswer(int queryId) async {
    Dio api = apiService.getApi();
    api.options.connectTimeout = null;
    try {
      var response = await api.post(regenerateAnswerURL,
          data: FormData.fromMap({'query_id': queryId}));

      return {'chat': ChatMessage.fromJson(response.data)};
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Error creating answer']);
    }
  }
}
