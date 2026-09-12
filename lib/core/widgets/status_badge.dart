import 'package:flutter/material.dart';
import '../models/application_status.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class StatusBadge extends StatelessWidget {
  final AppStatus? status;
  final String? customLabel;
  final Color? customColor;
  final Color? customBgColor;
  final BorderSide? customBorder;
  final IconData? customIcon;
  final bool showIcon;
  final bool isCompact;

  const StatusBadge({
    super.key,
    required AppStatus this.status,
    this.showIcon = true,
    this.isCompact = false,
  })  : customLabel = null,
        customColor = null,
        customBgColor = null,
        customBorder = null,
        customIcon = null;

  const StatusBadge.custom({
    super.key,
    required String label,
    required Color color,
    Color? backgroundColor,
    BorderSide? border,
    IconData? icon,
    this.showIcon = true,
    this.isCompact = false,
  })  : status = null,
        customLabel = label,
        customColor = color,
        customBgColor = backgroundColor,
        customBorder = border,
        customIcon = icon;

  static Widget active({bool isCompact = false}) => StatusBadge.custom(
        label: 'Active',
        color: AppColors.success,
        backgroundColor: AppColors.successLight,
        icon: Icons.check_circle_rounded,
        isCompact: isCompact,
      );

  static Widget inactive({bool isCompact = false}) => StatusBadge.custom(
        label: 'Inactive',
        color: AppColors.neutralStatus,
        backgroundColor: AppColors.neutralStatusLight,
        icon: Icons.pause_circle_outline_rounded,
        isCompact: isCompact,
      );

  static Widget verified({bool isCompact = false}) => StatusBadge.custom(
        label: 'Verified',
        color: AppColors.success,
        backgroundColor: AppColors.successLight,
        icon: Icons.verified_rounded,
        isCompact: isCompact,
      );

  static Widget matched({bool isCompact = false}) => StatusBadge.custom(
        label: 'Matched',
        color: AppColors.success,
        backgroundColor: AppColors.successLight,
        icon: Icons.done_all_rounded,
        isCompact: isCompact,
      );

  static Widget notMatched({bool isCompact = false}) => StatusBadge.custom(
        label: 'Not Matched',
        color: AppColors.danger,
        backgroundColor: AppColors.dangerLight,
        icon: Icons.error_outline_rounded,
        isCompact: isCompact,
      );

  static Widget pending({bool isCompact = false}) => StatusBadge.custom(
        label: 'Pending',
        color: AppColors.warning,
        backgroundColor: AppColors.warningLight,
        icon: Icons.pending_actions_rounded,
        isCompact: isCompact,
      );

  @override
  Widget build(BuildContext context) {
    final String label = customLabel ?? status?.label ?? '';
    final Color color = customColor ?? status?.color ?? AppColors.textSecondary;
    final Color bgColor = customBgColor ?? status?.backgroundColor ?? AppColors.surfaceSubtle;
    final BorderSide border = customBorder ??
        BorderSide(
          color: (status != null ? status!.borderColor : color).withValues(alpha: 0.35),
          width: 1,
        );
    final IconData? icon = customIcon ?? status?.icon;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? AppSpacing.s : AppSpacing.sm,
        vertical: isCompact ? 3.0 : 5.0,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.fromBorderSide(border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && icon != null) ...[
            Icon(
              icon,
              size: isCompact ? 12 : 14,
              color: color,
            ),
            SizedBox(width: isCompact ? AppSpacing.xs : AppSpacing.s),
          ],
          Flexible(
            child: Text(
              label,
              style: (isCompact ? AppTypography.labelSmall : AppTypography.labelBold).copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
