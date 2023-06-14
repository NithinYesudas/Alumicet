import 'package:cloud_firestore/cloud_firestore.dart';

class RatingServices {
  static Future<double> calculateRating() async {
    final firestore = FirebaseFirestore.instance;
    final result = await firestore.collection("users").get();
    final users = result.docs;
    dynamic postCount = 1;
    for (var snapshot in users) {
      final user = snapshot.data()["postCount"];
      postCount += user;
    }
    final rating = (users.length*5)/postCount;
    return rating.roundToDouble();
  }
}
