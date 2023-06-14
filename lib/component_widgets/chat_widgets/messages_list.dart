
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/message_model.dart';
import 'chat_bubble.dart';

class MessagesList extends StatelessWidget {
  MessagesList({required this.selectedUserId, Key? key}) : super(key: key);
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final String selectedUserId;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .doc(currentUserId)
            .collection("people")
            .doc(selectedUserId)
            .collection("messages").orderBy("createdAt")
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No messages yet",
                style: GoogleFonts.nunitoSans(),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: mediaQuery.width*.01,vertical: mediaQuery.height*.01),
            itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) {
            final messageDoc = snapshot.data!.docs[index].data();
            final message = Message(
                userId: messageDoc['userId'],
                message: messageDoc["message"],
                createdAt: DateTime.parse(messageDoc['createdAt']));
            return ChatBubble(message: message);
          });
        });
  }
}
