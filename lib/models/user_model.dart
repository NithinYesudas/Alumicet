class UserProfile {
  final String userId, name, emailId, imageUrl, bio;

  final int postCount,followingCount,followersCount;

  UserProfile({
    required this.userId,
    required this.name,
    required this.emailId,
    required this.bio,
    required this.imageUrl,
    required this.followersCount,
    required this.followingCount,
    required this.postCount
  });
}
