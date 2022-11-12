import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hackathon_project/models/group_model.dart';
import 'package:hackathon_project/models/user_model.dart';
import 'package:hackathon_project/screens/logic_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({super.key});

  @override
  State<NewGroupScreen> createState() => _NewGroupScreen();
}

class _NewGroupScreen extends State<NewGroupScreen> {
  TextEditingController _nickNameCont = TextEditingController();
  TextEditingController _logicCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            TextField(
              autofocus: true,
              controller: _nickNameCont,
              cursorColor: Colors.grey[400],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Group Name',
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
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _logicCont,
              textAlign: TextAlign.center,
              cursorColor: Colors.grey[400],
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Group Logic',
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
              enabled: false,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(76, 49, 159, 1))),
              onPressed: () async {
                try {
                  String logic = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LogicScreen(),
                    ),
                  );
                  _logicCont.text = logic;
                } catch (e) {}
              },
              child: Text("Add Logic"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(76, 49, 159, 1),
        onPressed: () async {
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
          String? userid = await FlutterSecureStorage().read(key: "user");
          GroupModel newGroup = GroupModel(name: name, logic: logic);
          newGroup.users.add(userid!);
          var snapshot =
              await FirebaseFirestore.instance.collection("users").get();
          snapshot.docs.forEach((element) {
            UserModel currUser = UserModel.fromJson(element.data());
            if (currUser.id == userid) return;
            if (currUser.evaluateLogic(logic)) {
              newGroup.users.add(currUser.id);
            }
          });
          FirebaseFirestore.instance
              .collection("groups")
              .add(newGroup.toJson());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${name} has been created with ${newGroup.users.length} users.",
              ),
            ),
          );
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
