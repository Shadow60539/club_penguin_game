import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_game/application/chat/chat_bloc.dart';
import 'package:social_media_game/application/movement/movement_bloc.dart';
import 'package:social_media_game/application/providers/chat_provider.dart';
import 'package:social_media_game/core/utils/build_context.dart';
import 'package:social_media_game/core/utils/clean_string.dart';
import 'package:social_media_game/presentation/game/components/text_box.dart';
import 'package:social_media_game/presentation/game/game.dart';

class Penguin extends SpriteAnimationComponent
    with JoystickListener, HasGameRef<ClubPenguinGame> {
  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _walkAnimation;

  MyTextBox? _myTextBox;

  late Timer _timer;
  // Debouncer
  late Timer _sendingMessageTimer;

  Penguin() {
    final SpriteSheet _idleSpriteSheet = SpriteSheet(
        image: Flame.images.fromCache("idle_me.png"), srcSize: Vector2(32, 48));
    final SpriteSheet _walkSpriteSheet = SpriteSheet(
        image: Flame.images.fromCache("walk_me.png"), srcSize: Vector2(33, 48));

    _walkAnimation = _walkSpriteSheet.createAnimation(stepTime: 0.1, row: 0);
    _idleAnimation = _idleSpriteSheet.createAnimation(stepTime: 0.1, row: 0);

    _timer = Timer(1, repeat: true, callback: () {
      _updateXToServer(x: x, currentBackground: gameRef.currentBackground);
      // _updateBackgroundToServer(gameRef.currentBackground);
    });
    _timer.start();

    _sendingMessageTimer = Timer(5);

    animation = _idleAnimation;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    final _size = gameSize.toSize();

    width = _size.width / 10;
    height = 100;
    y = _size.height - height - 72;

    super.onGameResize(gameSize);
  }

  @override
  Future<void> update(double t) async {
    _timer.update(t);
    _sendingMessageTimer.update(t);

    if (_myTextBox != null) {
      // Message is still showing
      if (gameRef.components.whereType<MyTextBox>().contains(_myTextBox)) {
        _myTextBox!.x = x;
      } else {
        // Message stoped showing

        _myTextBox = null;
      }
    }

    final double _screenWidth = gameRef.size.toSize().width;

    if (x + width >= _screenWidth &&
        gameRef.currentBackground == Background.night) {
      x = _screenWidth - width;
    }

    super.update(t);
  }

  void _updateXToServer(
      {required double x, required Background currentBackground}) {
    MovementBloc.addEventWithoutContext(
        MovementEvent.updatePosition(x: x, background: currentBackground));
  }

  // void _updateBackgroundToServer(Background currentBackground) {
  //   MovementBloc.addEventWithoutContext(
  //       MovementEvent.updateBackground(currentBackground));
  // }

  @override
  void joystickAction(JoystickActionEvent event) {
    final String _messageToBeSent = cleanString(
        Provider.of<ChatProvider>(context, listen: false)
            .textEditingController
            .text);

    if (!_sendingMessageTimer.isRunning() && _messageToBeSent.isNotEmpty) {
      FocusScope.of(context).unfocus();
      _sendingMessageTimer.start();

      ChatBloc.addEventWithoutContext(ChatEvent.sendMessage(_messageToBeSent));

      Provider.of<ChatProvider>(context, listen: false).onMessageSent();
    }
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    // TODO: implement joystickChangeDirectional
    if (event.directional == JoystickMoveDirectional.moveRight ||
        event.directional == JoystickMoveDirectional.moveUpRight ||
        event.directional == JoystickMoveDirectional.moveDownRight) {
      if (x >= gameRef.size.toSize().width * 0.5) {
        // gameRef.camera.add(Position(2, 0));
      }
      renderFlipX = false;
      x = x + 2;
      // _updateXToServer(x.ceil());
    } else if (event.directional == JoystickMoveDirectional.moveLeft ||
        event.directional == JoystickMoveDirectional.moveUpLeft ||
        event.directional == JoystickMoveDirectional.moveDownLeft) {
      if (x > 0) {
        x = x - 2;
        // _updateXToServer(x.ceil());

        if (x > gameRef.size.toSize().width * 0.5) {
          // gameRef.camera.add(Position(-2, 0));
        }
      }

      renderFlipX = true;
    }

    if (event.directional == JoystickMoveDirectional.idle) {
      animation = _idleAnimation;
    } else {
      animation = _walkAnimation;
    }
  }

  void showMessage(String? message) {
    if (message == null) {
      return;
    }
    if (_myTextBox == null) {
      _myTextBox = MyTextBox(message)
        ..x = x
        ..y = y;
      gameRef.add(_myTextBox!);
      log("Message added $message");
    } else {}
  }

  void hide() {
    // How to hide 👀 ?
    size = Vector2.all(0);
  }

  void show() {
    final _size = gameRef.size.toSize();
    width = _size.width / 10;
    height = 100;
  }
}
