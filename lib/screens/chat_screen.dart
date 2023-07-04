import 'dart:developer';

import 'package:chat_gpt/constants/constants.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/services/api_services.dart';
import 'package:chat_gpt/services/assets_manager.dart';
import 'package:chat_gpt/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/models_provider.dart';
import '../services/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late ScrollController _listController;
  late TextEditingController textEditingController;
  late FocusNode focusNode;

  @override
  void initState() {
    _listController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openAILogo),
        ),
        title: const Text("ChatGPT"),
        actions: [
          IconButton(
            onPressed: () async => await Services.showBottomSheet(context: context),
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: ScrollPhysics(),
                controller: _listController,
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatList[index].msg,
                    chatIndex: chatList[index].chatIndex,
                  );
                },
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                size: 18,
                color: Colors.white,
              ),
            ],
            const SizedBox(height: 15),
            Material(
              color: kCardColor,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          sendMessageFCT(modelsProvider: modelsProvider);
                        },
                        decoration: const InputDecoration(
                          hintText: 'How can I help you',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await sendMessageFCT(modelsProvider: modelsProvider);
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEND() {
    _listController.animateTo(
      _listController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessageFCT({required ModelsProvider modelsProvider}) async {
    try {
      chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
      setState(() {
        _isTyping = true;
      });
      log("Request has been sent");
      chatList.addAll(await ApiService.sendMessage(
        message: textEditingController.text,
        modelId: modelsProvider.getCurrentModel,
      ));
      setState(() {});
    } catch (e) {
      print("error $e");
    } finally {
      scrollListToEND();
      setState(() {
        textEditingController.clear();
        focusNode.unfocus();
        _isTyping = false;
      });
    }
  }
}
