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
        height: 86,
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
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final photoCache = (56 * dpr).round();
    final cardCache = (170 * dpr).round();

    return Container(
      width: 250,
      padding: const EdgeInsets.all(8),
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
                filterQuality: FilterQuality.medium,
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
                filterQuality: FilterQuality.medium,
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
  }
}
