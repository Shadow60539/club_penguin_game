import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_game/domain/auth/auth_failure.dart';
import 'package:social_media_game/domain/auth/i_auth_repo.dart';
import 'package:social_media_game/domain/core/user.dart';

@prod
@Injectable(as: IAuthRepo)
class AuthRepo extends IAuthRepo {
  final FirebaseAuth firebaseAuth;

  AuthRepo({required this.firebaseAuth});
  @override
  Future<Either<AuthFailure, GameUser>> getSignedInUser() async {
    try {
      final UserCredential _userCredential =
          await firebaseAuth.signInAnonymously();
      if (_userCredential.user != null) {
        final GameUser _user =
            GameUser.fromUserCredential(_userCredential.user!);

        return right(_user);
      } else {
        return left(const AuthFailure.noUserFailure());
      }
    } catch (e) {
      // if (e is FirebaseAuthException) {
      //   await Sentry.captureException(e, stackTrace: e.stackTrace);
      // }
      return left(const AuthFailure.serverFailure());
    }
  }
}
