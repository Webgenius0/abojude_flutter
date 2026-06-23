// import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
// import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'features/home/presentation/home_screen.dart';
// import 'features/home/presentation/journal_screen.dart';
// import 'features/insights/presentation/insights_screen.dart';
// import 'features/profile/presentation/profile_screen.dart';
//
// class NavigationMenu extends StatefulWidget {
//   const NavigationMenu({super.key});
//
//   @override
//   State<NavigationMenu> createState() => _NavigationMenuState();
// }
//
// class _NavigationMenuState extends State<NavigationMenu> {
//   int _currentIndex = 0;
//
//   static const Color activeColor = Color(0xFF9D87F5);
//   static const Color inactiveColor = Color(0xFF9DB2CE);
//
//   List<Widget> get _pages => [
//     HomeScreen(),
//     JournalScreen(),
//     InsightsScreen(),
//     ProfileScreen(),
//   ];
//
//   Future<bool> _onWillPop() async {
//     final result = await showCupertinoDialog<bool>(
//       context: context,
//       builder: (context) {
//         return CupertinoAlertDialog(
//           title: const Text("Exit App"),
//           content: const Text("Are you sure you want to leave the app?"),
//           actions: [
//             CupertinoDialogAction(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text("Cancel"),
//             ),
//             CupertinoDialogAction(
//               isDestructiveAction: true,
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//               child: const Text("Exit"),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (result == true) {
//       SystemNavigator.pop(); // close app
//     }
//
//     return false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (didPop) async {
//         if (didPop) return;
//         await _onWillPop();
//       },
//       child: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: const SystemUiOverlayStyle(
//           statusBarColor: Colors.transparent,
//           statusBarIconBrightness: Brightness.light,
//           statusBarBrightness: Brightness.dark,
//         ),
//         child: SafeArea(
//           top: false,
//           child: Scaffold(
//             body: _pages[_currentIndex],
//
//             bottomNavigationBar: CurvedNavigationBar(
//               index: _currentIndex,
//               height: 65,
//               backgroundColor: Color(0xFF0A0B1A),
//
//               color: const Color(0xFF191A28),
//
//               buttonBackgroundColor: const Color(0xFF39345A),
//               animationDuration: const Duration(milliseconds: 300),
//
//               items: [
//                 _buildNavItem("Home", "assets/icons/home.png", 0),
//                 _buildNavItem("Journal", "assets/icons/Icon.png", 1),
//                 _buildNavItem("Insights", "assets/icons/Button.png", 2),
//                 _buildNavItem("Profile", "assets/icons/user.png", 3),
//               ],
//
//               onTap: (index) {
//                 setState(() {
//                   _currentIndex = index;
//                 });
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   CurvedNavigationBarItem _buildNavItem(
//     String label,
//     String iconPath,
//     int index,
//   ) {
//     final bool isSelected = _currentIndex == index;
//
//     return CurvedNavigationBarItem(
//       child: Image.asset(
//         iconPath,
//         height: 24.h,
//         color: isSelected ? activeColor : inactiveColor,
//       ),
//       label: label,
//       labelStyle: TextStyle(
//         fontSize: 12.sp,
//         fontWeight: FontWeight.w500,
//         color: isSelected ? activeColor : inactiveColor,
//       ),
//     );
//   }
// }

import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
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

            _buildNavItem(
              index: 2,
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Message',
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.person_outline_rounded,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterFAB() {
    return GestureDetector(
      onTap: () {
        NavigationService.navigateToReplacement(Routes.createListingScreen);
      },
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
