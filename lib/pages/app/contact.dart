import 'package:asteron_x/service/firebase/remote_data.dart';
import 'package:asteron_x/widgets/x_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final email = RemoteData().adminEmail.trim();
    final phone = RemoteData().adminPhone.trim();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
        title: Text('Contact',
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
              if (email.isNotEmpty)
                _ContactTile(
                  icon: Icons.mail_outline_rounded,
                  label: 'Email',
                  value: email,
                  cta: 'Send email',
                  onTap: () => _openEmail(context, email),
                  onLongPress: () => _copy(context, email, 'Email'),
                  scheme: scheme,
                  tt: tt,
                ),
              if (email.isNotEmpty && phone.isNotEmpty)
                const SizedBox(height: 12),
              if (phone.isNotEmpty)
                _ContactTile(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: phone,
                  cta: 'Call',
                  onTap: () => _openDialer(context, phone),
                  onLongPress: () => _copy(context, phone, 'Phone'),
                  scheme: scheme,
                  tt: tt,
                ),
              if (email.isEmpty && phone.isEmpty)
                _UnavailableCard(scheme: scheme, tt: tt),
              const SizedBox(height: 24),
              _NoteCard(scheme: scheme, tt: tt),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openEmail(BuildContext context, String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Asteron Partner — support'},
    );
    final ok = await _tryLaunch(uri);
    if (!ok && context.mounted) {
      _copy(context, email, 'Email',
          fallback: 'No email app found. Address copied to clipboard.');
    }
  }

  Future<void> _openDialer(BuildContext context, String phone) async {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: cleaned);
    final ok = await _tryLaunch(uri);
    if (!ok && context.mounted) {
      _copy(context, phone, 'Phone',
          fallback: 'No dialer found. Number copied to clipboard.');
    }
  }

  Future<bool> _tryLaunch(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  void _copy(BuildContext context, String value, String label,
      {String? fallback}) {
    Clipboard.setData(ClipboardData(text: value));
    final scheme = Theme.of(context).colorScheme;
    customToast(
      fallback ?? '$label copied',
      Icons.content_copy_rounded,
      scheme.primary,
      scheme.onSurface,
    ).show(context);
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
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.support_agent_rounded,
                color: scheme.primary, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We\'re here to help',
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reach out through any channel below.',
                  style: tt.bodyMedium?.copyWith(
                    color: scheme.onPrimaryContainer.withValues(alpha: 0.85),
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

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String cta;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ColorScheme scheme;
  final TextTheme tt;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.cta,
    required this.onTap,
    required this.onLongPress,
    required this.scheme,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: scheme.onPrimaryContainer, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: tt.labelSmall?.copyWith(
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: tt.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  cta,
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontFamily: 'montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final ColorScheme scheme;
  final TextTheme tt;
  const _NoteCard({required this.scheme, required this.tt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.schedule_rounded,
              size: 18, color: scheme.onSurface),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Support hours: Mon–Sat, 10:00 AM – 7:00 PM IST. We typically reply within one business day.',
              style: tt.bodySmall?.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnavailableCard extends StatelessWidget {
  final ColorScheme scheme;
  final TextTheme tt;
  const _UnavailableCard({required this.scheme, required this.tt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_off_rounded,
              size: 36, color: scheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            'Contact details unavailable',
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Please check your connection and reopen this screen.',
            textAlign: TextAlign.center,
            style: tt.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
