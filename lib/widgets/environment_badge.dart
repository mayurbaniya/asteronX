import 'package:asteron_x/config/environment.dart';
import 'package:flutter/material.dart';

/// Small "TEST" / "UAT" pill shown in non-production builds. Renders as
/// `SizedBox.shrink()` in production so the badge never ships to end users.
class EnvironmentBadge extends StatelessWidget {
  const EnvironmentBadge({super.key});

  @override
  Widget build(BuildContext context) {
    if (EnvironmentConfig.isProduction) {
      return const SizedBox.shrink();
    }

    final accent = _badgeColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            EnvironmentConfig.environmentName,
            style: TextStyle(
              color: accent,
              fontFamily: 'montserrat',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  Color _badgeColor() {
    switch (EnvironmentConfig.current) {
      case AppEnvironment.test:
        return const Color(0xFFB45309); // warm amber for TEST
      case AppEnvironment.uat:
        return const Color(0xFF1D4ED8); // info blue for UAT
      case AppEnvironment.production:
        return const Color(0xFF15803D); // never shown
    }
  }
}
