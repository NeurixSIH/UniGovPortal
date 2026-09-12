import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/modal_dialogs.dart';

class AdminSettingsScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const AdminSettingsScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final isMobile = MediaQuery.of(context).size.width < 700;

    final settings = [
      {
        'title': 'System Notification Preferences',
        'subtitle': 'Critical failure alerts, officer onboarding digests & security broadcasts',
        'icon': Icons.notifications_active_outlined,
        'color': const Color(0xFF7C3AED),
        'bg': const Color(0xFFF5F3FF),
      },
      {
        'title': 'System & Platform Settings',
        'subtitle': 'API rate limits, maintenance window scheduling & gateway timeouts',
        'icon': Icons.tune_rounded,
        'color': AppColors.primary,
        'bg': AppColors.primarySurface,
      },
      {
        'title': 'Security & Zero-Trust Access Control',
        'subtitle': 'Two-factor auth policies, IP whitelist rules & DSC certificate management',
        'icon': Icons.admin_panel_settings_outlined,
        'color': const Color(0xFFDC2626),
        'bg': const Color(0xFFFEF2F2),
      },
      {
        'title': 'Language & Regional Localization',
        'subtitle': 'Active portal language: ${state.currentLanguage} (Marathi, Hindi, Gujarati, English)',
        'icon': Icons.translate_rounded,
        'color': const Color(0xFF0D9488),
        'bg': const Color(0xFFCCFBF1),
      },
      {
        'title': 'Help & Support Escalations',
        'subtitle': 'Central Ministry NIC support desk, documentation & error logs',
        'icon': Icons.support_agent_rounded,
        'color': const Color(0xFF059669),
        'bg': const Color(0xFFECFDF5),
      },
      {
        'title': 'About Platform',
        'subtitle': 'Government Interoperability Hub v2.4 Enterprise • Government of Maharashtra',
        'icon': Icons.info_outline_rounded,
        'color': AppColors.neutralStatus,
        'bg': AppColors.neutralStatusLight,
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppSpacing.m : AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.l),
            color: const Color(0xFF6D28D9),
            border: BorderSide.none,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.settings_suggest_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('System Administration Settings', style: AppTypography.h2.copyWith(color: Colors.white, fontSize: 18)),
                      Text('Global platform governance, compliance & infrastructure parameters', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: settings.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s),
            itemBuilder: (context, idx) {
              final s = settings[idx];
              return AppCard(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${s["title"]} verified'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: s['bg'] as Color,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 22),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s['title'] as String, style: AppTypography.labelBold.copyWith(fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(s['subtitle'] as String, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),

          // Logout Button at Bottom
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Logout Administrator Session',
              variant: AppButtonVariant.danger,
              leadingIcon: Icons.logout_rounded,
              onPressed: () async {
                final confirmed = await ModalDialogs.showConfirmation(
                  context: context,
                  title: 'Confirm Logout',
                  message: 'Are you sure you want to end your System Administration session?',
                  confirmLabel: 'Logout',
                  isDestructive: true,
                );
                if (confirmed == true) {
                  state.logout();
                  onLogout();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
