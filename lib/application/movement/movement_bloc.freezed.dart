// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'movement_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$MovementEventTearOff {
  const _$MovementEventTearOff();

  _UpdatePosition updatePosition(
      {required double x, required Background background}) {
    return _UpdatePosition(
      x: x,
      background: background,
    );
  }
}

/// @nodoc
const $MovementEvent = _$MovementEventTearOff();

/// @nodoc
mixin _$MovementEvent {
  double get x => throw _privateConstructorUsedError;
  Background get background => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(double x, Background background) updatePosition,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(double x, Background background)? updatePosition,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UpdatePosition value) updatePosition,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UpdatePosition value)? updatePosition,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MovementEventCopyWith<MovementEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovementEventCopyWith<$Res> {
  factory $MovementEventCopyWith(
          MovementEvent value, $Res Function(MovementEvent) then) =
      _$MovementEventCopyWithImpl<$Res>;
  $Res call({double x, Background background});
}

/// @nodoc
class _$MovementEventCopyWithImpl<$Res>
    implements $MovementEventCopyWith<$Res> {
  _$MovementEventCopyWithImpl(this._value, this._then);

  final MovementEvent _value;
  // ignore: unused_field
  final $Res Function(MovementEvent) _then;

  @override
  $Res call({
    Object? x = freezed,
    Object? background = freezed,
  }) {
    return _then(_value.copyWith(
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      background: background == freezed
          ? _value.background
          : background // ignore: cast_nullable_to_non_nullable
              as Background,
    ));
  }
}

/// @nodoc
abstract class _$UpdatePositionCopyWith<$Res>
    implements $MovementEventCopyWith<$Res> {
  factory _$UpdatePositionCopyWith(
          _UpdatePosition value, $Res Function(_UpdatePosition) then) =
      __$UpdatePositionCopyWithImpl<$Res>;
  @override
  $Res call({double x, Background background});
}

/// @nodoc
class __$UpdatePositionCopyWithImpl<$Res>
    extends _$MovementEventCopyWithImpl<$Res>
    implements _$UpdatePositionCopyWith<$Res> {
  __$UpdatePositionCopyWithImpl(
      _UpdatePosition _value, $Res Function(_UpdatePosition) _then)
      : super(_value, (v) => _then(v as _UpdatePosition));

  @override
  _UpdatePosition get _value => super._value as _UpdatePosition;

  @override
  $Res call({
    Object? x = freezed,
    Object? background = freezed,
  }) {
    return _then(_UpdatePosition(
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      background: background == freezed
          ? _value.background
          : background // ignore: cast_nullable_to_non_nullable
              as Background,
    ));
  }
}

/// @nodoc

class _$_UpdatePosition implements _UpdatePosition {
  const _$_UpdatePosition({required this.x, required this.background});

  @override
  final double x;
  @override
  final Background background;

  @override
  String toString() {
    return 'MovementEvent.updatePosition(x: $x, background: $background)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UpdatePosition &&
            (identical(other.x, x) ||
                const DeepCollectionEquality().equals(other.x, x)) &&
            (identical(other.background, background) ||
                const DeepCollectionEquality()
                    .equals(other.background, background)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(x) ^
      const DeepCollectionEquality().hash(background);

  @JsonKey(ignore: true)
  @override
  _$UpdatePositionCopyWith<_UpdatePosition> get copyWith =>
      __$UpdatePositionCopyWithImpl<_UpdatePosition>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(double x, Background background) updatePosition,
  }) {
    return updatePosition(x, background);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(double x, Background background)? updatePosition,
    required TResult orElse(),
  }) {
    if (updatePosition != null) {
      return updatePosition(x, background);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UpdatePosition value) updatePosition,
  }) {
    return updatePosition(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UpdatePosition value)? updatePosition,
    required TResult orElse(),
  }) {
    if (updatePosition != null) {
      return updatePosition(this);
    }
    return orElse();
  }
}

abstract class _UpdatePosition implements MovementEvent {
  const factory _UpdatePosition(
      {required double x, required Background background}) = _$_UpdatePosition;

  @override
  double get x => throw _privateConstructorUsedError;
  @override
  Background get background => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UpdatePositionCopyWith<_UpdatePosition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$MovementStateTearOff {
  const _$MovementStateTearOff();

  _MovementState call(
      {required Option<Either<MovementFailure, Unit>> movementOption}) {
    return _MovementState(
      movementOption: movementOption,
    );
  }
}

/// @nodoc
const $MovementState = _$MovementStateTearOff();

/// @nodoc
mixin _$MovementState {
  Option<Either<MovementFailure, Unit>> get movementOption =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MovementStateCopyWith<MovementState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovementStateCopyWith<$Res> {
  factory $MovementStateCopyWith(
          MovementState value, $Res Function(MovementState) then) =
      _$MovementStateCopyWithImpl<$Res>;
  $Res call({Option<Either<MovementFailure, Unit>> movementOption});
}

/// @nodoc
class _$MovementStateCopyWithImpl<$Res>
    implements $MovementStateCopyWith<$Res> {
  _$MovementStateCopyWithImpl(this._value, this._then);

  final MovementState _value;
  // ignore: unused_field
  final $Res Function(MovementState) _then;

  @override
  $Res call({
    Object? movementOption = freezed,
  }) {
    return _then(_value.copyWith(
      movementOption: movementOption == freezed
          ? _value.movementOption
          : movementOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<MovementFailure, Unit>>,
    ));
  }
}

/// @nodoc
abstract class _$MovementStateCopyWith<$Res>
    implements $MovementStateCopyWith<$Res> {
  factory _$MovementStateCopyWith(
          _MovementState value, $Res Function(_MovementState) then) =
      __$MovementStateCopyWithImpl<$Res>;
  @override
  $Res call({Option<Either<MovementFailure, Unit>> movementOption});
}

/// @nodoc
class __$MovementStateCopyWithImpl<$Res>
    extends _$MovementStateCopyWithImpl<$Res>
    implements _$MovementStateCopyWith<$Res> {
  __$MovementStateCopyWithImpl(
      _MovementState _value, $Res Function(_MovementState) _then)
      : super(_value, (v) => _then(v as _MovementState));

  @override
  _MovementState get _value => super._value as _MovementState;

  @override
  $Res call({
    Object? movementOption = freezed,
  }) {
    return _then(_MovementState(
      movementOption: movementOption == freezed
          ? _value.movementOption
          : movementOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<MovementFailure, Unit>>,
    ));
  }
}

/// @nodoc

class _$_MovementState implements _MovementState {
  const _$_MovementState({required this.movementOption});

  @override
  final Option<Either<MovementFailure, Unit>> movementOption;

  @override
  String toString() {
    return 'MovementState(movementOption: $movementOption)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MovementState &&
            (identical(other.movementOption, movementOption) ||
                const DeepCollectionEquality()
                    .equals(other.movementOption, movementOption)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(movementOption);

  @JsonKey(ignore: true)
  @override
  _$MovementStateCopyWith<_MovementState> get copyWith =>
      __$MovementStateCopyWithImpl<_MovementState>(this, _$identity);
}

abstract class _MovementState implements MovementState {
  const factory _MovementState(
          {required Option<Either<MovementFailure, Unit>> movementOption}) =
      _$_MovementState;

  @override
  Option<Either<MovementFailure, Unit>> get movementOption =>
      throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MovementStateCopyWith<_MovementState> get copyWith =>
      throw _privateConstructorUsedError;
}
