import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_project/models/group_model.dart';
import 'package:hackathon_project/screens/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Future<String?> getLogin() async {
  //   const storage = FlutterSecureStorage();
  //   String? value = await storage.read(key: "user");
  //   return value;
  // }

  @override
  Widget build(BuildContext context) {
    String userid = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("groups").get(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return const SpinKitWave(
            color: Color.fromRGBO(122, 83, 217, 0.9),
          );
        }
        List<GroupModel> displayGroups = [];
        List<String> displayGroupsIds = [];
        for (var e in snapshot.data!.docs) {
          GroupModel currGroup = GroupModel.fromJson(e.data());
          if (currGroup.users.contains(userid)) {
            displayGroups.add(currGroup);
            displayGroupsIds.add(e.id);
          }
        }
        return Container(
          color: const Color.fromRGBO(229, 224, 239, 1),
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            child: ListView.builder(
              itemCount: displayGroups.length,
              itemBuilder: (context, index) => SizedBox(
                height: 80,
                child: Card(
                  color: const Color.fromRGBO(122, 83, 217, 0.9),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Container(
                              width: 48.0,
                              height: 48.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    displayGroups[index].name[0],
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 20.0,
                                      color: const Color.fromRGBO(
                                          122, 83, 217, 0.9),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            displayGroups[index].name,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[200],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
