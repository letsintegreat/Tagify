import 'package:flutter/material.dart';
import '../chat/messages.dart';
import '../chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hey there'),
        backgroundColor: const Color.fromRGBO(108, 52, 217, 0.9),
        elevation: 0,
      ),
      body: Container(
        color: const Color.fromRGBO(229, 224, 239, 1),
        child: Column(
          children:  [
            Expanded(
              child: Messages(),
            ),
            const NewMessage(),
          ],
        ),
      ),
    );
  }
}
