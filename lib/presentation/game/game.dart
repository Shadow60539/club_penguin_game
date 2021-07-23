// Reference docs: https://flame-engine.org/docs/#/

import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
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
class ClubPenguinGame extends BaseGame with HasDraggableComponents {
  /// Penguin extending `SpriteAnimationComponent`
  ///
  /// Component used to indentify the penguin you
  late Penguin penguin;

  /// To create a virtual joystick for taking input
  ///
  /// There is some initial setup inorder for the joystick to work
  /// Reference:- https://flame-engine.org/docs/#/input?id=joystick
  late JoystickComponent joystick;

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
  late Stream<Event> _newPlayerConnectedStream;

  /// In `FirebaseDatabase` when any data is removed from `USER_COLLECTION`
  /// `onChildRemoved` stream gets updated
  /// To hold the stream `onChildRemoved`
  late Stream<Event> _playerDisconnectedStream;

  /// In `FirebaseDatabase` when already existing data is changed in `USER_COLLECTION`
  /// `onChildChanged` stream gets updated
  /// To hold the stream `onChildChanged`
  late Stream<Event> _playerMovingStream;

  /// In `FirebaseDatabase` when already existing data is changed in `USER_COLLECTION`
  /// `onChildChanged` stream gets updated
  /// To hold the stream `onChildChanged`
  late Stream<Event> _playerTypingStream;

