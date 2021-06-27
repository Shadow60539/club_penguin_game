import 'package:flutter/material.dart';
import 'package:social_media_game/core/services/navigation_service.dart';
import 'package:social_media_game/injection.dart';

final BuildContext context =
    getIt<NavigationService>().navigationKey.currentContext!;
