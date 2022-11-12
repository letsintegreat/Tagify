import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hackathon_project/models/group_model.dart';
import 'package:hackathon_project/models/user_model.dart';
import 'package:hackathon_project/screens/logic_screen.dart';

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
      body: Column(
        children: [
          TextField(
            controller: _nickNameCont,
          ),
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: _logicCont,
                enabled: false,
              )),
              ElevatedButton(
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
                child: Text("click"),
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
