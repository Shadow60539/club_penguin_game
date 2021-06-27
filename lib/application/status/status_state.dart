part of 'status_bloc.dart';

@freezed
class StatusState with _$StatusState {
  const factory StatusState({
    required Option<Either<StatusFailure, Unit>> statusOption,
  }) = _StatusState;

  factory StatusState.initial() => StatusState(statusOption: none());
}
