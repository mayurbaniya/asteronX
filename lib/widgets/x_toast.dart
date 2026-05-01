import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

/// Themed toast — caller still passes title/icon, but background/foreground
/// derive from the active theme so it looks right in both modes.
DelightToastBar customToast(
  String title,
  IconData iconData,
  Color iconColor,
  Color titleColor,
) {
  return DelightToastBar(
    position: DelightSnackbarPosition.top,
    autoDismiss: true,
    builder: (context) {
      final scheme = Theme.of(context).colorScheme;
      return ToastCard(
        color: scheme.surfaceContainerHigh,
        leading: Icon(iconData, color: iconColor),
        title: Text(
          title,
          style: TextStyle(
            color: scheme.onSurface,
            overflow: TextOverflow.ellipsis,
            fontFamily: 'montserrat',
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    },
  );
}
