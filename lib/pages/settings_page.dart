import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/settings_data_provider.dart';
import '../domain/settings_page_presenter.dart';

class ChessPage extends StatefulWidget {
  const ChessPage({super.key, required this.dataProvider});

  final ChessDataProvider dataProvider;

  @override
  ChessPageState createState() => ChessPageState();
}

class ChessPageState extends State<ChessPage> {
  late String selectedOrientation;
  late String selectedBackgroundColor;
  late ChessPagePresenter presenter;

  @override
  void initState() {
    super.initState();
    selectedOrientation = widget.dataProvider.getBoardOrientation();
    selectedBackgroundColor = widget.dataProvider.getBoardColor();
    presenter = ChessPagePresenter(widget.dataProvider);
  }

  List<Widget> _orientationOptions() {
    return presenter.getOrientations().map((orientation) {
      return presenter.buildOrientationRadio(
        orientation,
        selectedOrientation,
        (value) {
          setState(() {
            selectedOrientation = value!;
          });
        },
      );
    }).toList();
  }

  List<Widget> _backgroundColorOptions() {
    return presenter.getBackgroundColors().map((backgroundColor) {
      return presenter.buildBackgroundColorRadio(
        backgroundColor,
        selectedBackgroundColor,
        (value) {
          setState(() {
            selectedBackgroundColor = value!;
          });
        },
      );
    }).toList();
  }

  FloatingActionButton _saveAndReturnButton() {
    return FloatingActionButton(
      onPressed: () {
        widget.dataProvider.setBoardOrientation(selectedOrientation);
        widget.dataProvider.setBoardColor(selectedBackgroundColor);

        Get.back();
      },
      child: const Icon(Icons.check),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chess Table Settings'),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Choose Orientation',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Column(children: _orientationOptions()),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Choose Background Color',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Column(children: _backgroundColorOptions()),
          ],
        ),
        floatingActionButton: _saveAndReturnButton());
  }
}
