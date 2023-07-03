import 'package:final_project/domain/scoreboard_interactor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/auth.dart';
import '../data/local_storage.dart';
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

  final controller = ChessBoardController();
  final chessboardSettings = ChessPagePresenter(LocalStorage(GetStorage()));
  final scoreboardInteractor = ScoreboardInteractor();

  bool _showResetButton = false;

  @override
  void initState() {
    super.initState();
    chessboardSettings.readSettings();
    controller.addListener(() {
      if (controller.isGameOver()) {
        setState(() {
          _showResetButton = true;
        });
        scoreboardInteractor.registerGame(user!.email);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Visibility(
        visible: _showResetButton,
        child: FloatingActionButton(
            onPressed: () {
              controller.resetBoard();
              setState(() {
                _showResetButton = false;
              });
            },
            child: const Icon(Icons.restart_alt)),
      ),
      appBar: AppBar(title: Text('Logged in as ${user?.email}')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ChessBoard(
                controller: controller,
                boardColor: chessboardSettings.settings.boardColor,
                boardOrientation: chessboardSettings.settings.boardOrientation,
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

  Future<void> _navigateToSettingsPage(context) async {
    Get.to(ChessPage(
      chessboardSettings: LocalStorage(GetStorage()),
    ))?.then((value) => setState(() => chessboardSettings.readSettings()));
  }

  Future<void> _navigateToScoreboard(context) async {
    Get.to(const ScoreboardPage());
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
}
