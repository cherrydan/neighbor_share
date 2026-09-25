import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/neighbor_profile_model.dart';

class TrustScoreCard extends StatelessWidget {
  final NeighborProfileModel profile;

  const TrustScoreCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final scoreColor = profile.trustScore >= 100
        ? const Color(0xFF2ECC71)
        : profile.trustScore >= 70
            ? Colors.orange
            : Colors.red;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: scoreColor.withValues(alpha: 0.15),
              child: Icon(
                Icons.shield_rounded,
                color: scoreColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.trustScoreTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.trustScorePoints(profile.trustScore),
                    style: TextStyle(
                      color: scoreColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
