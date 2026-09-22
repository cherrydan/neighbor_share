import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AiInspectionService {
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

    static Future<String> inspectItemCondition({
    required Uint8List photoBeforeBytes,
    required Uint8List photoAfterBytes,
    required String languageCode,
    String? itemName,        // 🟢 Имя вещи из базы
    String? itemDescription, // 🟢 Описание вещи из базы
  }) async {
   final modelName = ['gem', 'ini-', '3.6-', 'flash'].join();


  final url = Uri.parse(
  'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$_apiKey',
);



    final itemContext = (itemName != null && itemName.isNotEmpty)
        ? 'The item being inspected is: "$itemName"${itemDescription != null && itemDescription.isNotEmpty ? ' with description: "$itemDescription"' : ''}.'
        : 'An item is being inspected.';

    final prompt = '''
        You are an expert inspecting borrowed items for damages and fraud prevention.
        $itemContext

        Instructions:
        1. Verification: First, check if BOTH images actually show the specified item. If either image depicts an entirely unrelated object (e.g., food, animals, different tools, or a totally different item), warn immediately about the mismatch.
        2. Condition comparison: If the images do show the specified item, compare Image 1 (Before loan) and Image 2 (After return). Identify any new scratches, cracks, dirt, or damages.
        3. Length: Provide a concise 2-sentence verdict.
        4. Language: Respond STRICTLY in language: $languageCode.
        5. Success: If the item matches AND is in good condition, begin with "✅".
        ''';

    // ... дальше всё остаётся как было (body, http.post и т.д.) ...


    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt},
            {
              "inline_data": {
                "mime_type": "image/jpeg",
                "data": base64Encode(photoBeforeBytes),
              }
            },
            {
              "inline_data": {
                "mime_type": "image/jpeg",
                "data": base64Encode(photoAfterBytes),
              }
            }
          ]
        }
      ]
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final parts = candidates[0]['content']['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            return parts[0]['text'] as String;
          }
        }
        return 'Не удалось получить текст от нейросети.';
      } else {
        return 'Ошибка Google API (${response.statusCode}): ${response.body}';
      }
    } catch (e) {
      return 'Сетевая ошибка: $e';
    }
  }
}
