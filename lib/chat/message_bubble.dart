import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String Sender;

  MessageBubble({
    required this.message,
    required this.isMe,
    required this.Sender,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 220),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: isMe
                      ? const Color.fromRGBO(108, 52, 217, 0.9)
                      : Colors.white),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isMe)
                    Text(
                      Sender,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  Text(
                    message,
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: !isMe
                            ? const Color.fromRGBO(108, 52, 217, 0.9)
                            : Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
