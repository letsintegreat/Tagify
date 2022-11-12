import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = "";
  final _controller = new TextEditingController();

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
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          CircleAvatar(
            radius: 28,
            backgroundColor: Color.fromRGBO(173, 149, 232, 0.9),
            child: IconButton(
              color: ,
                onPressed: _enteredMessage.trim().isEmpty
                    ? null
                    : () async {
                      
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
                icon: const Icon(Icons.send,size: 22),
                ),
          ),
        ],
      ),
    );
  }
}
