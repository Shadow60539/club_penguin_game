import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  /// `FirebaseAuthException` is mapped with this failure
  const factory AuthFailure.serverFailure() = _ServerFailure;

  /// Catch exceptions thrown by `signInAnonymously`
  const factory AuthFailure.noUserFailure() = _NoUserFailure;
}
