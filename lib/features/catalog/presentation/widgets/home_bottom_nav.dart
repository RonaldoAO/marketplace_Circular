import 'package:flutter/material.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFFE6F3E);
    const inactive = Color(0xFF9B9B9B);
    final items = [
      _BottomItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_filled,
        label: 'Home',
      ),
      _BottomItem(
        icon: Icons.file_copy_outlined,
        activeIcon: Icons.file_copy_rounded,
        label: 'Ofertas',
      ),
      _BottomItem(
        icon: Icons.chat_bubble_outline_rounded,
        activeIcon: Icons.chat_bubble_rounded,
        label: 'Chats',
      ),
      _BottomItem(
        icon: Icons.more_horiz,
        activeIcon: Icons.more_horiz,
        label: 'Menu',
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE6E6E6), width: 1),
        ),
      ),
      child: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isActive = index == selectedIndex;
              return Expanded(
                child: InkResponse(
                  onTap: () => onSelected(index),
                  highlightShape: BoxShape.rectangle,
                  radius: 28,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isActive ? item.activeIcon : item.icon,
                        size: 22,
                        color: isActive ? primary : inactive,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isActive ? primary : inactive,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomItem {
  const _BottomItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}
