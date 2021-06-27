part of 'status_bloc.dart';

@freezed
class StatusEvent with _$StatusEvent {
  const factory StatusEvent.setOnline() = _SetOnline;
  const factory StatusEvent.setOffline() = _SetOffline;
}
