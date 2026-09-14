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
  }) async {
           final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key=$_apiKey',
    );

   


    final prompt = '''
                    You are an expert inspecting borrowed items for damages.
                    Compare these two images (Image 1: Before loan, Image 2: After return).
                    Identify any new scratches, cracks, dirt, or damages.
                    Provide a concise 2-sentence verdict.
                    Respond strictly in language: $languageCode.
                    If in good condition, begin with "✅" followed by the localized verdict.
                    ''';


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
