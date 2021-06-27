import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:social_media_game/core/utils/build_context.dart';
import 'package:social_media_game/domain/chat/chat_failure.dart';
import 'package:social_media_game/domain/chat/i_chat_repo.dart';

part 'chat_bloc.freezed.dart';
part 'chat_event.dart';
part 'chat_state.dart';

@injectable
@prod
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  static void addEventWithoutContext(ChatEvent e) =>
      BlocProvider.of<ChatBloc>(context).add(e);

  ChatBloc(this.chatRepo) : super(ChatState.initial());

  final IChatRepo chatRepo;

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    yield* event.map(
      sendMessage: (e) async* {
        final _failureOrSuccess = await chatRepo.sendMessage(e.message);

        yield _failureOrSuccess.fold(
          (l) => state.copyWith(sendMessageOption: some(left(l))),
          (r) => state.copyWith(sendMessageOption: some(right(r))),
        );
      },
    );
  }
}
