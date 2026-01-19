import 'package:flutter/foundation.dart';

/// Internal destinations are expressed as keys to keep the domain layer
/// independent from routing (GetX / RouteHelper).
enum AppRouteKey {
  /// Original app home (BottomNavScreen).
  /// Params: {"page": "home" | "offers" | ...}
  main,

  signUp,

  /// Discounts/Offers screen.
  offers,

  /// Chat inbox.
  chatInbox,

  /// Profile screen.
  profile,

  /// Notifications screen.
  notifications,

  /// Optional legacy routes (kept for compatibility).
  allCategories,
  allProviders,
  nearByProviders,
  internationalLawyers,
}

@immutable
sealed class LandingDestination {
  const LandingDestination();
}

@immutable
class AppRouteDestination extends LandingDestination {
  final AppRouteKey key;
  final Map<String, String> params;

  const AppRouteDestination({
    required this.key,
    this.params = const <String, String>{},
  });
}

@immutable
class ExternalUriDestination extends LandingDestination {
  final Uri uri;

  const ExternalUriDestination(this.uri);
}

@immutable
class InAppWebViewDestination extends LandingDestination {
  final String title;
  final Uri uri;

  const InAppWebViewDestination({
    required this.title,
    required this.uri,
  });
}

/// RouteHelper.html?page=<pageKey>&title=<title>
@immutable
class HtmlDestination extends LandingDestination {
  final String pageKey;
  final String? title;

  const HtmlDestination({
    required this.pageKey,
    this.title,
  });
}

/// UI-only destination: open a taxi provider picker (bottom sheet) and launch
/// installed apps (or fallback to store).
@immutable
class TaxiSheetDestination extends LandingDestination {
  const TaxiSheetDestination();
}

@immutable
class LandingAction {
  final String id;
  final String title;
  final String iconKey;
  final LandingDestination destination;

  const LandingAction({
    required this.id,
    required this.title,
    required this.iconKey,
    required this.destination,
  });
}
