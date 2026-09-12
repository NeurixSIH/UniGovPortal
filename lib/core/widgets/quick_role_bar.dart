import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class QuickRoleBar extends StatelessWidget {
  const QuickRoleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final currentRole = state.currentRole;
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        boxShadow: [
          BoxShadow(color: Color(0x2A000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        top: true,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? AppSpacing.s : AppSpacing.m,
            vertical: isMobile ? 4 : AppSpacing.s,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Emblem & Brand Name
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        'assets/images/gov_logo.png',
                        width: 22,
                        height: 22,
                        errorBuilder: (_, __, ___) => Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.account_balance_rounded, size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    Text(
                      'SETU',
                      style: AppTypography.labelBold.copyWith(
                        color: const Color(0xFFFDE047), // Gold accent
                        letterSpacing: 1.5,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'GOVT OF INDIA',
                      style: AppTypography.labelSmall.copyWith(
                        color: const Color(0xFF93C5FD),
                        letterSpacing: 0.8,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.m),
                Container(height: 16, width: 1, color: const Color(0xFF334155)),
                const SizedBox(width: AppSpacing.m),

                // Role Perspective Tabs
                _RoleTab(
                  label: 'Citizen',
                  icon: Icons.person_rounded,
                  isActive: currentRole == UserRole.citizen,
                  onTap: () => state.setRole(UserRole.citizen),
                ),
                const SizedBox(width: AppSpacing.xs),
                _RoleTab(
                  label: 'Officer',
                  icon: Icons.shield_rounded,
                  isActive: currentRole == UserRole.officer,
                  onTap: () => state.setRole(UserRole.officer),
                ),
                const SizedBox(width: AppSpacing.xs),
                _RoleTab(
                  label: 'Admin',
                  icon: Icons.admin_panel_settings_rounded,
                  isActive: currentRole == UserRole.admin,
                  onTap: () => state.setRole(UserRole.admin),
                ),

                const SizedBox(width: AppSpacing.m),
                Container(height: 16, width: 1, color: const Color(0xFF334155)),
                const SizedBox(width: AppSpacing.s),

                // Language Selector
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: state.currentLanguage,
                    dropdownColor: AppColors.primaryDark,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 16),
                    style: AppTypography.labelSmall.copyWith(color: Colors.white, fontSize: 11),
                    items: const [
                      DropdownMenuItem(value: 'English', child: Text('EN')),
                      DropdownMenuItem(value: 'Hindi', child: Text('हिन्दी')),
                      DropdownMenuItem(value: 'Gujarati', child: Text('ગુજરાતી')),
                    ],
                    onChanged: (val) {
                      if (val != null) state.setLanguage(val);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _RoleTab({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryAccent : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: isActive ? const Color(0xFF60A5FA) : const Color(0xFF334155),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: isActive ? Colors.white : const Color(0xFF94A3B8)),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isActive ? Colors.white : const Color(0xFFCBD5E1),
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
