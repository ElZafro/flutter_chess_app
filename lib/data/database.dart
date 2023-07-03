import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final db = FirebaseFirestore.instance;

  Future<void> addUser(email) async {
    final user = {"email": email, "games": 0};

    await db.collection('Users').add(user);
  }

  Future<Map<String, int>> readScoreboard() async {
    try {
      final QuerySnapshot querySnapshot = await db.collection('Users').get();

      final Map<String, int> scoreboardData = {};

      for (var doc in querySnapshot.docs) {
        final email = doc['email'];
        final games = doc['games'] as int;
        scoreboardData[email] = games;
      }

      return scoreboardData;
    } catch (e) {
      return {};
    }
  }
}
