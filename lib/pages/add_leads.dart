import 'package:asteron_x/service/getx/controller/leads_controller.dart';
import 'package:asteron_x/service/getx/controller/user_controller.dart';
import 'package:asteron_x/service/getx/helper/validator.dart';
import 'package:asteron_x/widgets/x_button.dart';
import 'package:asteron_x/widgets/x_inputfield.dart';
import 'package:asteron_x/widgets/x_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddLeads extends StatefulWidget {
  final Function onLeadSubmitted;

  const AddLeads({super.key, required this.onLeadSubmitted});

  @override
  State<AddLeads> createState() => _AddLeadsState();
}

class _AddLeadsState extends State<AddLeads> {
  static const _steps = <_StepMeta>[
    _StepMeta('Customer', 'Who is the buyer?', Icons.person_outline_rounded),
    _StepMeta('Details', 'Lead context & finance', Icons.assignment_outlined),
    _StepMeta('Review', 'Confirm & submit', Icons.fact_check_outlined),
  ];

  int _currentStep = 0;

  final UserController userController = Get.put(UserController());
  final LeadsController leadsController = Get.put(LeadsController());

  // Field controllers
  final _name = TextEditingController();
  final _vehicle = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();
  final _notes = TextEditingController();

  // Finance is a segmented choice, not free text.
  String? _finance;

  // Per-field error messages — drive inline red borders + helper text.
  String? _nameErr, _vehicleErr, _phoneErr, _cityErr, _financeErr, _notesErr;

  @override
  void initState() {
    super.initState();
    userController.getUserDataFromSF();
  }

  @override
  void dispose() {
    _name.dispose();
    _vehicle.dispose();
    _phone.dispose();
    _city.dispose();
    _notes.dispose();
    super.dispose();
  }

  // ---------- Validation ----------

  bool _validateStep0() {
    final n = _name.text.trim();
    final v = _vehicle.text.trim();
    final p = _phone.text.trim();

    setState(() {
      _nameErr = n.isEmpty
          ? 'Required'
          : (!Validation.isValidName(n) ? 'Use only letters and spaces' : null);
      _vehicleErr = v.isEmpty
          ? 'Required'
          : (!Validation.isVehicleNameValid(v)
              ? '3 to 20 characters'
              : null);
      _phoneErr = p.isEmpty
          ? 'Required'
          : (!Validation.isValidPhone(p)
              ? 'Enter a valid 10-digit Indian number'
              : null);
    });

    return _nameErr == null && _vehicleErr == null && _phoneErr == null;
  }

  bool _validateStep1() {
    final c = _city.text.trim();
    final notes = _notes.text.trim();

    setState(() {
      _cityErr = c.isEmpty ? 'Required' : null;
      _financeErr = _finance == null ? 'Pick one' : null;
      _notesErr = notes.isNotEmpty && !Validation.isNotesValid(notes)
          ? '3 to 100 characters'
          : null;
    });

    return _cityErr == null && _financeErr == null && _notesErr == null;
  }

  // ---------- Actions ----------

  void _next() {
    final ok = _currentStep == 0 ? _validateStep0() : _validateStep1();
    if (!ok) return;
    setState(() => _currentStep += 1);
  }

  void _back() {
    setState(() => _currentStep -= 1);
  }

  void _submit() {
    // Re-validate everything on submit in case fields changed after step nav.
    final s0 = _validateStep0();
    final s1 = _validateStep1();
    if (!s0) {
      setState(() => _currentStep = 0);
      return;
    }
    if (!s1) {
      setState(() => _currentStep = 1);
      return;
    }

    if (userController.user.value == null) {
      customToast(
        'Profile still loading — please try again in a moment',
        Icons.hourglass_empty_rounded,
        Theme.of(context).colorScheme.error,
        Theme.of(context).colorScheme.onSurface,
      ).show(context);
      userController.getUserDataFromSF();
      return;
    }

    leadsController.addNewLead(
      _name.text.trim(),
      _vehicle.text.trim(),
      _phone.text.trim(),
      _city.text.trim(),
      _finance!,
      _notes.text.trim(),
      widget.onLeadSubmitted,
    );
  }

