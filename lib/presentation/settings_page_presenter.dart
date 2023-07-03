import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

import '../data/settings_data_provider.dart';

class Settings {
  var boardColor = BoardColor.brown;
  var boardOrientation = PlayerColor.white;
}

class ChessPagePresenter {
  final ChessDataProvider dataProvider;
  Settings settings = Settings();

  ChessPagePresenter(this.dataProvider) {
    readSettings();
  }

  List<String> getOrientations() {
    return ['white', 'black'];
  }

  List<String> getBackgroundColors() {
    return ['brown', 'dark brown', 'green', 'orange'];
  }

  Widget buildOrientationRadio(String orientation, String selectedOrientation,
      void Function(String?)? onChanged) {
    return ListTile(
      title: Text(orientation),
      leading: Radio(
        value: orientation,
        groupValue: selectedOrientation,
        onChanged: onChanged,
      ),
    );
  }

  Widget buildBackgroundColorRadio(String backgroundColor,
      String selectedBackgroundColor, Function(String?)? onChanged) {
    return ListTile(
      title: Text(backgroundColor),
      leading: Radio(
        value: backgroundColor,
        groupValue: selectedBackgroundColor,
        onChanged: onChanged,
      ),
    );
  }

  void readSettings() {
    final String orientation = dataProvider.getBoardOrientation();
    final String backgroundColor = dataProvider.getBoardColor();

    settings.boardOrientation =
        orientation == 'white' ? PlayerColor.white : PlayerColor.black;

    switch (backgroundColor) {
      case 'dark brown':
        settings.boardColor = BoardColor.darkBrown;
        break;
      case 'green':
        settings.boardColor = BoardColor.green;
        break;
      case 'orange':
        settings.boardColor = BoardColor.orange;
        break;
      default:
        settings.boardColor = BoardColor.brown;
    }
  }
}
