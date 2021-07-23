import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:social_media_game/domain/core/user.dart';
import 'package:social_media_game/presentation/game/components/text_box.dart';
import 'package:social_media_game/presentation/game/game.dart';

class OtherPenguin extends SpriteAnimationComponent
    with HasGameRef<ClubPenguinGame> {
  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _chatIdleAnimation;
  late SpriteAnimation _walkAnimation;
  late SpriteAnimation _chatWalkAnimation;
  late SpriteAnimation _hurtAnimation;

  late Timer timer;

  MyTextBox? _myTextBox;

  final GameUser user;
  OtherPenguin({required this.user}) {
    timer = Timer(0.25, callback: () {
      if (user.isTyping) {
        animation = _chatIdleAnimation;
      } else {
        animation = _idleAnimation;
      }
    });

    final SpriteSheet _idleSpriteSheet = SpriteSheet(
      srcSize: Vector2(32, 48),
      image: Flame.images.fromCache("idle.png"),
    );

    final SpriteSheet _chatIdleSpriteSheet = SpriteSheet(
      srcSize: Vector2(32, 48),
      image: Flame.images.fromCache("chat_idle.png"),
    );
    final SpriteSheet _walkSpriteSheet = SpriteSheet(
      srcSize: Vector2(33, 48),
      image: Flame.images.fromCache("walk.png"),
    );
    final SpriteSheet _chatWalkSpriteSheet = SpriteSheet(
      srcSize: Vector2(33, 48),
      image: Flame.images.fromCache("chat_run.png"),
    );
    final SpriteSheet _hurtSpriteSheet = SpriteSheet(
      srcSize: Vector2(33, 44),
      image: Flame.images.fromCache("hurt.png"),
    );

    _idleAnimation = _idleSpriteSheet.createAnimation(stepTime: 0.1, row: 0);
    _chatIdleAnimation =
        _chatIdleSpriteSheet.createAnimation(stepTime: 0.1, row: 0);
    _walkAnimation = _walkSpriteSheet.createAnimation(stepTime: 0.1, row: 0);
    _chatWalkAnimation =
        _chatWalkSpriteSheet.createAnimation(stepTime: 0.1, row: 0);
    _hurtAnimation = _hurtSpriteSheet.createAnimation(stepTime: 0.1, row: 0);

    animation = _idleAnimation;
  }

  @override
  Future<void> onGameResize(Vector2 gameSize) async {
    final _size = gameSize.toSize();

    width = _size.width / 10;
    height = 100;
    y = _size.height - height - 72;

    // When keyboard is shown, penguins not in this current background are
    // revealing

    if (isMounted) {
      if (user.currentBackground != gameRef.currentBackground) {
        hide();
      } else {
        show();
      }
    }

    super.onGameResize(gameSize);
  }

  @override
  void update(double t) {
    timer.update(t);

    if (_myTextBox != null) {
      // Message is still showing
      if (gameRef.components.whereType<MyTextBox>().contains(_myTextBox)) {
        _myTextBox!.x = x;
      } else {
        // Message stoped showing

        _myTextBox = null;
      }
    }

    super.update(t);
  }

  void walkLeft() {
    renderFlipX = true;
    if (user.isTyping) {
      animation = _chatWalkAnimation;
    } else {
      animation = _walkAnimation;
    }
  }

  void walkRight() {
    renderFlipX = false;
    if (user.isTyping) {
      animation = _chatWalkAnimation;
    } else {
      animation = _walkAnimation;
    }
  }

  void resetToIdleAnimation() {
    // renderFlipX = false;
    animation = _idleAnimation;
  }

  void showMessage(String? message) {
    if (message == null) {
      return;
    }

    // Do not show when not in same background
    if (user.currentBackground != gameRef.currentBackground) {
      return;
    }

    if (_myTextBox == null) {
      _myTextBox = MyTextBox(message)
        ..x = x
        ..y = y;
      gameRef.add(_myTextBox!);
      log("Message added $message");
    }
  }

  void hide() {
    // How to hide 👀 ?
    size = Vector2.all(0);
    // x = -50;
  }

  void show() {
    final _size = gameRef.size.toSize();
    width = _size.width / 10;
    height = 100;
  }

  Future<void> playHurtAnimation() async {
    animation = _hurtAnimation;
  }

  bool isHurtAnimationPlaying() {
    return animation == _hurtAnimation;
  }
}
