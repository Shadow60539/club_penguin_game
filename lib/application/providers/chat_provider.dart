import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_game/application/chat/chat_bloc.dart';
import 'package:social_media_game/core/utils/clean_string.dart';
import 'package:social_media_game/domain/chat/bad_words.dart';
import 'package:social_media_game/presentation/game/game.dart';

@lazySingleton
class ChatProvider extends ChangeNotifier {
  ChatProvider(this.game);

  final ClubPenguinGame game;

  /// ChatBox TextEditingController defined in `HomePage`
  final TextEditingController _textEditingController = TextEditingController();

  TextEditingController get textEditingController =>
      _textEditingController..addListener(_listener);

  /// Called after sending the message in `Penguin` class
  void onMessageSent() {
    final String _message = cleanString(_textEditingController.value.text);
    if (_message.isNotEmpty) {
      ChatBloc.addEventWithoutContext(
          ChatEvent.sendMessage(BadWordFilter.clean(_message)));
    }
    _textEditingController.clear();

    notifyListeners();
  }

  void _listener() {}
}
