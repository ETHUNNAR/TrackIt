import 'package:flutter/material.dart';
import 'package:flutter_learning/core/theme/app_theme.dart';
import 'package:flutter_learning/data/notifiers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _toggleTheme(bool value) async {
    isDarkModeNotifier.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Appearance'),
            const SizedBox(height: 12),
            _SettingsCard(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: isDarkModeNotifier,
                  builder: (context, isDarkMode, _) => _SettingsTile(
                    icon: isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                    title: 'Dark Mode',
                    subtitle: isDarkMode ? 'Currently using dark theme' : 'Currently using light theme',
                    trailing: Switch.adaptive(
                      value: isDarkMode,
                      onChanged: _toggleTheme,
                      activeColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Data & Storage'),
            const SizedBox(height: 12),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.cloud_outlined,
                  title: 'Cloud Sync',
                  subtitle: 'Sync your receipts across devices',
                  trailing: Switch.adaptive(
                    value: false,
                    onChanged: (value) {},
                    activeColor: AppColors.primary,
                  ),
                ),
                Divider(height: 1, indent: 56, color: isDark ? AppColors.border : AppColors.divider),
                _SettingsTile(
                  icon: Icons.storage_outlined,
                  title: 'Storage Used',
                  subtitle: '0 MB of 100 MB',
                  trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  onTap: () {},
                ),
                Divider(height: 1, indent: 56, color: isDark ? AppColors.border : AppColors.divider),
                _SettingsTile(
                  icon: Icons.delete_sweep_outlined,
                  title: 'Clear Cache',
                  subtitle: 'Free up storage space',
                  trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cache cleared', style: GoogleFonts.dmSans()),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Privacy'),
            const SizedBox(height: 12),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.fingerprint_outlined,
                  title: 'Biometric Lock',
                  subtitle: 'Require authentication to open app',
                  trailing: Switch.adaptive(
                    value: false,
                    onChanged: (value) {},
                    activeColor: AppColors.primary,
                  ),
                ),
                Divider(height: 1, indent: 56, color: isDark ? AppColors.border : AppColors.divider),
                _SettingsTile(
                  icon: Icons.analytics_outlined,
                  title: 'Analytics',
                  subtitle: 'Help improve TrackIt',
                  trailing: Switch.adaptive(
                    value: true,
                    onChanged: (value) {},
                    activeColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('About'),
            const SizedBox(height: 12),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'Version',
                  subtitle: '1.0.0',
                  trailing: const SizedBox.shrink(),
                ),
                Divider(height: 1, indent: 56, color: isDark ? AppColors.border : AppColors.divider),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  onTap: () {},
                ),
                Divider(height: 1, indent: 56, color: isDark ? AppColors.border : AppColors.divider),
                _SettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'Privacy Policy',
                  trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textMuted,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.border : AppColors.divider),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
