part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState(
          {required Option<Either<ChatFailure, Unit>> sendMessageOption}) =
      _ChatState;

  factory ChatState.initial() => ChatState(sendMessageOption: none());
}
