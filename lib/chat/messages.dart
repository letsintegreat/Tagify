import './message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Messages extends StatelessWidget {
  var _userEmail = "";
  var isMe = true;

  Future<void> cred() async {
    final _storage = FlutterSecureStorage();
    _userEmail = await _storage.read(key: 'user') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder(
    //   stream: FirebaseFirestore.instance
    //       .collection('/chat')
    //       .orderBy('createdAt', descending: true)
    //       .snapshots(),
    //   builder: ((context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //     final chatDocs = snapshot.data!.docs;

    //     return FutureBuilder(
    //       future: cred(),
    //       builder: (context, snapshot) =>
    return ListView.builder(
      reverse: true,
      itemCount: 100,
      itemBuilder: (context, index) => MessageBubble(
          message: 'hi there, this is GeekyPS',
          isMe: (isMe=!isMe),
          Sender: 'Priyanshu Srivastava'),
    );
    // );
    // }),
    // );
  }
}
