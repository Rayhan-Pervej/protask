import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:protask/screens/Users/users.dart';
import 'package:protask/screens/home/home.dart';
import 'package:protask/screens/leave_application/leave_application.dart';
import 'package:protask/theme/my_color.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;
  final pageViewController = PageController(initialPage: 0);

  final List<NavItem> navItems = [
    NavItem(icon: Iconsax.home_2, label: 'Home'),
    NavItem(icon: FluentIcons.people_community_48_filled, label: 'Employees'),
    NavItem(icon: FluentIcons.mail_48_filled, label: 'Applications'),
  ];

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index;
        pageViewController.jumpToPage(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: PageView(
        controller: pageViewController,
        onPageChanged: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        children: const [Home(), Users(), LeaveApplication()],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                navItems.length,
                (index) => _buildNavItem(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = selectedIndex == index;
    final item = navItems[index];

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 60,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 20,
                alignment: Alignment.center,
                child: Icon(
                  item.icon,
                  color: isSelected ? MyColor.softBlue : Colors.grey.shade500,
                  size: 26,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? MyColor.softBlue : Colors.grey.shade500,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}
