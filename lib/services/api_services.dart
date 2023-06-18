import 'dart:convert';
import 'dart:io';

import 'package:chat_gpt/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<void> getModels() async {
    try {
      Uri uri = Uri.parse("$kBaseUrl/models");
      var response = await http.get(uri, headers: {"Authorization": "Bearer $kApiKey"});
      Map jsonResponse = json.decode(response.body);

      if (jsonResponse['error'] != null) {
        print("jsonResponse['error']: ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }

      print(jsonResponse);
    } catch (e) {
      print("error: $e");
    }
  }
}
