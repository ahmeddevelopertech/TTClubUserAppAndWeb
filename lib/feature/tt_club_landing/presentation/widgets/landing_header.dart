import 'package:flutter/material.dart';

class LandingHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String logoAssetPath;

  /// Right-side icon (end side). Example: notifications.
  final IconData trailingIcon;
  final VoidCallback? onTrailingTap;

  const LandingHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.logoAssetPath,
    this.trailingIcon = Icons.notifications_none,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Keep brand accent consistent, while backgrounds/text follow the app theme.
    const brand = Color(0xFFD6B36A);

    final top = isDark ? const Color(0xFF121212) : cs.surface;
    final bottom = isDark ? const Color(0xFF1B1B1B) : cs.surfaceVariant;
    final titleColor = cs.onSurface;
    final subtitleColor = cs.onSurface.withOpacity(0.72);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, bottom],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                logoAssetPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => DecoratedBox(
                  decoration: BoxDecoration(color: cs.surfaceVariant),
                  child: const Center(child: Icon(Icons.shield, color: brand)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onTrailingTap,
            icon: Icon(trailingIcon, color: brand),
            tooltip: 'إشعارات',
          ),
        ],
      ),
    );
  }
}
