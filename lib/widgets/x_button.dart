import 'package:flutter/material.dart';

/// Themed primary button. Uses ElevatedButtonTheme so it adapts to light/dark.
/// `buttonColor` overrides the theme primary if you need a custom accent.
class MyButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final Color? buttonColor;
  final Widget? icon;
  final bool fullWidth;
  final bool loading;

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    this.buttonColor,
    this.icon,
    this.fullWidth = true,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color bg = buttonColor ?? scheme.primary;
    final Color fg = ThemeData.estimateBrightnessForColor(bg) == Brightness.dark
        ? Colors.white
        : Colors.black;

    final child = loading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                IconTheme(
                    data: IconThemeData(color: fg, size: 18), child: icon!),
                const SizedBox(width: 8),
              ],
              Text(text),
            ],
          );

    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        disabledBackgroundColor: scheme.onSurface.withValues(alpha: 0.12),
        disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
      ),
      onPressed: loading ? null : onTap,
      child: child,
    );

    if (!fullWidth) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
