import 'package:dartz/dartz.dart';
import 'package:social_media_game/domain/status/status_failure.dart';

abstract class IStatusRepo {
  /// Create the penguin with last known position
  Future<Either<StatusFailure, Unit>> setOnline();

  /// Remove this penguin from the database
  Future<Either<StatusFailure, Unit>> setOffline();
}
