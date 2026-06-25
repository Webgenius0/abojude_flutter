

import 'package:flutter/material.dart';
import 'features/home/presentation/explore_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/message_screeen/message_screeen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  static const Color _activeColor = Color(0xFF1B2D6B);
  static const Color _inactiveColor = Color(0xFF9E9E9E);
  static const Color _fabColor = Color(0xFF1B2D6B);

  final List<Widget> _pages = [
    const HomeScreen(),
    ExploreScreen(),
    MessagesScreen(),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildCustomBottomBar(),
    );
  }

  Widget _buildCustomBottomBar() {
    return SafeArea(
      child: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildNavItem(index: 0, icon: Icons.home_rounded, label: 'Home'),
            _buildNavItem(index: 1, icon: Icons.search, label: 'Explore'),

            // Center FAB — same line, no float
            _buildCenterFAB(),

            _buildNavItem(index: 2, icon: Icons.chat_bubble_outline_rounded, label: 'Message'),
            _buildNavItem(index: 3, icon: Icons.person_outline_rounded, label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterFAB() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: _fabColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? _activeColor : _inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? _activeColor : _inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}