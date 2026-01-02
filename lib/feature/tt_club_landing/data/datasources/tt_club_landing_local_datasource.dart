import '../../domain/entities/landing_config.dart';

class TtClubLandingLocalDataSource {
  const TtClubLandingLocalDataSource();

  Future<LandingConfig> fetch() async {
    return LandingConfig(
      appTitle: 'TT CLUB',
      subtitle: 'نادي الحماية الدولي للأنشطة القانونية',
      hotlineText: '1088.tel',

      // ✅ غيّر ده لمسار اللوجو الحقيقي عندك
      logoAssetPath: 'assets/images/logo.png',

      joinLink:  LandingLink(
        title: 'انضم الآن',
        url: Uri.parse('https://www.1088.tel/w/Join'),
        type: LandingLinkType.inAppWebView,
      ),
      nearestLawyerLink:  LandingLink(
        title: 'اقرب محامي',
        url: Uri.parse('https://www.1088.tel/w/near-by-Ar'),
        type: LandingLinkType.inAppWebView,
      ),

      mainTiles:  [
        LandingLink(
          title: 'التخصصات',
          url: Uri.parse('https://www.1088.tel/w/Specialty'),
          type: LandingLinkType.inAppWebView,
        ),
        LandingLink(
          title: 'المحامين',
          url: Uri.parse('https://ttclub.org/%D8%A7%D9%84%D9%85%D8%AD%D8%A7%D9%85%D9%8A%D9%86/'),
          type: LandingLinkType.inAppWebView,
        ),
        LandingLink(
          title: 'المحامين الدوليين',
          url: Uri.parse('https://ttclub.org/%D8%A7%D9%84%D9%85%D8%AD%D8%A7%D9%85%D9%8A%D9%86-%D8%A7%D9%84%D8%AF%D9%88%D9%84%D9%8A%D9%8A%D9%86/'),
          type: LandingLinkType.inAppWebView,
        ),
      ],
      footerLinks:  [
        LandingLink(
          title: 'Email',
          url: Uri.parse('mailto:info@ttclub.org'),
          type: LandingLinkType.external,
        ),
        LandingLink(
          title: 'Website',
          url: Uri.parse('https://ttclub.org/'),
          type: LandingLinkType.inAppWebView,
        ),
        LandingLink(
          title: 'WhatsApp',
          url: Uri.parse('https://api.whatsapp.com/send?phone=201227491145'),
          type: LandingLinkType.external,
        ),
        LandingLink(
          title: 'Facebook',
          url: Uri.parse('https://www.facebook.com/140.tel'),
          type: LandingLinkType.external,
        ),
      ],
    );
  }
}
