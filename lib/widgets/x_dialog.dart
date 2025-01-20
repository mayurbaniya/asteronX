import 'package:asteron_x/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

void showCustomCupertinoAlertDialog({
  required String title,
  required String message,
  String buttonText = "Close",
}) {
  Get.dialog(
    CupertinoAlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          color: textPrimaryColor, // Red color title
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            color: textPrimaryColor,
          ),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          isDefaultAction: true,
          child: Text(
            buttonText,
            style: const TextStyle(
              color: btnBgColor, // Blue close button
            ),
          ),
        ),
      ],
    ),
    barrierDismissible: false, // Prevent dismissing by tapping outside
  );
}
