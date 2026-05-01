import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Themed alert dialog — replaces the previous Cupertino-only one so it adapts
/// to light/dark Material themes.
void showCustomCupertinoAlertDialog({
  required String title,
  required String message,
  String cancelButtonText = "Close",
  VoidCallback? onCancelPressed,
  String? actionButtonText,
  VoidCallback? onActionPressed,
  bool barrierDismissible = false,
  bool isForced = false,
}) {
  final formattedMessage = message.replaceAll('\\n', '\n');

  Get.dialog(
    PopScope(
      canPop: !isForced,
      child: Builder(
        builder: (context) {
          final scheme = Theme.of(context).colorScheme;
          final tt = Theme.of(context).textTheme;
          return AlertDialog(
            title: Text(title, style: tt.titleLarge),
            content: Text(formattedMessage, style: tt.bodyMedium),
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            actions: [
              if (!isForced)
                TextButton(
                  onPressed: () {
                    Get.back();
                    onCancelPressed?.call();
                  },
                  child: Text(cancelButtonText),
                ),
              if (actionButtonText != null)
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(80, 40),
                    backgroundColor: scheme.primary,
                  ),
                  onPressed: () {
                    if (onActionPressed != null) {
                      onActionPressed();
                    } else {
                      Get.back();
                    }
                  },
                  child: Text(actionButtonText),
                ),
            ],
          );
        },
      ),
    ),
    barrierDismissible: !isForced && barrierDismissible,
  );
}
