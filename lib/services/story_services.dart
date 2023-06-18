import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StoryServices {
  static Future<void> uploadStory(Uint8List image) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final reference = FirebaseStorage.instance;

    final fileName = "${const Uuid().v1()}.jpg";
    final metaData = SettableMetadata(contentType: "image/jpg");
    TaskSnapshot details = await reference
        .ref()
        .child("stories/$uid/$fileName")
        .putData(image, metaData)
        .whenComplete(() {});
    if (details.state == TaskState.success) {
      final imageUrl = await details.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection("stories").doc(uid).set({
        "userId": uid,
        "imageUrl": imageUrl,
        "createdAt": DateTime.now().toIso8601String()
      });
    }
  }
}
