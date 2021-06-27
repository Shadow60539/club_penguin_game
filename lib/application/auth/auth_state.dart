part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required Option<Either<AuthFailure, GameUser>> authOption,
    required GameUser? user,
  }) = _AuthState;

  factory AuthState.initial() => AuthState(authOption: none(), user: null);
}
