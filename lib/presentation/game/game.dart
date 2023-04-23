// Reference docs: https://flame-engine.org/docs/#/

import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';
import 'package:social_media_game/application/auth/auth_bloc.dart';
import 'package:social_media_game/application/providers/world_provider.dart';
import 'package:social_media_game/core/utils/build_context.dart';
import 'package:social_media_game/core/utils/firestore_collection_names.dart';
import 'package:social_media_game/domain/core/user.dart';
import 'package:social_media_game/presentation/game/components/background.dart';
import 'package:social_media_game/presentation/game/components/text_box.dart';

import 'components/other_penguin.dart';
import 'components/penguin.dart';

const ONLINE_GREEN = "ONLINE_GREEN";
const TEXT_FIELD = "TEXT_FIELD";
const LEVEL_TEXT = "LEVEL_TEXT";

enum Background { day, night }

@lazySingleton
class ClubPenguinGame extends FlameGame {
  /// Penguin extending `SpriteAnimationComponent`
  ///
  /// Component used to indentify the penguin you
  late Penguin penguin;

  /// To create a virtual joystick for taking input
  ///
  /// There is some initial setup inorder for the joystick to work
  /// Reference:- https://flame-engine.org/docs/#/input?id=joystick
  late JoystickComponent joystick;

  late HudButtonComponent quickChatButton;

  /// DayBackground extending `ParallaxComponent`
  ///
  /// To display day parallax background
  late DayBackground dayBackground;

  /// NightBackground extending `ParallaxComponent`
  ///
  /// To display night parallax background
  late NightBackground nightBackground;

  /// To keep tack of the current background displayed
  ///
  /// Default value is [Background.day]
  /// Logic behind changing the background is to actually change the priority
  late Background currentBackground;

  /// In `FirebaseDatabase` when new data is added to `USER_COLLECTION`
  /// `onChildAdded` stream gets updated
  /// To hold the stream `onChildAdded`
  late Stream<DatabaseEvent> _newPlayerConnectedStream;

  /// In `FirebaseDatabase` when any data is removed from `USER_COLLECTION`
  /// `onChildRemoved` stream gets updated
  /// To hold the stream `onChildRemoved`
  late Stream<DatabaseEvent> _playerDisconnectedStream;

  /// In `FirebaseDatabase` when already existing data is changed in `USER_COLLECTION`
  /// `onChildChanged` stream gets updated
  /// To hold the stream `onChildChanged`
  late Stream<DatabaseEvent> _playerMovingStream;

  /// In `FirebaseDatabase` when already existing data is changed in `USER_COLLECTION`
  /// `onChildChanged` stream gets updated
  /// To hold the stream `onChildChanged`
  late Stream<DatabaseEvent> _playerTypingStream;

  /// In `FirebaseDatabase` when already existing data is changed in `MESSAGE_COLLECTION`
  /// `onChildChanged` stream gets updated
  /// To hold the stream `onChildChanged`
  late Stream<DatabaseEvent> _chatStream;

  /// To display the no of online players count as text
  late TextComponent onlineText;

  /// Current User's model
  late GameUser me;

  /// To keep track of the online users count
  late int _userCount;

