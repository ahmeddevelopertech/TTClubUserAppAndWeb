import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:demandium/feature/location/controller/location_controller.dart';

import '../providers/international_lawyers_providers.dart';
import '../providers/tt_club_landing_providers.dart';
import '../widgets/international_lawyers_marquee.dart';
import '../widgets/landing_bottom_bar.dart';
import '../widgets/landing_header.dart';
import '../widgets/landing_tile.dart';
import '../widgets/nearest_lawyer_fab.dart';

class TtClubLandingPage extends ConsumerStatefulWidget {
  const TtClubLandingPage({super.key});

  @override
  ConsumerState<TtClubLandingPage> createState() => _TtClubLandingPageState();
}

class _TtClubLandingPageState extends ConsumerState<TtClubLandingPage> {
  bool _locationRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestCurrentLocationOnOpen();
    });
  }

  Future<void> _requestCurrentLocationOnOpen() async {
    if (_locationRequested) return;
    _locationRequested = true;

    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final locationController = Get.find<LocationController>();
      final address = await locationController.getCurrentLocation(
        true,
        deviceCurrentLocation: true,
      );
      await locationController.saveUserAddress(address);
    } catch (_) {
      // Keep landing flow smooth even if location fails.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const brand = Color(0xFFD6B36A);

    final asyncCfg = ref.watch(landingConfigProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: asyncCfg.when(
        loading: () => Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: const Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Center(
            child: Text(
              'خطأ أثناء تحميل الصفحة\n$e',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
            ),
          ),
        ),
        data: (cfg) {
          final exec = ref.read(landingActionExecutorProvider);

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            extendBody: true,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: NearestLawyerFab(
              onTap: () => exec.execute(context, cfg.nearestLawyerAction),
            ),
            bottomNavigationBar: LandingBottomBar(
              services: cfg.servicesNavAction,
              about: cfg.aboutNavAction,
              messages: cfg.messagesNavAction,
              profile: cfg.profileNavAction,
            ),
            body: SafeArea(
              top: true,
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: LandingHeader(
                      title: cfg.appTitle,
                      subtitle: cfg.subtitle,
                      logoAssetPath: cfg.logoAssetPath,
                      trailingIcon: _iconFor(cfg.headerTrailingAction.iconKey),
                      onTrailingTap: () =>
                          exec.execute(context, cfg.headerTrailingAction),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
                      child: _JoinCard(
                        onTap: () => exec.execute(context, cfg.joinAction),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'المحامين الدوليين',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: cs.onSurface,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => exec.execute(
                              context,
                              cfg.internationalLawyersAction,
                            ),
                            child: const Text(
                              'عرض الكل',
                              style: TextStyle(
                                color: brand,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final asyncItems = ref.watch(
                          internationalLawyersProvider,
                        );
                        return asyncItems.when(
                          loading: () => const SizedBox(
                            height: 96,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (e, _) => SizedBox(
                            height: 96,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'تعذر تحميل المحامين الدوليين',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    e.toString(),
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: cs.error,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Retry by invalidating the provider so it re-fetches
                                      ref.invalidate(
                                        internationalLawyersProvider,
                                      );
                                    },
                                    child: Text('إعادة المحاولة'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          data: (items) =>
                              InternationalLawyersMarquee(items: items),
                        );
                      },
                    ),
                  ),

                  // Categories (middle section)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
                      child: Text(
                        'الخدمات السريعة',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = cfg.categories[index];
                        return LandingTile(
                          title: item.title,
                          icon: _iconFor(item.iconKey),
                          onTap: () => exec.execute(context, item),
                        );
                      }, childCount: cfg.categories.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.92,
                          ),
                    ),
                  ),

                  // Contact icons row
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 110),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: cfg.contactIcons
                              .map((a) {
                                return IconButton(
                                  onPressed: () => exec.execute(context, a),
                                  icon: Icon(_iconFor(a.iconKey), color: brand),
                                  tooltip: a.title,
                                );
                              })
                              .toList(growable: false),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _iconFor(String key) {
    switch (key) {
      case 'notifications':
        return Icons.notifications_none;
      case 'comp_doc':
        return Icons.description_outlined;
      case 'specialties':
        return Icons.grid_view_outlined;
      case 'taxi':
        return Icons.local_taxi;
      case 'services':
        return Icons.home_filled;
      case 'about':
        return Icons.info_outline;
      case 'messages':
        return Icons.chat_bubble_outline;
      case 'me':
        return Icons.person_outline;
      case 'email':
        return Icons.email;
      case 'website':
        return Icons.language;
      case 'whatsapp':
        return Icons.chat;
      case 'facebook':
        return Icons.facebook;
      case 'near':
        return Icons.near_me;
      case 'join':
        return Icons.how_to_reg;
      case 'intl':
        return Icons.public;
      default:
        return Icons.link;
    }
  }
}

class _JoinCard extends StatelessWidget {
  final VoidCallback onTap;

  const _JoinCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFD6B36A),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.how_to_reg, color: Colors.black),
              SizedBox(width: 10),
              Expanded(
                child: Center(
                  child: Text(
                    'فتح باب الانضمام إلى عضوية النادي\nانضم الآن',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Icon(Icons.chevron_left, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
