import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neighbor_share/services/ai_inspection_service.dart';
import '../l10n/app_localizations.dart';

class ItemConditionCard extends StatefulWidget {
  final String? photoBeforeUrl;
  final String? photoAfterUrl;
  final String? itemName;        // 🟢 Имя вещи
  final String? itemDescription; // 🟢 Описание вещи

  const ItemConditionCard({
    super.key,
    this.photoBeforeUrl,
    this.photoAfterUrl,
    this.itemName,
    this.itemDescription,
  });

  @override
  State<ItemConditionCard> createState() => _ItemConditionCardState();
}


class _ItemConditionCardState extends State<ItemConditionCard> {
  Uint8List? _beforeBytes;
  Uint8List? _afterBytes;
  

  bool _isAnalyzing = false;
  String? _aiVerdict;

  Future<void> _pickImage(bool isBefore) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
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
    // Внутри build перед return или прямо перед блоком плашки:
    final bool isSuccess = _aiVerdict != null && _aiVerdict!.startsWith('✅');
    final Color verdictColor = isSuccess ? Colors.green : Colors.red.shade700;
    final Color verdictBgColor = isSuccess ? Colors.green.shade50 : Colors.red.shade50;
    final Color verdictBorderColor = isSuccess ? Colors.green.shade300 : Colors.red.shade300;
    final IconData verdictIcon = isSuccess ? Icons.check_circle_rounded : Icons.warning_amber_rounded;

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
                    imageBytes: _beforeBytes,
                    onTap: () => _pickImage(true),
                  ),
                ),
                const SizedBox(width: 12),

                // 2. Фото ПОСЛЕ
                Expanded(
                  child: _buildPhotoSlot(
                    label: l10n.photoAfterLabel,
                    icon: Icons.assignment_turned_in_outlined,
                    imageBytes: _afterBytes,
                    onTap: () => _pickImage(false),
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
                        // Проверяем, выбраны ли оба фото:
                        if (_beforeBytes == null || _afterBytes == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.addBothPhotosWarning)),
                          );
                          return;
                        }

                        setState(() {
                          _isAnalyzing = true;
                          _aiVerdict = null;
                        });

                        final languageCode = Localizations.localeOf(context).languageCode;

                        final verdict = await AiInspectionService.inspectItemCondition(
                        photoBeforeBytes: _beforeBytes!,
                        photoAfterBytes: _afterBytes!,
                        languageCode: languageCode,
                        itemName: widget.itemName,               // 🟢 Передаем ИИ!
                        itemDescription: widget.itemDescription, // 🟢 Передаем ИИ!
                      );


                        if (!mounted) return;

                        setState(() {
                          _isAnalyzing = false;
                          _aiVerdict = verdict;
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
      color: verdictBgColor,
      borderRadius: BorderRadius.circular(10),
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

  // Вспомогательный слот для фото
  Widget _buildPhotoSlot({
  required String label,
  required IconData icon,
  required Uint8List? imageBytes,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageBytes != null
            ? Image.memory(imageBytes, fit: BoxFit.cover, width: double.infinity)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 36, color: Colors.grey.shade600),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}

}