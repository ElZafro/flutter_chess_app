import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/scoreboard_interactor.dart';

class Database {
  final db = FirebaseFirestore.instance;

  Future<void> addUser(email) async {
    final user = {"email": email, "games": 0};

    await db.collection('Users').add(user);
  }

  Future<void> registerGame(email) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users') // Replace with your collection name
        .where('email', isEqualTo: email)
        .get();

    final List<QueryDocumentSnapshot> documents = snapshot.docs;

    if (documents.isNotEmpty) {
      final DocumentSnapshot document = documents.first;

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(document.id)
          .update({"games": FieldValue.increment(1)});
    }
  }

  Future<List<ScoreboardEntry>> getScoreboard() async {
    try {
      final QuerySnapshot querySnapshot = await db.collection('Users').get();

      final List<ScoreboardEntry> scoreboardData = [];

      for (var doc in querySnapshot.docs) {
        final email = doc['email'];
        final games = doc['games'] as int;
        final entry = ScoreboardEntry(email: email, games: games);
        scoreboardData.add(entry);
      }

      return scoreboardData;
    } catch (e) {
      return [];
    }
  }
}
