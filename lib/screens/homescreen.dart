import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hey there'),
        backgroundColor: const Color(0xff7A53D9),
        elevation: 0,
      ),
      body: Container(
        color: const Color.fromRGBO(229, 224, 239, 1),
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: ListView.builder(
            itemBuilder: (context, index) => Container(
              height: 75,
              margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(36),color: Colors.white),
              child: Row(
                children: [
                  const SizedBox(width: 10,),
                  CircleAvatar(backgroundColor: Colors.grey[200],radius: 32,),
                  const SizedBox(width: 10,),
                  Text('Group Name',style: GoogleFonts.inter(fontSize: 22,color: Colors.black),)
                ],
              ),
            ),
            itemCount: 5,
          ),
        ),
      ),
    );
  }
}
