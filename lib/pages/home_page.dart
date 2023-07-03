import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/auth.dart';
import '../data/settings_data_provider.dart';
import '../domain/settings_page_presenter.dart';
import 'scoreboard.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final User? user = Auth().currentUser;

  ChessBoardController controller = ChessBoardController();
  ChessPagePresenter presenter =
      ChessPagePresenter(ChessDataProvider(GetStorage()));

  @override
  void initState() {
    super.initState();
    presenter.readSettings();
  }

  Future<void> _navigateToSettingsPage(context) async {
    Get.to(ChessPage(
      dataProvider: ChessDataProvider(GetStorage()),
    ))?.then((value) => setState(() => presenter.readSettings()));
  }

  Future<void> _navigateToScoreboard(context) async {
    Get.to(ScoreboardPage());
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _navigateToSettingsButton() {
    return ElevatedButton(
        onPressed: () {
          _navigateToSettingsPage(context);
        },
        child: const Text('Settings'));
  }

  Widget _navigateToScoreboardButton() {
    return ElevatedButton(
        onPressed: () {
          _navigateToScoreboard(context);
        },
        child: const Text('Scoreboard'));
  }

  Widget _recentMovesList() {
    return ValueListenableBuilder<Chess>(
      valueListenable: controller,
      builder: (context, game, _) {
        return SingleChildScrollView(
          child: Text(
            controller.getSan().fold(
                  '',
                  (previousValue, element) =>
                      '$previousValue\n${element ?? ''}',
                ),
          ),
        );
      },
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logged in as ${user?.email}')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ChessBoard(
                controller: controller,
                boardColor: presenter.settings.boardColor,
                boardOrientation: presenter.settings.boardOrientation,
              ),
            ),
          ),
          Expanded(child: _recentMovesList()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _signOutButton(),
                _navigateToScoreboardButton(),
                _navigateToSettingsButton(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
