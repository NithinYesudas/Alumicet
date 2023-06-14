
import 'package:alumni_connect/component_widgets/homescreen_widgets/post_head_section.dart';
import 'package:flutter/material.dart';

import '../../models/post_model.dart';
import 'likes_and_comment_section.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({required this.post, Key? key}) : super(key: key);
  final Post post;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return SizedBox(
      height: mediaQuery.height * .76,
      width: double.infinity,
      child: Column(
        children: [
          PostHeadWidget(userId: post.userId),
          const Divider(color: Colors.white,height: 4,),
          SizedBox(
              height: mediaQuery.height * .5,
              width: mediaQuery.width,
              child: Image.network(
                post.imageUrl,
                fit: BoxFit.cover,
              )),
          LikesAndCommentWidget(post: post,)
        ],
      ),
    );
  }
}
