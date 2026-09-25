import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/item_enums.dart';
import '../models/item_model.dart';
import '../models/loan_model.dart';
import '../models/neighbor_profile_model.dart';
import '../services/auth_service.dart';
import '../services/item_service.dart';
import '../services/user_service.dart';
import '../widgets/item_condition_card.dart';
import '../widgets/return_timer_card.dart';
import '../widgets/saved_money_card.dart';
import '../widgets/trust_score_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTab),
      ),
      body: StreamBuilder<User?>(
        stream: AuthService().authStateChanges,
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = authSnapshot.data;

          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return StreamBuilder<NeighborProfileModel?>(
            stream: UserService().getUserProfileStream(user.uid),
            builder: (context, profileSnapshot) {
              final profile = profileSnapshot.data;

              return StreamBuilder<LoanModel?>(
                stream: ItemService().getActiveLoanStream(user.uid),
                builder: (context, loanSnapshot) {
                  final activeLoan = loanSnapshot.data;

                  final totalSaved = activeLoan?.savedAmount ?? 0.0;
                  final borrowedCount = activeLoan == null ? 0 : 1;

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _ProfileHeader(user: user),
                      const SizedBox(height: 16),

                      // Карточка рейтинга доверия
                      if (profile != null) ...[
                        TrustScoreCard(profile: profile),
                        const SizedBox(height: 16),
                      ],

                      // Паспорт экономии
                      SavedMoneyCard(
                        totalSaved: totalSaved,
                        itemsBorrowedCount: borrowedCount,
                      ),
                      const SizedBox(height: 16),

                      // Активная аренда
                      if (activeLoan != null)
                        FutureBuilder<ItemModel?>(
                          future: ItemService().getItemById(activeLoan.itemId),
                          builder: (context, itemSnapshot) {
                            final item = itemSnapshot.data;
                            final itemName = item?.name ?? '…';
                            final itemDescription = item?.description;

                            final isOverdue = activeLoan.returnDueDate
                                .isBefore(DateTime.now());

                            // Обновляем статус вещи после истечения срока.
                            if (isOverdue &&
                                item != null &&
                                item.status != ItemStatus.overdue) {
                              ItemService().markItemOverdue(activeLoan.itemId);
                            }

                            return Column(
                              children: [
                                ReturnTimerCard(
                                  loan: activeLoan,
                                  itemName: itemName,
                                ),
                                const SizedBox(height: 16),

                                // AI-проверка получает данные вещи из Firestore.
                                ItemConditionCard(
                                  itemName: itemName,
                                  itemDescription: itemDescription,
                                ),
                              ],
                            );
                          },
                        )
                      else
                        const ItemConditionCard(),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final User user;

  const _ProfileHeader({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final title = user.displayName ?? user.email ?? user.uid;
    final photoUrl = user.photoURL;

    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: photoUrl == null
              ? null
              : NetworkImage(photoUrl),
          child: photoUrl == null
              ? Text(
                  title.isEmpty ? '?' : title[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (user.email != null)
                Text(
                  user.email!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
            ],
          ),
        ),

        IconButton(
          tooltip: 'Sign out',
          onPressed: () => AuthService().signOut(),
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
    );
  }
}