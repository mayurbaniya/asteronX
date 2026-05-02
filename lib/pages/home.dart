import 'package:asteron_x/pages/add_leads.dart';
import 'package:asteron_x/pages/leaderboard.dart';
import 'package:asteron_x/pages/my_leads.dart';
import 'package:asteron_x/pages/payment_details.dart';
import 'package:asteron_x/pages/payment_history.dart';
import 'package:asteron_x/service/getx/controller/user_controller.dart';
import 'package:asteron_x/widgets/environment_badge.dart';
import 'package:asteron_x/widgets/x_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserController userController =
      Get.put(UserController(), permanent: true);

  int currentIndex = 2;
  late final List<Widget> _screens;

  void _changeTabToMyLeads() {
    if (mounted) setState(() => currentIndex = 0);
  }

  static const _titles = [
    'My Leads',
    'Payment',
    'Overview',
    'New Lead',
    'History',
  ];

  @override
  void initState() {
    super.initState();

    _screens = [
      const MyLeads(),
      const PaymentDetails(),
      const Leaderboard(),
      AddLeads(onLeadSubmitted: _changeTabToMyLeads),
      const PaymentHistory(),
    ];

    // Defer the SF read until after the first frame: getUserDataFromSF()
    // toggles `isLoading` synchronously before the first `await`, which
    // would notify Obx listeners while /home is still being built and
    // trigger "setState() called during build" via the route Builder.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      userController.getUserDataFromSF();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomSideBar(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu_rounded),
          tooltip: 'Menu',
        ),
        titleSpacing: 0,
        title: Text(
          _titles[currentIndex],
          style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Center(child: EnvironmentBadge()),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Obx(() {
                final name = userController.user.value?.name ?? '';
                final initials = name.trim().isEmpty
                    ? '?'
                    : name
                        .trim()
                        .split(RegExp(r'\s+'))
                        .take(2)
                        .map((s) => s.isEmpty ? '' : s[0])
                        .join()
                        .toUpperCase();
                return CircleAvatar(
                  radius: 16,
                  backgroundColor: scheme.primaryContainer,
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: currentIndex,
        onChanged: (i) {
          if (mounted) setState(() => currentIndex = i);
        },
      ),
      body: _screens[currentIndex],
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const _BottomNav({required this.currentIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          top: BorderSide(
              color: scheme.outlineVariant.withValues(alpha: 0.5), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: SalomonBottomBar(
            curve: Curves.easeOut,
            currentIndex: currentIndex,
            onTap: onChanged,
            selectedItemColor: scheme.primary,
            unselectedItemColor: scheme.onSurfaceVariant,
            itemPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            items: [
              SalomonBottomBarItem(
                activeIcon: const Icon(Icons.list_alt_rounded, size: 22),
                icon: const Icon(Icons.list_alt_outlined, size: 22),
                title: const Text('Leads'),
              ),
              SalomonBottomBarItem(
                activeIcon: const Icon(Icons.account_balance_wallet_rounded,
                    size: 22),
                icon: const Icon(Icons.account_balance_wallet_outlined,
                    size: 22),
                title: const Text('Pay'),
              ),
              SalomonBottomBarItem(
                activeIcon: const Icon(Icons.insights_rounded, size: 22),
                icon: const Icon(Icons.insights_outlined, size: 22),
                title: const Text('Overview'),
              ),
              SalomonBottomBarItem(
                activeIcon: const Icon(Icons.add_circle_rounded, size: 22),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
                title: const Text('Add'),
              ),
              SalomonBottomBarItem(
                activeIcon: const Icon(Icons.history_rounded, size: 22),
                icon: const Icon(Icons.history_outlined, size: 22),
                title: const Text('History'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
