import 'package:alumni_connect/component_widgets/profile_widgets/post_view_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostList extends StatelessWidget {
  PostList({required this.selectedUserId, Key? key}) : super(key: key);
  final String selectedUserId;
  final currentUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Flexible(
      fit: FlexFit.loose,
      child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("posts")
              .doc(selectedUserId)
              .collection('images')
              .orderBy("createdAt")
              .get(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final posts = snapshot.data!.docs;
            return SizedBox(
              height: mediaQuery.height * (posts.length * .3),
              child: GridView.builder(
                  itemCount: posts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    mainAxisSpacing: 5, // Spacing between rows
                    crossAxisSpacing: 5.0, // Spacing between columns
                  ),
                  itemBuilder: (ctx, index) {
                    final post = posts[index].data();
                    print(post);
                    return GestureDetector(
                      onTap: selectedUserId == currentUid
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostViewScreen(
                                            post: post,
                                          )));
                            }
                          : () {},
                      child: SizedBox(
                        height: mediaQuery.height * .3,
                        width: mediaQuery.width * .4,
                        child: Image.network(
                          post['imageUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
            );
          }),
    );
  }
}
