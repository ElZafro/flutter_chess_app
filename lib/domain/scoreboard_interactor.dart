import '../data/database.dart';

class ScoreboardEntry {
  final String email;
  final int games;

  ScoreboardEntry({required this.email, required this.games});
}

class ScoreboardInteractor {
  final _database = Database();

  Future<List<ScoreboardEntry>> getScoreboard() async {
    return await _database.getScoreboard();
  }

  void registerGame(email) async {
    await _database.registerGame(email);
  }
}