  // ---------- Build ----------

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        _StepHeader(
          steps: _steps,
          currentStep: _currentStep,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.topCenter,
              child: _buildStep(_currentStep),
            ),
          ),
        ),
        _BottomActionBar(
          showBack: _currentStep > 0,
          isLast: _currentStep == _steps.length - 1,
          onBack: _back,
          onContinue: _next,
          onSubmit: _submit,
          loading: leadsController.isLoading,
          surface: scheme.surface,
          divider: scheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ],
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return _StepCard(
          icon: _steps[0].icon,
          title: _steps[0].title,
          subtitle: _steps[0].subtitle,
          children: [
            MyTextField(
              controller: _name,
              labelText: 'Customer name',
              hintText: 'e.g. Rahul Sharma',
              obscureText: false,
              errorText: _nameErr,
              prefixIcon: const Icon(Icons.person_outline_rounded),
              onChanged: (_) {
                if (_nameErr != null) setState(() => _nameErr = null);
              },
            ),
            const SizedBox(height: 16),
            MyTextField(
              controller: _vehicle,
              labelText: 'Vehicle of interest',
              hintText: 'e.g. Honda Activa 6G',
              obscureText: false,
              errorText: _vehicleErr,
              prefixIcon: const Icon(Icons.two_wheeler_rounded),
              onChanged: (_) {
                if (_vehicleErr != null) setState(() => _vehicleErr = null);
              },
            ),
            const SizedBox(height: 16),
            MyTextField(
              controller: _phone,
              labelText: 'Phone number',
              hintText: '10-digit Indian number',
              obscureText: false,
              keyboardType: TextInputType.phone,
              maxLength: 13,
              errorText: _phoneErr,
              prefixIcon: const Icon(Icons.phone_outlined),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
              ],
              onChanged: (_) {
                if (_phoneErr != null) setState(() => _phoneErr = null);
              },
            ),
          ],
        );
      case 1:
        return _StepCard(
          icon: _steps[1].icon,
          title: _steps[1].title,
          subtitle: _steps[1].subtitle,
          children: [
            MyTextField(
              controller: _city,
              labelText: 'City',
              hintText: 'Customer city',
              obscureText: false,
              errorText: _cityErr,
              prefixIcon: const Icon(Icons.location_on_outlined),
              onChanged: (_) {
                if (_cityErr != null) setState(() => _cityErr = null);
              },
            ),
            const SizedBox(height: 20),
            _FieldLabel('Interested in finance?'),
            const SizedBox(height: 8),
            _FinanceSegments(
              value: _finance,
              onChanged: (v) {
                setState(() {
                  _finance = v;
                  _financeErr = null;
                });
              },
              error: _financeErr,
            ),
            const SizedBox(height: 20),
            MyTextField(
              controller: _notes,
              labelText: 'Notes (optional)',
              hintText: 'Anything the team should know — 3 to 100 characters',
              obscureText: false,
              minLines: 3,
              maxLines: 5,
              maxLength: 100,
              errorText: _notesErr,
              prefixIcon: const Icon(Icons.notes_outlined),
              onChanged: (_) {
                if (_notesErr != null) setState(() => _notesErr = null);
              },
            ),
          ],
        );
      case 2:
        return _ReviewCard(
          icon: _steps[2].icon,
          title: _steps[2].title,
          subtitle: _steps[2].subtitle,
          name: _name.text.trim(),
          vehicle: _vehicle.text.trim(),
          phone: _phone.text.trim(),
          city: _city.text.trim(),
          finance: _finance ?? '—',
          notes: _notes.text.trim(),
          onEdit: (s) => setState(() => _currentStep = s),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ====================== Helpers / sub-widgets ======================

class _StepMeta {
  final String title;
  final String subtitle;
  final IconData icon;
  const _StepMeta(this.title, this.subtitle, this.icon);
}

class _StepHeader extends StatelessWidget {
  final List<_StepMeta> steps;
  final int currentStep;

  const _StepHeader({required this.steps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final progress = (currentStep + 1) / steps.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          bottom:
              BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.4)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Step ${currentStep + 1} of ${steps.length}',
                style: tt.labelMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const Spacer(),
              Text(
                steps[currentStep].title,
                style: tt.labelMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: scheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;

  const _StepCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: scheme.onPrimaryContainer, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: tt.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ...children,
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _FinanceSegments extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final String? error;

  const _FinanceSegments({
    required this.value,
    required this.onChanged,
    required this.error,
  });

  static const _options = <(String, IconData)>[
    ('Yes', Icons.check_circle_outline_rounded),
    ('No', Icons.cancel_outlined),
    ('Unsure', Icons.help_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: error != null ? scheme.error : Colors.transparent,
              width: error != null ? 1.5 : 0,
            ),
          ),
          child: Row(
            children: _options.map((opt) {
              final selected = value == opt.$1;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(opt.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? scheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          opt.$2,
                          size: 18,
                          color: selected
                              ? scheme.onPrimary
                              : scheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          opt.$1,
                          style: TextStyle(
                            color: selected
                                ? scheme.onPrimary
                                : scheme.onSurface,
                            fontFamily: 'montserrat',
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 6),
            child: Text(
              error!,
              style: tt.bodySmall?.copyWith(color: scheme.error),
            ),
          ),
      ],
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final bool showBack;
  final bool isLast;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final VoidCallback onSubmit;
  final RxBool loading;
  final Color surface;
  final Color divider;

  const _BottomActionBar({
    required this.showBack,
    required this.isLast,
    required this.onBack,
    required this.onContinue,
    required this.onSubmit,
    required this.loading,
    required this.surface,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: divider)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (showBack)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Back'),
                ),
              ),
            if (showBack) const SizedBox(width: 12),
            Expanded(
              child: isLast
                  ? Obx(() => MyButton(
                        onTap: onSubmit,
                        text: 'Submit lead',
                        loading: loading.value,
                        icon: const Icon(Icons.send_rounded),
                      ))
                  : MyButton(
                      onTap: onContinue,
                      text: 'Continue',
                      icon: const Icon(Icons.arrow_forward_rounded),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String name;
  final String vehicle;
  final String phone;
  final String city;
  final String finance;
  final String notes;
  final ValueChanged<int> onEdit;

  const _ReviewCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.name,
    required this.vehicle,
    required this.phone,
    required this.city,
    required this.finance,
    required this.notes,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final s0 = <(IconData, String, String)>[
      (Icons.person_outline_rounded, 'Customer', name),
      (Icons.two_wheeler_rounded, 'Vehicle', vehicle),
      (Icons.phone_outlined, 'Phone', phone),
    ];
    final s1 = <(IconData, String, String)>[
      (Icons.location_on_outlined, 'City', city),
      (Icons.account_balance_wallet_outlined, 'Finance', finance),
      if (notes.isNotEmpty) (Icons.notes_outlined, 'Notes', notes),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepCard(
          icon: icon,
          title: title,
          subtitle: subtitle,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: scheme.tertiaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 18, color: scheme.onSurface),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Submitting fake data may result in account suspension.',
                      style: tt.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _ReviewSection(
              title: 'Customer',
              entries: s0,
              onEdit: () => onEdit(0),
              scheme: scheme,
              tt: tt,
            ),
            const SizedBox(height: 12),
            _ReviewSection(
              title: 'Details',
              entries: s1,
              onEdit: () => onEdit(1),
              scheme: scheme,
              tt: tt,
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewSection extends StatelessWidget {
  final String title;
  final List<(IconData, String, String)> entries;
  final VoidCallback onEdit;
  final ColorScheme scheme;
  final TextTheme tt;

  const _ReviewSection({
    required this.title,
    required this.entries,
    required this.onEdit,
    required this.scheme,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Row(
              children: [
                Text(
                  title.toUpperCase(),
                  style: tt.labelSmall?.copyWith(
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onEdit,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, 32),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 14),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: scheme.outlineVariant.withValues(alpha: 0.5),
          ),
          ...List.generate(entries.length, (i) {
            final (icon, label, value) = entries[i];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, size: 18, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 80,
                        child: Text(
                          label,
                          style: tt.bodyMedium
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          value.isEmpty ? '—' : value,
                          style: tt.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < entries.length - 1)
                  Divider(
                    height: 1,
                    color: scheme.outlineVariant.withValues(alpha: 0.5),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
