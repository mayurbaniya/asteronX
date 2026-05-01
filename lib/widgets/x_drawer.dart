import 'package:asteron_x/service/getx/controller/theme_controller.dart';
import 'package:asteron_x/service/getx/helper/manage_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSideBar extends StatefulWidget {
  const CustomSideBar({super.key});

  @override
  State<CustomSideBar> createState() => _CustomSideBarState();
}

class _CustomSideBarState extends State<CustomSideBar> {
  String _userName = '';
  String _email = '';
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final pkg = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _userName = prefs.getString('name') ?? 'Partner';
      _email = prefs.getString('email') ?? '';
      _version = pkg.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(name: _userName, email: _email),
            const SizedBox(height: 8),
            Divider(
                color: scheme.outlineVariant.withValues(alpha: 0.4),
                height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _NavTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed('/about');
                    },
                  ),
                  _NavTile(
                    icon: Icons.mail_outline_rounded,
                    title: 'Contact',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed('/contact');
                    },
                  ),
                  _NavTile(
                    icon: Icons.policy_outlined,
                    title: 'Policies',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed('/policies');
                    },
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
                    child: Text(
                      'APPEARANCE',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                            color: scheme.onSurfaceVariant,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  const _ThemeToggle(),
                ],
              ),
            ),
            Divider(
                color: scheme.outlineVariant.withValues(alpha: 0.4),
                height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'v$_version',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => ManageAuth.logout(),
                    style: TextButton.styleFrom(
                        foregroundColor: scheme.error),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  final String email;
  const _Header({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final initials = name.trim().isEmpty
        ? '?'
        : name.trim().split(' ').take(2).map((s) => s[0]).join().toUpperCase();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: scheme.primaryContainer,
            child: Text(
              initials,
              style: TextStyle(
                color: scheme.onPrimaryContainer,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            overflow: TextOverflow.ellipsis,
          ),
          if (email.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                email,
                style: tt.bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _NavTile(
      {required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: scheme.onSurfaceVariant),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
      trailing: Icon(Icons.chevron_right_rounded,
          color: scheme.onSurfaceVariant, size: 20),
      onTap: onTap,
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Obx(() {
        final mode = controller.mode.value;
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _segment(context, ThemeMode.system, Icons.brightness_auto_rounded,
                  'System', mode, controller),
              _segment(context, ThemeMode.light, Icons.light_mode_rounded,
                  'Light', mode, controller),
              _segment(context, ThemeMode.dark, Icons.dark_mode_rounded,
                  'Dark', mode, controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _segment(
    BuildContext context,
    ThemeMode value,
    IconData icon,
    String label,
    ThemeMode current,
    ThemeController controller,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final selected = current == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setMode(value),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? scheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: scheme.shadow.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? scheme.primary : scheme.onSurfaceVariant,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
