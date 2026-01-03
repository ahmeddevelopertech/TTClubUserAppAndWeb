import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/international_lawyer_visual.dart';
import '../providers/international_lawyers_providers.dart';

class InternationalLawyersPage extends ConsumerWidget {
  const InternationalLawyersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(internationalLawyersProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المحامين الدوليين'),
        ),
        body: asyncItems.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => const Center(
            child: Text('تعذر تحميل المحامين الدوليين'),
          ),
          data: (items) => _Body(items: items),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final List<InternationalLawyerVisual> items;
  const _Body({required this.items});

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];
        final photoCache = (56 * dpr).round();
        final cardCache = (280 * dpr).round();

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF151515),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFD6B36A), width: 1),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: ClipOval(
                  child: Image.asset(
                    item.photoAsset,
                    fit: BoxFit.cover,
                    cacheWidth: photoCache,
                    errorBuilder: (_, __, ___) => const ColoredBox(
                      color: Color(0xFF2A2A2A),
                      child: Icon(Icons.person, color: Color(0xFFD6B36A)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item.cardAsset,
                    fit: BoxFit.cover,
                    cacheWidth: cardCache,
                    errorBuilder: (_, __, ___) => const ColoredBox(
                      color: Color(0xFF2A2A2A),
                      child: Center(
                        child: Text('Missing card', style: TextStyle(color: Colors.white70)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
