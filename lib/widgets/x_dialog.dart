import 'package:asteron_x/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

void showCustomCupertinoAlertDialog({
  required String title,
  required String message,
  String cancelButtonText = "Cancel", // Default Cancel/Hide button text
  VoidCallback? onCancelPressed, // Callback for Cancel button
  String? actionButtonText, // Optional Action button text
  VoidCallback? onActionPressed, // Callback for Action button
  bool barrierDismissible = false, // Default barrier dismissibility
  bool isForced = false, // Prevent user from dismissing if true
}) {
  // Replace escaped newline with actual newline
  final formattedMessage = message.replaceAll('\\n', '\n');

  Get.dialog(
    WillPopScope(
      onWillPop: () async {
        if (isForced) {
          // Prevent back button when forced
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: CupertinoAlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            color: textPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            textAlign: TextAlign.start,
            formattedMessage, // Use properly formatted message
            style: const TextStyle(
              fontSize: 16,
              color: textPrimaryColor,
            ),
          ),
        ),
        actions: [
          if (!isForced)
            CupertinoDialogAction(
              onPressed: () {
                Get.back(); // Close the dialog
                if (onCancelPressed != null) {
                  onCancelPressed();
                }
              },
              isDestructiveAction: true,
              child: Text(
                cancelButtonText,
                style: const TextStyle(color: textPrimaryColor),
              ),
            ),
          if (actionButtonText != null)
            CupertinoDialogAction(
              onPressed: () {
                if (onActionPressed != null) {
                  onActionPressed();
                } else {
                  Get.back();
                }
              },
              child: Text(
                actionButtonText,
                style: const TextStyle(color: btnBgColor),
              ),
            ),
        ],
      ),
    ),
    barrierDismissible: !isForced && barrierDismissible,
  );
}
