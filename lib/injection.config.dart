// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_auth/firebase_auth.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'application/auth/auth_bloc.dart' as _i16;
import 'application/chat/chat_bloc.dart' as _i17;
import 'application/movement/movement_bloc.dart' as _i13;
import 'application/providers/chat_provider.dart' as _i18;
import 'application/status/status_bloc.dart' as _i15;
import 'core/services/navigation_service.dart' as _i14;
import 'domain/auth/i_auth_repo.dart' as _i5;
import 'domain/chat/i_chat_repo.dart' as _i7;
import 'domain/movement/i_movement_repo.dart' as _i9;
import 'domain/status/i_status_repo.dart' as _i11;
import 'infrastructure/auth/auth_repo.dart' as _i6;
import 'infrastructure/chat/chat_repo.dart' as _i8;
import 'infrastructure/injectable_module.dart' as _i19;
import 'infrastructure/movement/movement_repo.dart' as _i10;
import 'infrastructure/status/status_repo.dart' as _i12;
import 'presentation/game/game.dart' as _i3;

const String _prod = 'prod';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final injectableModule = _$InjectableModule();
  gh.lazySingleton<_i3.ClubPenguinGame>(() => _i3.ClubPenguinGame());
  gh.lazySingleton<_i4.FirebaseAuth>(() => injectableModule.firebaseAuth);
  gh.factory<_i5.IAuthRepo>(
      () => _i6.AuthRepo(firebaseAuth: get<_i4.FirebaseAuth>()),
      registerFor: {_prod});
  gh.factory<_i7.IChatRepo>(() => _i8.ChatRepo(), registerFor: {_prod});
  gh.factory<_i9.IMovementRepo>(() => _i10.MovementRepo(),
      registerFor: {_prod});
  gh.factory<_i11.IStatusRepo>(() => _i12.StatusRepo(), registerFor: {_prod});
  gh.factory<_i13.MovementBloc>(
      () => _i13.MovementBloc(get<_i9.IMovementRepo>()),
      registerFor: {_prod});
  gh.lazySingleton<_i14.NavigationService>(() => _i14.NavigationService());
  gh.factory<_i15.StatusBloc>(() => _i15.StatusBloc(get<_i11.IStatusRepo>()),
      registerFor: {_prod});
  gh.factory<_i16.AuthBloc>(() => _i16.AuthBloc(get<_i5.IAuthRepo>()),
      registerFor: {_prod});
  gh.factory<_i17.ChatBloc>(() => _i17.ChatBloc(get<_i7.IChatRepo>()),
      registerFor: {_prod});
  gh.lazySingleton<_i18.ChatProvider>(
      () => _i18.ChatProvider(get<_i3.ClubPenguinGame>()));
  return get;
}

class _$InjectableModule extends _i19.InjectableModule {}
