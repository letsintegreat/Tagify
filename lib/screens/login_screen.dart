import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/login_page.svg'),
                  fit: BoxFit.cover),
              
            ),
          ),
          Container(
            width: double.infinity,
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
                  margin: EdgeInsets.all(0),
                  child: Divider(
                    thickness: 4,
                    color: Colors.white,
                  ),
                  width: 200,
                ),
                const SizedBox(
                  height: 300,
                ),
                Container(
                  width: 300,
                  height: 60,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(9))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
