import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_game/core/utils/build_context.dart';
import 'package:social_media_game/domain/movement/i_movement_repo.dart';
import 'package:social_media_game/domain/movement/movement_failure.dart';
import 'package:social_media_game/presentation/game/game.dart';

part 'movement_bloc.freezed.dart';
part 'movement_event.dart';
part 'movement_state.dart';

@injectable
@prod
class MovementBloc extends Bloc<MovementEvent, MovementState> {
  static void addEventWithoutContext(MovementEvent e) =>
      BlocProvider.of<MovementBloc>(context).add(e);

  MovementBloc(this.movementRepo) : super(MovementState.initial());

  final IMovementRepo movementRepo;

  @override
  Stream<MovementState> mapEventToState(
    MovementEvent event,
  ) async* {
    yield* event.map(
      updatePosition: (e) async* {
        final _failureOrSuccess = await movementRepo.updatePosition(
          x: e.x,
          currentBackground: e.background,
          isTyping: e.isTyping,
        );

        yield _failureOrSuccess.fold(
          (l) => state.copyWith(movementOption: some(left(l))),
          (r) => state.copyWith(movementOption: some(right(unit))),
        );
      },
    );
  }
}
