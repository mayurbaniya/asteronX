import 'package:asteron_x/service/firebase/remote_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _version = '${info.version}+${info.buildNumber}');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
        title: Text('About',
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Hero(scheme: scheme, tt: tt),
              const SizedBox(height: 24),
              _Section(
                title: 'Who we are',
                child: Text(
                  'Asteron Vehicles is your trusted vehicle dealer in Nagpur. We help customers buy both new and used vehicles from any showroom in the city. Our mission is to simplify the vehicle buying process — making it more convenient and transparent for you.\n\nJust search for the vehicle you want, tap "Interested", and our team handles the rest — from selection through documentation to delivery of the number plate.',
                  style:
                      tt.bodyMedium?.copyWith(height: 1.5, color: scheme.onSurface),
                ),
              ),
              const SizedBox(height: 16),
              _Section(
                title: 'Our mission',
                icon: Icons.flag_outlined,
                child: Text(
                  'To simplify the vehicle buying process — bridging the gap between showrooms and buyers. We protect customers from aggressive showroom marketing while ensuring they get the best deals.',
                  style: tt.bodyMedium?.copyWith(
                    height: 1.5,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _Section(
                title: 'How partners earn',
                icon: Icons.workspace_premium_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BulletRow(
                      icon: Icons.send_rounded,
                      text: 'Submit qualified leads through the app',
                      scheme: scheme,
                      tt: tt,
                    ),
                    const SizedBox(height: 10),
                    _BulletRow(
                      icon: Icons.handshake_outlined,
                      text:
                          'Our team works the lead with the buyer and showroom',
                      scheme: scheme,
                      tt: tt,
                    ),
                    const SizedBox(height: 10),
                    _BulletRow(
                      icon: Icons.account_balance_wallet_outlined,
                      text: 'Earnings are paid to your verified UPI on close',
                      scheme: scheme,
                      tt: tt,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _ContactCard(scheme: scheme, tt: tt),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  _version.isEmpty ? '' : 'Asteron Partner • v$_version',
                  style: tt.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final ColorScheme scheme;
  final TextTheme tt;
  const _Hero({required this.scheme, required this.tt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primaryContainer,
            scheme.primaryContainer.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.bolt_rounded,
                color: scheme.primary, size: 30),
          ),
          const SizedBox(height: 16),
          Text(
            'Asteron Vehicles',
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.onPrimaryContainer,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Simplifying your vehicle buying experience',
            style: tt.bodyMedium?.copyWith(
              color: scheme.onPrimaryContainer.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? icon;
  const _Section({required this.title, required this.child, this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: scheme.primary),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final ColorScheme scheme;
  final TextTheme tt;
  const _BulletRow({
    required this.icon,
    required this.text,
    required this.scheme,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: scheme.primaryContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: scheme.onPrimaryContainer),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(text, style: tt.bodyMedium),
          ),
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final ColorScheme scheme;
  final TextTheme tt;
  const _ContactCard({required this.scheme, required this.tt});

  @override
  Widget build(BuildContext context) {
    final email = RemoteData().adminEmail;
    final phone = RemoteData().adminPhone;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.support_agent_rounded,
              size: 28, color: scheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help?',
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  email.isNotEmpty || phone.isNotEmpty
                      ? 'Reach out — we usually reply within a day.'
                      : 'Reach out via the Contact screen.',
                  style: tt.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Get.toNamed('/contact'),
            child: const Text('Contact'),
          ),
        ],
      ),
    );
  }
}
