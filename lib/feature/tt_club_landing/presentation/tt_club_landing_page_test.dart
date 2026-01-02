import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:demandium/feature/tt_club_landing/domain/entities/landing_config.dart';
import 'package:demandium/feature/tt_club_landing/presentation/pages/tt_club_landing_page.dart';
import 'package:demandium/feature/tt_club_landing/presentation/providers/tt_club_landing_providers.dart';

void main() {
  testWidgets('Landing page shows header title and hotline', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          landingConfigProvider.overrideWith((ref) async {
            return LandingConfig(
              appTitle: 'TT CLUB',
              subtitle: 'sub',
              hotlineText: '1088.tel',
              logoAssetPath: 'assets/images/logo.png',
              joinLink:  LandingLink(title: 'join', url: Uri.parse('https://www.1088.tel/w/Join'), type: LandingLinkType.inAppWebView),
              nearestLawyerLink:  LandingLink(title: 'near', url: Uri.parse('https://www.1088.tel/w/near-by-Ar'), type: LandingLinkType.inAppWebView),
              mainTiles: const [],
              footerLinks: const [],
            );
          }),
        ],
        child: const GetMaterialApp(home: TtClubLandingPage()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('TT CLUB'), findsOneWidget);
    expect(find.text('1088.tel'), findsOneWidget);
  });
}
