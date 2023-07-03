import 'package:get_storage/get_storage.dart';

class LocalStorage {
  final GetStorage storage;

  LocalStorage(this.storage) {
    storage.writeIfNull('board-color', 'brown');
    storage.writeIfNull('board-orientation', 'white');
  }

  String getBoardOrientation() {
    return storage.read('board-orientation');
  }

  String getBoardColor() {
    return storage.read('board-color');
  }

  void setBoardOrientation(String orientation) {
    storage.write('board-orientation', orientation);
  }

  void setBoardColor(String color) {
    storage.write('board-color', color);
  }
}
