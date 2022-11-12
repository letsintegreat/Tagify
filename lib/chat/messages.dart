import 'package:hackathon_project/models/group_model.dart';
import 'package:hackathon_project/models/message_model.dart';

import './message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Messages extends StatelessWidget {
  String userid;
  GroupModel groupModel;

  Messages({required this.groupModel, required this.userid, super.key});

  @override
  Widget build(BuildContext context) {
    List<MessageModel> messages = groupModel.messages;
    messages.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) => MessageBubble(
          message: messages[index].text,
          isMe: messages[index].id != userid,
          Sender: messages[index].name),
    );
  }
}
