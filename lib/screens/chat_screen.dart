import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hackathon_project/models/group_model.dart';
import 'package:hackathon_project/models/user_model.dart';
import 'package:hackathon_project/screens/group_info_screen.dart';

import '../chat/messages.dart';
import '../chat/new_message.dart';
import '../widgets/tags.dart';

class ChatScreen extends StatefulWidget {
  String groupid;
  ChatScreen({required this.groupid, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Future<String?> getLogin() async {
  //   const storage = FlutterSecureStorage();
  //   String? value = await storage.read(key: "user");
  //   return value;
  // }

  @override
  Widget build(BuildContext context) {
    String userid = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("users").doc(userid).get(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: SpinKitWave(
              color: Color.fromRGBO(122, 83, 217, 0.9),
            ),
          );
        }
        UserModel userModel = UserModel.fromJson(snapshot.data!.data()!);
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("groups")
              .doc(widget.groupid)
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: SpinKitWave(
                  color: Color.fromRGBO(122, 83, 217, 0.9),
                ),
              );
            }
            GroupModel groupModel = GroupModel.fromJson(snapshot.data!.data()!);
            return Scaffold(
              appBar: AppBar(
                title: Text(groupModel.name),
                backgroundColor: const Color.fromRGBO(108, 52, 217, 0.9),
                elevation: 0,
                actions: <Widget>[
                  Builder(builder: (context) {
                    return IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  GroupInfoScreen(groupModel: groupModel),
                            ),
                          );
                        },
                        icon: const Icon(Icons.info));
                  }),
                ],
              ),
              body: Container(
                color: const Color.fromRGBO(229, 224, 239, 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Messages(
                        groupModel: groupModel,
                        userid: userid,
                      ),
                    ),
                    NewMessage(
                      userid: userid,
                      groupModel: groupModel,
                      groupid: widget.groupid,
                      userModel: userModel,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
