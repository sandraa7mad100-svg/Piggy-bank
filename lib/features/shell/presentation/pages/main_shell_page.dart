import 'package:flutter/material.dart';

import '../../../ai_chat/presentation/pages/ai_chat_page.dart';
import '../../../goals/presentation/pages/goals_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../transactions/presentation/pages/transactions_page.dart';

/// Persistent bottom-navigation shell. Uses an [IndexedStack] (not a fresh
/// page per tap) so each tab keeps its scroll position and provider state
/// when switching back and forth.
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _index = 0;

  static const _pages = [
    HomePage(),
    TransactionsPage(),
    GoalsPage(),
    AiChatPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Activity',
          ),
          NavigationDestination(icon: Icon(Icons.flag_outlined), selectedIcon: Icon(Icons.flag_rounded), label: 'Goals'),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Penny',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
