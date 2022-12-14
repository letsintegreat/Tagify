import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hackathon_project/models/group_model.dart';
import 'package:hackathon_project/models/user_model.dart';
import 'package:hackathon_project/screens/logic_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tabs_screen.dart';

class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({super.key});

  @override
  State<NewGroupScreen> createState() => _NewGroupScreen();
}

class _NewGroupScreen extends State<NewGroupScreen> {
  final TextEditingController _nickNameCont = TextEditingController();
  final TextEditingController _logicCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(229, 224, 239, 1),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            const Spacer(),
            TextField(
              autofocus: true,
              controller: _nickNameCont,
              cursorColor: const Color.fromRGBO(82, 45, 174, 1),
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(82, 45, 174, 1)),
              decoration: InputDecoration(
                hintText: 'Group Name',
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
            const SizedBox(
              height: 40,
            ),
            TextField(
              controller: _logicCont,
              cursorColor: const Color.fromRGBO(82, 45, 174, 1),
              autofocus: true,
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(82, 45, 174, 1)),
              decoration: InputDecoration(
                hintText: 'Logic',
                hintStyle: GoogleFonts.poppins(
                  color: const Color.fromRGBO(82, 45, 174, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(82, 45, 174, 1), width: 2)),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(82, 45, 174, 1), width: 2)),
                focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(82, 45, 174, 1), width: 2)),
              ),
              enabled: false,
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 40.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromRGBO(122, 83, 217, 0.9),
                  ),
                ),
                onPressed: () async {
                  try {
                    String logic = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LogicScreen(),
                      ),
                    );
                    _logicCont.text = logic;
                  } catch (e) {}
                },
                child: Text(
                  "Add Logic",
                  style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(122, 83, 217, 0.9),
        onPressed: () {
          String name = _nickNameCont.text;
          String logic = _logicCont.text;
          if (name.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Name can't be empty"),
              ),
            );
            return;
          }
          if (logic.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Logic can't be empty"),
              ),
            );
            return;
          }
          DocumentReference<Map<String, dynamic>> newDoc = FirebaseFirestore.instance
              .collection("groups")
              .doc();
          String? userid = FirebaseAuth.instance.currentUser!.uid;

          GroupModel newGroup = GroupModel(groupId: newDoc.id,name: name, logic: logic);

          newGroup.users.add(userid);

          FirebaseFirestore.instance.collection("users").get().then((snapshot){
                for (var element in snapshot.docs) {
                  UserModel currUser = UserModel.fromJson(element.data());
                  if (currUser.id == userid) continue;
                  if (currUser.evaluateLogic(logic)) {
                    newGroup.users.add(currUser.id);
                  }
                }

                newDoc.set(newGroup.toJson());

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "$name has been created with ${newGroup.users.length} users.",
                    ),
                  ),
                );

                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => TabsScreen( ),
                  ),
                      (route) => false,
                );
              });



        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
