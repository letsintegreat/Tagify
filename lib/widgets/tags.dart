import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Tag extends StatelessWidget {
  final String tagName;

  Tag({required this.tagName});

  @override
  Widget build(BuildContext context) {
    return
      Flexible(
        child: Container(
        padding: const EdgeInsets.symmetric(horizontal:12, vertical: 10),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(82, 45, 174, 1),
            borderRadius: BorderRadius.all(Radius.circular(36))),
              child: Text(
                tagName,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
              )
          )
      );
  }
}
