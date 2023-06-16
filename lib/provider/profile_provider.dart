import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  List<dynamic> _mutualFollowers = [];

  List<dynamic> get getMutualFollowers {
    return _mutualFollowers;
  }

  UserProfile? _selectedUser;

  UserProfile? get getSelectedUser {
    return _selectedUser;
  }

  bool isFollowing = false;

  Future<void> fetchUserDetails(String selectedUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final result = await FirebaseFirestore.instance
        .collection("users")
        .doc(selectedUserId)
        .get();
    final userData = result.data();

    _selectedUser = UserProfile(
        userId: userData!["userId"],
        name: userData["name"],
        emailId: userData["email"],
        bio: userData["bio"],
        imageUrl: userData["imageUrl"],
        followersCount: userData["followersCount"],
        followingCount: userData["followingCount"],
        postCount: userData["postCount"]);
    notifyListeners();
    if(selectedUserId!=currentUserId) {
      fetchMutualFollowers(selectedUserId, currentUserId);
    }
  }

  Future<void> fetchMutualFollowers(
      String selectedUserId, String currentUserId) async {
    final HttpsCallable findMutualFollowers =
        FirebaseFunctions.instance.httpsCallable('getMutualFollowers');
    final result = await findMutualFollowers.call({
      'currentUserId': currentUserId,
      'selectedUserId': selectedUserId,
    });
    _mutualFollowers = result.data as List<dynamic>;
    notifyListeners();
  }

  Future<void> getIsFollowing(
      String selectedUserId, String currentUserId) async {
    final HttpsCallable isFollowed =
        FirebaseFunctions.instance.httpsCallable('isFollowing');
    final data = await isFollowed.call({
      'currentUserId': currentUserId,
      'selectedUserId': selectedUserId,
    });
    isFollowing = data.data;
    notifyListeners();
  }
}
