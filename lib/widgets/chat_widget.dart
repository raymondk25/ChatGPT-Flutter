import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt/constants/constants.dart';
import 'package:chat_gpt/services/assets_manager.dart';
import 'package:chat_gpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({required this.msg, required this.chatIndex, super.key});

  final String msg;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? kScaffoldBackgroundColor : kCardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0 ? AssetsManager.userImage : AssetsManager.chatLogo,
                  width: 30,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: chatIndex == 0
                      ? TextWidget(label: msg)
                      : DefaultTextStyle(
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                          child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            displayFullTextOnTap: true,
                            repeatForever: false,
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TyperAnimatedText(msg.trim()),
                            ],
                          ),
                        ),
                ),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        children: const [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: Colors.white,
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
