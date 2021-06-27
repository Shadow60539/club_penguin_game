import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_game/core/utils/firestore_collection_names.dart';
import 'package:social_media_game/domain/chat/chat_failure.dart';
import 'package:social_media_game/domain/chat/i_chat_repo.dart';

@Injectable(as: IChatRepo)
@prod
class ChatRepo extends IChatRepo {
  @override
  Future<Either<ChatFailure, Unit>> sendMessage(String? message) async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      final db = FirebaseDatabase.instance;
      final reference = db.reference();
      await reference.child(MESSAGE_COLLECTION).child(userId).set({
        "id": userId,
        "message": message,
        "time": DateTime.now().toIso8601String()
      });
      return right(unit);
    } catch (e) {
      // await Sentry.captureException(e, stackTrace: e.toString());

      return left(const ChatFailure.serverFailure());
    }
  }
}
