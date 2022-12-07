import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/screens/email_signup.dart';

import '../widgets/my_password_field.dart';
import '../widgets/my_text_button.dart';
import '../widgets/my_text_field.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({super.key});

  @override
  _EmailLoginPageState createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLogin> {
  bool isPasswordVisible = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _emailError = "";
  String _passwordError = "";

  Future<void> submit() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    if (email.isEmpty) {
      setState(() {
        _emailError = "Username required.";
      });
      return;
    }
    else{
      setState(() {
        _emailError = "";
      });
    }
    if (password.isEmpty) {
      setState(() {
        _passwordError = "Password required.";
      });
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        setState(() {
          _emailError = "Invalid username";
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _passwordError = "Incorrect password";
        });
      } else {
        setState(() {
          _emailError = e.code;
        });
      }
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
        constraints: const BoxConstraints(minHeight: double.infinity),
        color: const Color.fromRGBO(82, 45, 174, 1),
        child: SafeArea(
          //to make page scrollable
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome back.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "You've been missed!",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        MyTextField(
                          errorText: _emailError,
                          controller: _emailController,
                          hintText: 'Email',
                          inputType: TextInputType.text,
                        ),
                        MyPasswordField(
                          errorText: _passwordError,
                          controller: _passwordController,
                          isPasswordVisible: isPasswordVisible,
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmailSignup(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextButton(
                    buttonName: 'Sign In',
                    onTap: submit,
                    bgColor: Colors.white,
                    textColor: Colors.black87,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
