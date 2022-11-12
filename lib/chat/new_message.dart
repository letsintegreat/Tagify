import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:hackathon_project/models/group_model.dart';
import 'package:hackathon_project/models/message_model.dart';
import 'package:hackathon_project/models/user_model.dart';

class NewMessage extends StatefulWidget {
  String userid;
  GroupModel groupModel;
  String groupid;
  UserModel userModel;
  NewMessage(
      {required this.userid,
      required this.groupModel,
      required this.groupid,
      required this.userModel,
      super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
            controller: _controller,
            cursorColor: const Color.fromRGBO(82, 45, 174, 1),
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(82, 45, 174, 1)),
                decoration: InputDecoration(
                  hintText: 'Type something...',
                  hintStyle: GoogleFonts.poppins(
                    color: const Color.fromRGBO(82, 45, 174, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(82, 45, 174, 1), width: 2)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(82, 45, 174, 1), width: 2)),
            ),
          ),
              )),
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color.fromRGBO(122, 83, 217, 1),
            child: IconButton(
              color: Colors.white,
              onPressed: () async {
                String enteredMessage = _controller.text;
                if (enteredMessage.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please Type in a message'),
                    ),
                  );
                } else {
                  MessageModel newMessage = MessageModel(
                    name: widget.userModel.name,
                    id: widget.userid,
                    text: enteredMessage,
                    timeStamp: DateTime.now().toString(),
                  );
                  widget.groupModel.messages.add(newMessage);
                  FirebaseFirestore.instance
                      .collection("groups")
                      .doc(widget.groupid)
                      .set(widget.groupModel.toJson());
                  _controller.text = "";
                }
              },
              icon: const Icon(Icons.send, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
