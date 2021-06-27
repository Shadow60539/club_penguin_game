import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_game/presentation/game/game.dart';

//TODO: Freezed
class GameUser {
  /// The is the only model used to identify the players in the game
  GameUser(
      {required this.id,
      this.name,
      required this.x,
      this.message,
      required this.currentBackground});

  /// Hold uid coming from `UserCredential`
  final String id;

  /// Penguin name
  ///
  /// Name is not used anywhere in the game in the initial release
  final String? name;

  /// Penguin's x position on the world
  ///
  /// The main parameter which holdes the last known position of the penguin
  /// Planning to use [y] parameter to also keep track of the y coordinate of
  /// the penguin
  final double x;

  /// Used to display the penguin in the background
  /// [Background.day] and [Background.night]
  Background currentBackground = Background.day;

  /// Penguin chat message
  ///
  /// To hold the chat message sent by penguin
  String? message;

  /// Used in `AuthRepo`
  ///
  /// For every logout of the game the new penguin is given a default
  /// value of 0.0 as [x] and Background.day as [currentBackground]
  factory GameUser.fromUserCredential(User user) => GameUser(
        id: user.uid,
        name: user.displayName,
        x: 0.0,
        currentBackground: Background.day,
      );

  /// Used in `ClubPenguinGame`
  ///
  /// For every status change the new model is created
  factory GameUser.fromCollection(Map<String, dynamic> data) => GameUser(
      id: data['id'] as String,
      name: "Player", // Change later
      message: data['message'] as String?,
      currentBackground: data['background'] == null
          ? Background.day
          : _stringToBackground(data['background'] as String),
      x: data["x"] == null ? 0.0 : (data["x"] as num).toDouble());
}

Background _stringToBackground(String backgroundString) {
  return backgroundString.length == 3 ? Background.day : Background.night;
}
