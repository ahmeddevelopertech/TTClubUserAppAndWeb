import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:demandium/helper/route_helper.dart';
import 'package:demandium/feature/in_app_browser/presentation/pages/simple_webview_page.dart';

import '../pages/compensation_document_page.dart';

import '../../data/datasources/tt_club_landing_local_datasource.dart';
import '../../data/repositories/tt_club_landing_repository_impl.dart';
import '../../domain/entities/landing_action.dart';
import '../../domain/entities/landing_config.dart';
import '../../domain/repositories/tt_club_landing_repository.dart';
import '../../domain/usecases/get_landing_config_usecase.dart';

final _landingDataSourceProvider = Provider<TtClubLandingLocalDataSource>((ref) {
  return const TtClubLandingLocalDataSource();
});

final _landingRepositoryProvider = Provider<TtClubLandingRepository>((ref) {
  return TtClubLandingRepositoryImpl(ref.watch(_landingDataSourceProvider));
});

final _landingUseCaseProvider = Provider<GetLandingConfigUseCase>((ref) {
  return GetLandingConfigUseCase(ref.watch(_landingRepositoryProvider));
});

final landingConfigProvider = FutureProvider<LandingConfig>((ref) async {
  return ref.watch(_landingUseCaseProvider).call();
});

abstract class LandingNavigator {
  Future<void> go(LandingDestination destination);
}

final landingNavigatorProvider = Provider<LandingNavigator>((ref) {
  return const _GetxLandingNavigator();
});

class _GetxLandingNavigator implements LandingNavigator {
  const _GetxLandingNavigator();

  @override
  Future<void> go(LandingDestination destination) async {
    switch (destination) {
      case AppRouteDestination():
        final route = _mapRoute(destination.key, destination.params);
        Get.toNamed(route);
        return;

      case HtmlDestination():
        // Special-case: show native PDF viewer (Arabic/English) instead of HTML web page.
        if (destination.pageKey == 'compensation_document') {
          Get.to(() => const CompensationDocumentPage());
          return;
        }
        final title = destination.title ?? '';
        final route = RouteHelper.getHtmlRoute(destination.pageKey, title: title);
        Get.toNamed(route);
        return;

      case InAppWebViewDestination():
        if (kIsWeb) {
          final ok = await launchUrl(destination.uri, mode: LaunchMode.platformDefault);
          if (!ok) {
            throw  PlatformException(code: 'LAUNCH_FAILED', message: 'Failed to launch url');
          }
          return;
        }
        Get.to(() => SimpleWebViewPage(title: destination.title, url: destination.uri));
        return;

      case ExternalUriDestination():
        final ok = await launchUrl(destination.uri, mode: LaunchMode.externalApplication);
        if (!ok) {
          throw  PlatformException(code: 'LAUNCH_FAILED', message: 'Failed to launch url');
        }
        return;

      case TaxiSheetDestination():
        // UI-only destination: handled by LandingActionExecutor.
        return;
    }
  }

  String _mapRoute(AppRouteKey key, Map<String, String> params) {
    switch (key) {
      case AppRouteKey.main:
        return RouteHelper.getMainRoute(params['page'] ?? 'home');

      case AppRouteKey.signUp:
        return RouteHelper.getSignUpRoute();

      case AppRouteKey.offers:
        return RouteHelper.getOffersRoute();

      case AppRouteKey.chatInbox:
        return RouteHelper.getInboxScreenRoute();

      case AppRouteKey.profile:
        return RouteHelper.getProfileRoute();

      case AppRouteKey.notifications:
        final fromNotification = (params['fromNotification'] ?? 'false') == 'true';
        final reservationId = int.tryParse(params['reservationID'] ?? '0') ?? 0;
        return RouteHelper.getNotificationRoute();

      case AppRouteKey.allCategories:
        return RouteHelper.getAllCategoriesScreen();
      case AppRouteKey.allProviders:
        return RouteHelper.getAllProviderRoute();
      case AppRouteKey.nearByProviders:
        final tabIndex = int.tryParse(params['tabIndex'] ?? '0') ?? 0;
        return RouteHelper.getNearByProviderScreen(tabIndex: tabIndex);
      case AppRouteKey.internationalLawyers:
        return RouteHelper.getInternationalLawyersRoute();
    }
  }
}

abstract class LandingActionExecutor {
  Future<void> execute(BuildContext context, LandingAction action);
}

final landingActionExecutorProvider = Provider<LandingActionExecutor>((ref) {
  return _LandingActionExecutor(ref.watch(landingNavigatorProvider));
});

class _LandingActionExecutor implements LandingActionExecutor {
  final LandingNavigator _navigator;

  _LandingActionExecutor(this._navigator);

