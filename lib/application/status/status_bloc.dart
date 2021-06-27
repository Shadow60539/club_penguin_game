import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:social_media_game/core/utils/build_context.dart';
import 'package:social_media_game/domain/status/i_status_repo.dart';
import 'package:social_media_game/domain/status/status_failure.dart';
import 'package:social_media_game/infrastructure/status/status_repo.dart';

part 'status_bloc.freezed.dart';
part 'status_event.dart';
part 'status_state.dart';

@injectable
@prod
class StatusBloc extends Bloc<StatusEvent, StatusState> {
  static void addEventWithoutContext(StatusEvent e) =>
      BlocProvider.of<StatusBloc>(context).add(e);

  StatusBloc(this._statusRepo) : super(StatusState.initial());
  final IStatusRepo _statusRepo;

  @override
  Stream<StatusState> mapEventToState(
    StatusEvent event,
  ) async* {
    yield* event.map(
      setOnline: (e) async* {
        yield* _toggleStatus(StatusEnum.online);
      },
      setOffline: (e) async* {
        yield* _toggleStatus(StatusEnum.offline);
      },
    );
  }

  Stream<StatusState> _toggleStatus(StatusEnum statusEnum) async* {
    yield state.copyWith(statusOption: none());

    Either<StatusFailure, Unit> _failureOrSuccess;

    if (statusEnum == StatusEnum.online) {
      _failureOrSuccess = await _statusRepo.setOnline();
    } else {
      _failureOrSuccess = await _statusRepo.setOffline();
    }

    yield _failureOrSuccess.fold(
      (l) {
        return state.copyWith(statusOption: some(left(l)));
      },
      (r) {
        return state.copyWith(statusOption: some(right(r)));
      },
    );
  }
}
