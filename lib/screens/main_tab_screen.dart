import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/item_model.dart';
import 'feed_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;

  final GlobalKey<MapScreenState> _mapKey = GlobalKey<MapScreenState>();

  void _showItemOnMap(ItemModel item) {
    setState(() => _currentIndex = 1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapKey.currentState?.moveToItem(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final screens = [
      FeedScreen(onShowOnMap: _showItemOnMap),
      MapScreen(key: _mapKey),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        selectedItemColor: const Color(0xFF2ECC71),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt_rounded),
            label: l10n.feedTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map_rounded),
            label: l10n.mapTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_rounded),
            label: l10n.profileTab,
          ),
        ],
      ),
    );
  }
}
