import 'package:flutter/foundation.dart';

import 'landing_action.dart';

@immutable
class LandingConfig {
  final String appTitle;
  final String subtitle;
  final String logoAssetPath;

  /// Header trailing action (right side). Example: notifications.
  final LandingAction headerTrailingAction;

  /// CTA buttons.
  final LandingAction joinAction;
  final LandingAction nearestLawyerAction;

  /// Section actions.
  final LandingAction internationalLawyersAction;

  /// Middle cards section (3 cards in sketch).
  final List<LandingAction> categories;

  /// Contact icon row (mail/web/phone/...)
  final List<LandingAction> contactIcons;

  /// Bottom navigation.
  final LandingAction servicesNavAction;
  final LandingAction aboutNavAction;
  final LandingAction messagesNavAction;
  final LandingAction profileNavAction;

  const LandingConfig({
    required this.appTitle,
    required this.subtitle,
    required this.logoAssetPath,
    required this.headerTrailingAction,
    required this.joinAction,
    required this.nearestLawyerAction,
    required this.internationalLawyersAction,
    required this.categories,
    required this.contactIcons,
    required this.servicesNavAction,
    required this.aboutNavAction,
    required this.messagesNavAction,
    required this.profileNavAction,
  });
}
