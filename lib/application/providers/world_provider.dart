import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_media_game/presentation/game/game.dart';

class WorldProvider extends ChangeNotifier {
  /// To keep track of current background displaying in the game
  Background _currentBackground = Background.day;

  Background get currentBackground => _currentBackground;

  /// To update the [_currentBackground]
  void updateBackground(Background newBackground) {
    _currentBackground = newBackground;
    notifyListeners();
  }
}
