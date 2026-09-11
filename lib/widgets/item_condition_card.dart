import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class ItemConditionCard extends StatefulWidget {
  final String? photoBeforeUrl;
  final String? photoAfterUrl;

  const ItemConditionCard({
    super.key,
    this.photoBeforeUrl,
    this.photoAfterUrl,
  });

  @override
  State<ItemConditionCard> createState() => _ItemConditionCardState();
}

class _ItemConditionCardState extends State<ItemConditionCard> {
  bool _isAnalyzing = false;
  String? _aiVerdict;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Row(
              children: [
                const Icon(Icons.verified_user_rounded, color: Colors.indigo, size: 24),
                const SizedBox(width: 8),
                Text(
                  l10n.conditionPassportTitle,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Две фото-плашки рядом
            Row(
              children: [
                // 1. Фото ДО
                Expanded(
                  child: _buildPhotoSlot(
                    label: l10n.photoBeforeLabel,
                    icon: Icons.camera_alt_outlined,
                    imageUrl: widget.photoBeforeUrl,
                  ),
                ),
                const SizedBox(width: 12),

                // 2. Фото ПОСЛЕ
                Expanded(
                  child: _buildPhotoSlot(
                    label: l10n.photoAfterLabel,
                    icon: Icons.assignment_turned_in_outlined,
                    imageUrl: widget.photoAfterUrl,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Кнопка AI Анализа
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isAnalyzing
                    ? null
                    : () async {
                        setState(() {
                          _isAnalyzing = true;
                          _aiVerdict = null;
                        });

                        // 🟢 Имитируем запрос к бесплатному ChatGPT AI (2 секунды)
                        await Future.delayed(const Duration(seconds: 2));

                        if (!mounted) return;
                        setState(() {
                          _isAnalyzing = false;
                          _aiVerdict = l10n.aiVerdictSuccess;
                        });
                      },
                icon: _isAnalyzing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.auto_awesome_rounded),
                label: Text(l10n.aiInspectButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            // Вывод вердикта AI
            if (_aiVerdict != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _aiVerdict!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Вспомогательный слот для фото
  Widget _buildPhotoSlot({required String label, required IconData icon, String? imageUrl}) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: Colors.grey.shade600),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}