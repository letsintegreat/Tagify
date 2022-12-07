import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/models/user_model.dart';

import '../widgets/my_password_field.dart';
import '../widgets/my_text_button.dart';
import '../widgets/my_text_field.dart';

class EmailSignup extends StatefulWidget {
  const EmailSignup({super.key});

  @override
  _EmailSignupState createState() => _EmailSignupState();
}

class _EmailSignupState extends State<EmailSignup> {
  bool passwordVisibility = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  String _nameError = "";
  String _emailError = "";
  String _passwordError = "";
  String _confirmError = "";

  Future<void> submit() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirm = _confirmController.text;

    if (name.isEmpty) {
      setState(() {
        _nameError = "Name is required.";
      });
      return;
    }
    else{
      setState(() {
        _nameError = "";
      });
    }
    if (email.isEmpty) {
      setState(() {
        _emailError = "Email is required.";
      });
      return;
    }
    else if (! RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      setState(() {
        _emailError =
        "Enter valid email";
      });
      return;
    }
    else{
      setState(() {
        _emailError = "";
      });
    }
    if (password != confirm) {
      setState(() {
        _confirmError = "Passwords don't match.";
      });
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = FirebaseAuth.instance.currentUser!;
      CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");
      UserModel user = UserModel(
          id: firebaseUser.uid, name: name, email: email);
      usersCollection.doc(user.id).set(user.toJson());
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        setState(() {
          _passwordError = "Password too weak.";
        });
      } else if (e.code == "email-already-in-use") {
        setState(() {
          _emailError = "Username already registered.";
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Some error occurred")));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(82, 45, 174, 1),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        constraints: BoxConstraints(minHeight: double.infinity),
        color: const Color.fromRGBO(82, 45, 174, 1),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Create new account to get started.",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      MyTextField(
                        errorText:  _nameError,
                        controller: _nameController,
                        hintText: 'Name',
                        inputType: TextInputType.name,
                      ),
                      MyTextField(
                        errorText: _emailError,
                        controller: _emailController,
                        hintText: 'Email',
                        inputType: TextInputType.emailAddress,
                      ),
                      MyPasswordField(
                        errorText: _passwordError,
                        controller: _passwordController,
                        isPasswordVisible: passwordVisibility,
                        onTap: () {
                          setState(() {
                            passwordVisibility = !passwordVisibility;
                          });
                        },
                      ),
                      MyTextField(
                        errorText: _confirmError,
                        controller: _confirmController,
                        hintText: 'Confirm Password',
                        inputType: TextInputType.text,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextButton(
                    buttonName: 'Register',
                    onTap: submit,
                    bgColor: Colors.white,
                    textColor: Colors.black87,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
