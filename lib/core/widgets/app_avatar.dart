import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? fallbackIcon;

  const AppAvatar({
    super.key,
    required this.name,
    this.radius = 20,
    this.backgroundColor,
    this.textColor,
    this.fallbackIcon,
  });

  String get _initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.primary;
    final fg = textColor ?? Colors.white;

    return CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      child: name.isEmpty && fallbackIcon != null
          ? Icon(fallbackIcon, size: radius * 1.1, color: fg)
          : Text(
              _initials,
              style: AppTypography.labelBold.copyWith(
                color: fg,
                fontSize: radius * 0.75,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
