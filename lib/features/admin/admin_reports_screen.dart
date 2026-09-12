import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final isMobile = MediaQuery.of(context).size.width < 700;
    final apps = state.applications;
    final officers = state.officers;
    final services = state.services;

    final totalApps = apps.length;
    final totalOfficers = officers.length;
    final totalServices = services.length;

    final reports = [
      {
        'title': 'Statewide Application Report',
        'desc': 'Gross volume across all 36 districts, citizen intake rates, issuance turnaround, and disposal velocity.',
        'metric': '$totalApps Total Applications',
        'sub': '94.2% statutory SLA clearance',
        'icon': Icons.assignment_rounded,
        'color': const Color(0xFF7C3AED),
        'bg': const Color(0xFFF5F3FF),
      },
      {
        'title': 'Officer Scrutiny Activity Report',
        'desc': 'Caseload per desk, average files scrutinized per officer daily, approval vs rejection ratios, and time-in-queue.',
        'metric': '$totalOfficers Active Officers',
        'sub': '18.4 cases average daily disposal per officer',
        'icon': Icons.badge_rounded,
        'color': AppColors.primary,
        'bg': AppColors.primarySurface,
      },
      {
        'title': 'Department Workload Distribution',
        'desc': 'Secretariat ministry load balancing, pending verification backlog, and revenue reconciliation.',
        'metric': '7 Ministries Integrated',
        'sub': 'Revenue & Urban Development carry 62% volume',
        'icon': Icons.pie_chart_rounded,
        'color': const Color(0xFF0D9488),
        'bg': const Color(0xFFCCFBF1),
      },
      {
        'title': 'Service Utilization & Demand',
        'desc': 'Most requested certificates (Income Certificate, Domicile Certificate, Caste Certificate), and fee ledger.',
        'metric': '$totalServices Services Live',
        'sub': 'Income Certificate: #1 Most Applied Service',
        'icon': Icons.trending_up_rounded,
        'color': const Color(0xFFD97706),
        'bg': const Color(0xFFFFFBEB),
      },
      {
        'title': 'Central Interoperability & Sync Audit',
        'desc': 'Cryptographic audit ledger of inter-departmental data pulls via Setu Gateway and DigiLocker exchange.',
        'metric': '100% Cryptographically Signed',
        'sub': 'Zero data integrity incidents reported',
        'icon': Icons.sync_rounded,
        'color': const Color(0xFF059669),
        'bg': const Color(0xFFECFDF5),
      },
      {
        'title': 'Citizen Consent Governance Report',
        'desc': 'DPDP Act compliance ledger, revocations, active data access authorizations, and citizen privacy requests.',
        'metric': 'DPDP 2023 Compliant',
        'sub': 'All requests have active citizen authorization',
        'icon': Icons.security_rounded,
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
            color: const Color(0xFF6D28D9),
            border: BorderSide.none,
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Row(
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
                      Text('System Analytics & Oversight Reports', style: AppTypography.h2.copyWith(color: Colors.white, fontSize: 18)),
                      Text('Cross-departmental telemetry, officer auditing & statutory disposal analytics', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
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
