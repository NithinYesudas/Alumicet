
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../utils/accessory_widgets.dart';

class FollowServices {
  static Future<void> followUnfollow(
      bool isFollow, String selectedUserId, BuildContext context) async {
    final fireStore = FirebaseFirestore.instance;
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    try {
      if (!isFollow) {
        await fireStore
            .collection("users")
            .doc(currentUserId)
            .collection("following")
            .doc(selectedUserId)
            .set({"userId": selectedUserId});
        await fireStore
            .collection("users")
            .doc(selectedUserId)
            .collection("followers")
            .doc(currentUserId)
            .set({"userId": selectedUserId});
      } else {
        await fireStore
            .collection("users")
            .doc(selectedUserId)
            .collection("followers")
            .doc(currentUserId)
            .delete();
        await fireStore
            .collection("users")
            .doc(currentUserId)
            .collection("following")
            .doc(selectedUserId)
            .delete();
      }
    } on FirebaseException catch (e) {
      AccessoryWidgets.snackBar(e.code, context);
    } catch (e) {
      AccessoryWidgets.snackBar("Unknown error occured", context);
    }
  }
}
