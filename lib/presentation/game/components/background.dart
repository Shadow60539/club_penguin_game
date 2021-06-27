import 'package:flame/components.dart';
import 'package:flame/src/parallax.dart';
import 'package:social_media_game/presentation/game/game.dart';

class DayBackground extends ParallaxComponent with HasGameRef<ClubPenguinGame> {
  DayBackground();

  @override
  Future<void>? onLoad() async {
    // TODO: implement onLoad
    final dayImages = [
      gameRef.loadParallaxImage('background/screen1/1.png'),
      gameRef.loadParallaxImage('background/screen1/5.png'),
      gameRef.loadParallaxImage('background/screen1/2.png'),
      gameRef.loadParallaxImage('background/screen1/4.png'),
      gameRef.loadParallaxImage('background/screen1/6.png'),
      gameRef.loadParallaxImage('background/screen1/7.png',
          fill: LayerFill.none),
    ];
    final dayLayers = dayImages.map((image) async =>
        ParallaxLayer(await image, velocityMultiplier: Vector2(1, 0)));
    parallax = ParallaxComponent.fromParallax(
      Parallax(
        await Future.wait(dayLayers),
        baseVelocity: Vector2(5, 0),
      ),
    ).parallax;

    return super.onLoad();
  }
}

class NightBackground extends ParallaxComponent
    with HasGameRef<ClubPenguinGame> {
  NightBackground();

  @override
  Future<void>? onLoad() async {
    // TODO: implement onLoad
    final dayImages = [
      gameRef.loadParallaxImage('background/screen2/1.png'),
      gameRef.loadParallaxImage('background/screen2/2.png'),
      gameRef.loadParallaxImage('background/screen2/3.png'),
      gameRef.loadParallaxImage('background/screen2/4.png'),
      gameRef.loadParallaxImage('background/screen2/5.png'),
      gameRef.loadParallaxImage('background/screen2/6.png'),
      gameRef.loadParallaxImage('background/screen2/7.png'),
      gameRef.loadParallaxImage('background/screen2/8.png'),
      gameRef.loadParallaxImage('background/screen2/9.png'),
      gameRef.loadParallaxImage('background/screen2/10.png'),
      gameRef.loadParallaxImage('background/screen2/11.png'),
      gameRef.loadParallaxImage('background/screen2/12.png'),
      // gameRef.loadParallaxImage('background/screen2/7.png',
      //     fill: LayerFill.none),
    ];
    final dayLayers = dayImages.map((image) async =>
        ParallaxLayer(await image, velocityMultiplier: Vector2(1, 0)));
    parallax = ParallaxComponent.fromParallax(
      Parallax(
        await Future.wait(dayLayers),
        baseVelocity: Vector2(5, 0),
      ),
    ).parallax;

    return super.onLoad();
  }
}
