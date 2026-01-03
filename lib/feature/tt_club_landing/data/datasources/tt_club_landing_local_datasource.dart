import 'package:demandium/utils/core_export.dart';

import '../../domain/entities/landing_action.dart';
import '../../domain/entities/landing_config.dart';

class TtClubLandingLocalDataSource {
  const TtClubLandingLocalDataSource();

  Future<LandingConfig> fetch() async {
    return LandingConfig(
      appTitle: 'TT CLUB',
      subtitle: 'نادي الحماية الدولي للأنشطة القانونية',
      hotlineText: '1088.tel',
      logoAssetPath: Images.logo,

      joinAction: const LandingAction(
        id: 'join',
        title: 'انضم الآن',
        iconKey: 'join',
        destination: AppRouteDestination(key: AppRouteKey.signUp),
      ),

      nearestLawyerAction: const LandingAction(
        id: 'near',
        title: 'اقرب محامي',
        iconKey: 'near',
        destination: AppRouteDestination(
          key: AppRouteKey.nearByProviders,
          params: {'tabIndex': '0'},
        ),
      ),

      mainTiles: const [
        LandingAction(
          id: 'specialties',
          title: 'التخصصات',
          iconKey: 'specialties',
          destination: AppRouteDestination(key: AppRouteKey.allCategories),
        ),
        LandingAction(
          id: 'lawyers',
          title: 'المحامين',
          iconKey: 'lawyers',
          destination: AppRouteDestination(key: AppRouteKey.allProviders),
        ),
        LandingAction(
          id: 'intl',
          title: 'المحامين الدوليين',
          iconKey: 'intl',
          destination: AppRouteDestination(key: AppRouteKey.internationalLawyers),
        ),
      ],

      footerIcons:  [
        LandingAction(
          id: 'email',
          title: 'Email',
          iconKey: 'email',
          destination: ExternalUriDestination(Uri.parse('mailto:info@ttclub.org')),
        ),
        LandingAction(
          id: 'website',
          title: 'Website',
          iconKey: 'website',
          destination: InAppWebViewDestination(
            title: 'TT Club',
            uri: Uri.parse('https://ttclub.org/'),
          ),
        ),
        LandingAction(
          id: 'whatsapp',
          title: 'WhatsApp',
          iconKey: 'whatsapp',
          destination: ExternalUriDestination(
            Uri.parse('https://api.whatsapp.com/send?phone=201227491145'),
          ),
        ),
        LandingAction(
          id: 'facebook',
          title: 'Facebook',
          iconKey: 'facebook',
          destination: ExternalUriDestination(Uri.parse('https://www.facebook.com/140.tel')),
        ),
      ],
    );
  }
}
