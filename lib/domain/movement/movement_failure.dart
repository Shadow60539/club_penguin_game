import 'package:freezed_annotation/freezed_annotation.dart';

part 'movement_failure.freezed.dart';

@freezed
class MovementFailure with _$MovementFailure {
  /// Placeholder failure to map all the exceptions
  const factory MovementFailure.serverFailure() = _ServerFailure;
}
