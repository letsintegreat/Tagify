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
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter a message..',
              fillColor: Colors.white,
              hintStyle: GoogleFonts.poppins(
                color: const Color.fromRGBO(140, 142, 151, 1),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(72)),
                  borderSide: BorderSide(color: Colors.grey, width: 1)),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(72)),
                  borderSide: BorderSide(color: Colors.grey, width: 1)),
            ),
          )),
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color.fromRGBO(122, 83, 217, 1),
            child: IconButton(
              color: Colors.white,
              onPressed: () async {
                String _enteredMessage = _controller.text;
                if (_enteredMessage.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please Type in a message'),
                    ),
                  );
                } else {
                  MessageModel newMessage = MessageModel(
                    name: widget.userModel.name,
                    id: widget.userid,
                    text: _enteredMessage,
                    timeStamp: DateTime.now().toString(),
                  );
                  widget.groupModel.messages.add(newMessage);
                  FirebaseFirestore.instance
                      .collection("groups")
                      .doc(widget.groupid)
                      .set(widget.groupModel.toJson());
                }

                // FocusScope.of(context).unfocus();
                // final googleSignIn = GoogleSignIn();
                // final googleAccount = await googleSignIn.signIn();
                // FirebaseFirestore.instance.collection('chat').add(
                //   {
                //     'text': _enteredMessage,
                //     'createdAt': Timestamp.now(),
                //     'userID': googleAccount?.email,
                //   },
                // );
                // _controller.clear();
              },
              icon: const Icon(Icons.send, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
