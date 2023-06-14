import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';

import '../models/post_model.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _followingPosts = [];
  bool isLiked = true;

  List<Post> get getFollowingPosts {
    return _followingPosts;
  }

  Future<void> fetchFollowingPosts() async {
    try {
      final HttpsCallable getFollowingPostsCallable =
          FirebaseFunctions.instance.httpsCallable('getFollowingPosts');

      final result = await getFollowingPostsCallable.call();
      final postList = result.data;
      final List<Post> loadedPosts = [];
      postList.forEach((post) {
        loadedPosts.add(Post(
            userId: post["userId"],
            postId: post["postId"],
            imageUrl: post["imageUrl"],
            caption: post["caption"],
            likesCount: post["likesCount"],
            commentsCount: post["commentsCount"],
            createdAt: DateTime.parse(post["createdAt"]),

            isLiked: post["isLiked"]));
      });

      _followingPosts = loadedPosts;

      print(_followingPosts);
      notifyListeners();
    } on FirebaseException catch (e) {
      print("an error occured${e.message}");
    }
  }


}
