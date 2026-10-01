import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseService {
  // Системные ключи RevenueCat (тестовые ключи из ZeroWasteChef)
  static const _googleApiKey = "test_RTiIEKtNdoALeDKbjPdwZnmjxEd";
  static const _appleApiKey = "test_RTiIEKtNdoALeDKbjPdwZnmjxEd";

  // Инициализация сервиса покупок
  static Future<void> init() async {
    try {
      // Режим отладки для вывода логов платежей в консоль
      await Purchases.setLogLevel(LogLevel.debug);

      String apiKey = "";
      if (Platform.isAndroid) {
        apiKey = _googleApiKey;
      } else if (Platform.isIOS) {
        apiKey = _appleApiKey;
      }

      // Инициализируем конфигурацию RevenueCat
      PurchasesConfiguration configuration = PurchasesConfiguration(apiKey);
      await Purchases.configure(configuration);
      
      debugPrint("📡 [RevenueCat] Успешно инициализирован!");
    } catch (e) {
      debugPrint("❌ [RevenueCat] Ошибка инициализации: $e");
    }
  }

  // Проверяем, активна ли у пользователя Premium подписка прямо сейчас
  static Future<bool> isUserPremium() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      // "premium" - ID entitlement в консоли RevenueCat
      return customerInfo.entitlements.all["premium"]?.isActive ?? false;
    } catch (e) {
      debugPrint("❌ [RevenueCat] Ошибка проверки подписки: $e");
      return false;
    }
  }

  // Получаем дату окончания Premium подписки в красивом формате
  static Future<String?> getPremiumExpirationDate() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      final entitlement = customerInfo.entitlements.all["premium"];
      
      if (entitlement != null && entitlement.isActive) {
        final dynamic rawExpDate = entitlement.expirationDate;
        
        if (rawExpDate != null) {
          DateTime? expDateTime;
          
          if (rawExpDate is String) {
            expDateTime = DateTime.tryParse(rawExpDate);
          } else if (rawExpDate is DateTime) {
            expDateTime = rawExpDate;
          }
          
          if (expDateTime != null) {
            return "${expDateTime.day.toString().padLeft(2, '0')}.${expDateTime.month.toString().padLeft(2, '0')}.${expDateTime.year}";
          }
        }
      }
    } catch (e) {
      debugPrint("❌ [RevenueCat] Ошибка получения даты окончания: $e");
    }
    return null;
  }

  // Привязываем покупки к Firebase UID
  static Future<void> login(String firebaseUid) async {
    try {
      await Purchases.logIn(firebaseUid);
      debugPrint("📡 [RevenueCat] Успешно привязан к UID: $firebaseUid");
    } catch (e) {
      debugPrint("❌ [RevenueCat] Ошибка привязки к UID: $e");
    }
  }

  // Отвязываем покупки при выходе пользователя
  static Future<void> logout() async {
    try {
      bool isAnonymous = await Purchases.isAnonymous;
      if (!isAnonymous) {
        await Purchases.logOut();
        debugPrint("📡 [RevenueCat] Успешно отвязан.");
      } else {
        debugPrint("📡 [RevenueCat] Пользователь уже анонимный, вызов пропущен.");
      }
    } catch (e) {
      debugPrint("❌ [RevenueCat] Ошибка отвязки: $e");
    }
  }

  // Загружаем текущие предложения (Offerings) из сети
  static Future<Offering?> getMonthlyOffering() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        return offerings.current;
      }
    } catch (e) {
      debugPrint("❌ [RevenueCat] Ошибка загрузки предложений: $e");
    }
    return null;
  }

    // Покупка пакета (подписки) — обновлено под актуальный SDK RevenueCat
  static Future<bool> purchasePackage(Package package) async {
    try {
      // 🟢 Используем актуальный класс PurchaseParams и получаем PurchaseResult
      final purchaseResult = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      
      return purchaseResult.customerInfo.entitlements.all["premium"]?.isActive ?? false;
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint("📡 [RevenueCat] Пользователь отменил покупку");
      } else {
        debugPrint("❌ [RevenueCat] Ошибка покупки: ${e.message}");
      }
      return false;
    } catch (e) {
      debugPrint("❌ [RevenueCat] Непредвиденная ошибка: $e");
      return false;
    }
  }

}