import 'dart:convert';
import 'dart:io';

import 'package:chat_gpt/constants/api_constants.dart';
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
}
