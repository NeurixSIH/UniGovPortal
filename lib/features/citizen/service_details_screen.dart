import 'package:flutter/material.dart';
import '../../core/models/service_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onApply;
  final VoidCallback onBack;

  const ServiceDetailsScreen({
    super.key,
    required this.service,
    required this.onApply,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back link
              TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Back to Service Catalog'),
              ),
              const SizedBox(height: AppSpacing.s),

              // Header Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        ),
                        child: Icon(service.icon, color: AppColors.primary, size: 36),
                      ),
                      const SizedBox(width: AppSpacing.l),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSubtle,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: Text(
                                '${service.code} • ${service.departmentName}',
                                style: AppTypography.labelSmall.copyWith(color: AppColors.primaryAccent),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s),
                            Text(service.name, style: AppTypography.h1),
                            const SizedBox(height: AppSpacing.xs),
                            Text(service.description, style: AppTypography.bodyMedium),
                            const SizedBox(height: AppSpacing.l),

                            // Metrics summary
                            Wrap(
                              spacing: AppSpacing.xl,
                              runSpacing: AppSpacing.s,
                              children: [
                                _DetailItem(
                                  label: 'Statutory Processing Time',
                                  value: '${service.processingTimeDays} Working Days',
                                  icon: Icons.timer_outlined,
                                ),
                                _DetailItem(
                                  label: 'Official Government Fee',
                                  value: service.governmentFee == 0 ? 'Nil (Free of Cost)' : '₹ ${service.governmentFee.toStringAsFixed(0)}',
                                  icon: Icons.currency_rupee_rounded,
                                ),
                                _DetailItem(
                                  label: 'Issuance Format',
                                  value: 'QR-Verified Digital Certificate',
                                  icon: Icons.verified_rounded,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.l),

              // Eligibility Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 22),
                          const SizedBox(width: AppSpacing.s),
                          Text('Eligibility Criteria', style: AppTypography.h3),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.m),
                      Text(service.eligibility, style: AppTypography.bodyMedium),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.l),

              // Mandatory Documents Required
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.file_copy_outlined, color: AppColors.primaryAccent, size: 22),
                          const SizedBox(width: AppSpacing.s),
                          Text('Required Documents (${service.requiredDocuments.length})', style: AppTypography.h3),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.m),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: service.requiredDocuments.length,
                        separatorBuilder: (_, __) => const Divider(height: AppSpacing.m),
                        itemBuilder: (context, index) {
                          final doc = service.requiredDocuments[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: AppColors.primarySurface,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: AppTypography.labelSmall.copyWith(color: AppColors.primaryAccent),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.m),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(doc.name, style: AppTypography.labelBold),
                                        if (doc.isMandatory) ...[
                                          const SizedBox(width: AppSpacing.xs),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: AppColors.dangerLight,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'Mandatory',
                                              style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.danger),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(doc.description, style: AppTypography.bodySmall),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Formats: ${doc.allowedFormats.join(", ")} • Max: ${doc.maxSizeMB} MB',
                                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.l),

              // Process Lifecycle Steps
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.alt_route_rounded, color: AppColors.secondary, size: 22),
                          const SizedBox(width: AppSpacing.s),
                          Text('Service Delivery Process Flow', style: AppTypography.h3),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.m),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: service.processSteps.length,
                        itemBuilder: (context, index) {
                          final step = service.processSteps[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.s),
                            child: Row(
                              children: [
                                const Icon(Icons.arrow_right_alt_rounded, color: AppColors.secondary),
                                const SizedBox(width: AppSpacing.s),
                                Expanded(child: Text(step, style: AppTypography.bodyMedium)),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Bottom CTA Bar
              Container(
                padding: const EdgeInsets.all(AppSpacing.l),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 550;
                    final textCol = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ready to start your application?', style: AppTypography.labelBold),
                        Text('Average completion time: ~4 minutes with pre-filled Aadhaar data.', style: AppTypography.bodySmall),
                      ],
                    );
                    final applyBtn = AppButton(
                      label: 'Apply Now',
                      size: isNarrow ? AppButtonSize.medium : AppButtonSize.large,
                      leadingIcon: Icons.edit_document,
                      onPressed: onApply,
                    );

                    if (isNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textCol,
                          const SizedBox(height: AppSpacing.m),
                          SizedBox(width: double.infinity, child: applyBtn),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: textCol),
                        const SizedBox(width: AppSpacing.m),
                        applyBtn,
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.primaryAccent),
        const SizedBox(width: AppSpacing.s),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted)),
            Text(value, style: AppTypography.labelBold),
          ],
        ),
      ],
    );
  }
}
