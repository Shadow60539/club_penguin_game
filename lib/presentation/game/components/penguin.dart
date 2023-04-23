import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:provider/provider.dart';
import 'package:social_media_game/application/chat/chat_bloc.dart';
import 'package:social_media_game/application/movement/movement_bloc.dart';
import 'package:social_media_game/application/providers/chat_provider.dart';
import 'package:social_media_game/core/utils/build_context.dart';
import 'package:social_media_game/core/utils/clean_string.dart';
import 'package:social_media_game/presentation/game/components/text_box.dart';
import 'package:social_media_game/presentation/game/game.dart';

class Penguin extends SpriteAnimationComponent
    with HasGameRef<ClubPenguinGame> {
  final JoystickComponent joystick;
  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _chatIdleAnimation;
  late SpriteAnimation _walkAnimation;

  MyTextBox? _myTextBox;

  late Timer _timer;

  Penguin(this.joystick) {
    final SpriteSheet _idleSpriteSheet = SpriteSheet(
        image: Flame.images.fromCache("idle_me.png"), srcSize: Vector2(32, 48));
    final SpriteSheet _chatIdleSpriteSheet = SpriteSheet(
        image: Flame.images.fromCache("chat_idle.png"),
        srcSize: Vector2(32, 48));
    final SpriteSheet _walkSpriteSheet = SpriteSheet(
        image: Flame.images.fromCache("walk_me.png"), srcSize: Vector2(33, 48));

    _idleAnimation = _idleSpriteSheet.createAnimation(stepTime: 0.1, row: 0);
    _chatIdleAnimation =
        _chatIdleSpriteSheet.createAnimation(stepTime: 0.1, row: 0);
    _walkAnimation = _walkSpriteSheet.createAnimation(stepTime: 0.1, row: 0);

    _timer = Timer(1, repeat: true, onTick: () {
      _updateXToServer(x: x, currentBackground: gameRef.currentBackground);
      // _updateBackgroundToServer(gameRef.currentBackground);
    });
    _timer.start();

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
    _myTextBox?.x = x;

    final double _screenWidth = gameRef.size.toSize().width;

    if (x + width >= _screenWidth &&
        gameRef.currentBackground == Background.night) {
      x = _screenWidth - width;
    }

    _updateJoystickMovement();
    super.update(t);
  }

  void _updateXToServer(
      {required double x, required Background currentBackground}) {
    final String _messageToBeSent = cleanString(
        Provider.of<ChatProvider>(context, listen: false)
            .textEditingController
            .text);

    final bool _isTyping = _messageToBeSent.isNotEmpty;
    MovementBloc.addEventWithoutContext(MovementEvent.updatePosition(
      x: x,
      background: currentBackground,
      isTyping: _isTyping,
    ));
  }

  void _updateJoystickMovement() {
    if (joystick.direction == JoystickDirection.right ||
        joystick.direction == JoystickDirection.upRight ||
        joystick.direction == JoystickDirection.downRight) {
      if (x >= gameRef.size.toSize().width * 0.5) {
        // gameRef.camera.add(Position(2, 0));
      }
      if (isFlippedHorizontally) {
        flipHorizontallyAroundCenter();
      }
      x = x + 2;
      // _updateXToServer(x.ceil());
    } else if (joystick.direction == JoystickDirection.left ||
        joystick.direction == JoystickDirection.upLeft ||
        joystick.direction == JoystickDirection.downLeft) {
      if (x > 0) {
        x = x - 2;
        // _updateXToServer(x.ceil());

        if (x > gameRef.size.toSize().width * 0.5) {
          // gameRef.camera.add(Position(-2, 0));
        }
      }

      if (!isFlippedHorizontally) {
        flipHorizontallyAroundCenter();
      }
    }

    if (joystick.direction == JoystickDirection.idle) {
      animation = _idleAnimation;
    } else {
      animation = _walkAnimation;
    }
  }

  // void _updateBackgroundToServer(Background currentBackground) {
  //   MovementBloc.addEventWithoutContext(
  //       MovementEvent.updateBackground(currentBackground));
  // }

  void onQuickChatPressed() {
    ChatBloc.addEventWithoutContext(const ChatEvent.sendMessage("Hi!"));
  }

  void showMessage(String? message) {
    if (message == null) {
      return;
    }
    if (_myTextBox != null && !_myTextBox!.isRemoved) {
      gameRef.remove(_myTextBox!);
    }
    _myTextBox = MyTextBox(message)
      ..x = x
      ..y = y;
    gameRef.add(_myTextBox!);
    log("Message added $message");
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

  void changeAnimationToTyping() {
    animation = _chatIdleAnimation;
  }

  void changeAnimationToIdle() {
    animation = _idleAnimation;
  }
}
