import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  // 🟢 Exact Cloud Name and Unsigned Preset from your screenshot:
  static const String _cloudName = 'jrw66nr0';
  static const String _uploadPreset = 'purr_patrol';

  static Future<String?> uploadImage(Uint8List imageBytes) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');

    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = _uploadPreset
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'item_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      debugPrint("📡 [Cloudinary] Status Code: ${response.statusCode}");
      debugPrint("📡 [Cloudinary] Response: $responseData");

      if (response.statusCode == 200) {
        final json = jsonDecode(responseData);
        return json['secure_url'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("❌ [Cloudinary] Error: $e");
      return null;
    }
  }
}
