import 'package:asteron_x/service/models/leads_model.dart';
import 'package:asteron_x/utils/theme.dart';
import 'package:asteron_x/widgets/custom_expansion_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadDetails extends StatelessWidget {
  const LeadDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final Content lead = Get.arguments as Content;
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final s = context.semantics;

    final (statusColor, statusIcon, statusLabel) = switch (lead.status) {
      'NEW' => (s.leadNew, Icons.fiber_new_rounded, 'NEW'),
      'ONGOING' => (s.leadOngoing, Icons.sync_rounded, 'ONGOING'),
      'CLOSED' => (s.leadClosed, Icons.check_circle_rounded, 'CLOSED'),
      'DELETED' => (s.leadDeleted, Icons.delete_outline_rounded, 'DELETED'),
      _ => (scheme.outline, Icons.help_outline_rounded, lead.status ?? '—'),
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(lead.clientName ?? 'Lead details',
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StatusBanner(
                color: statusColor,
                icon: statusIcon,
                label: statusLabel,
              ),
              const SizedBox(height: 16),
              _Section(
                title: 'Customer details',
                children: [
                  _InfoRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Name',
                      value: lead.clientName ?? '—'),
                  _InfoRow(
                      icon: Icons.two_wheeler_rounded,
                      label: 'Vehicle',
                      value: lead.vehicle ?? '—'),
                  _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'City',
                      value: lead.city ?? '—'),
                  _InfoRow(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Finance',
                      value: lead.isFinanceInterested ?? '—'),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _EarningsTile(
                        title: 'Expected',
                        value: lead.expectedEarnings ?? '—',
                        color: s.info,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _EarningsTile(
                        title: 'Earned',
                        value: lead.partnersTake ?? '—',
                        color: s.success,
                        emphasize: true,
                      ),
                    ),
                  ],
                ),
              ),
              if ((lead.noteForPrt ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                _Section(
                  title: 'Note from Asteron',
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(lead.noteForPrt!,
                          style: tt.bodyMedium?.copyWith(height: 1.4)),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              CustomExpansionTile(
                title: 'Payment & transaction',
                initiallyExpanded: lead.status == 'CLOSED',
                data: [
                  {
                    'icon': CupertinoIcons.money_rubl_circle_fill,
                    'label': 'Payment status',
                    'value': lead.paymentStatus ?? '—'
                  },
                  {
                    'icon': Icons.confirmation_number_outlined,
                    'label': 'Transaction ID',
                    'value': lead.txnId ?? '—'
                  },
                  {
                    'icon': Icons.event_available_rounded,
                    'label': 'Closed on',
                    'value': lead.leadClosedOn ?? '—'
                  },
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  const _StatusBanner(
      {required this.color, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status',
                    style: tt.bodySmall?.copyWith(color: color)),
                Text(
                  label,
                  style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700, color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
            child: Text(
              title,
              style: tt.labelLarge
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: scheme.outlineVariant.withValues(alpha: 0.4)),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: scheme.onSurfaceVariant),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(label,
                style: tt.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant)),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _EarningsTile extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final bool emphasize;
  const _EarningsTile({
    required this.title,
    required this.value,
    required this.color,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: emphasize
            ? color.withValues(alpha: 0.10)
            : scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: emphasize
                ? color.withValues(alpha: 0.5)
                : scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: tt.labelMedium
                  ?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Text(
            value,
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
