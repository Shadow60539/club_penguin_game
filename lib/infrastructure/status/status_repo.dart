import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_game/core/utils/firestore_collection_names.dart';
import 'package:social_media_game/domain/status/i_status_repo.dart';
import 'package:social_media_game/domain/status/status_failure.dart';

enum StatusEnum { online, offline }

@Injectable(as: IStatusRepo)
@prod
class StatusRepo extends IStatusRepo {
  @override
  Future<Either<StatusFailure, Unit>> setOffline() =>
      _toggleStatus(StatusEnum.offline);

  @override
  Future<Either<StatusFailure, Unit>> setOnline() =>
      _toggleStatus(StatusEnum.online);

  Future<Either<StatusFailure, Unit>> _toggleStatus(
      StatusEnum statusEnum) async {
    try {
      final db = FirebaseDatabase.instance;
      final reference = db.reference();

      // Current User != null
      //
      // This status regestration is called after the authentication
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      if (statusEnum == StatusEnum.offline) {
        // Remove from user collection
        await reference.child(USER_COLLECTION).child(userId).remove();
        return right(unit);
      } else {
        // Add user to collection
        await reference.child(USER_COLLECTION).child(userId).set({
          "id": userId,
          "x": 0.0,
        });

        return right(unit);
      }
    } catch (e) {
      // await Sentry.captureException(e, stackTrace: e.toString());

      return left(const StatusFailure.serverFailure());
    }
  }
}
