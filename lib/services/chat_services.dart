import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  static Future<void> sendMessage(String message, String selectedUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final fireStore = FirebaseFirestore.instance;
    await fireStore
        .collection("chats")
        .doc(currentUserId)
        .collection("people")
        .doc(selectedUserId)
        .collection("messages")
        .add({
      "message": message,
      "userId": currentUserId,
      "createdAt": DateTime.now().toIso8601String()
    });
    await fireStore.collection("chats").doc(currentUserId).collection("people").doc(selectedUserId).set(
        {"createdAt": DateTime.now().toIso8601String()});

  }
}
