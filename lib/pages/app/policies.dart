import 'package:asteron_x/service/firebase/remote_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PoliciesPage extends StatelessWidget {
  const PoliciesPage({super.key});

  static const _policies = <_PolicyItem>[
    _PolicyItem(
      icon: Icons.assignment_ind_outlined,
      title: 'Lead ownership and responsibility',
      body:
          'You are responsible for the leads you submit. Do not submit leads owned by the showroom or obtained from unauthorized sources. If a lead is found to be invalid or stolen, you are accountable for any legal consequences.',
    ),
    _PolicyItem(
      icon: Icons.account_balance_wallet_outlined,
      title: 'Payment verification',
      body:
          'Verify your payment details daily. If your details are incorrect and we pay your earnings to the wrong account, we are not responsible for the loss.',
    ),
    _PolicyItem(
      icon: Icons.gpp_bad_outlined,
      title: 'Invalid leads & account suspension',
      body:
          'Repeated submission of invalid leads may result in account suspension. We expect honesty in all transactions.',
    ),
    _PolicyItem(
      icon: Icons.cloud_off_outlined,
      title: 'Server load & misuse',
      body:
          'If you put additional load on our servers or violate usage policies, your account may be suspended immediately to protect the stability of the service.',
    ),
    _PolicyItem(
      icon: Icons.gavel_outlined,
      title: 'Legal consequences for violation',
      body:
          'You agreed to these policies when creating your account. Any violation will be treated seriously and you will be held accountable for any legal consequences.',
    ),
  ];

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
        title: Text('Policies',
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Hero(scheme: scheme, tt: tt),
              const SizedBox(height: 20),
              ...List.generate(_policies.length, (i) {
                final p = _policies[i];
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: i == _policies.length - 1 ? 0 : 12),
                  child: _PolicyCard(
                    index: i + 1,
                    item: p,
                    scheme: scheme,
                    tt: tt,
                  ),
                );
              }),
              const SizedBox(height: 20),
              _Footer(scheme: scheme, tt: tt),
            ],
          ),
        ),
      ),
    );
  }
}

class _PolicyItem {
  final IconData icon;
  final String title;
  final String body;
  const _PolicyItem({
    required this.icon,
    required this.title,
    required this.body,
  });
}

class _Hero extends StatelessWidget {
  final ColorScheme scheme;
  final TextTheme tt;
  const _Hero({required this.scheme, required this.tt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
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
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.policy_rounded,
                color: scheme.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Partner policies',
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You agreed to these terms when you created your account.',
                  style: tt.bodySmall?.copyWith(
                    color: scheme.onPrimaryContainer.withValues(alpha: 0.85),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final int index;
  final _PolicyItem item;
  final ColorScheme scheme;
  final TextTheme tt;

  const _PolicyCard({
    required this.index,
    required this.item,
    required this.scheme,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: scheme.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(item.icon, size: 18, color: scheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title,
                  style:
                      tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.body,
            style: tt.bodyMedium?.copyWith(
              height: 1.5,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final ColorScheme scheme;
  final TextTheme tt;
  const _Footer({required this.scheme, required this.tt});

  @override
  Widget build(BuildContext context) {
    final email = RemoteData().adminEmail.trim();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.help_outline_rounded,
              size: 22, color: scheme.onSurface),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Questions about these policies?',
                  style: tt.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  email.isEmpty
                      ? 'Reach out via the Contact screen.'
                      : email,
                  style: tt.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => Get.toNamed('/contact'),
            child: const Text('Contact'),
          ),
        ],
      ),
    );
  }
}
