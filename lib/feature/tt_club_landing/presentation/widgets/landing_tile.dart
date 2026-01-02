import 'package:flutter/material.dart';

class LandingTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const LandingTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF151515),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 34, color: const Color(0xFFD6B36A)),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
