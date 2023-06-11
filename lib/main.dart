import 'package:flutter/material.dart';
import 'constants/constants.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: kScaffoldBackgroundColor,
          appBarTheme: AppBarTheme(color: kCardColor),
        ),
        home: const ChatScreen());
  }
}
