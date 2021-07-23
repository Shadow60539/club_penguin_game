part of 'movement_bloc.dart';

@freezed
class MovementEvent with _$MovementEvent {
  const factory MovementEvent.updatePosition({
    required double x,
    required Background background,
    required bool isTyping,
  }) = _UpdatePosition;
}
