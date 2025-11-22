import 'package:flutter/material.dart';

import '../widgets/home_bottom_nav.dart';
import 'home_page.dart';
import 'requests_page.dart';
import 'chats_page.dart';
import 'menu_page.dart';
import '../../../scan/presentation/views/scan_item_page.dart';

class HomeTabsPage extends StatefulWidget {
  const HomeTabsPage({super.key});

  @override
  State<HomeTabsPage> createState() => _HomeTabsPageState();
}

class _HomeTabsPageState extends State<HomeTabsPage> {
  int _selectedIndex = 0;

  List<Widget> get _pages => const [
        HomePage(),
        RequestsPage(),
        ChatsPage(),
        MenuPage(),
      ];

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  void _openScanner() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ScanItemPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _CenterActionButton(
        onPressed: _openScanner,
      ),
      bottomNavigationBar: HomeBottomNav(
        selectedIndex: _selectedIndex,
        onSelected: _onTabSelected,
      ),
    );
  }
}

class _CenterActionButton extends StatefulWidget {
  const _CenterActionButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_CenterActionButton> createState() => _CenterActionButtonState();
}

class _CenterActionButtonState extends State<_CenterActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1 - _controller.value;
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Container(
          height: 62,
          width: 62,
          decoration: BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.camera_alt_outlined,
              color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
