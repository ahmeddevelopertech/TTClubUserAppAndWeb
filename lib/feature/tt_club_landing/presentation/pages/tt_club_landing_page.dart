import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/landing_action.dart';
import '../providers/international_lawyers_providers.dart';
import '../providers/tt_club_landing_providers.dart';
import '../widgets/international_lawyers_marquee.dart';
import '../widgets/landing_header.dart';
import '../widgets/landing_tile.dart';

class TtClubLandingPage extends ConsumerWidget {
  const TtClubLandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCfg = ref.watch(landingConfigProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: asyncCfg.when(
        loading: () => const Scaffold(
          backgroundColor: Color(0xFF0F0F0F),
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Scaffold(
          backgroundColor: const Color(0xFF0F0F0F),
          body: Center(
            child: Text(
              'خطأ أثناء تحميل الصفحة\n$e',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        data: (cfg) => Scaffold(
          backgroundColor: const Color(0xFF0F0F0F),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: const Color(0xFFD6B36A),
            foregroundColor: Colors.black,
            onPressed: () => _handleAction(ref, cfg.nearestLawyerAction, context),
            icon: const Icon(Icons.near_me),
            label: const Text('اقرب محامي', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
          body: CustomScrollView(
            slivers: [
              // ✅ Header تحت شريط الحالة
              SliverSafeArea(
                top: true,
                bottom: false,
                sliver: SliverToBoxAdapter(
                  child: LandingHeader(
                    title: cfg.appTitle,
                    subtitle: cfg.subtitle,
                    hotline: cfg.hotlineText,
                    logoAssetPath: cfg.logoAssetPath,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
                  child: _JoinCard(
                    onTap: () => _handleAction(ref, cfg.joinAction, context),
                  ),
                ),
              ),

              // International lawyers marquee
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                  child: const Text(
                    'المحامين الدوليين',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, ref, _) {
                    final asyncItems = ref.watch(internationalLawyersProvider);
                    return asyncItems.when(
                      loading: () => const SizedBox(
                        height: 92,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => SizedBox(
                        height: 92,
                        child: Center(
                          child: Text(
                            'تعذر تحميل المحامين الدوليين: $e',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                      data: (items) => InternationalLawyersMarquee(items: items),
                    );
                  },
                ),
              ),

              // Main tiles
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 90),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final item = cfg.mainTiles[index];
                      return LandingTile(
                        title: item.title,
                        icon: _iconFor(item.iconKey),
                        onTap: () => _handleAction(ref, item, context),
                      );
                    },
                    childCount: cfg.mainTiles.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                ),
              ),

              // Footer icons
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 130),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: cfg.footerIcons.map((a) {
                      return IconButton(
                        onPressed: () => _handleAction(ref, a, context),
                        icon: Icon(_iconFor(a.iconKey), color: const Color(0xFFD6B36A)),
                      );
                    }).toList(growable: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAction(WidgetRef ref, LandingAction action, BuildContext context) async {
    final nav = ref.read(landingNavigatorProvider);
    try {
      await nav.go(action.destination);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تنفيذ العملية')),
      );
    }
  }

  IconData _iconFor(String key) {
    if (key == 'specialties') return Icons.category;
    if (key == 'lawyers') return Icons.person;
    if (key == 'intl') return Icons.public;
    if (key == 'email') return Icons.email;
    if (key == 'website') return Icons.language;
    if (key == 'whatsapp') return Icons.chat;
    if (key == 'facebook') return Icons.facebook;
    if (key == 'near') return Icons.near_me;
    if (key == 'join') return Icons.how_to_reg;
    return Icons.link;
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
                child: Text(
                  'فتح باب الانضمام إلى عضوية النادي\nانضم الآن',
                  style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
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
