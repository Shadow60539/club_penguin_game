import 'package:freezed_annotation/freezed_annotation.dart';

part 'status_failure.freezed.dart';

@freezed
class StatusFailure with _$StatusFailure {
  /// Placeholder failure to map all the exceptions
  const factory StatusFailure.serverFailure() = _ServerFailure;
}
