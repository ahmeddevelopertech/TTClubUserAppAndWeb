import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:demandium/helper/route_helper.dart';
import 'package:demandium/feature/in_app_browser/presentation/pages/simple_webview_page.dart';

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
    }
  }

  String _mapRoute(AppRouteKey key, Map<String, String> params) {
    switch (key) {
      case AppRouteKey.signUp:
        return RouteHelper.getSignUpRoute();
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
      await _navigator.go(action.destination);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح الصفحة/الرابط')),
      );
    }
  }
}
