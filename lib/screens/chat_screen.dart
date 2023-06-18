import 'package:chat_gpt/constants/constants.dart';
import 'package:chat_gpt/services/api_services.dart';
import 'package:chat_gpt/services/assets_manager.dart';
import 'package:chat_gpt/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final bool _isTyping = true;
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatMessages[index]['msg'].toString(),
                    chatIndex: int.parse(chatMessages[index]['chatIndex'].toString()),
                  );
                },
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(height: 15),
              Material(
                color: kCardColor,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: textEditingController,
                          onSubmitted: (value) {
                            //TODO send msg
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
                          try {
                            await ApiService.getModels();
                          } catch (e) {
                            print("error $e");
                          }
                          await ApiService.getModels();
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
