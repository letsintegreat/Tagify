import 'dart:convert';
import 'dart:io';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_project/models/user_model.dart';
import 'package:hackathon_project/screens/tabs_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  AadOAuth oauth;
  LoginScreen({required this.oauth, super.key});

  Future<String?> getLogin() async {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: "user");
    return value;
  }

  String nameCaper(String name) {
    name = name.toLowerCase();
    String newname = name[0].toUpperCase();
    for (var i = 1; i < name.length; i++) {
      newname = newname + name[i];
      if (name[i] == ' ') {
        newname = newname + name[i + 1].toUpperCase();
        i++;
      }
    }
    return newname;
  }

  void auth(BuildContext context) async {
    final storage = FlutterSecureStorage();
    try {
      await oauth.login();
      var accessToken = await oauth.getAccessToken();
      if (accessToken != null) {
        var response = await http.get(
            Uri.parse('https://graph.microsoft.com/v1.0/me'),
            headers: {HttpHeaders.authorizationHeader: accessToken});
        print(response.statusCode);
        if (response.statusCode != 200) {
          print("error");
          return;
        }
        var data = jsonDecode(response.body);
        var name = nameCaper(data['displayName']);
        var rollNumber = data['surname'];
        var email = data['userPrincipalName'];
        var id = data['id'];
        var course = data['jobTitle'];
        await storage.write(key: "user", value: id);
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference users = firestore.collection('users');
        DocumentSnapshot snapshot = await users.doc(id).get();
        if (!snapshot.exists) {
          // New user
          UserModel myUser = UserModel(id: id, name: name, email: email);
          users.doc(id).set(myUser.toJson());
        } else {
          // Already there
          UserModel myUser =
              UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => TabsScreen(oauth: oauth),
            ),
          );
        }
      } else {
        // TODO: error

      }
    } catch (e) {
      // showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
          future: getLogin(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => TabsScreen(
                      oauth: oauth,
                    ),
                  ),
                );
              });
              return Text("Logged in!");
            } else {
              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/login_page.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 120,
                        ),
                        const SizedBox(
                          height: 200,
                          width: 200,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 200,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: const EdgeInsets.all(0),
                          width: 200,
                          child: const Divider(
                            thickness: 4,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Tagify',
                          style: GoogleFonts.inter(
                              fontSize: 40,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 250,
                        ),
                        Builder(builder: (context) {
                          return GestureDetector(
                            onTap: () => auth(context),
                            child: Container(
                              width: 300,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(9),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Login with Outlook',
                                  style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
