import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

enum VanqButtonStyle { primary, secondary, text }

/// The VanQ "Button" component: Primary, Secondary, Text and Disabled
/// (disabled = onPressed is null).
class VanqButton extends StatelessWidget {
  const VanqButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = VanqButtonStyle.primary,
    this.expand = true,
    this.horizontalPadding = 24,
  });

  final String label;
  final VoidCallback? onPressed;
  final VanqButtonStyle style;
  final bool expand;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;

    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    if (disabled) {
      bg = AppColors.disabled;
      fg = AppColors.bgSurface;
    } else {
      switch (style) {
        case VanqButtonStyle.primary:
          bg = AppColors.brandPrimary;
          fg = AppColors.bgSurface;
        case VanqButtonStyle.secondary:
          bg = AppColors.bgSurface;
          fg = AppColors.brandPrimary;
          border = const BorderSide(color: AppColors.border);
        case VanqButtonStyle.text:
          bg = Colors.transparent;
          fg = AppColors.brandPrimary;
      }
    }

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
      side: border,
    );

    final child = Material(
      color: bg,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Center(
            widthFactor: expand ? null : 1,
            child: Text(
              label,
              style: AppText.headline(color: fg),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: child) : child;
  }
}

/// Small pill action used in upload tiles, doc review rows, retry, etc.
class PillAction extends StatelessWidget {
  const PillAction({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.background = AppColors.bgSurface,
    this.foreground = AppColors.brandPrimary,
    this.outlined = false,
    this.verticalPadding = 8,
    this.center = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color background;
  final Color foreground;
  final bool outlined;
  final double verticalPadding;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: StadiumBorder(
        side: outlined
            ? const BorderSide(color: AppColors.border)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 12, vertical: verticalPadding),
          child: Row(
            mainAxisSize: center ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment:
                center ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: foreground),
                const SizedBox(width: 6),
              ],
              Text(label, style: AppText.label(color: foreground)),
            ],
          ),
        ),
      ),
    );
  }
}
