import 'package:flutter/material.dart';
import 'package:flutter_learning/core/theme/app_theme.dart';
import 'package:flutter_learning/data/notifiers.dart';
import 'package:flutter_learning/views/pages/home__page.dart';
import 'package:flutter_learning/views/pages/profile_page.dart';
import 'package:flutter_learning/views/pages/receipt_page.dart';
import 'package:flutter_learning/views/pages/settings_page.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final List<Widget> _pages = const [
    HomePage(),
    ReceiptPage(),
    ProfilePage(),
  ];

  final List<String> _titles = const [
    'Home',
    'Scan',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedIndex, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _titles[selectedIndex],
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: false,
            actions: [
              if (selectedIndex == 0) ...[
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                  },
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surface : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.border : AppColors.divider,
                      ),
                    ),
                    child: Icon(
                      Icons.settings_outlined,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
          body: IndexedStack(
            index: selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.border : AppColors.divider,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                      label: 'Home',
                      isSelected: selectedIndex == 0,
                      onTap: () => selectedPageNotifier.value = 0,
                    ),
                    _NavItem(
                      icon: Icons.document_scanner_outlined,
                      activeIcon: Icons.document_scanner_rounded,
                      label: 'Scan',
                      isSelected: selectedIndex == 1,
                      onTap: () => selectedPageNotifier.value = 1,
                      isHighlighted: true,
                    ),
                    _NavItem(
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      label: 'Profile',
                      isSelected: selectedIndex == 2,
                      onTap: () => selectedPageNotifier.value = 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isHighlighted;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isHighlighted) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(isSelected ? activeIcon : icon, color: AppColors.textDark, size: 22),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.dmSans(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
