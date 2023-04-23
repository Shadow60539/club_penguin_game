import 'dart:developer';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_game/presentation/game/game.dart';

const double MESSAGE_SHOW_TIME = 4;

final _tiny = TextPaint(
    style: TextStyle(
        fontSize: 8,
        color: BasicPalette.black.color,
        fontFamily: GoogleFonts.pressStart2p().fontFamily));

final _white = Paint()
  ..color = BasicPalette.white.color
  ..style = PaintingStyle.fill;

class MyTextBox extends TextBoxComponent with HasGameRef<ClubPenguinGame> {
  late Timer _timer;

  MyTextBox(String text)
      : super(
          text: text,
          textRenderer: _tiny,
          boxConfig: TextBoxConfig(
              timePerChar: 0.05, maxWidth: text.length * 9.0), // T&E
        ) {
    _timer = Timer(MESSAGE_SHOW_TIME + text.length * 0.15, onTick: () {
      removeFromParent();
    });
  }

  @override
  void onGameResize(Vector2 gameSize) {
    y = gameRef.penguin.y;
    super.onGameResize(gameSize);
  }

  @override
  void onMount() {
    _timer.start();
    super.onMount();
  }

  @override
  void onRemove() {
    log("$text removed");
    super.onRemove();
  }

  @override
  void drawBackground(Canvas c) {
    final rect = Rect.fromLTWH(0, 0, width, height);
    c.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)), _white);
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }
}

class NotificationTextBox extends TextBoxComponent
    with HasGameRef<ClubPenguinGame> {
  late Timer _timer;

  NotificationTextBox()
      : super(
          text: 'New Penguin joined',
          textRenderer: _tiny,
          boxConfig: TextBoxConfig(
              timePerChar: 0.05,
              maxWidth: 'New Penguin joined'.length * 9.0), // T&E
        ) {
    _timer = Timer(MESSAGE_SHOW_TIME, onTick: () {
      removeFromParent();
    });
  }

  @override
  void onMount() {
    _timer.start();
    super.onMount();
  }

  @override
  void drawBackground(Canvas c) {
    final rect = Rect.fromLTWH(0, 0, width, height);
    c.drawRect(rect, _white);
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }
}
