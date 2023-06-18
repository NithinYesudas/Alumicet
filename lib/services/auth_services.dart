import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/accessory_widgets.dart';

class AuthServices {
  static Future<bool> login(
      String email, String password, BuildContext ctx) async {
    // function for login
    bool isSuccessful = true;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("logging in");
    } on FirebaseAuthException catch (e) {
      isSuccessful = false;
      String? message;
      if (e.code.contains("user-not-found")) {
        message = "User not found";
      } else {
        message = e.code;
      }
      AccessoryWidgets.snackBar(message, ctx);
      isSuccessful = false;
    } on PlatformException catch (e) {
      AccessoryWidgets.snackBar("An error occurred", ctx);
    } on Exception catch (e) {
      isSuccessful = false;
      AccessoryWidgets.snackBar("An error occurred", ctx);
    }
    return isSuccessful;
  }

  static Future<bool> createAccount(
      //for creating a new account
      String email,
      String password,
      BuildContext ctx) async {
    bool isSuccessful = true;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      AccessoryWidgets.snackBar(e.code, ctx);
      isSuccessful = false;
    } catch (error) {
      AccessoryWidgets.snackBar("An error occured", ctx);
      isSuccessful = false;
    }
    return isSuccessful;
  }

  static Future<bool> uploadDetails(Uint8List image, String name, String bio,
      String passOutYear, BuildContext ctx) async {
    //to upload user details to database
    bool isSuccessful = true;
    try {
      final authRef = FirebaseAuth.instance;
      String? uid = authRef.currentUser?.uid;
      String? email = authRef.currentUser!.email;
      final fireStoreRef = FirebaseFirestore.instance;
      String role;
      if (int.parse(passOutYear) > DateTime.now().year) {
        role = "Student";
      } else {
        role = "Alumni";
      }

      final metadata = SettableMetadata(contentType: 'image/jpeg');
      TaskSnapshot details = await FirebaseStorage.instance
          . //upload image to storage
          ref()
          .child("profileImages/$uid/$uid.jpg")
          .putData(image, metadata)
          .whenComplete(() {});
      if (details.state == TaskState.success) {
        String imageUrl =
            await details.ref.getDownloadURL(); //get image url from storage

        await fireStoreRef.collection('users').doc(uid).set({
          "userId": uid,
          "email": email,
          "name": name,
          "bio": bio,
          "role": role,
          "passOutYear": passOutYear,
          "imageUrl": imageUrl,
          "followingCount": 0,
          "followersCount": 0,
          "postCount": 0
        });
      }
    } on FirebaseException catch (e) {
      isSuccessful = false;
      print(e.message);
      AccessoryWidgets.snackBar('FirebaseException while uploading file', ctx);
      // Handle FirebaseException
    } on IOException catch (e) {
      isSuccessful = false;
      AccessoryWidgets.snackBar('IOException while uploading file', ctx);
      // Handle IOException
    } catch (e) {
      isSuccessful = false;
      print(e);
      AccessoryWidgets.snackBar(
          'An Unknown error occured while uploading', ctx);
      // Handle other exceptions
    }

    return isSuccessful;
  }

  static Future<void> deleteAccount() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser!.uid;
    await FirebaseFirestore.instance.collection("users").doc(uid).delete();
    await currentUser.delete();
  }

  static Future<bool> updateDetails(
      Uint8List image, String name, String bio, BuildContext ctx) async {
    bool isSuccessful = false;
    try {
      final authRef = FirebaseAuth.instance;
      String? uid = authRef.currentUser?.uid;
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      TaskSnapshot details = await FirebaseStorage.instance
          . //upload image to storage
          ref()
          .child("profileImages/$uid/$uid.jpg")
          .putData(image, metadata)
          .whenComplete(() {});
      if (details.state == TaskState.success) {
        String imageUrl =
            await details.ref.getDownloadURL(); //get image url from storage

        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .update({"name": name, "bio": bio, "imageUrl": imageUrl});
        isSuccessful = true;
      }
    } on FirebaseException catch (e) {
      AccessoryWidgets.snackBar(e.message!, ctx);
    } catch (e) {
      AccessoryWidgets.snackBar("An error occured", ctx);
    }

    return isSuccessful;
  }
}
