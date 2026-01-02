import 'package:flutter_test/flutter_test.dart';
import 'package:demandium/feature/tt_club_landing/domain/entities/landing_config.dart';
import 'package:demandium/feature/tt_club_landing/domain/repositories/tt_club_landing_repository.dart';
import 'package:demandium/feature/tt_club_landing/domain/usecases/get_landing_config_usecase.dart';

class _FakeRepo implements TtClubLandingRepository {
  @override
  Future<LandingConfig> getLandingConfig() async {
    return LandingConfig(
      appTitle: 'TT CLUB',
      subtitle: 'x',
      hotlineText: '1088.tel',
      logoAssetPath: 'assets/images/logo.png',
      joinLink: LandingLink(title: 'join', url: Uri.parse('https://www.1088.tel/w/Join'), type: LandingLinkType.inAppWebView),
      nearestLawyerLink:  LandingLink(title: 'near', url: Uri.parse('https://www.1088.tel/w/near-by-Ar'), type: LandingLinkType.inAppWebView),
      mainTiles: const [],
      footerLinks: const [],
    );
  }
}

void main() {
  test('GetLandingConfigUseCase returns config', () async {
    final usecase = GetLandingConfigUseCase(_FakeRepo());
    final cfg = await usecase();
    expect(cfg.hotlineText, '1088.tel');
    expect(cfg.joinLink.url.toString(), contains('/w/Join'));
  });
}
