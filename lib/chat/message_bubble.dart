import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  MessageBubble({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          width: 200,
          decoration: BoxDecoration(
            
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: isMe
                  ? const Color.fromRGBO(108, 52, 217, 0.9)
                  : Colors.white),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message,
            style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: !isMe
                    ? const Color.fromRGBO(108, 52, 217, 0.9)
                    : Colors.white),
          ),
        ),
      ],
    );
  }
}
