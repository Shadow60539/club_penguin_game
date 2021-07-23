import 'package:dartz/dartz.dart';
import 'package:social_media_game/domain/movement/movement_failure.dart';
import 'package:social_media_game/presentation/game/game.dart';

abstract class IMovementRepo {
  /// Update [x] and [currentBackground] fields in the database
  Future<Either<MovementFailure, Unit>> updatePosition({
    required double x,
    required Background currentBackground,
    required bool isTyping,
  });
}
