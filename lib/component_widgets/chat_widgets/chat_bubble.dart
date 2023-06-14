
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/message_model.dart';
import '../../utils/custom_colors.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({required this.message, Key? key}) : super(key: key);
  final Message message;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: isCurrentUser?MainAxisAlignment.end:MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(mediaQuery.height*.01),
          padding: EdgeInsets.symmetric(horizontal:mediaQuery.width*.03,vertical: mediaQuery.height*.01),
          alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: isCurrentUser?CustomColors.lightAccent:Colors.black45,
              borderRadius: isCurrentUser
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
          child: Text(
            message.message,
            style: GoogleFonts.nunitoSans(color: Colors.white),
          ),
        ),
      ],
    );
  }

  bool  get isCurrentUser  {
    return currentUserId == message.userId;
  }
}
