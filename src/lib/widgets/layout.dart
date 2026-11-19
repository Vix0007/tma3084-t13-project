import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Scrollable screen body with 24px gaps between sections (Figma auto-layout)
/// and room at the bottom for a floating nav or action bar.
class ScreenScroll extends StatelessWidget {
  const ScreenScroll({
    super.key,
    required this.children,
    this.bottomSpace = 120,
    this.gap = 24,
    this.topPadding = 56,
  });

  final List<Widget> children;
  final double bottomSpace;
  final double gap;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return SingleChildScrollView(
      // Figma frames include a ~24px status bar in their 56px top padding.
      // In a browser there is no status bar (top == 0), so never go below
      // the Figma value.
      padding: EdgeInsets.fromLTRB(
          20, math.max(topPadding, topPadding - 24 + top), 20, bottomSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Greeting line + Large Title, used at the top of tab screens.
class PageHeader extends StatelessWidget {
  const PageHeader({super.key, this.overline, required this.title, this.trailing});
  final String? overline;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (overline != null) ...[
          Text(overline!, style: AppText.body(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
        ],
        Text(title, style: AppText.largeTitle()),
      ],
    );
    if (trailing == null) return text;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Expanded(child: text), trailing!],
    );
  }
}

/// "Top Bar" component – back arrow + Title.
class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.title, this.onBack});
  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkResponse(
          onTap: onBack ?? () => Navigator.of(context).maybePop(),
          radius: 22,
          child: SvgPicture.asset('assets/icons/back.svg', width: 24, height: 24),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: AppText.title())),
      ],
    );
  }
}

/// Frosted glass container (the "Glass" effect in Figma).
class Glass extends StatelessWidget {
  const Glass({
    super.key,
    required this.child,
    required this.radius,
    this.color = AppColors.glassNav,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double radius;
  final Color color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius);
    return ClipRRect(
      borderRadius: r,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            borderRadius: r,
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: AppColors.cardShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Bottom action bar that floats over content (price bar, submit bar, etc.).
class FloatingActionBar extends StatelessWidget {
  const FloatingActionBar({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Positioned(
      left: 20,
      right: 20,
      bottom: 24 + bottom,
      child: Glass(
        radius: 28,
        color: AppColors.glassBar,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

class NavItem {
  const NavItem(this.icon, this.label);

  /// Figma icon name in assets/icons (e.g. 'home' -> home.svg / home_active.svg).
  final String icon;
  final String label;
}

/// Floating glass bottom navigation (Customer / Driver / Admin variants).
class GlassBottomNav extends StatelessWidget {
  const GlassBottomNav({
    super.key,
    required this.items,
    required this.index,
    required this.onTap,
  });

  final List<NavItem> items;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Positioned(
      left: 20,
      right: 20,
      bottom: 24 + bottom,
      child: Glass(
        radius: 36,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: i == index
                          ? AppColors.brandAccentSoft
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/${items[i].icon}${i == index ? '_active' : ''}.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          items[i].label,
                          style: AppText.caption(
                            color: i == index
                                ? AppColors.brandPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// VanQ logo. Uses assets/images/vanq_logo.png if present, otherwise draws
/// a close stand-in so the app still runs.
class VanqLogo extends StatelessWidget {
  const VanqLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 171,
      child: Image.asset(
        'assets/images/vanq_logo.png',
        fit: BoxFit.contain,
        alignment: Alignment.centerLeft,
        errorBuilder: (_, __, ___) => const _LogoFallback(),
      ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.brandPrimary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.search_rounded, size: 46, color: AppColors.bgSurface),
              Padding(
                padding: EdgeInsets.only(right: 6, bottom: 6),
                child: Icon(Icons.airport_shuttle_rounded,
                    size: 18, color: AppColors.brandAccent),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: AppText.title(color: AppColors.brandPrimary)
                    .copyWith(fontWeight: FontWeight.w800, fontSize: 24),
                children: const [
                  TextSpan(text: 'Van'),
                  TextSpan(
                      text: 'Q',
                      style: TextStyle(color: AppColors.brandAccent)),
                ],
              ),
            ),
            Text(
              'VAN RENTAL, SIMPLIFIED',
              style: AppText.caption(color: AppColors.brandPrimary)
                  .copyWith(fontSize: 6, letterSpacing: 1, height: 1),
            ),
          ],
        ),
      ],
    );
  }
}

/// Van photo with a fallback when the image file is missing.
class VanImage extends StatelessWidget {
  const VanImage(this.path, {super.key, this.height = 160});
  final String path;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: AppColors.bgScreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Icon(Icons.airport_shuttle_rounded,
                size: 72, color: AppColors.disabled),
          ),
        ),
      ),
    );
  }
}

/// Draws a dashed rounded border around [child] (empty Upload Tile).
class DashedBorderBox extends StatelessWidget {
  const DashedBorderBox({
    super.key,
    required this.child,
    this.radius = 20,
    this.color = AppColors.border,
  });

  final Widget child;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedPainter(radius: radius, color: color),
      child: child,
    );
  }
}

class _DashedPainter extends CustomPainter {
  _DashedPainter({required this.radius, required this.color});
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    ).deflate(0.75);
    final path = Path()..addRRect(rrect);
    const dash = 6.0;
    const gap = 4.0;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedPainter old) =>
      old.color != color || old.radius != radius;
}

/// Shows a small floating confirmation message.
void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message, style: AppText.body(color: AppColors.bgSurface)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.brandPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      ),
    );
}
