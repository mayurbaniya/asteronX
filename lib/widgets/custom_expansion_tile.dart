import 'package:flutter/material.dart';

/// Themed expansion tile — adapts to light/dark via ColorScheme.
class CustomExpansionTile extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;
  final bool initiallyExpanded;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.data,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          initiallyExpanded: initiallyExpanded || title == 'Summary',
          iconColor: scheme.primary,
          collapsedIconColor: scheme.onSurfaceVariant,
          title: Text(
            title,
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          children: data
              .map((item) => _buildRow(
                    context,
                    item['icon'] as IconData,
                    item['label'] as String,
                    (item['value'] ?? '-').toString(),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, IconData icon, String label, String value) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: scheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: tt.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant)),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
