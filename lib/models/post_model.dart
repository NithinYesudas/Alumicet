class Post {
  final String userId, postId, imageUrl, caption;
  final int likesCount, commentsCount;

  final DateTime createdAt;
  final bool isLiked;

  Post(
      {required this.userId,
      required this.postId,
      required this.imageUrl,
      required this.caption,
      required this.commentsCount,
      required this.isLiked,
      required this.likesCount,
      required this.createdAt,
});
}

class Comment {
  final String userId, comment;

  Comment({required this.userId, required this.comment});
}
