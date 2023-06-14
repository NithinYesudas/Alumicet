
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../models/post_model.dart';
import '../../services/post_services.dart';
import '../../utils/custom_colors.dart';

class CommentSheet {
  static void openModalBottomSheet(BuildContext context, Post post) {
    final mediaQuery = MediaQuery.of(context).size;
    final TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: mediaQuery.height * .6,
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
          child: Column(
            children: [
              SizedBox(
                height: mediaQuery.height * .08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                            prefixIcon: Icon(
                              Ionicons.mail_outline,
                              color: CustomColors.lightAccent,
                            ),
                            hintText: "Add a Comment",
                            hintStyle: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600,
                                color: Colors.black38),
                            fillColor: Colors.black12,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              CustomColors.lightAccent)),
                      onPressed: () {
                        PostServices.addComment(
                            controller.text, post.userId, post.postId, context);
                      },
                      child: const Icon(
                        Ionicons.send_outline,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: mediaQuery.height*.4,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .doc(post.userId)
                        .collection("images")
                        .doc(post.postId)
                        .collection("comments")
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final result = snapshot.data;
                      if (result == null) {
                        return const SizedBox();
                      } else {
                        final commentDocs = result.docs;
                        return ListView.builder(
                            itemCount: commentDocs.length,
                            itemBuilder: (ctx, index) {
                              final comments = commentDocs[index].data();
                              final commentUserId = comments["userId"];

                              return FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(commentUserId)
                                      .get(),
                                  builder: (ctx, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox();
                                    }
                                    final userName =
                                        snapshot.data!.data()!["name"];
                                    final imageUrl =
                                        snapshot.data!.data()!["imageUrl"];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(imageUrl),
                                      ),
                                      title: Text(
                                        userName,
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      subtitle: Text(
                                        comments["comment"],
                                        style: GoogleFonts.nunitoSans(),
                                      ),
                                    );
                                  });
                            });
                      }
                    }),
              )
            ],
          ),
        );
      },
    );
  }
}
