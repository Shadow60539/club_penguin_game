import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_game/core/utils/firestore_collection_names.dart';
import 'package:social_media_game/domain/movement/i_movement_repo.dart';
import 'package:social_media_game/domain/movement/movement_failure.dart';
import 'package:social_media_game/presentation/game/game.dart';

@Injectable(as: IMovementRepo)
@prod
class MovementRepo extends IMovementRepo {
  @override
  Future<Either<MovementFailure, Unit>> updatePosition(
      {required double x, required Background currentBackground}) async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      final db = FirebaseDatabase.instance;
      final reference = db.reference();

      await reference.child(USER_COLLECTION).child(userId).set({
        "id": userId,
        "x": x,
        "background": currentBackground == Background.day ? "day" : "night"
      });
      return right(unit);
    } catch (e) {
      // await Sentry.captureException(e, stackTrace: e.toString());
      return left(const MovementFailure.serverFailure());
    }
  }
}
