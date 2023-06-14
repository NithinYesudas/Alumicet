
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/user_model.dart';
import '../../utils/custom_colors.dart';
import 'messages_screen.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final fireStore = FirebaseFirestore.instance;
  final HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('getMessagerDetails');

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        backgroundColor: CustomColors.lightAccent,
        title: Text(
          "Chats",
          style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .doc(currentUserId)
            .collection("people")
            .orderBy("createdAt")
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: CustomColors.lightAccent,
                strokeWidth: 2,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Messages yet",
                style: GoogleFonts.nunitoSans(),
              ),
            );
          }

          final people = snapshot.data!.docs;

          return ListView.builder(
              itemCount: people.length,
              itemBuilder: (_, index) {
                final user =
                    people[people.length - index - 1].id; //to reverse the list
                return FutureBuilder(
                    future: fireStore.collection("users").doc(user).get(),
                    builder: (_, futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox();
                      }
                      final data = futureSnapshot.data!.data();
                      final selectedUser = UserProfile(
                          userId: data!['userId'],
                          name: data["name"],
                          emailId: data['email'],
                          bio: data['bio'],
                          imageUrl: data['imageUrl'],
                          followersCount: data['followersCount'],
                          followingCount: data['followingCount'],
                          postCount: data['postCount']);
                      final name = selectedUser.name;
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => MessagesScreen(
                                      selectedUser: selectedUser)));
                            },
                            title: Text(
                              name,
                              style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w700,fontSize: mediaQuery.width*.045 ),
                            ),
                            leading: CircleAvatar(
                              radius: mediaQuery.width*.06,
                              backgroundImage: NetworkImage(data["imageUrl"]),
                            ),
                            // subtitle: LastMessage(userId:data["userId"]),
                          ),
                          const Divider(
                            height: 5,
                            color: Colors.black12,
                          )
                        ],
                      );
                    });
              });
        },
      ),
    );
  }
}
