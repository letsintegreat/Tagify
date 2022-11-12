import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_project/models/group_model.dart';
import 'package:hackathon_project/screens/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<String?> getLogin() async {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: "user");
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getLogin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading");
        }
        String userid = snapshot.data!;
        return FutureBuilder(
          future: FirebaseFirestore.instance.collection("groups").get(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading");
            }
            List<GroupModel> displayGroups = [];
            List<String> displayGroupsIds = [];
            snapshot.data!.docs.forEach((e) {
              GroupModel currGroup = GroupModel.fromJson(e.data());
              if (currGroup.users.contains(userid)) {
                displayGroups.add(currGroup);
                displayGroupsIds.add(e.id);
              }
            });
            return Container(
              color: const Color.fromRGBO(229, 224, 239, 1),
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: ListView.builder(
                  itemCount: displayGroups.length,
                  itemBuilder: (context, index) => Container(
                    height: 75,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        color: Colors.white),
                    child: Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                groupid: displayGroupsIds[index],
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              radius: 32,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              displayGroups[index].name,
                              style: GoogleFonts.inter(
                                  fontSize: 22, color: Colors.black),
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
