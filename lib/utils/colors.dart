import 'package:flutter/material.dart';

/// Legacy color constants kept for backwards compatibility with screens that
/// still reference them directly. New code should pull colors from
/// `Theme.of(context).colorScheme` / `context.semantics` (see utils/theme.dart).
///
/// Values were updated to align with the indigo/neutral palette so screens
/// that haven't been fully migrated still look consistent.

// Brand seed (indigo)
const Color primaryColor = Color(0xFF4F46E5);
const Color primaryColorDark = Color(0xFF818CF8);

// Surfaces (light)
const Color bgColor = Color(0xFFFFFFFF);
const Color secondaryColor = Color(0xFFF1F5F9);
const Color mainGridColor = Color(0xFFFFFFFF);

// Text
const Color textPrimaryColor = Color(0xFF0F172A);
const Color textSecondaryColor = Color(0xFFFFFFFF);
const Color textHighlightColor = Color(0xFF4F46E5);

// AppBar (legacy — prefer theme.appBarTheme)
const Color appbarPrimaryColor = Color(0xFFFFFFFF);
const Color appbarSecondary = Color(0xFF0F172A);
const Color appBarColor = Color(0xFFFFFFFF);

// Icons
const Color primaryIconColor = Color(0xFFDC2626);
const Color secondaryIconColor = Color(0xFF0F172A);

// Greys
const Color greyColor = Color(0xFF64748B);

// Status (semantic)
const Color loadingColor = Color(0xFF4F46E5);
const Color errorColor = Color(0xFFDC2626);
const Color warningColor = Color(0xFFB45309);
const Color successColor = Color(0xFF15803D);

// Buttons
const Color btnBgColor = Color(0xFF4F46E5);
const Color btnBgColor2 = Color(0xFF0F172A);
