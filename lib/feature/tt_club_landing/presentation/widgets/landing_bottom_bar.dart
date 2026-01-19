import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/landing_action.dart';
import '../providers/tt_club_landing_providers.dart';

class LandingBottomBar extends ConsumerWidget {
  final LandingAction services;
  final LandingAction about;
  final LandingAction messages;
  final LandingAction profile;

  const LandingBottomBar({
    super.key,
    required this.services,
    required this.about,
    required this.messages,
    required this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exec = ref.read(landingActionExecutorProvider);
    final theme = Theme.of(context);

    return BottomAppBar(

      elevation: 0,
      // NOTE: Our "Nearest Lawyer" button is a Stadium / pill shape.
      // Using AutomaticNotchedShape avoids the circular notch glitch.
      shape: const AutomaticNotchedShape(
        RoundedRectangleBorder(),
        StadiumBorder(),
      ),
      notchMargin: 10,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 72,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Item(
              icon: Icons.home_filled,
              label: 'اكثر',
              onTap: () => exec.execute(context, services),
            ),
            _Item(
              icon: Icons.info_outline,
              label: 'من نحن',
              onTap: () => exec.execute(context, about),
            ),
            // Keep enough space for the centered pill button.
            const SizedBox(width: 200),
            _Item(
              icon: Icons.chat_bubble_outline,
              label: 'الرسائل',
              onTap: () => exec.execute(context, messages),
            ),
            _Item(
              icon: Icons.person_outline,
              label: 'حسابي',
              onTap: () => exec.execute(context, profile),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _Item({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const brand = Color(0xFFD6B36A);

    return Expanded(
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: brand),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurface.withOpacity(0.72),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
