import 'package:dartz/dartz.dart';
import 'package:social_media_game/domain/auth/auth_failure.dart';
import 'package:social_media_game/domain/core/user.dart';

abstract class IAuthRepo {
  /// To get signed in user
  Future<Either<AuthFailure, GameUser>> getSignedInUser();
}
