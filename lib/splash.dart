import 'package:asteron_x/service/firebase/remote_data.dart';
import 'package:asteron_x/service/getx/controller/UpdateController.dart';
import 'package:asteron_x/service/getx/controller/payment_controller.dart';
import 'package:asteron_x/service/getx/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final UserController userController = Get.put(UserController());
  final PaymentController paymentController = Get.put(PaymentController());
  final UpdateController updateController = Get.put(UpdateController());

  @override
  void initState() {
    super.initState();
    updateController.checkLatestVersion();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('loggedIn') ?? false;

    if (!mounted) return;
    if (RemoteData().underMaintanence == 'true') {
      Get.offAllNamed('/maintanence');
      return;
    }
    Get.offAllNamed(loggedIn ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Icon(Icons.bolt_rounded,
                      size: 48, color: scheme.onPrimaryContainer),
                ),
                const SizedBox(height: 24),
                Text(
                  'Asteron',
                  style: tt.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Partner Portal',
                  style: tt.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 56,
            child: Center(
              child: SizedBox(
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    backgroundColor:
                        scheme.surfaceContainerHighest,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(scheme.primary),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
