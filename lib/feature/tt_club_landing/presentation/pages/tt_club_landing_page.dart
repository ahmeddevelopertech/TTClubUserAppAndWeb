import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/landing_config.dart';
import '../providers/tt_club_landing_providers.dart';
import '../widgets/landing_header.dart';
import '../widgets/landing_tile.dart';
import '../../../in_app_browser/presentation/pages/in_app_webview_page.dart';

class TtClubLandingPage extends ConsumerWidget {
  const TtClubLandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncConfig = ref.watch(landingConfigProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: asyncConfig.when(
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
        data: (config) => _LandingBody(config: config),
      ),
    );
  }
}

class _LandingBody extends StatelessWidget {
  final LandingConfig config;
  const _LandingBody({required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFD6B36A),
        foregroundColor: Colors.black,
        onPressed: () => _openLink(context, config.nearestLawyerLink),
        icon: const Icon(Icons.near_me),
        label: const Text('اقرب محامي', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: LandingHeader(
              title: config.appTitle,
              subtitle: config.subtitle,
              hotline: config.hotlineText,
              logoAssetPath: config.logoAssetPath,
            ),
          ),

          // Join card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
              child: _JoinCard(
                onTap: () => _openLink(context, config.joinLink),
              ),
            ),
          ),

          // Main tiles
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 80),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = config.mainTiles[index];
                  final icon = switch (item.title) {
                    'التخصصات' => Icons.category,
                    'المحامين' => Icons.person,
                    _ => Icons.public,
                  };
                  return LandingTile(
                    title: item.title,
                    icon: icon,
                    onTap: () => _openLink(context, item),
                  );
                },
                childCount: config.mainTiles.length,
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
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 110),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: config.footerLinks.map((l) {
                  final icon = switch (l.title) {
                    'Email' => Icons.email,
                    'Website' => Icons.language,
                    'WhatsApp' => Icons.chat,
                    'Facebook' => Icons.facebook,
                    _ => Icons.link,
                  };
                  return IconButton(
                    onPressed: () => _openLink(context, l),
                    icon: Icon(icon, color: const Color(0xFFD6B36A)),
                  );
                }).toList(growable: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openLink(BuildContext context, LandingLink link) async {
    if (link.type == LandingLinkType.inAppWebView) {
      Get.to(() => InAppWebViewPage(title: link.title, url: link.url));
      return;
    }

    final ok = await launchUrl(link.url, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح الرابط')),
      );
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
