import 'package:flutter/material.dart';

import '../domain/scoreboard_interactor.dart';

class ScoreboardPage extends StatefulWidget {
  const ScoreboardPage({super.key});

  @override
  ScoreboardPageState createState() => ScoreboardPageState();
}

class ScoreboardPageState extends State<ScoreboardPage> {
  final _scoreboardInteractor = ScoreboardInteractor();

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
            _buildScoreboardContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreboardContent() {
    return FutureBuilder<List<ScoreboardEntry>>(
      future: _scoreboardInteractor.getScoreboard(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading scoreboard'));
        } else {
          final scoreboardData = snapshot.data;
          return Column(
            children: [
              Row(
                children: [
                  _buildColumnTitle('Email'),
                  _buildColumnTitle('Games Played'),
                ],
              ),
              const SizedBox(height: 16.0),
              ...scoreboardData!.map((entry) {
                return _buildScoreboardRow(entry.email, entry.games);
              }).toList(),
            ],
          );
        }
      },
    );
  }

  Widget _buildColumnTitle(title) {
    return Expanded(
      flex: 3,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
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
