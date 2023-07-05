import 'package:chat_gpt/models/chat_model.dart';
import 'package:flutter/cupertino.dart';

import '../services/api_services.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void getUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> getMessageAndAnswers({required String msg, required String choosenModelId}) async {
    chatList.addAll(await ApiService.sendMessage(
      message: msg,
      modelId: choosenModelId,
    ));
    notifyListeners();
  }
}
