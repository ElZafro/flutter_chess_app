import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'data/settings_data_provider.dart';
import 'pages/settings_page.dart';
import 'presentation/settings_page_presenter.dart';

void main() async {
  await GetStorage.init();
  runApp(const ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chess Table App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  ChessBoardController controller = ChessBoardController();
  ChessPagePresenter presenter =
      ChessPagePresenter(ChessDataProvider(GetStorage()));

  @override
  void initState() {
    super.initState();
    presenter.readSettings();
  }

  Future<void> _navigateToChessPage(context) async {
    Get.to(ChessPage(
      dataProvider: ChessDataProvider(GetStorage()),
    ))?.then((value) => setState(() => presenter.readSettings()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16.0), // Add margin/padding to the top
              child: Center(
                child: ChessBoard(
                  controller: controller,
                  boardColor: presenter.settings.boardColor,
                  boardOrientation: presenter.settings.boardOrientation,
                ),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Chess>(
              valueListenable: controller,
              builder: (context, game, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Optional: Add horizontal padding
                  child: SingleChildScrollView(
                    child: Text(
                      controller.getSan().fold(
                            '',
                            (previousValue, element) =>
                                '$previousValue\n${element ?? ''}',
                          ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(
                16.0), // Optional: Add padding to the FloatingActionButton
            child: FloatingActionButton.extended(
              onPressed: () {
                _navigateToChessPage(context);
              },
              label: const Text(
                'Change Settings',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