  ClubPenguinGame() {
    dayBackground = DayBackground();
    nightBackground = NightBackground();
    currentBackground = Background.day;
    me = BlocProvider.of<AuthBloc>(context).state.user!;
    _newPlayerConnectedStream = FirebaseDatabase.instance
        .reference()
        .child(USER_COLLECTION)
        .onChildAdded;
    _playerDisconnectedStream = FirebaseDatabase.instance
        .reference()
        .child(USER_COLLECTION)
        .onChildRemoved;
    _playerMovingStream = FirebaseDatabase.instance
        .reference()
        .child(USER_COLLECTION)
        .onChildChanged;
    _playerTypingStream = FirebaseDatabase.instance
        .reference()
        .child(USER_COLLECTION)
        .onChildChanged;

    _chatStream = FirebaseDatabase.instance
        .reference()
        .child(MESSAGE_COLLECTION)
        .onChildChanged;

    _userCount = 0;

    onlineText = TextComponent(
      text: "Online: 0",
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 8,
          color: Colors.white,
          fontFamily: GoogleFonts.pressStart2p().fontFamily,
        ),
      ),
    )
      ..x = 30
      ..y = 20;
  }

  @override
  Future<void> onLoad() async {
    // Make sure you lay out the parallax background first so that
    // other components are visible
    // Think of it like as `Stack` widget

    await add(nightBackground); // ----> priority: 0
    await add(dayBackground); // ----> priority: 1

    // Joystick
    final knobPaint = BasicPalette.black.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.white.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 15, paint: knobPaint),
      background: CircleComponent(radius: 50, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(joystick);
    penguin = Penguin(joystick);
    quickChatButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: Sprite(Flame.images.fromCache("chat.png")),
      ),
      margin: const EdgeInsets.only(
        right: 40,
        bottom: 40,
      ),
      onPressed: penguin.onQuickChatPressed,
    );
    add(quickChatButton);
    // Overlays
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      overlays.add(ONLINE_GREEN);
      overlays.add(TEXT_FIELD);
      overlays.add(LEVEL_TEXT);
    });

    // Text Components
    add(onlineText);

    // Penguin is not added here
    // It is added inside [_playerConnectedListener] method

    _newPlayerConnectedStream.listen(_playerConnectedListener);
    _playerDisconnectedStream.listen(_playerDisconnectedListener);
    _playerMovingStream.listen(_playerMovingListener);
    _playerTypingStream.listen(_playerTypingListener);
    _chatStream.listen(_chatStreamListener);

    return super.onLoad();
  }

  /// Check for the [penguin] x position and figure out which background
  /// to be shown
  Future<void> backGroundChangeLookUp() async {
    final double _penguinX = penguin.x;
    final double _screenWidth = size.toSize().width;

    const double PENGUIN_START = 2.0;

    // Daytime and player on end of the screen
    if (currentBackground == Background.day && _penguinX >= _screenWidth) {
      nightBackground.priority = 0;
      dayBackground.priority = -1;
      currentBackground = Background.night;
      Provider.of<WorldProvider>(context, listen: false)
          .updateBackground(currentBackground);
      penguin.x =
          PENGUIN_START; //TODO: create a method to reset inside `Penguin` class
      return;
    }
    // Nighttime and player on start of the screen
    if (currentBackground == Background.night && _penguinX < PENGUIN_START) {
      nightBackground.priority = -1;
      dayBackground.priority = 0;

      currentBackground = Background.day;
      Provider.of<WorldProvider>(context, listen: false)
          .updateBackground(currentBackground);
      penguin.x = _screenWidth - penguin.width;
      return;
    }

    // Add penguins into right background
    final List<OtherPenguin> _otherPlayersList =
        children.whereType<OtherPenguin>().toList();

    for (final _otherPenguin in _otherPlayersList) {
      try {
        if (_otherPenguin.user.currentBackground != currentBackground) {
          _otherPenguin.hide();
          _otherPenguin.removeMessage();
        } else {
          _otherPenguin.show();
        }
      } catch (e) {
        _otherPenguin.hide();
        _otherPenguin.removeMessage();
      }
    }
  }

  @override
  void update(double t) {
    onlineText.text = "0nline :$_userCount";
    backGroundChangeLookUp();

    super.update(t);
  }

  /// To update the [_userCount] everytime there is any change in
  /// the status of the player
  ///
  /// It is called everytime any player joins, exists the game
  Future<void> _getOnlineUserCount() async {
    final _snapshot =
        await FirebaseDatabase.instance.ref().child(USER_COLLECTION).get();

    try {
      if (_snapshot.value == null) {
        _userCount = 0;
      } else {
        _userCount = (_snapshot.value as Map).keys.length;
      }
    } on Exception catch (_) {
      // TODO
    }
  }

  void _playerConnectedListener(DatabaseEvent event) {
    final List<OtherPenguin> _otherPenguinLists =
        children.whereType<OtherPenguin>().toList();

    final GameUser _newCommer = GameUser.fromCollection(
        Map<String, dynamic>.from(event.snapshot.value as Map));

    // Check if the player is you
    if (_newCommer.id == me.id) {
      // Check If Penguin already exist.
      final bool _isPenguinAlreadyPresent =
          children.whereType<Penguin>().isNotEmpty;
      if (_isPenguinAlreadyPresent) {
        // Skip
      } else {
        _getOnlineUserCount();
        log("Me added ${_newCommer.id}");
        add(penguin);
        // why this is called again after add(penguin) ?
        // Because, add method adds the component on the next game tick
        // So after this loop get compiled, again the [_isPenguinAlreadyPresent]
        // will return false because the [penguin] was not added
        // Similar code can be found in [_playerDisconnectedListener]
        return;
      }
    } else {
      // Other players

      final bool _isNewCommerAlreadyPresent = _otherPenguinLists
          .where((element) => element.user.id == _newCommer.id)
          .toList()
          .isNotEmpty;
      if (_isNewCommerAlreadyPresent) {
        // Skip
      } else {
        _getOnlineUserCount();
        log("New User added ${_newCommer.id}");
        add(NotificationTextBox()
          ..y = 50
          ..x = 10);
        add(OtherPenguin(user: _newCommer)..x = _newCommer.x);
        return;
      }
    }
  }

  Future<void> _playerDisconnectedListener(DatabaseEvent event) async {
    final GameUser _disconnectedUser = GameUser.fromCollection(
        Map<String, dynamic>.from(event.snapshot.value as Map));

    // Check if the player is you
    if (_disconnectedUser.id == me.id) {
      // Check If Penguin already exist.
      final bool _isPenguinAlreadyPresent =
          children.whereType<Penguin>().isNotEmpty;
      if (_isPenguinAlreadyPresent) {
        _getOnlineUserCount();

        log("Me disconnected ${_disconnectedUser.id}");
        // markToRemove(_penguin);
        remove(penguin);
        return;
      } else {
        // Skip
      }
    } else {
      // Other players

      final List<OtherPenguin> _otherPenguinLists =
          children.whereType<OtherPenguin>().toList();

      final bool _isDisconnectedAlreadyPresent = _otherPenguinLists
          .where((element) => element.user.id == _disconnectedUser.id)
          .toList()
          .isNotEmpty;
      if (_isDisconnectedAlreadyPresent) {
        final OtherPenguin _markDisconnectedPenguin = _otherPenguinLists
            .firstWhere((element) => element.user.id == _disconnectedUser.id);

        remove(_markDisconnectedPenguin);
        _getOnlineUserCount();
        log("User disconnected ${_disconnectedUser.id}");

        return;
      } else {
        // Skip
      }
    }
  }

  void _playerMovingListener(DatabaseEvent event) {
    final GameUser _movingUser = GameUser.fromCollection(
        Map<String, dynamic>.from(event.snapshot.value as Map));

    if (_movingUser.id == me.id) {
      // Skip
    } else {
      // Other players moving

      final List<OtherPenguin> _otherPenguinLists =
          children.whereType<OtherPenguin>().toList();

      if (_otherPenguinLists
          .where((element) => element.user.id == _movingUser.id)
          .isEmpty) {
        return;
      }

      final OtherPenguin _markedAsMovePenguin = _otherPenguinLists
          .lastWhere((element) => element.user.id == _movingUser.id);

      _markedAsMovePenguin.user.currentBackground =
          _movingUser.currentBackground;

      final bool _isIdle = _movingUser.x.floorToDouble() ==
          _markedAsMovePenguin.x.floorToDouble();

      if (!_isIdle) {
        _markedAsMovePenguin.timer.start();
        final int _m = _movingUser.x.floorToDouble() >
                _markedAsMovePenguin.x.floorToDouble()
            ? 1
            : -1;
        if (_m.isNegative) {
          _markedAsMovePenguin.walkLeft();
        } else {
          _markedAsMovePenguin.walkRight();
        }
        _markedAsMovePenguin.x = _movingUser.x;
      } else {}
    }
  }

  void _playerTypingListener(DatabaseEvent event) {
    final GameUser _typingUser = GameUser.fromCollection(
        Map<String, dynamic>.from(event.snapshot.value as Map));

    if (_typingUser.id == me.id) {
      // Skip
    } else {
      // Other players moving

      final List<OtherPenguin> _otherPenguinLists =
          children.whereType<OtherPenguin>().toList();

      if (_otherPenguinLists
          .where((element) => element.user.id == _typingUser.id)
          .isEmpty) {
        return;
      }

      final OtherPenguin _markedAsTypingPenguin = _otherPenguinLists
          .lastWhere((element) => element.user.id == _typingUser.id);

      if (_typingUser.isTyping) {
        if (!_markedAsTypingPenguin.user.isTyping) {
          _markedAsTypingPenguin.user.isTyping = true;
          _markedAsTypingPenguin.timer.start();
        }
      } else {
        if (_markedAsTypingPenguin.user.isTyping) {
          _markedAsTypingPenguin.user.isTyping = false;
          _markedAsTypingPenguin.timer.start();
        }
      }
    }
  }

  void _chatStreamListener(DatabaseEvent event) {
    final List<OtherPenguin> _otherPenguinLists =
        children.whereType<OtherPenguin>().toList();

    final GameUser _chattingUser = GameUser.fromCollection(
        Map<String, dynamic>.from(event.snapshot.value as Map));

    if (_chattingUser.id == me.id) {
      // Skip
      penguin.showMessage(_chattingUser.message);
    } else {
      // Other player chating

      try {
        if (_otherPenguinLists
            .where((element) => element.user.id == _chattingUser.id)
            .isEmpty) {
          return;
        }
        final OtherPenguin _chattingPenguin = _otherPenguinLists
            .lastWhere((element) => element.user.id == _chattingUser.id);

        _chattingPenguin.user.isTyping = false;
        _chattingPenguin.timer.start();
        _chattingPenguin.showMessage(_chattingUser.message);
      } catch (e) {
        log(e.toString());
      }
    }
  }
}
