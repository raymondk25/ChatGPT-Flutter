import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/constants.dart';
import 'providers/chats_provider.dart';
import 'providers/models_provider.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter ChatGPT Clone',
          theme: ThemeData(
            scaffoldBackgroundColor: kScaffoldBackgroundColor,
            appBarTheme: AppBarTheme(color: kCardColor),
          ),
          home: const ChatScreen()),
    );
  }
}
