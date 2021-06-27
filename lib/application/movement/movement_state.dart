part of 'movement_bloc.dart';

@freezed
class MovementState with _$MovementState {
  const factory MovementState({
    required Option<Either<MovementFailure, Unit>> movementOption,
  }) = _MovementState;

  factory MovementState.initial() => MovementState(
        movementOption: none(),
      );
}
