import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  /// ChatBox TextEditingController defined in `HomePage`
  final TextEditingController _textEditingController = TextEditingController();

  TextEditingController get textEditingController => _textEditingController;

  /// Called after sending the message in `Penguin` class
  void onMessageSent() {
    _textEditingController.clear();
    notifyListeners();
  }
}
