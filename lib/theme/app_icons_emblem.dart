import 'package:flutter/material.dart';
import 'app_theme.dart';

class MaharashtraEmblemWidget extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isDark;

  const MaharashtraEmblemWidget({
    super.key,
    this.size = 64,
    this.showText = true,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? Colors.white.withAlpha(30) : AppTheme.primaryBlueLight.withAlpha(20),
            border: Border.all(
              color: isDark ? Colors.white70 : AppTheme.primaryBlue,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black26 : AppTheme.primaryBlue.withAlpha(30)),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring rays
                Icon(
                  Icons.shield_outlined,
                  size: size * 0.65,
                  color: isDark ? Colors.white : AppTheme.primaryBlue,
                ),
                Icon(
                  Icons.account_balance,
                  size: size * 0.40,
                  color: isDark ? AppTheme.saffron : AppTheme.primaryBlueDark,
                ),
              ],
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 6),
          Text(
            'महाराष्ट्र शासन',
            style: TextStyle(
              fontSize: size * 0.22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.primaryBlueDark,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            'GOVERNMENT OF MAHARASHTRA',
            style: TextStyle(
              fontSize: (size * 0.14).clamp(9.0, 12.0),
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppTheme.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ],
    );
  }
}

class TricolorCurvedAccent extends StatelessWidget {
  final double height;
  final double width;

  const TricolorCurvedAccent({
    super.key,
    this.height = 4,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: const LinearGradient(
          colors: [
            AppTheme.saffron,
            Colors.white,
            AppTheme.primaryBlue,
            Colors.white,
            AppTheme.indiaGreen,
          ],
          stops: [0.0, 0.45, 0.5, 0.55, 1.0],
        ),
      ),
    );
  }
}

class StatusBadgeWidget extends StatelessWidget {
  final String status;
  final bool compact;

  const StatusBadgeWidget({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.borderColor, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: compact ? 12 : 14, color: config.textColor),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: config.textColor,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status.toLowerCase().replaceAll(' ', '_')) {
      case 'verified':
      case 'approved':
      case 'success':
      case 'granted':
      case 'active':
        return _StatusConfig(
          label: status[0].toUpperCase() + status.substring(1),
          bgColor: AppTheme.statusSuccessLight,
          borderColor: AppTheme.statusSuccess.withAlpha(100),
          textColor: AppTheme.statusSuccess,
          icon: Icons.check_circle_outline,
        );
      case 'pending':
      case 'under_review':
      case 'documents_required':
        return _StatusConfig(
          label: status == 'documents_required'
              ? 'Docs Required'
              : (status == 'under_review' ? 'Under Review' : 'Pending'),
          bgColor: AppTheme.statusPendingLight,
          borderColor: AppTheme.statusPending.withAlpha(100),
          textColor: AppTheme.statusPending,
          icon: Icons.access_time,
        );
      case 'rejected':
      case 'denied':
      case 'revoked':
      case 'failed':
      case 'blocked':
        return _StatusConfig(
          label: status[0].toUpperCase() + status.substring(1),
          bgColor: AppTheme.statusRejectedLight,
          borderColor: AppTheme.statusRejected.withAlpha(100),
          textColor: AppTheme.statusRejected,
          icon: Icons.cancel_outlined,
        );
      case 'completed':
        return _StatusConfig(
          label: 'Completed',
          bgColor: AppTheme.statusInfoLight,
          borderColor: AppTheme.statusInfo.withAlpha(100),
          textColor: AppTheme.statusInfo,
          icon: Icons.verified_outlined,
        );
      case 'submitted':
      default:
        return _StatusConfig(
          label: status.isNotEmpty ? status[0].toUpperCase() + status.substring(1) : 'Submitted',
          bgColor: AppTheme.primaryBlueLight.withAlpha(25),
          borderColor: AppTheme.primaryBlue.withAlpha(80),
          textColor: AppTheme.primaryBlue,
          icon: Icons.arrow_circle_up_outlined,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final IconData icon;

  _StatusConfig({
    required this.label,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
    required this.icon,
  });
}

class DepartmentHelper {
  static IconData getIcon(String dept) {
    final d = dept.toLowerCase();
    if (d.contains('municipal')) return Icons.location_city;
    if (d.contains('bank')) return Icons.account_balance;
    if (d.contains('land')) return Icons.landscape;
    if (d.contains('agri')) return Icons.eco;
    if (d.contains('revenue')) return Icons.receipt_long;
    if (d.contains('food') || d.contains('ration')) return Icons.local_dining;
    if (d.contains('education') || d.contains('scholarship')) return Icons.school;
    return Icons.domain;
  }

  static Color getColor(String dept) {
    final d = dept.toLowerCase();
    if (d.contains('municipal')) return const Color(0xFF0288D1);
    if (d.contains('bank')) return const Color(0xFF1565C0);
    if (d.contains('land')) return const Color(0xFF6D4C41);
    if (d.contains('agri')) return const Color(0xFF2E7D32);
    if (d.contains('revenue')) return const Color(0xFF8E24AA);
    if (d.contains('food')) return const Color(0xFFE65100);
    return AppTheme.primaryBlue;
  }
}
