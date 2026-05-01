import 'dart:io';

import 'package:asteron_x/service/getx/controller/payment_controller.dart';
import 'package:asteron_x/service/getx/helper/validator.dart';
import 'package:asteron_x/service/models/PaymentModel.dart';
import 'package:asteron_x/widgets/x_button.dart';
import 'package:asteron_x/widgets/x_dialog.dart';
import 'package:asteron_x/widgets/x_inputfield.dart';
import 'package:asteron_x/widgets/x_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final PaymentController paymentController = Get.put(PaymentController());
  final TextEditingController upiController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    paymentController.getPaymentDetails();
  }

  @override
  void dispose() {
    upiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (paymentController.isLoading.value) {
        return const Center(child: CustomLoadingIndicator());
      }

      final details = paymentController.paymentDetails.value;
      if (details != null) {
        return _renderPaymentDetails(details);
      }

      return _renderForm(isUpdating: false);
    });
  }

  Widget _renderForm({required bool isUpdating}) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isUpdating ? 'Update payment details' : 'Set up payments',
              style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Verify your details daily. If anything looks off, contact Asteron support.',
              style: tt.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            MyTextField(
              controller: upiController,
              labelText: 'UPI ID',
              hintText: 'username@bank',
              obscureText: false,
              prefixIcon: const Icon(Icons.alternate_email_rounded),
            ),
            const SizedBox(height: 16),
            _QrUploadCard(
              image: _image,
              existingUrl:
                  paymentController.paymentDetails.value?.data?.qrCode,
              onTap: _pickImage,
            ),
            const SizedBox(height: 24),
            MyButton(
              onTap: _onConfirm,
              text: isUpdating ? 'Save changes' : 'Confirm',
              icon: const Icon(Icons.check_circle_outline_rounded),
            ),
            if (isUpdating) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => paymentController.isEditing(false),
                child: const Text('Cancel'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _renderPaymentDetails(PaymentModel payment) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Obx(() {
      if (paymentController.isEditing.value) {
        if (upiController.text.isEmpty) {
          upiController.text = payment.data?.upiId ?? '';
        }
        return _renderForm(isUpdating: true);
      }

      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Your payout details',
                  style: tt.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(
                'These are the details Asteron uses to send your earnings.',
                style:
                    tt.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: scheme.outlineVariant.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: payment.data?.qrCode != null
                          ? Image.network(
                              payment.data!.qrCode!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                CupertinoIcons.qrcode,
                                size: 80,
                                color: scheme.onSurfaceVariant,
                              ),
                            )
                          : Icon(CupertinoIcons.qrcode,
                              size: 80, color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 20),
                    SelectableText(
                      payment.data?.upiId ?? '—',
                      style: tt.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'UPI ID',
                      style: tt.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: scheme.outlineVariant
                        .withValues(alpha: 0.5)),
                    const SizedBox(height: 12),
                    _PartnerInfoRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Partner',
                      value: payment.data?.partner?.name ?? '—',
                    ),
                    const SizedBox(height: 8),
                    _PartnerInfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: payment.data?.partner?.phone ?? '—',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                onTap: () => paymentController.isEditing(true),
                text: 'Update payment details',
                icon: const Icon(Icons.edit_rounded),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() => _image = File(picked.path));
  }

  void _onConfirm() {
    final upiId = upiController.text.trim();
    if (upiId.isEmpty || _image == null) {
      showCustomCupertinoAlertDialog(
        title: 'Missing details',
        message: 'Please provide both your UPI ID and a QR code image.',
      );
      return;
    }
    if (!Validation.isValidUPI(upiId)) {
      showCustomCupertinoAlertDialog(
        title: 'Invalid UPI ID',
        message: 'Please enter a valid UPI ID like username@bank.',
      );
      return;
    }
    paymentController.addPaymentDetails(_image!, upiId);
    paymentController.isEditing(false);
  }
}

class _QrUploadCard extends StatelessWidget {
  final File? image;
  final String? existingUrl;
  final VoidCallback onTap;

  const _QrUploadCard(
      {required this.image, required this.existingUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.6)),
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // 1. New file picked locally — show it with an edit affordance.
    if (image != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(image!, fit: BoxFit.cover),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: scheme.surface.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.edit_rounded, size: 16, color: scheme.primary),
            ),
          ),
        ],
      );
    }

    // 2. Existing remote image — try to load, fall back to a friendly
    //    placeholder if the URL is missing, removed, or unreachable.
    if (existingUrl != null && existingUrl!.trim().isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            existingUrl!,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: scheme.primary,
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (_, __, ___) => _placeholder(
              context,
              icon: Icons.image_not_supported_outlined,
              title: 'Couldn\'t load your saved QR',
              subtitle: 'Tap to upload a new one',
              warn: true,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: scheme.surface.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.edit_rounded, size: 16, color: scheme.primary),
            ),
          ),
        ],
      );
    }

    // 3. Nothing there yet — first-time upload prompt.
    return _placeholder(
      context,
      icon: CupertinoIcons.qrcode,
      title: 'Upload your UPI QR code',
      subtitle: 'JPG or PNG, square preferred',
    );
  }

  Widget _placeholder(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    bool warn = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final accent = warn ? scheme.error : scheme.onSurfaceVariant;
    return Container(
      color: warn
          ? scheme.errorContainer.withValues(alpha: 0.25)
          : Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: warn
                  ? scheme.errorContainer.withValues(alpha: 0.6)
                  : scheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36, color: accent),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: tt.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _PartnerInfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: scheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(label,
            style: tt.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
