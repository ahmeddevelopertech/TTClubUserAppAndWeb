import 'package:flutter/foundation.dart';

enum LandingLinkType { inAppWebView, external }

@immutable
class LandingLink {
  final String title;
  final Uri url;
  final LandingLinkType type;

  const LandingLink({
    required this.title,
    required this.url,
    required this.type,
  });
}

@immutable
class LandingConfig {
  final String appTitle;
  final String subtitle;
  final String hotlineText;
  final String logoAssetPath;

  final LandingLink joinLink;
  final LandingLink nearestLawyerLink;

  final List<LandingLink> mainTiles;     // التخصصات / المحامين / المحامين الدوليين
  final List<LandingLink> footerLinks;   // Email / Website / WhatsApp / Facebook

  const LandingConfig({
    required this.appTitle,
    required this.subtitle,
    required this.hotlineText,
    required this.logoAssetPath,
    required this.joinLink,
    required this.nearestLawyerLink,
    required this.mainTiles,
    required this.footerLinks,
  });
}
