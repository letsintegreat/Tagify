import 'dart:convert';
import 'dart:io';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hackathon_project/models/user_model.dart';
import 'package:hackathon_project/screens/email_login.dart';
import 'package:hackathon_project/screens/tabs_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  // AadOAuth oauth;
  LoginScreen({super.key});

  // Future<String?> getLogin() async {
  //   const storage = FlutterSecureStorage();
  //   String? value = await storage.read(key: "user");
  //   return value;
  // }

  // String nameCaper(String name) {
  //   name = name.toLowerCase();
  //   String newname = name[0].toUpperCase();
  //   for (var i = 1; i < name.length; i++) {
  //     newname = newname + name[i];
  //     if (name[i] == ' ') {
  //       newname = newname + name[i + 1].toUpperCase();
  //       i++;
  //     }
  //   }
  //   return newname;
  // }

  void auth(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        String id = auth.currentUser!.uid;
        String name = auth.currentUser!.displayName!;
        String email = auth.currentUser!.email!;

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference users = firestore.collection('users');
        DocumentSnapshot snapshot = await users.doc(id).get();
        if (!snapshot.exists) {
          // New user
          UserModel myUser = UserModel(id: id, name: name, email: email);
          users.doc(id).set(myUser.toJson());
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }
  }

  // void auth(BuildContext context) async {
  //   final storage = FlutterSecureStorage();
  //   try {
  //     await oauth.login();
  //     var accessToken = await oauth.getAccessToken();
  //     if (accessToken != null) {
  //       var response = await http.get(
  //           Uri.parse('https://graph.microsoft.com/v1.0/me'),
  //           headers: {HttpHeaders.authorizationHeader: accessToken});
  //       print(response.statusCode);
  //       if (response.statusCode != 200) {
  //         print("error");
  //         return;
  //       }
  //       var data = jsonDecode(response.body);
  //       var name = nameCaper(data['displayName']);
  //       var rollNumber = data['surname'];
  //       var email = data['userPrincipalName'];
  //       var id = data['id'];
  //       var course = data['jobTitle'];
  //       await storage.write(key: "user", value: id);
  //       FirebaseFirestore firestore = FirebaseFirestore.instance;
  //       CollectionReference users = firestore.collection('users');
  //       DocumentSnapshot snapshot = await users.doc(id).get();
  //       if (!snapshot.exists) {
  //         // New user
  //         UserModel myUser = UserModel(id: id, name: name, email: email);
  //         users.doc(id).set(myUser.toJson());
  //       } else {
  //         // Already there
  //         UserModel myUser =
  //             UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
  //         Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(
  //             builder: (context) => TabsScreen(oauth: oauth),
  //           ),
  //         );
  //       }
  //     } else {
  //       // TODO: error

  //     }
  //   } catch (e) {
  //     // showError(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
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
                    backgroundColor: Color.fromRGBO(108, 52, 217, 1),
                    radius: 180,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.all(0),
                  width: 180,
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
                  height: 200,
                ),
                Builder(builder: (context) {
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>EmailLogin())),
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
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.all(8),
                                child: const Icon(Icons.email,size: 42)),
                             const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Login with Email',
                              style: GoogleFonts.inter(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20,),
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
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.all(8),
                                child: Image.asset(
                                  'assets/google.png',
                                  height: 30,
                                  width: 30
                                  )),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Login with Google',
                              style: GoogleFonts.inter(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
