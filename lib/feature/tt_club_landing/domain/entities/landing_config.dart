import 'package:flutter/foundation.dart';
import 'landing_action.dart';

@immutable
class LandingConfig {
  final String appTitle;
  final String subtitle;
  final String hotlineText;
  final String logoAssetPath;

  final LandingAction joinAction;
  final LandingAction nearestLawyerAction;

  /// Grid tiles (e.g., specialties / lawyers / international).
  final List<LandingAction> mainTiles;

  /// Footer icon actions (email / website / whatsapp / facebook).
  final List<LandingAction> footerIcons;

  const LandingConfig({
    required this.appTitle,
    required this.subtitle,
    required this.hotlineText,
    required this.logoAssetPath,
    required this.joinAction,
    required this.nearestLawyerAction,
    required this.mainTiles,
    required this.footerIcons,
  });
}
