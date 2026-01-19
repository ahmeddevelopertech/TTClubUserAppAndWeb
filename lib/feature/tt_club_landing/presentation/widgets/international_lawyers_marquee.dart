import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../domain/entities/international_lawyer_visual.dart';

class InternationalLawyersMarquee extends StatefulWidget {
  final List<InternationalLawyerVisual> items;

  /// px/second
  final double speed;

  const InternationalLawyersMarquee({
    super.key,
    required this.items,
    this.speed = 28,
  });

  @override
  State<InternationalLawyersMarquee> createState() => _InternationalLawyersMarqueeState();
}

class _InternationalLawyersMarqueeState extends State<InternationalLawyersMarquee>
    with SingleTickerProviderStateMixin {
  late final ScrollController _controller;
  late final Ticker _ticker;

  Duration? _lastElapsed;
  bool _userInteracting = false;
  DateTime? _resumeAt;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    _ticker = createTicker((elapsed) {
      if (!mounted || !_controller.hasClients) return;

      final mq = MediaQuery.maybeOf(context);
      final disableAnimations =
          (mq?.disableAnimations ?? false) || (mq?.accessibleNavigation ?? false);
      if (disableAnimations) return;

      if (_userInteracting) return;
      if (_resumeAt != null && DateTime.now().isBefore(_resumeAt!)) return;

      final last = _lastElapsed;
      _lastElapsed = elapsed;
      if (last == null) return;

      final dt = (elapsed - last).inMicroseconds / 1e6;
      final delta = widget.speed * dt;

      final position = _controller.position;
      final max = position.maxScrollExtent;
      if (max <= 0) return;

      // With duplicated list, we loop at half extent.
      final half = max / 2;
      var next = position.pixels + delta;
      if (next >= half) next -= half;
      if (next < 0) next = 0;

      _controller.jumpTo(next);
    });

    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    if (items.isEmpty) return const SizedBox.shrink();

    final duplicated = List<InternationalLawyerVisual>.from(items)..addAll(items);

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n is ScrollStartNotification) {
          _userInteracting = true;
          _resumeAt = null;
        } else if (n is ScrollEndNotification) {
          _userInteracting = false;
          _resumeAt = DateTime.now().add(const Duration(milliseconds: 1200));
        }
        return false;
      },
      child: SizedBox(
        height: 96,
        child: RepaintBoundary(
          child: ListView.separated(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: duplicated.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = duplicated[index];
              return _InternationalLawyerTile(item: item);
            },
          ),
        ),
      ),
    );
  }
}

class _InternationalLawyerTile extends StatelessWidget {
  final InternationalLawyerVisual item;

  const _InternationalLawyerTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const brand = Color(0xFFD6B36A);

    final dpr = MediaQuery.of(context).devicePixelRatio;
    final photoCache = (56 * dpr).round();
    final flagCache = (18 * dpr).round();

    final name = item.name.trim().isEmpty ? 'محامي دولي' : item.name.trim();
    final country = item.countryName.trim().isNotEmpty
        ? item.countryName.trim()
        : (item.countryCode?.trim().isNotEmpty ?? false)
            ? item.countryCode!.trim()
            : '—';

    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: brand, width: 1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            height: 58,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipOval(
                  child: Image.asset(
                    item.photoAsset,
                    fit: BoxFit.cover,
                    cacheWidth: photoCache,
                    filterQuality: FilterQuality.medium,
                    errorBuilder: (_, __, ___) => ColoredBox(
                      color: cs.surfaceVariant,
                      child: const Center(child: Icon(Icons.person, color: brand)),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: _FlagBadge(
                    flagAsset: item.flagAsset,
                    countryCode: item.countryCode,
                    cacheWidth: flagCache,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  country,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if ((item.specialty?.trim().isNotEmpty ?? false)) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.specialty!.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlagBadge extends StatelessWidget {
  final String? flagAsset;
  final String? countryCode;
  final int cacheWidth;

  const _FlagBadge({
    required this.flagAsset,
    required this.countryCode,
    required this.cacheWidth,
  });

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
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: brand, width: 1),
        color: cs.surfaceVariant,
      ),
      clipBehavior: Clip.antiAlias,
      child: resolved == null
          ? const Icon(Icons.flag, size: 12, color: brand)
          : Image.asset(
              resolved,
              fit: BoxFit.cover,
              cacheWidth: cacheWidth,
              filterQuality: FilterQuality.low,
              errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 12, color: brand),
            ),
    );
  }
}
