import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../utils/accessory_widgets.dart';

class PostServices {
  static Future<bool> uploadPost(
      Uint8List image, String caption, BuildContext ctx) async {
    bool isSuccessful = false;
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final reference = FirebaseStorage.instance;
      final metaData = SettableMetadata(contentType: "image/jpg");
      final fileName = "${const Uuid().v1()}.jpg";
      TaskSnapshot details = await reference
          .ref()
          .child("posts/$uid/$fileName")
          .putData(image, metaData)
          .whenComplete(() {});
      if (details.state == TaskState.success) {
        isSuccessful = true;
        final imageUrl = await details.ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(uid)
            .collection("images")
            .add({
          "userId": uid,
          "imageUrl": imageUrl,
          "caption": caption,
          "postId": "",
          "likesCount": 0,
          "commentsCount": 0,
          "createdAt": DateTime.now().toIso8601String()
        });
      }
    } on FirebaseException catch (e) {
      isSuccessful = false;
      AccessoryWidgets.snackBar('FirebaseException while uploading file', ctx);
      // Handle FirebaseException
    } on IOException catch (e) {
      isSuccessful = false;
      AccessoryWidgets.snackBar('IOException while uploading file', ctx);
      // Handle IOException
    } catch (e) {
      isSuccessful = false;
      print(e.toString());
      AccessoryWidgets.snackBar('An Unknown error occured', ctx);
      // Handle other exceptions
    }
    return isSuccessful;
  }

  static Future<void> likeDislike(String selectedUserId, String postId,
      bool isLike, BuildContext context) async {
    final fireStore = FirebaseFirestore.instance;
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    try {
      if (isLike) {
        await fireStore
            .collection("posts")
            .doc(selectedUserId)
            .collection("images")
            .doc(postId)
            .collection("likes")
            .doc(currentUserId)
            .set({"userId": currentUserId});
      } else {
        await fireStore
            .collection("posts")
            .doc(selectedUserId)
            .collection("images")
            .doc(postId)
            .collection("likes")
            .doc(currentUserId)
            .delete();
      }
    } on FirebaseException catch (e) {
      AccessoryWidgets.snackBar(e.code, context);
    } catch (e) {
      AccessoryWidgets.snackBar("An error occurred", context);
    }
  }

  static Future<bool> getIsLiked(
      {required String selectedUserId, required String postId}) async {
    HttpsCallable isLiked = FirebaseFunctions.instance.httpsCallable('isLiked');
    final result = await isLiked
        .call({'selectedUserId': selectedUserId, 'postId': postId});
    return result.data;
  }

  static Future<void> addComment(String comment, String selectedUserId,
      String postId, BuildContext context) async {
    final fireStore = FirebaseFirestore.instance;
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    try {
      await fireStore
          .collection("posts")
          .doc(selectedUserId)
          .collection("images")
          .doc(postId)
          .collection("comments")
          .add({"userId": currentUserId, "comment": comment});
    } on FirebaseException catch (e) {
      AccessoryWidgets.snackBar(e.code, context);
    } catch (e) {
      AccessoryWidgets.snackBar("An error occurred", context);
    }
  }

  static Future<bool> deletePost(String userId, String postId) async {
    bool isSuccessful = false;
    try {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(userId)
          .collection("images")
          .doc(postId)
          .delete();
      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        "postCount": FieldValue.increment(-1),
      });

      isSuccessful = true;
    } on FirebaseException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    return isSuccessful;
  }

  static Future<bool> updatePost(
      String userId, String postId, String caption) async {
    bool isSuccessful = false;
    try {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(userId)
          .collection("images")
          .doc(postId)
          .update({"caption": caption});
      isSuccessful = true;
    } on FirebaseException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    return isSuccessful;
  }
}
