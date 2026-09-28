import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  // 🟢 Получить текущие координаты GPS пользователя
  static Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Проверяем, включен ли GPS на устройстве
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Возвращаем дефолтные координаты (Лиссабон), если GPS выключен
      return const LatLng(38.7223, -9.1393);
    }

    // 2. Проверяем разрешения
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const LatLng(38.7223, -9.1393);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return const LatLng(38.7223, -9.1393);
    }

    // 3. Достаем точные координаты устройства!
    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }
}
