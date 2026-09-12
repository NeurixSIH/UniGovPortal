import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';

class OfficerReportsScreen extends StatelessWidget {
  const OfficerReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final isMobile = MediaQuery.of(context).size.width < 700;
    final apps = state.applications;

    final total = apps.length;
    final approved = apps.where((a) => a.status.name.contains('approved') || a.status.name.contains('completed') || a.status.name.contains('certificate')).length;
    final rejected = apps.where((a) => a.status.name.contains('rejected')).length;
    final pending = total - approved - rejected;

    final reports = [
      {
        'title': 'Application Caseload Report',
        'desc': 'Total file throughput, disposal ratios, average scrutiny time (2.4 days), and SLA adherence index.',
        'metric': '$total Total Files',
        'sub': '$approved approved • $pending active • $rejected rejected',
        'icon': Icons.assignment_turned_in_rounded,
        'color': AppColors.primary,
        'bg': AppColors.primarySurface,
      },
      {
        'title': 'Department Load Report',
        'desc': 'Desk-by-desk quota distribution, pending document queues, and officer capacity index across wards.',
        'metric': '84% SLA On-Time',
        'sub': 'Average turnaround: 3.1 business days',
        'icon': Icons.speed_rounded,
        'color': const Color(0xFF0D9488),
        'bg': const Color(0xFFCCFBF1),
      },
      {
        'title': 'Sync Audit Report',
        'desc': 'Real-time telemetry of Digilocker pulls, Aadhaar e-KYC handshakes, and ULB Municipal API connectivity logs.',
        'metric': '99.98% Gateway Uptime',
        'sub': '14,280 daily transactions without failure',
        'icon': Icons.sync_alt_rounded,
        'color': const Color(0xFFD97706),
        'bg': const Color(0xFFFFFBEB),
      },
      {
        'title': 'Consent & Access Log Report',
        'desc': 'Statutory audit ledger of data attributes accessed by officers under Section 6 of DPDP Act 2023.',
        'metric': '100% Audited',
        'sub': 'Full non-repudiation cryptographic seal logged',
        'icon': Icons.verified_user_rounded,
        'color': const Color(0xFF059669),
        'bg': const Color(0xFFECFDF5),
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppSpacing.m : AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            color: AppColors.primary,
            border: BorderSide.none,
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Officer Performance & Analytics', style: AppTypography.h2.copyWith(color: Colors.white, fontSize: 18)),
                          Text('Statutory reporting, disposal audits & SLA monitoring', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reports.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s),
            itemBuilder: (context, idx) {
              final r = reports[idx];
              return AppCard(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: r['bg'] as Color,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Icon(r['icon'] as IconData, color: r['color'] as Color, size: 24),
                        ),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r['title'] as String, style: AppTypography.labelBold.copyWith(fontSize: 15)),
                              const SizedBox(height: 2),
                              Text(r['desc'] as String, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(r['metric'] as String, style: AppTypography.labelBold.copyWith(color: r['color'] as Color, fontSize: 13)),
                          Text(r['sub'] as String, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
