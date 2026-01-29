import 'package:demandium/utils/core_export.dart';

import '../../domain/entities/landing_action.dart';
import '../../domain/entities/landing_config.dart';

class TtClubLandingLocalDataSource {
  const TtClubLandingLocalDataSource();

  Future<LandingConfig> fetch() async {
    return LandingConfig(
      appTitle: 'TT CLUB',
      subtitle: 'نادي الحماية الدولي \n للأنشطة القانونية',
      logoAssetPath: Images.logo,

      headerTrailingAction: const LandingAction(
        id: 'notifications',
        title: 'الإشعارات',
        iconKey: 'notifications',
        destination: AppRouteDestination(
          key: AppRouteKey.notifications,
          params: {
            'fromNotification': 'false',
            'reservationID': '0',
          },
        ),
      ),

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

      internationalLawyersAction: const LandingAction(
        id: 'intl',
        title: 'المحامين الدوليين',
        iconKey: 'intl',
        destination: AppRouteDestination(key: AppRouteKey.internationalLawyers),
      ),

      categories: const [
        LandingAction(
          id: 'comp_doc',
          title: 'وثيقة التعويض',
          iconKey: 'comp_doc',
          destination: HtmlDestination(
            pageKey: 'compensation_document',
            title: 'وثيقة التعويض',
          ),
        ),
        LandingAction(
          id: 'specialties',
          title: 'التخصصات',
          iconKey: 'specialties',
          // NOTE: this should navigate to the existing "Specialties / Categories" feature.
          // If your project uses a different key, change it here only.
          destination: AppRouteDestination(key: AppRouteKey.allCategories),
        ),
        LandingAction(
          id: 'taxi',
          title: 'تاكسي',
          iconKey: 'taxi',
          destination: TaxiSheetDestination(),
        ),
      ],

      contactIcons:  [
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

      servicesNavAction: const LandingAction(
        id: 'services',
        title: 'الخدمات',
        iconKey: 'services',
        destination: AppRouteDestination(
          key: AppRouteKey.main,
          params: {'page': 'home'},
        ),
      ),
      aboutNavAction:  LandingAction(
        id: 'about',
        title: 'من نحن',
        iconKey: 'about',
        destination: InAppWebViewDestination(
          title: 'من نحن',
          uri: Uri.parse('https://1088.tel'),
        ),
      ),
      messagesNavAction: const LandingAction(
        id: 'messages',
        title: 'الرسائل',
        iconKey: 'messages',
        destination: AppRouteDestination(key: AppRouteKey.chatInbox),
      ),
      profileNavAction: const LandingAction(
        id: 'me',
        title: 'أنا',
        iconKey: 'me',
        destination: AppRouteDestination(key: AppRouteKey.profile),
      ),
    );
  }
}