  @override
  Future<void> execute(BuildContext context, LandingAction action) async {
    try {
      if (action.id == 'join') {
        await _showJoinSheet(context);
        return;
      }
      if (action.destination is TaxiSheetDestination) {
        await _showTaxiSheet(context);
        return;
      }
      await _navigator.go(action.destination);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح الصفحة/الرابط')),
      );
    }
  }

  Future<void> _showTaxiSheet(BuildContext context) async {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const brand = Color(0xFFD6B36A);

    final selected = await showModalBottomSheet<_TaxiOption>(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'اختر تطبيق التاكسي',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ..._TaxiOption.values.map((o) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.local_taxi, color: brand),
                    title: Text(
                      o.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_left, color: cs.onSurfaceVariant),
                    onTap: () => Navigator.of(context).pop(o),
                  );
                }),
                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null) return;
    await _launchTaxi(context, selected);
  }

  Future<void> _launchTaxi(BuildContext context, _TaxiOption option) async {
    if (kIsWeb) {
      // On web, just open fallback URLs.
      final ok = await launchUrl(option.fallbackUrl, mode: LaunchMode.platformDefault);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر فتح الرابط')));
      }
      return;
    }

    // Try deep link first.
    if (await canLaunchUrl(option.deepLink)) {
      final ok = await launchUrl(option.deepLink, mode: LaunchMode.externalApplication);
      if (ok) return;
    }

    final ok = await launchUrl(option.fallbackUrl, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر فتح متجر التطبيقات')));
    }
  }

  Future<void> _showJoinSheet(BuildContext context) async {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const brand = Color(0xFFD6B36A);

    final selected = await showModalBottomSheet<_JoinOption>(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'اختر نوع الانضمام',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ..._JoinOption.values.map((o) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(o.icon, color: brand),
                    title: Text(
                      o.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_left, color: cs.onSurfaceVariant),
                    onTap: () => Navigator.of(context).pop(o),
                  );
                }),
                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null) return;

    // Keep the existing SignUp flow, only passing an argument for the selected join type.
    Get.toNamed(
      RouteHelper.getSignUpRoute(),
      arguments: <String, dynamic>{
        'join_type': selected.joinTypeKey,
        'join_title': selected.label,
      },
    );
  }
}

enum _JoinOption {
  lawyers,
  companies,
  individualsMembership,
  clubDelegate,
  legalSponsorship;

  String get label {
    return switch (this) {
      _JoinOption.lawyers => 'انضمام محامين',
      _JoinOption.companies => 'انضمام شركات',
      _JoinOption.individualsMembership => 'انضمام افراد العضويه',
      _JoinOption.clubDelegate => 'عضو منتدب للنادي',
      _JoinOption.legalSponsorship => 'الرعايه القانونيه',
    };
  }

  IconData get icon {
    return switch (this) {
      _JoinOption.lawyers => Icons.gavel,
      _JoinOption.companies => Icons.business,
      _JoinOption.individualsMembership => Icons.person_add,
      _JoinOption.clubDelegate => Icons.badge,
      _JoinOption.legalSponsorship => Icons.security,
    };
  }

  String get joinTypeKey {
    // Stable keys for backend/UI mapping.
    return switch (this) {
      _JoinOption.lawyers => 'lawyers',
      _JoinOption.companies => 'companies',
      _JoinOption.individualsMembership => 'individuals_membership',
      _JoinOption.clubDelegate => 'club_delegate',
      _JoinOption.legalSponsorship => 'legal_sponsorship',
    };
  }
}

enum _TaxiOption {
  didi,
  inDrive,
  uber;

  String get label {
    return switch (this) {
      _TaxiOption.didi => 'DiDi',
      _TaxiOption.inDrive => 'inDrive',
      _TaxiOption.uber => 'Uber',
    };
  }

  Uri get deepLink {
    return switch (this) {
      _TaxiOption.didi => Uri.parse('didi://'),
      _TaxiOption.inDrive => Uri.parse('indrive://'),
      _TaxiOption.uber => Uri.parse('uber://'),
    };
  }

  Uri get fallbackUrl {
    // Using store listings as the most reliable fallback.
    // Android links work on iOS too in browser; but we prefer iOS App Store.
    if (GetPlatform.isIOS) {
      return switch (this) {
        _TaxiOption.didi => Uri.parse('https://apps.apple.com/us/app/didi-rider-affordable-rides/id1362398401'),
        _TaxiOption.inDrive => Uri.parse('https://apps.apple.com/us/app/indrive-save-on-city-rides/id780125801'),
        _TaxiOption.uber => Uri.parse('https://apps.apple.com/me/app/uber-request-a-ride/id368677368'),
      };
    }
    return switch (this) {
      _TaxiOption.didi => Uri.parse('https://play.google.com/store/apps/details?id=com.didiglobal.passenger'),
      _TaxiOption.inDrive => Uri.parse('https://play.google.com/store/apps/details?id=sinet.startup.inDriver'),
      _TaxiOption.uber => Uri.parse('https://play.google.com/store/apps/details?id=com.ubercab'),
    };
  }
}
