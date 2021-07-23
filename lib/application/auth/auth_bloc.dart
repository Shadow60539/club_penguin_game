import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:social_media_game/application/chat/chat_bloc.dart';
import 'package:social_media_game/application/movement/movement_bloc.dart';
import 'package:social_media_game/core/utils/build_context.dart';
import 'package:social_media_game/domain/auth/auth_failure.dart';
import 'package:social_media_game/domain/auth/i_auth_repo.dart';
import 'package:social_media_game/domain/core/user.dart';
import 'package:social_media_game/presentation/game/game.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
@prod
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static void addEventWithoutContext(AuthEvent e) =>
      BlocProvider.of<AuthBloc>(context).add(e);

  AuthBloc(this._authRepo) : super(AuthState.initial());

  final IAuthRepo _authRepo;
  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    yield* event.map(
      getSignedInUser: (e) async* {
        final _failureOrSuccess = await _authRepo.getSignedInUser();
        yield _failureOrSuccess.fold(
          (l) => state.copyWith(authOption: some(left(l))),
          (r) {
            // Update x
            // In developement: -> x = 0 always
            // TODO: Try to cache the last known location in future
            // and use that instead of (0.0)
            ChatBloc.addEventWithoutContext(const ChatEvent.sendMessage(null));
            MovementBloc.addEventWithoutContext(
                const MovementEvent.updatePosition(
              x: 0.0,
              background: Background.day,
              isTyping: false,
            ));

            return state.copyWith(authOption: some(right(r)), user: r);
          },
        );
      },
      signOut: (e) async* {
        //TODO: Add signout instead of closing the app
      },
    );
  }
}
