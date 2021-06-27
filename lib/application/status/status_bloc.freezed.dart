// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'status_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$StatusEventTearOff {
  const _$StatusEventTearOff();

  _SetOnline setOnline() {
    return const _SetOnline();
  }

  _SetOffline setOffline() {
    return const _SetOffline();
  }
}

/// @nodoc
const $StatusEvent = _$StatusEventTearOff();

/// @nodoc
mixin _$StatusEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() setOnline,
    required TResult Function() setOffline,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? setOnline,
    TResult Function()? setOffline,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SetOnline value) setOnline,
    required TResult Function(_SetOffline value) setOffline,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SetOnline value)? setOnline,
    TResult Function(_SetOffline value)? setOffline,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusEventCopyWith<$Res> {
  factory $StatusEventCopyWith(
          StatusEvent value, $Res Function(StatusEvent) then) =
      _$StatusEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$StatusEventCopyWithImpl<$Res> implements $StatusEventCopyWith<$Res> {
  _$StatusEventCopyWithImpl(this._value, this._then);

  final StatusEvent _value;
  // ignore: unused_field
  final $Res Function(StatusEvent) _then;
}

/// @nodoc
abstract class _$SetOnlineCopyWith<$Res> {
  factory _$SetOnlineCopyWith(
          _SetOnline value, $Res Function(_SetOnline) then) =
      __$SetOnlineCopyWithImpl<$Res>;
}

/// @nodoc
class __$SetOnlineCopyWithImpl<$Res> extends _$StatusEventCopyWithImpl<$Res>
    implements _$SetOnlineCopyWith<$Res> {
  __$SetOnlineCopyWithImpl(_SetOnline _value, $Res Function(_SetOnline) _then)
      : super(_value, (v) => _then(v as _SetOnline));

  @override
  _SetOnline get _value => super._value as _SetOnline;
}

/// @nodoc

class _$_SetOnline implements _SetOnline {
  const _$_SetOnline();

  @override
  String toString() {
    return 'StatusEvent.setOnline()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _SetOnline);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() setOnline,
    required TResult Function() setOffline,
  }) {
    return setOnline();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? setOnline,
    TResult Function()? setOffline,
    required TResult orElse(),
  }) {
    if (setOnline != null) {
      return setOnline();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SetOnline value) setOnline,
    required TResult Function(_SetOffline value) setOffline,
  }) {
    return setOnline(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SetOnline value)? setOnline,
    TResult Function(_SetOffline value)? setOffline,
    required TResult orElse(),
  }) {
    if (setOnline != null) {
      return setOnline(this);
    }
    return orElse();
  }
}

abstract class _SetOnline implements StatusEvent {
  const factory _SetOnline() = _$_SetOnline;
}

/// @nodoc
abstract class _$SetOfflineCopyWith<$Res> {
  factory _$SetOfflineCopyWith(
          _SetOffline value, $Res Function(_SetOffline) then) =
      __$SetOfflineCopyWithImpl<$Res>;
}

/// @nodoc
class __$SetOfflineCopyWithImpl<$Res> extends _$StatusEventCopyWithImpl<$Res>
    implements _$SetOfflineCopyWith<$Res> {
  __$SetOfflineCopyWithImpl(
      _SetOffline _value, $Res Function(_SetOffline) _then)
      : super(_value, (v) => _then(v as _SetOffline));

  @override
  _SetOffline get _value => super._value as _SetOffline;
}

/// @nodoc

class _$_SetOffline implements _SetOffline {
  const _$_SetOffline();

  @override
  String toString() {
    return 'StatusEvent.setOffline()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _SetOffline);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() setOnline,
    required TResult Function() setOffline,
  }) {
    return setOffline();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? setOnline,
    TResult Function()? setOffline,
    required TResult orElse(),
  }) {
    if (setOffline != null) {
      return setOffline();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SetOnline value) setOnline,
    required TResult Function(_SetOffline value) setOffline,
  }) {
    return setOffline(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SetOnline value)? setOnline,
    TResult Function(_SetOffline value)? setOffline,
    required TResult orElse(),
  }) {
    if (setOffline != null) {
      return setOffline(this);
    }
    return orElse();
  }
}

abstract class _SetOffline implements StatusEvent {
  const factory _SetOffline() = _$_SetOffline;
}

/// @nodoc
class _$StatusStateTearOff {
  const _$StatusStateTearOff();

  _StatusState call(
      {required Option<Either<StatusFailure, Unit>> statusOption}) {
    return _StatusState(
      statusOption: statusOption,
    );
  }
}

/// @nodoc
const $StatusState = _$StatusStateTearOff();

/// @nodoc
mixin _$StatusState {
  Option<Either<StatusFailure, Unit>> get statusOption =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StatusStateCopyWith<StatusState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusStateCopyWith<$Res> {
  factory $StatusStateCopyWith(
          StatusState value, $Res Function(StatusState) then) =
      _$StatusStateCopyWithImpl<$Res>;
  $Res call({Option<Either<StatusFailure, Unit>> statusOption});
}

/// @nodoc
class _$StatusStateCopyWithImpl<$Res> implements $StatusStateCopyWith<$Res> {
  _$StatusStateCopyWithImpl(this._value, this._then);

  final StatusState _value;
  // ignore: unused_field
  final $Res Function(StatusState) _then;

  @override
  $Res call({
    Object? statusOption = freezed,
  }) {
    return _then(_value.copyWith(
      statusOption: statusOption == freezed
          ? _value.statusOption
          : statusOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<StatusFailure, Unit>>,
    ));
  }
}

/// @nodoc
abstract class _$StatusStateCopyWith<$Res>
    implements $StatusStateCopyWith<$Res> {
  factory _$StatusStateCopyWith(
          _StatusState value, $Res Function(_StatusState) then) =
      __$StatusStateCopyWithImpl<$Res>;
  @override
  $Res call({Option<Either<StatusFailure, Unit>> statusOption});
}

/// @nodoc
class __$StatusStateCopyWithImpl<$Res> extends _$StatusStateCopyWithImpl<$Res>
    implements _$StatusStateCopyWith<$Res> {
  __$StatusStateCopyWithImpl(
      _StatusState _value, $Res Function(_StatusState) _then)
      : super(_value, (v) => _then(v as _StatusState));

  @override
  _StatusState get _value => super._value as _StatusState;

  @override
  $Res call({
    Object? statusOption = freezed,
  }) {
    return _then(_StatusState(
      statusOption: statusOption == freezed
          ? _value.statusOption
          : statusOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<StatusFailure, Unit>>,
    ));
  }
}

/// @nodoc

class _$_StatusState implements _StatusState {
  const _$_StatusState({required this.statusOption});

  @override
  final Option<Either<StatusFailure, Unit>> statusOption;

  @override
  String toString() {
    return 'StatusState(statusOption: $statusOption)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _StatusState &&
            (identical(other.statusOption, statusOption) ||
                const DeepCollectionEquality()
                    .equals(other.statusOption, statusOption)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(statusOption);

  @JsonKey(ignore: true)
  @override
  _$StatusStateCopyWith<_StatusState> get copyWith =>
      __$StatusStateCopyWithImpl<_StatusState>(this, _$identity);
}

abstract class _StatusState implements StatusState {
  const factory _StatusState(
          {required Option<Either<StatusFailure, Unit>> statusOption}) =
      _$_StatusState;

  @override
  Option<Either<StatusFailure, Unit>> get statusOption =>
      throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$StatusStateCopyWith<_StatusState> get copyWith =>
      throw _privateConstructorUsedError;
}
