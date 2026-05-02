import 'package:asteron_x/service/getx/controller/leads_controller.dart';
import 'package:asteron_x/service/models/leads_model.dart';
import 'package:asteron_x/utils/theme.dart';
import 'package:asteron_x/widgets/x_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyLeads extends StatefulWidget {
  const MyLeads({super.key});

  @override
  State<MyLeads> createState() => _MyLeadsState();
}

class _MyLeadsState extends State<MyLeads> {
  final LeadsController leadsController = Get.put(LeadsController());

  @override
  void initState() {
    super.initState();
    leadsController.fetchAllLeads();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: _LegendStrip(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Obx(() {
            final total = leadsController.leads.value?.totalElements ?? 0;
            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$total ${total == 1 ? 'lead' : 'leads'}',
                        style: tt.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'shared by you',
                        style: tt.bodySmall
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _showSortOptions(context),
                  icon: const Icon(Icons.sort_rounded, size: 18),
                  label: const Text('Sort'),
                ),
              ],
            );
          }),
        ),
        Expanded(
          child: Obx(() {
            if (leadsController.isLoading.value) {
              return const Center(child: CustomLoadingIndicator());
            }

            final leads = leadsController.leads.value;
            final content = leads?.content;
            if (content == null || content.isEmpty) {
              return _EmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async => leadsController.fetchAllLeads(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: content.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  if (i == content.length) {
                    return PaginationFooter(
                      currentPage: leads?.pageNumber ?? 1,
                      totalPages: leads?.totalPages ?? 1,
                      onPreviousPage: leadsController.loadPreviousPage,
                      onNextPage: leadsController.loadNextPage,
                      isLastPage: leads?.lastPage ?? false,
                    );
                  }
                  return _LeadCard(lead: content[i]);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  void _showSortOptions(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.arrow_downward_rounded),
                title: const Text('Newest first'),
                onTap: () {
                  leadsController.updateSortOrder('time', 'desc');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_upward_rounded),
                title: const Text('Oldest first'),
                onTap: () {
                  leadsController.updateSortOrder('time', 'asc');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _LegendStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.semantics;
    final entries = <(Color, String)>[
      (s.leadNew, 'New'),
      (s.leadOngoing, 'Ongoing'),
      (s.leadClosed, 'Closed'),
      (s.leadDeleted, 'Deleted'),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: entries
          .map((e) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration:
                        BoxDecoration(color: e.$1, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    e.$2,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ))
          .toList(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.inbox_outlined,
                  size: 48, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Text(
              'No leads yet',
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Submit a new lead from the Add tab to get started.',
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeadCard extends StatelessWidget {
  final Content lead;
  const _LeadCard({required this.lead});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final s = context.semantics;

    final (statusColor, statusIcon, statusLabel) = switch (lead.status) {
      'NEW' => (s.leadNew, Icons.fiber_new_rounded, 'New'),
      'IN_PROGRESS' => (s.leadOngoing, Icons.sync_rounded, 'Ongoing'),
      'CLOSED' => (s.leadClosed, Icons.check_circle_rounded, 'Closed'),
      'CANCELLED' => (s.leadDeleted, Icons.delete_outline_rounded, 'Cancelled'),
      _ => (scheme.outline, Icons.help_outline_rounded, lead.status ?? '—'),
    };

    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.toNamed('/details', arguments: lead),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.4)),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.person_rounded,
                    color: scheme.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lead.clientName ?? '—',
                            style: tt.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusChip(
                          color: statusColor,
                          icon: statusIcon,
                          label: statusLabel,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lead.vehicle ?? '—',
                      style: tt.bodyMedium
                          ?.copyWith(color: scheme.onSurfaceVariant),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if ((lead.leadProvider?.name ?? '').isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.business_rounded,
                              size: 14, color: scheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            lead.leadProvider!.name!,
                            style: tt.bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  const _StatusChip(
      {required this.color, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'montserrat',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class PaginationFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final bool isLastPage;

  const PaginationFooter({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton.filledTonal(
            onPressed: currentPage == 0 ? null : onPreviousPage,
            icon: const Icon(CupertinoIcons.chevron_left, size: 18),
          ),
          Text(
            'Page ${currentPage + 1} of ${totalPages == 0 ? 1 : totalPages}',
            style: tt.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          IconButton.filledTonal(
            onPressed: isLastPage ? null : onNextPage,
            icon: const Icon(CupertinoIcons.chevron_right, size: 18),
          ),
        ],
      ),
    );
  }
}
