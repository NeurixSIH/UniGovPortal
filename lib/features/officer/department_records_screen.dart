import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';

class DepartmentRecordsScreen extends StatelessWidget {
  const DepartmentRecordsScreen({super.key});

  void _showRecordDetails(BuildContext context, String title, String description, IconData icon, List<Map<String, String>> sampleData) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(child: Text(title, style: AppTypography.h3)),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(description, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.m),
                const Divider(),
                const SizedBox(height: AppSpacing.s),
                Text('Statutory Registry Integration & Verification Node', style: AppTypography.labelBold),
                const SizedBox(height: AppSpacing.s),
                ...sampleData.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['label'] ?? '', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                        Text(item['value'] ?? '', style: AppTypography.labelBold.copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: AppColors.successBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'Encrypted API Tunnel Active • SSL 256-bit TLS 1.3',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          AppButton(
            label: 'Done',
            variant: AppButtonVariant.primary,
            size: AppButtonSize.small,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    final records = [
      {
        'title': 'Municipal Records',
        'desc': 'Property tax assessments, building sanction logs, ward registrations, and water/drainage cess accounts.',
        'icon': Icons.location_city_rounded,
        'color': AppColors.primary,
        'bg': AppColors.primarySurface,
        'data': [
          {'label': 'Data Source', 'value': 'Maharashtra Urban Local Bodies DB'},
          {'label': 'Connected ULBs', 'value': '28 Corporations, 241 Municipal Councils'},
          {'label': 'Last Sync', 'value': 'Today, 04:30 AM'},
          {'label': 'Service Endpoint', 'value': 'api.urban.maharashtra.gov.in/v2'},
        ],
      },
      {
        'title': 'Bank Records',
        'desc': 'DBT beneficiary account verification, NPCI Aadhaar-mapper validation, and PFMS clearance.',
        'icon': Icons.account_balance_rounded,
        'color': const Color(0xFF0D9488),
        'bg': const Color(0xFFCCFBF1),
        'data': [
          {'label': 'Clearing House', 'value': 'National Payments Corporation of India (NPCI)'},
          {'label': 'PFMS Integration', 'value': 'Direct Benefit Transfer Central Gateway'},
          {'label': 'Status', 'value': 'Real-time e-Mandate Active'},
          {'label': 'Active Mandates', 'value': '14,892,104 Accounts'},
        ],
      },
      {
        'title': 'Land Records',
        'desc': 'Bhulekh 7/12 extract database, cadastral land parcel maps (GIS), mutation entries, and title records.',
        'icon': Icons.landscape_rounded,
        'color': const Color(0xFFD97706),
        'bg': const Color(0xFFFFFBEB),
        'data': [
          {'label': 'Registry Portal', 'value': 'Mahabhulekh (e-Ferfar Central Portal)'},
          {'label': 'Total Land Parcels', 'value': '2.6 Crore RoR Records Digitized'},
          {'label': 'Digital Signature', 'value': 'NIC e-Signer Certified'},
          {'label': 'Latency', 'value': '48ms Average SLA'},
        ],
      },
      {
        'title': 'Agriculture Records',
        'desc': 'PM-KISAN eligibility ledger, crop insurance (PMFBY), Krishi card holdings, and fertilizer subsidy allotments.',
        'icon': Icons.agriculture_rounded,
        'color': const Color(0xFF059669),
        'bg': const Color(0xFFECFDF5),
        'data': [
          {'label': 'Registry Node', 'value': 'Kisan Samman Nidhi Central Service'},
          {'label': 'Farmer Count', 'value': '98.4 Lakh Registered Beneficiaries'},
          {'label': 'Aadhaar Seeded', 'value': '99.8% Complete'},
          {'label': 'Insurance Gateway', 'value': 'PMFBY Unified Portal'},
        ],
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
                      child: const Icon(Icons.dataset_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Interoperable Department Records', style: AppTypography.h2.copyWith(color: Colors.white, fontSize: 18)),
                          Text('Direct read-only bridges to federated statutory state registries', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
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
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s),
            itemBuilder: (context, idx) {
              final r = records[idx];
              final title = r['title'] as String;
              final desc = r['desc'] as String;
              final icon = r['icon'] as IconData;
              final color = r['color'] as Color;
              final bg = r['bg'] as Color;
              final data = r['data'] as List<Map<String, String>>;

              return AppCard(
                onTap: () => _showRecordDetails(context, title, desc, icon, data),
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: AppTypography.labelBold.copyWith(fontSize: 15)),
                          const SizedBox(height: 2),
                          Text(desc, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
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
        ],
      ),
    );
  }
}
