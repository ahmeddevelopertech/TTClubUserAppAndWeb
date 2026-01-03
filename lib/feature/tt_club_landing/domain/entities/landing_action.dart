import 'package:flutter/foundation.dart';

/// Internal destinations are expressed as keys to keep the domain layer
/// independent from routing (GetX / RouteHelper).
enum AppRouteKey {
  signUp,
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
