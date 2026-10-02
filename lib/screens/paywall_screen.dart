import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../l10n/app_localizations.dart';
import '../services/purchase_service.dart';
import '../services/user_service.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  Package? _offeringPackage;
  bool _isLoading = true;
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  // 🟢 Загружаем предложения подписок из RevenueCat
  Future<void> _loadOfferings() async {
    try {
      final offering = await PurchaseService.getMonthlyOffering();
      if (offering != null && offering.availablePackages.isNotEmpty) {
        setState(() {
          _offeringPackage = offering.availablePackages.first;
        });
      }
    } catch (e) {
      debugPrint("❌ [Paywall] Ошибка загрузки офферов: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // 🟢 Метод совершения покупки
  Future<void> _handlePurchase() async {
    if (_offeringPackage == null) {
      // Если оффер из RevenueCat еще не подтянулся (или в процессе настройки)
      _simulateProForTesting();
      return;
    }

    setState(() => _isPurchasing = true);

    try {
      final bool success = await PurchaseService.purchasePackage(_offeringPackage!);

      if (success) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Обновляем статус PRO в Firestore!
          await UserService().updateProStatus(user.uid, true);
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Поздравляем! Вы стали PRO Соседом!'),
            backgroundColor: Color(0xFF2ECC71),
          ),
        );
        Navigator.pop(context); // Закрываем пейволл
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка покупки: $e')),
      );
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  // 🟢 Режим тестирования: активирует PRO для разработки, если ключи RevenueCat ещё не привязаны
  Future<void> _simulateProForTesting() async {
    setState(() => _isPurchasing = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await UserService().updateProStatus(user.uid, true);
    }
    if (!mounted) return;
    setState(() => _isPurchasing = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 [TEST MODE] PRO-подписка успешно активирована!'),
        backgroundColor: Color(0xFF2ECC71),
      ),
    );
    Navigator.pop(context);
  }

  // 🟢 Восстановление покупок
  Future<void> _restorePurchases() async {
    setState(() => _isPurchasing = true);
    final isPremium = await PurchaseService.isUserPremium();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await UserService().updateProStatus(user.uid, isPremium);
    }

    if (!mounted) return;
    setState(() => _isPurchasing = false);

    if (isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Покупки успешно восстановлены!'),
          backgroundColor: Color(0xFF2ECC71),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Активных покупок не найдено.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Подтягиваем динамическую цену из магазина или дефолтное отображение
    final String priceText = _offeringPackage != null
        ? '${_offeringPackage!.storeProduct.priceString} / month'
        : l10n.proPrice;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2ECC71).withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.stars_rounded, size: 80, color: Color(0xFF2ECC71)),
              const SizedBox(height: 16),
              Text(
                l10n.proTitle,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  l10n.proSubtitle,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // Список фич
              _buildFeatureItem(Icons.auto_awesome_rounded, l10n.proFeatureAI),
              _buildFeatureItem(Icons.all_inclusive_rounded, l10n.proFeatureUnlimited),
              _buildFeatureItem(Icons.verified_user_rounded, l10n.proFeatureBadge),

              const Spacer(),

              // Блок цены и кнопки
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      Text(
                        priceText,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isPurchasing ? null : _handlePurchase,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2ECC71),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isPurchasing
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                l10n.subscribeButton,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _isPurchasing ? null : _restorePurchases,
                      child: Text(l10n.restorePurchases, style: const TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2ECC71), size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}