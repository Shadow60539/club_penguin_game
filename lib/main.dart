import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';
import 'package:social_media_game/application/auth/auth_bloc.dart';
import 'package:social_media_game/application/chat/chat_bloc.dart';
import 'package:social_media_game/application/movement/movement_bloc.dart';
import 'package:social_media_game/application/providers/chat_provider.dart';
import 'package:social_media_game/application/status/status_bloc.dart';
import 'package:social_media_game/core/services/navigation_service.dart';
import 'package:social_media_game/presentation/game/game.dart';
import 'package:social_media_game/presentation/home/pages/home_page.dart';

import 'application/providers/world_provider.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //TODO: Add sentry
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  // Firebase Setup
  await Firebase.initializeApp();
  configureInjection(Environment.prod);

  // Load asset images
  await Flame.images.loadAll([
    "idle.png",
    "walk.png",
    "idle_me.png",
    "walk_me.png",
    "hurt.png",
    "chat.png",
    "chat_idle.png",
    "chat_run.png",
    "background/screen1/1.png",
    "background/screen1/2.png",
    "background/screen1/3.png",
    "background/screen1/4.png",
    "background/screen1/5.png",
    "background/screen1/6.png",
    "background/screen1/7.png",
    "background/screen2/1.png",
    "background/screen2/2.png",
    "background/screen2/3.png",
    "background/screen2/4.png",
    "background/screen2/5.png",
    "background/screen2/6.png",
    "background/screen2/7.png",
    "background/screen2/8.png",
    "background/screen2/9.png",
    "background/screen2/10.png",
    "background/screen2/11.png",
    "background/screen2/12.png",
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NavigationService _navigationService = getIt<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                getIt<AuthBloc>()..add(const AuthEvent.getSignedInUser()),
          ),
          BlocProvider(
            create: (context) => getIt<StatusBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt<MovementBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt<ChatBloc>(),
          ),
          ChangeNotifierProvider(
            create: (_) => ChatProvider(getIt<ClubPenguinGame>()),
          ),
          ChangeNotifierProvider(
            create: (_) => WorldProvider(),
          )
        ],
        child: MaterialApp(
          title: 'Penguin Chat',
          key: _navigationService.navigationKey,
          theme: ThemeData.dark().copyWith(
            textTheme: GoogleFonts.pressStart2pTextTheme(),
            splashFactory: InkRipple.splashFactory,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
              },
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        ));
  }
}
