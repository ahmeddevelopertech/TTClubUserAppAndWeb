import 'package:flutter/material.dart';

/// Custom centered floating button (pill / Stadium shape) to match the sketch
/// and avoid the notch mismatch.
///
/// Important: keep this widget lightweight, no business logic.
class NearestLawyerFab extends StatelessWidget {
  final VoidCallback onTap;

  const NearestLawyerFab({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const brand = Color(0xFFD6B36A);

    return SizedBox(
      height: 56,
      width: 190,
      child: Material(
        color: brand,
        shape: const StadiumBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.near_me, color: Colors.black, size: 20),
                const SizedBox(width: 10),
                Text(
                  'أقرب محامي',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
