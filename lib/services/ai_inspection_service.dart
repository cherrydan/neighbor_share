import 'dart:typed_data';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiInspectionService {
  // 🟢 Вставь сюда свой скопированный бесплатный ключ:
  static const String _apiKey = 'AQ.Ab8RN6LeTURj-L7RAACbkdTogYVz-MPGrtjOg-kaAHLzj3bcnQ';

  static Future<String> inspectItemCondition({
    required Uint8List photoBeforeBytes,
    required Uint8List photoAfterBytes,
    required String languageCode,
  }) async {
    try {
      

      final model = GenerativeModel(
       model: 'gemini-1.5-flash',
        apiKey: _apiKey,
      );

      final prompt = TextPart('''
Ты — строгий эксперт по оценке сохранности арендованных вещей.
Перед тобой 2 фотографии одного предмета:
1. Фотография ДО передачи соседу.
2. Фотография ПОСЛЕ возврата.

Твоя задача:
- Сравни обе фотографии.
- Проверь, появились ли видимые сколы, трещины, глубокие царапины, грязь или поломки.
- Дай короткий вердикт (максимум 2-3 предложения).
- Отвечай строго на языке с кодом: $languageCode.
Если всё в порядке, начни ответ со слов "✅ Состояние отличное:" (или на соответствующем языке).
''');

      final imageBeforePart = DataPart('image/jpeg', photoBeforeBytes);
      final imageAfterPart = DataPart('image/jpeg', photoAfterBytes);

      final response = await model.generateContent([
        Content.multi([prompt, imageBeforePart, imageAfterPart])
      ]);

      return response.text ?? 'Не удалось получить ответ от нейросети.';
    } catch (e) {
      return 'Ошибка AI экспертизы: $e';
    }
  }
}