  /// In `FirebaseDatabase` when already existing data is changed in `MESSAGE_COLLECTION`
  /// `onChildChanged` stream gets updated
  /// To hold the stream `onChildChanged`
  late Stream<Event> _chatStream;

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
    penguin = Penguin();
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
      "Online: 0",
      textRenderer: TextPaint(
          config: TextPaintConfig(
              fontSize: 8,
              color: Colors.white,
              fontFamily: GoogleFonts.pressStart2p().fontFamily!)),
    )
      ..x = 30
      ..y = 20;
  }

  @override
  Future<void> onLoad() async {
    // Make sure you lay out the parallax background first so that
    // other components are visible
    // Think of it like as `Stack` widget

    await add(nightBackground); // ----> priority: -1
    await add(dayBackground); // ----> priority: 0

    // Joystick
    joystick = JoystickComponent(
      directional: JoystickDirectional(),
      actions: [
        JoystickAction(
          actionId: 1, // required
          action: JoystickElement.sprite(
              Sprite(Flame.images.fromCache("chat.png"))),
          // size: 50,
          color: Colors.white,
          margin: const EdgeInsets.all(50), // optional
        ),
      ],
      gameRef: this,
    );

    joystick.addObserver(penguin);
    add(joystick);

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
      changePriority(nightBackground, 0);
      changePriority(dayBackground, -1);
      currentBackground = Background.night;
      Provider.of<WorldProvider>(context, listen: false)
          .updateBackground(currentBackground);
      penguin.x =
          PENGUIN_START; //TODO: create a method to reset inside `Penguin` class
      return;
    }
    // Nighttime and player on start of the screen
    if (currentBackground == Background.night && _penguinX < PENGUIN_START) {
      changePriority(nightBackground, -1);
      changePriority(dayBackground, 0);

      currentBackground = Background.day;
      Provider.of<WorldProvider>(context, listen: false)
          .updateBackground(currentBackground);
      penguin.x = _screenWidth - penguin.width;
      return;
    }

    // Add penguins into right background
    final List<OtherPenguin> _otherPlayersList =
        components.whereType<OtherPenguin>().toList();

    for (final _otherPenguin in _otherPlayersList) {
      try {
        if (_otherPenguin.user.currentBackground != currentBackground) {
          _otherPenguin.hide();
        } else {
          _otherPenguin.show();
        }
      } catch (e) {
        _otherPenguin.hide();
      }
    }
  }

  @override
  void update(double t) {
    _newPlayerConnectedStream.listen(_playerConnectedListener);
    _playerDisconnectedStream.listen(_playerDisconnectedListener);
    _playerMovingStream.listen(_playerMovingListener);
    _playerTypingStream.listen(_playerTypingListener);
    _chatStream.listen(_chatStreamListener);

    onlineText.text = "0nline :$_userCount";
    backGroundChangeLookUp();

    super.update(t);
  }

  /// To update the [_userCount] everytime there is any change in
  /// the status of the player
  ///
  /// It is called everytime any player joins, exists the game
  Future<void> _getOnlineUserCount() async {
    final _snapshot = await FirebaseDatabase.instance
        .reference()
        .child(USER_COLLECTION)
        .get();

    try {
      _userCount = _snapshot!.value.keys.length as int;
    } on Exception catch (_) {
      // TODO
    }
  }

  void _playerConnectedListener(Event event) {
    final List<OtherPenguin> _otherPenguinLists =
        components.whereType<OtherPenguin>().toList();

    final GameUser _newCommer = GameUser.fromCollection(
        Map<String, dynamic>.from(event.snapshot.value as Map));

    // Check if the player is you
    if (_newCommer.id == me.id) {
      // Check If Penguin already exist.
      final bool _isPenguinAlreadyPresent =
          components.whereType<Penguin>().isNotEmpty;
      if (_isPenguinAlreadyPresent) {
        // Skip
      } else {
        _getOnlineUserCount();
        log("Me added ${_newCommer.id}");
        add(penguin);
        components
            .add(penguin); // why this is called again after add(penguin) ?
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
        components.add(OtherPenguin(user: _newCommer)..x = _newCommer.x);
        return;
      }
    }
  }

  Future<void> _playerDisconnectedListener(Event event) async {
    final GameUser _disconnectedUser = GameUser.fromCollection(
        Map<String, dynamic>.from(event.snapshot.value as Map));

    // Check if the player is you
    if (_disconnectedUser.id == me.id) {
      // Check If Penguin already exist.
      final bool _isPenguinAlreadyPresent =
          components.whereType<Penguin>().isNotEmpty;
      if (_isPenguinAlreadyPresent) {
        _getOnlineUserCount();

        log("Me disconnected ${_disconnectedUser.id}");
        // markToRemove(_penguin);
        remove(penguin);
        components.remove(penguin);
        return;
      } else {
        // Skip
      }
    } else {
      // Other players

      final List<OtherPenguin> _otherPenguinLists =
          components.whereType<OtherPenguin>().toList();

      final bool _isDisconnectedAlreadyPresent = _otherPenguinLists
          .where((element) => element.user.id == _disconnectedUser.id)
          .toList()
          .isNotEmpty;
      if (_isDisconnectedAlreadyPresent) {
        final OtherPenguin _markDisconnectedPenguin = _otherPenguinLists
            .firstWhere((element) => element.user.id == _disconnectedUser.id);

        remove(_markDisconnectedPenguin);
        components.remove(_markDisconnectedPenguin);
        _getOnlineUserCount();
        log("User disconnected ${_disconnectedUser.id}");

        return;
      } else {
        // Skip

      }
    }
  }

  void _playerMovingListener(Event event) {
    final GameUser _movingUser = GameUser.fromCollection(
        Map<String, dynamic>.from(event.snapshot.value as Map));

    if (_movingUser.id == me.id) {
      // Skip

    } else {
      // Other players moving

      final List<OtherPenguin> _otherPenguinLists =
          components.whereType<OtherPenguin>().toList();

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
        _markedAsMovePenguin.x += 0.2 * _m;
      } else {}
    }
  }

  void _playerTypingListener(Event event) {
    final GameUser _typingUser = GameUser.fromCollection(
        Map<String, dynamic>.from(event.snapshot.value as Map));

    if (_typingUser.id == me.id) {
      // Skip

    } else {
      // Other players moving

      final List<OtherPenguin> _otherPenguinLists =
          components.whereType<OtherPenguin>().toList();

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

  void _chatStreamListener(Event event) {
    final List<OtherPenguin> _otherPenguinLists =
        components.whereType<OtherPenguin>().toList();

    final GameUser _chattingUser = GameUser.fromCollection(
        Map<String, dynamic>.from(event.snapshot.value as Map));

    if (_chattingUser.id == me.id) {
      // Skip
      penguin.showMessage(_chattingUser.message);
    } else {
      // Other player chating

      try {
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
