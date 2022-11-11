import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    image: AssetImage('assets/login_page.png'),
                    fit: BoxFit.cover)),
          ),
          // Container(
          //   width: double.infinity,
          //   child:
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
                Text('Project X', style: GoogleFonts.inter(fontSize: 40,fontWeight: FontWeight.w300,color: Colors.white),),
                const SizedBox(
                  height: 250,
                ),
                Container(
                  width: 300,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(9),
                    ),
                  ),
                  child:  Center(
                    child: Text('Login with Outlook',style: GoogleFonts.inter(fontSize: 20,fontWeight: FontWeight.w500),),
                  ),
                ),
              ],
            ),
          ),
          //),
        ],
      ),
    );
  }
}
