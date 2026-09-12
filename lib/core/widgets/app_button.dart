import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  danger,
  ghost,
  success,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    Color bg;
    Color fg;
    BorderSide border;

    switch (widget.variant) {
      case AppButtonVariant.primary:
        bg = isEnabled
            ? (_isHovered ? AppColors.primaryLight : AppColors.primary)
            : AppColors.surfaceMuted;
        fg = isEnabled ? AppColors.textInverse : AppColors.textLight;
        border = BorderSide.none;
        break;
      case AppButtonVariant.secondary:
        bg = isEnabled
            ? (_isHovered ? const Color(0xFF0F766E) : AppColors.secondary)
            : AppColors.surfaceMuted;
        fg = isEnabled ? AppColors.textInverse : AppColors.textLight;
        border = BorderSide.none;
        break;
      case AppButtonVariant.outline:
        bg = _isHovered ? AppColors.surfaceSubtle : Colors.transparent;
        fg = isEnabled ? AppColors.textPrimary : AppColors.textLight;
        border = BorderSide(
          color: isEnabled
              ? (_isHovered ? AppColors.primaryAccent : AppColors.border)
              : AppColors.borderSubtle,
        );
        break;
      case AppButtonVariant.danger:
        bg = isEnabled
            ? (_isHovered ? const Color(0xFFB91C1C) : AppColors.danger)
            : AppColors.surfaceMuted;
        fg = isEnabled ? AppColors.textInverse : AppColors.textLight;
        border = BorderSide.none;
        break;
      case AppButtonVariant.success:
        bg = isEnabled
            ? (_isHovered ? const Color(0xFF047857) : AppColors.success)
            : AppColors.surfaceMuted;
        fg = isEnabled ? AppColors.textInverse : AppColors.textLight;
        border = BorderSide.none;
        break;
      case AppButtonVariant.ghost:
        bg = _isHovered ? AppColors.primarySurface : Colors.transparent;
        fg = isEnabled ? AppColors.primaryAccent : AppColors.textLight;
        border = BorderSide.none;
        break;
    }

    EdgeInsets padding;
    double fontSize;
    double iconSize;
    switch (widget.size) {
      case AppButtonSize.small:
        padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8);
        fontSize = 12.5;
        iconSize = 16;
        break;
      case AppButtonSize.medium:
        padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
        fontSize = 14;
        iconSize = 18;
        break;
      case AppButtonSize.large:
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
        fontSize = 15;
        iconSize = 20;
        break;
    }

    Widget content = Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          ),
          const SizedBox(width: AppSpacing.s),
        ] else if (widget.leadingIcon != null) ...[
          Icon(widget.leadingIcon, size: iconSize, color: fg),
          const SizedBox(width: AppSpacing.s),
        ],
        Flexible(
          child: Text(
            widget.label,
            style: AppTypography.button.copyWith(
              fontSize: fontSize,
              color: fg,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.trailingIcon != null && !widget.isLoading) ...[
          const SizedBox(width: AppSpacing.s),
          Icon(widget.trailingIcon, size: iconSize, color: fg),
        ],
      ],
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.isFullWidth ? double.infinity : null,
        child: Material(
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            side: border,
          ),
          child: InkWell(
            onTap: isEnabled ? widget.onPressed : null,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Padding(
              padding: padding,
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
