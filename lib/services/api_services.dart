import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_gpt/constants/api_constants.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:http/http.dart' as http;

import '../models/models_model.dart';

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$kBaseUrl/models"),
        headers: {'Authorization': 'Bearer $kApiKey'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      print("error $error");
      rethrow;
    }
  }

  //send Message fct
  static Future<List<ChatModel>> sendMessage({required String message, required String modelId}) async {
    try {
      log("modelId: $modelId");
      var response = await http.post(Uri.parse("$kBaseUrl/chat/completions"),
          headers: {
            'Authorization': 'Bearer $kApiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "model": modelId,
            "messages": [
              {"role": "user", "content": message}
            ],
            "max_tokens": 100
          }));

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse['choices'].length > 0) {
        // log("jsonResponse message: ${jsonResponse['choices'][0]['message']['content']}");
        chatList = List.generate(
          jsonResponse['choices'].length,
          (index) => ChatModel(
            msg: jsonResponse['choices'][index]['message']['content'],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      print("error $error");
      rethrow;
    }
  }
}
