import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hackathon_project/models/group_model.dart';
import 'package:hackathon_project/models/user_model.dart';
import 'package:hackathon_project/widgets/tags.dart';

class AllTagsScreen extends StatefulWidget {
  const AllTagsScreen({super.key});

  @override
  State<AllTagsScreen> createState() => _AllTagsScreen();
}

class _AllTagsScreen extends State<AllTagsScreen> {
  String userid = "";
  final List<String> _assignedTags = [];
  final List<String> _unassignedTags = [];

  Future<String?> getLogin() async {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: "user");
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getLogin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          userid = snapshot.data!;
          Future<DocumentSnapshot<Map<String, dynamic>>> snap =
              FirebaseFirestore.instance.collection("users").doc(userid).get();
          return FutureBuilder(
            future: snap,
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return const Text("Loading");
              }
              UserModel myUser = UserModel.fromJson(snapshot.data!.data()!);
              return FutureBuilder(
                future: FirebaseFirestore.instance.collection("tags").get(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Loading");
                  }
                  _assignedTags.clear();
                  _unassignedTags.clear();
                  for (var ind = 0; ind < snapshot.data!.docs.length; ind++) {
                    String currTag = snapshot.data!.docs[ind].id;
                    if (myUser.tags.contains(currTag)) {
                      _assignedTags.add(currTag);
                    } else {
                      _unassignedTags.add(currTag);
                    }
                  }
                  return ListView(
                    children: [
                      const SizedBox(
                        height: 16.0,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Your Tags",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color.fromRGBO(82, 45, 174, 1),
                          ),
                        ),
                      ),
                      Wrap(
                        children: _assignedTags
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Tag(tagName: e),
                                ))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "All Tags",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color.fromRGBO(82, 45, 174, 1),
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: _unassignedTags.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    Tag(tagName: _unassignedTags[index]),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: CircleAvatar(
                                        backgroundColor: const Color.fromRGBO(82, 45, 174, 1),
                                        child: IconButton(
                                          onPressed: () async {
                                            String tagInQuestion =
                                                _unassignedTags[index];
                                            myUser.tags.add(tagInQuestion);
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(userid)
                                                .set(myUser.toJson());
                                            var snapshot = await FirebaseFirestore
                                                .instance
                                                .collection("groups")
                                                .get();
                                            snapshot.docs.forEach(
                                              (element) async {
                                                GroupModel currGroup =
                                                    GroupModel.fromJson(
                                                        element.data());
                                                if (!currGroup.users
                                                    .contains(myUser.id)) {
                                                  if (myUser.evaluateLogic(
                                                      currGroup.logic)) {
                                                    currGroup.users.add(myUser.id);
                                                    await FirebaseFirestore.instance
                                                        .collection("groups")
                                                        .doc(element.id)
                                                        .set(currGroup.toJson());
                                                  }
                                                }
                                              },
                                            );
                                            setState(() {
                                              _unassignedTags.remove(tagInQuestion);
                                              _assignedTags.add(tagInQuestion);
                                            });
                                          },
                                          icon: const Icon(Icons.add, color: Colors.white,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        }),
                      ),
                    ],
                  );
                }),
              );
            }),
          );
        },
      ),
    );
  }
}
