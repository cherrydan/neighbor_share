import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/app_localizations.dart';
import '../services/ai_inspection_service.dart';
import '../screens/paywall_screen.dart'; // 🟢 Импорт Пейволла

class ItemConditionCard extends StatefulWidget {
  final String? photoBeforeUrl;
  final String? photoAfterUrl;
  final String? itemName;
  final String? itemDescription;
  final bool isPro; // 🟢 Статус подписки юзера

  const ItemConditionCard({
    super.key,
    this.photoBeforeUrl,
    this.photoAfterUrl,
    this.itemName,
    this.itemDescription,
    this.isPro = false, // По умолчанию false
  });

  @override
  State<ItemConditionCard> createState() => _ItemConditionCardState();
}

class _ItemConditionCardState extends State<ItemConditionCard> {
  Uint8List? _beforeBytes;
  Uint8List? _afterBytes;
  String? _aiVerdict;
  bool _isLoading = false;

  Future<void> _pickImage(bool isBefore) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        if (isBefore) {
          _beforeBytes = bytes;
        } else {
          _afterBytes = bytes;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Логика динамической окраски плашки вердикта
    final bool isSuccess = _aiVerdict != null && _aiVerdict!.startsWith('✅');
    final Color verdictColor = isSuccess ? Colors.green.shade700 : Colors.red.shade700;
    final Color verdictBgColor = isSuccess ? Colors.green.shade50 : Colors.red.shade50;
    final Color verdictBorderColor = isSuccess ? Colors.green.shade300 : Colors.red.shade300;
    final IconData verdictIcon = isSuccess ? Icons.check_circle_rounded : Icons.warning_amber_rounded;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.verified_user_outlined, color: Color(0xFF3F51B5)),
                const SizedBox(width: 8),
                Text(
                  l10n.conditionPassportTitle,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (widget.isPro) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.stars_rounded, color: Colors.amber, size: 20),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildPhotoSlot(true, _beforeBytes, l10n.photoBeforeLabel),
                const SizedBox(width: 12),
                _buildPhotoSlot(false, _afterBytes, l10n.photoAfterLabel),
              ],
            ),
            const SizedBox(height: 16),
            
            // Кнопка запуска экспертизы с проверкой PRO
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: (_beforeBytes == null || _afterBytes == null || _isLoading)
                    ? null
                    : () async {
                        // 🟢 ПРОВЕРКА ПОДПИСКИ ПЕРЕД ЗАПУСКОМ ИИ:
                        if (!widget.isPro) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaywallScreen()),
                          );
                          return;
                        }

                        // Если юзер PRO — запускаем оригинальный код анализа
                        setState(() {
                          _isLoading = true;
                          _aiVerdict = null;
                        });

                        try {
                          final languageCode = Localizations.localeOf(context).languageCode;
                          final verdict = await AiInspectionService.inspectItemCondition(
                            photoBeforeBytes: _beforeBytes!,
                            photoAfterBytes: _afterBytes!,
                            languageCode: languageCode,
                            itemName: widget.itemName,
                            itemDescription: widget.itemDescription,
                          );
                          setState(() => _aiVerdict = verdict);
                        } catch (e) {
                          setState(() => _aiVerdict = 'Error: $e');
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      },
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.auto_awesome_rounded),
                label: Text(l10n.aiInspectButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51B5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            // Вывод вердикта ИИ с динамическим стилем
            if (_aiVerdict != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: verdictBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: verdictBorderColor),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(verdictIcon, color: verdictColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _aiVerdict!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: verdictColor,
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

  Widget _buildPhotoSlot(bool isBefore, Uint8List? bytes, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _pickImage(isBefore),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: bytes != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.memory(bytes, fit: BoxFit.cover),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(isBefore ? Icons.camera_alt_outlined : Icons.assignment_turned_in_outlined,
                        color: Colors.grey.shade600),
                    const SizedBox(height: 4),
                    Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  ],
                ),
        ),
      ),
    );
  }
}