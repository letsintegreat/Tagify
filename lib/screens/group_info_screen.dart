import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_project/models/group_model.dart';
import 'package:hackathon_project/models/user_model.dart';
import 'package:hackathon_project/screens/tabs_screen.dart';
import 'package:hackathon_project/widgets/tags.dart';

class GroupInfoScreen extends StatelessWidget {
  GroupModel groupModel;
  GroupInfoScreen({required this.groupModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupModel.name),
        backgroundColor: const Color.fromRGBO(108, 52, 217, 0.9),
        elevation: 0,
        actions: [
          if(groupModel.users[0]==FirebaseAuth.instance.currentUser?.uid)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(onPressed: () {
                FirebaseFirestore.instance.collection("groups").doc(groupModel.groupId).delete().then((_) {
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => TabsScreen( ),
                    ),
                        (route) => false,
                  );
                });
            }, icon: Icon(Icons.delete_outline)),
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("users").get(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const SpinKitWave(
              color: Color.fromRGBO(122, 83, 217, 0.9),
            );
          }
          List<UserModel> participants = [];
          for (var element in snapshot.data!.docs) {
            UserModel currUser = UserModel.fromJson(element.data());
            if (groupModel.users.contains(currUser.id)) {
              participants.add(currUser);
            }
          }
          return ListView(
            children: [
              const SizedBox(
                height: 20.0,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Logic",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color.fromRGBO(82, 45, 174, 1),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Tag(tagName: groupModel.logic),
              ),
              const SizedBox(
                height: 40.0,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "All Participants",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color.fromRGBO(82, 45, 174, 1),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: participants.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 8.0,
                    ),
                    child: SizedBox(
                      height: 80.0,
                      child: Card(
                        elevation: 2.0,
                        color: const Color.fromRGBO(82, 45, 174, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Container(
                                width: 48.0,
                                height: 48.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: Center(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      participants[index].name[0],
                                      style: GoogleFonts.comfortaa(
                                        fontSize: 20.0,
                                        color: const Color.fromRGBO(
                                            82, 45, 174, 1),
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 80.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 15),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          participants[index].name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0, left: 8.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Center(
                                              child: SvgPicture.asset(
                                                "assets/At.svg",
                                                color: Colors.white,
                                                width: 15.0,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                participants[index]
                                                            .email
                                                            .split("@")[0]
                                                            .length <
                                                        15
                                                    ? participants[index]
                                                        .email
                                                        .split("@")[0]
                                                    : "${participants[index].email.split("@")[0].substring(0, 15)}...",
                                                style: GoogleFonts.inter(
                                                    color: Colors.white,
                                                    fontSize: 15.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          );
        }),
      ),
    );
  }
}
