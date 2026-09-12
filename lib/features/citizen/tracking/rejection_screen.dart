import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/application_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';

class RejectionScreen extends StatelessWidget {
  final ApplicationModel application;
  final VoidCallback onApplyAgain;
  final VoidCallback onViewDossier;
  final VoidCallback onBack;

  const RejectionScreen({
    super.key,
    required this.application,
    required this.onApplyAgain,
    required this.onViewDossier,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final rejectionDate = application.rejectionDate ?? application.lastUpdated;
    final category = application.rejectionCategory ?? 'Statutory Non-Compliance';
    final remarks = application.rejectionRemarks ??
        'The application could not be sanctioned as the submitted credentials did not meet the eligibility benchmarks notified under state rules.';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Back to Application Tracking'),
              ),
              const SizedBox(height: AppSpacing.s),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Banner
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        decoration: BoxDecoration(
                          color: AppColors.dangerLight,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(color: AppColors.dangerBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.cancel_outlined, color: AppColors.danger, size: 32),
                            const SizedBox(width: AppSpacing.m),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Application Not Approved (Rejected)',
                                    style: AppTypography.h3.copyWith(color: AppColors.danger, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Reference: ${application.id} • Decided on ${DateFormat("dd MMMM yyyy").format(rejectionDate)}',
                                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      Text('Reason & Statutory Grounds', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.s),

                      // Grounds Detail Card
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.l),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Classification: ', style: AppTypography.labelBold),
                                Text(category, style: AppTypography.labelBold.copyWith(color: AppColors.danger)),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.s),
                            Text('Scrutiny Officer Remarks:', style: AppTypography.labelBold),
                            const SizedBox(height: 4),
                            Text(
                              remarks,
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary, height: 1.5),
                            ),
                            const SizedBox(height: AppSpacing.m),
                            const Divider(),
                            const SizedBox(height: AppSpacing.s),
                            Row(
                              children: [
                                const Icon(Icons.shield_outlined, size: 16, color: AppColors.textMuted),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  'Competent Authority: ${application.assignedOfficerName ?? "Municipal / Revenue Authority"}',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // What can you do next?
                      Text('Recommended Next Actions', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.s),
                      Text(
                        'You may submit a fresh application after remedying the zoning or documentation deficiencies, or submit an appeal to the Appellate Authority under the Public Services Guarantee Act.',
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Action Buttons
                      Wrap(
                        spacing: AppSpacing.m,
                        runSpacing: AppSpacing.m,
                        children: [
                          AppButton(
                            label: 'Apply Again with Updated Documents',
                            variant: AppButtonVariant.primary,
                            size: AppButtonSize.large,
                            leadingIcon: Icons.refresh_rounded,
                            onPressed: onApplyAgain,
                          ),
                          AppButton(
                            label: 'View Application File & History',
                            variant: AppButtonVariant.outline,
                            size: AppButtonSize.large,
                            leadingIcon: Icons.folder_open_rounded,
                            onPressed: onViewDossier,
                          ),
                          AppButton(
                            label: 'Lodge First Appeal (CPGRAMS)',
                            variant: AppButtonVariant.ghost,
                            size: AppButtonSize.large,
                            leadingIcon: Icons.gavel_rounded,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Appellate Authority appeal dossier initiated.')),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
