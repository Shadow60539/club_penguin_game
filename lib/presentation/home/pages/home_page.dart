import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:social_media_game/application/auth/auth_bloc.dart';
import 'package:social_media_game/application/providers/chat_provider.dart';
import 'package:social_media_game/application/providers/world_provider.dart';
import 'package:social_media_game/application/status/status_bloc.dart';
import 'package:social_media_game/injection.dart';
import 'package:social_media_game/presentation/game/game.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    StatusBloc.addEventWithoutContext(const StatusEvent.setOffline());
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  // similar override can be found in the `BaseGame`
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // setOffline for all other states except [AppLifecycleState.resumed]
    // [AppLifecycleState.resumed] setOnline

    switch (state) {
      case AppLifecycleState.resumed:
        StatusBloc.addEventWithoutContext(const StatusEvent.setOnline());
        break;
      case AppLifecycleState.inactive:
        StatusBloc.addEventWithoutContext(const StatusEvent.setOffline());

        break;
      case AppLifecycleState.paused:
        StatusBloc.addEventWithoutContext(const StatusEvent.setOffline());

        break;
      case AppLifecycleState.detached:
        StatusBloc.addEventWithoutContext(const StatusEvent.setOffline());
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return state.authOption.fold(
              () => const _Loading(),
              (some) => some.fold(
                (failure) => const _Error(),
                (_) => const ClubPenguinGameWidget(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ClubPenguinGameWidget extends StatelessWidget {
  const ClubPenguinGameWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: getIt<ClubPenguinGame>(),
      overlayBuilderMap: {
        ONLINE_GREEN: (_, __) => greenIconOverlay(),
        LEVEL_TEXT: (_, __) => _levelTextOverlay(),
        TEXT_FIELD: (_, __) => _chatBoxTextFormField()
      },
    );
  }

  Widget _chatBoxTextFormField() {
    const String _hintText = 'Chat with other penguins';
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 200),
        margin: const EdgeInsets.only(bottom: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Consumer<ChatProvider>(
            builder: (_, chatProvider, __) {
              return TextFormField(
                cursorColor: Colors.white,
                controller: chatProvider.textEditingController,
                style: TextStyle(
                    fontSize: 8, color: Colors.black.withOpacity(0.7)),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: _hintText,
                    contentPadding: EdgeInsets.all(20),
                    hintStyle: TextStyle(fontSize: 8, color: Colors.black45),
                    fillColor: Colors.white,
                    filled: true),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _levelTextOverlay() {
    const Cubic _curve = Curves.ease;

    return Align(
      alignment: Alignment.topRight,
      child: Container(
          margin: const EdgeInsets.only(top: 21.5, right: 22),
          child: Consumer<WorldProvider>(
            builder: (context, worldProvider, child) {
              return AnimatedCrossFade(
                firstChild: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      "Night",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                    )
                  ],
                ),
                secondChild: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 10,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Day",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                crossFadeState:
                    worldProvider.currentBackground == Background.day
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 400),
                alignment: Alignment.center,
                layoutBuilder:
                    (topChild, topChildKey, bottomChild, bottomChildKey) =>
                        topChild,
                sizeCurve: _curve,
                firstCurve: _curve,
                secondCurve: _curve,
              );
            },
          )),
    );
  }

  Widget greenIconOverlay() {
    return Container(
      margin: const EdgeInsets.only(top: 21.5, left: 22),
      height: 3,
      width: 3,
      decoration: const BoxDecoration(
          shape: BoxShape.circle, color: Colors.greenAccent),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/error_dino.json',
              height: 200, width: 200, frameRate: FrameRate.max),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('Something went wrong !',
                style: TextStyle(
                    // fontFamily: GoogleFonts.pressStart2p().fontFamily,
                    fontSize: 9,
                    color: Color(0xff525252))),
          )
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CupertinoActivityIndicator(),
          SizedBox(height: 20),
          Text('Signing in anonymously',
              style: TextStyle(
                  // fontFamily: GoogleFonts.pressStart2p().fontFamily,
                  fontSize: 9,
                  color: Color(0xff525252)))
        ],
      ),
    );
  }
}
