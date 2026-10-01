import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/widgets/spring_animated_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeModeProvider.notifier);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final cs = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1E293B)
        : Colors.white;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Text('Settings',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins',
                          letterSpacing: -0.5,
                        )),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel(context, 'Appearance'),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _SettingsTile(
                        icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        iconColor: isDark ? const Color(0xFF818CF8) : const Color(0xFFF59E0B),
                        title: 'Theme',
                        subtitle: isDark ? 'Dark Mode' : 'Light Mode',
                        trailing: SpringTap(
                          onTap: () => themeNotifier.toggle(),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            width: 52,
                            height: 30,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF8B5CF6)
                                  : Colors.grey.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCubic,
                              alignment: isDark
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _sectionLabel(context, 'About'),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _SettingsTile(
                            icon: Icons.info_outline_rounded,
                            iconColor: const Color(0xFF8B5CF6),
                            title: 'MediaLog',
                            subtitle: 'Version 1.0.0',
                            trailing: const SizedBox.shrink(),
                          ),
                          Divider(
                            height: 1,
                            indent: 60,
                            endIndent: 16,
                            color: cs.onSurface.withValues(alpha: 0.07),
                          ),
                          _SettingsTile(
                            icon: Icons.favorite_outline_rounded,
                            iconColor: const Color(0xFFEC4899),
                            title: 'Made with',
                            subtitle: 'Flutter & Riverpod',
                            trailing: const SizedBox.shrink(),
                          ),
                          Divider(
                            height: 1,
                            indent: 60,
                            endIndent: 16,
                            color: cs.onSurface.withValues(alpha: 0.07),
                          ),
                          _SettingsTile(
                            icon: Icons.lock_outline_rounded,
                            iconColor: const Color(0xFF10B981),
                            title: 'Privacy',
                            subtitle: '100% offline, no data shared',
                            trailing: const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) => Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              letterSpacing: 1.2,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
      );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      )),
              Text(subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.45),
                        fontFamily: 'Inter',
                      )),
            ],
          ),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}
