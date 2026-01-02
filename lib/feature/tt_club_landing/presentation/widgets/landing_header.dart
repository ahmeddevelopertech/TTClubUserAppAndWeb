import 'package:flutter/material.dart';

class LandingHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String hotline;
  final String logoAssetPath;

  const LandingHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.hotline,
    required this.logoAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF121212), Color(0xFF1B1B1B)],
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 68,
            height: 68,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                logoAssetPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: Color(0xFF222222),
                  child: Center(child: Icon(Icons.shield, color: Color(0xFFD6B36A))),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    )),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18, color: Color(0xFFD6B36A)),
                    const SizedBox(width: 6),
                    Text(hotline,
                        style: const TextStyle(
                          color: Color(0xFFD6B36A),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
