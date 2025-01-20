import 'package:asteron_x/utils/colors.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

DelightToastBar customToast(
    String title, IconData iconData, Color iconColor, Color titleColor) {
  return DelightToastBar(
    position: DelightSnackbarPosition.top,
    autoDismiss: true,
    builder: (context) {
      return ToastCard(
          color: secondaryColor,
          leading: Icon(
            iconData,
            color: iconColor,
          ),
          title: Text(
            title,
            style:
                TextStyle(color: titleColor, overflow: TextOverflow.ellipsis),
          ));
    },
  );
}
