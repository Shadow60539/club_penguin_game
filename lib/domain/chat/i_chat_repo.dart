import 'package:dartz/dartz.dart';

import '../chat/chat_failure.dart';

abstract class IChatRepo {
  Future<Either<ChatFailure, Unit>> sendMessage(String? message);
}
