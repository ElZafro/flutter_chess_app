import 'package:final_project/data/database.dart';
import 'package:flutter/material.dart';

class ScoreboardPage extends StatelessWidget {
  final _database = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scoreboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scoreboard',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder<Map<String, int>>(
              future: _database.readScoreboard(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading scoreboard'));
                } else {
                  final scoreboardData = snapshot.data;
                  return Column(
                    children: scoreboardData!.entries.map((entry) {
                      return _buildScoreboardRow(entry.key, entry.value);
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreboardRow(String email, int games) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              email,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              games.toString(),
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: ScoreboardPage()));
}
