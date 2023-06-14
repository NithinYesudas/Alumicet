class Message {
  final String message, userId;
  final DateTime createdAt;

  Message(
      {required this.userId, required this.message, required this.createdAt});
}
