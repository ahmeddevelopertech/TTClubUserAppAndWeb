import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/international_lawyer_visual.dart';
import '../providers/international_lawyers_providers.dart';
import 'international_lawyer_details_page.dart';
import '../widgets/lawyer_network_image.dart';

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
          error: (e, _) => Center(
            child: Text('تعذر تحميل البيانات\n$e', textAlign: TextAlign.center),
          ),
          data: (items) => ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _LawyerRow(item: items[index]),
          ),
        ),
      ),
    );
  }
}

class _LawyerRow extends StatelessWidget {
  final InternationalLawyerVisual item;

  const _LawyerRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final address = item.address?.trim() ?? '';
    final phone = item.phone?.trim() ?? '';
    final name = item.name.trim().isEmpty ? 'محامي دولي' : item.name.trim();
    final country = item.countryName.trim().isNotEmpty
        ? item.countryName.trim()
        : (item.countryCode?.trim().isNotEmpty ?? false)
            ? item.countryCode!.trim()
            : '—';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => InternationalLawyerDetailsPage(lawyer: item),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD6B36A), width: 1),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipOval(
                    child: LawyerNetworkImage(
                      path: item.photoAsset,
                      fit: BoxFit.cover,
                      fallback: ColoredBox(
                        color: theme.colorScheme.surfaceVariant,
                        child: const Center(
                          child: Icon(Icons.person, color: Color(0xFFD6B36A)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: _FlagBadge(flagAsset: item.flagAsset, countryCode: item.countryCode),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    country,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  if ((item.specialty?.trim().isNotEmpty ?? false)) ...[
                    const SizedBox(height: 6),
                    Text(
                      item.specialty!.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFFD6B36A), fontWeight: FontWeight.w700),
                    ),
                  ],
                  if (address.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  if (phone.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      phone,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlagBadge extends StatelessWidget {
  final String? flagAsset;
  final String? countryCode;

  const _FlagBadge({required this.flagAsset, required this.countryCode});

  bool _isRemote(String path) {
    final p = path.trim().toLowerCase();
    return p.startsWith('http://') || p.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const brand = Color(0xFFD6B36A);

    final resolved = flagAsset?.trim().isNotEmpty ?? false
        ? flagAsset!.trim()
        : (countryCode?.trim().isNotEmpty ?? false)
            ? 'assets/images/flags/${countryCode!.trim().toLowerCase()}.png'
            : null;

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: brand, width: 1),
        color: cs.surfaceVariant,
      ),
      clipBehavior: Clip.antiAlias,
      child: resolved == null
          ? const Icon(Icons.flag, size: 13, color: brand)
          : _isRemote(resolved)
              ? Image.network(
                  resolved,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 13, color: brand),
                )
              : Image.asset(
                  resolved,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 13, color: brand),
                ),
    );
  }
}
