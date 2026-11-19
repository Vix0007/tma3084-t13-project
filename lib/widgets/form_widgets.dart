import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// "Text Field" component: label, rounded input, helper text.
class VanqTextField extends StatelessWidget {
  const VanqTextField({
    super.key,
    required this.label,
    required this.hint,
    this.helper,
    this.controller,
    this.obscure = false,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  final String label;
  final String hint;
  final String? helper;
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.label()),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          style: AppText.body(),
          cursorColor: AppColors.brandPrimary,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppText.body(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.bgSurface,
            isDense: true,
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide:
                  const BorderSide(color: AppColors.brandPrimary, width: 1.5),
            ),
          ),
        ),
        if (helper != null) ...[
          const SizedBox(height: 8),
          Text(helper!, style: AppText.caption()),
        ],
      ],
    );
  }
}

/// "Chip" component – selected = navy fill, unselected = white with border.
class VanqChip extends StatelessWidget {
  const VanqChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.brandPrimary : AppColors.bgSurface,
      shape: StadiumBorder(
        side: selected
            ? BorderSide.none
            : const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: AppText.label(
              color: selected ? AppColors.bgSurface : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Wrap of single-select chips.
class ChipGroup extends StatelessWidget {
  const ChipGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          VanqChip(
            label: o,
            selected: o == selected,
            onTap: () => onSelected(o),
          ),
      ],
    );
  }
}

/// "Segmented Control" – e.g. Self-drive / With driver.
class SegmentedControl extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: i == selectedIndex
                        ? AppColors.bgSurface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow:
                        i == selectedIndex ? AppColors.cardShadow : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    options[i],
                    style: AppText.label(
                      color: i == selectedIndex
                          ? AppColors.brandPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// "Checkbox" component – outline box + body label.
class VanqCheckbox extends StatelessWidget {
  const VanqCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              value ? 'assets/icons/checkbox_on.svg' : 'assets/icons/checkbox_off.svg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            Text(label, style: AppText.body()),
          ],
        ),
      ),
    );
  }
}
