import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/application_model.dart';
import '../../../core/models/application_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/next_action_banner.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/timeline_widget.dart';

class ApplicationTrackingScreen extends StatelessWidget {
  final ApplicationModel application;
  final VoidCallback onResolveRequired;
  final VoidCallback onViewCertificate;
  final VoidCallback onViewRejection;
  final VoidCallback onBack;

  const ApplicationTrackingScreen({
    super.key,
    required this.application,
    required this.onResolveRequired,
    required this.onViewCertificate,
    required this.onViewRejection,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final status = application.status;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 950),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back navigation
              TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Back to Applications List'),
              ),
              const SizedBox(height: AppSpacing.s),

              // Title Header Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isCompact = constraints.maxWidth < 600;

                          Widget? actionBtn;
                          if (status == AppStatus.certificateGenerated || status == AppStatus.approved) {
                            actionBtn = AppButton(
                              label: 'View Certificate',
                              variant: AppButtonVariant.success,
                              leadingIcon: Icons.verified_rounded,
                              onPressed: onViewCertificate,
                            );
                          } else if (status == AppStatus.rejected) {
                            actionBtn = AppButton(
                              label: 'View Rejection Grounds',
                              variant: AppButtonVariant.danger,
                              leadingIcon: Icons.info_outline_rounded,
                              onPressed: onViewRejection,
                            );
                          }

                          final headerText = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: AppSpacing.s,
                                runSpacing: AppSpacing.xs,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    application.id,
                                    style: AppTypography.code.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryAccent,
                                    ),
                                  ),
                                  StatusBadge(status: status),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.s),
                              Text(application.serviceName, style: AppTypography.h2),
                              const SizedBox(height: 2),
                              Text(
                                '${application.departmentName} • Submitted on ${DateFormat("dd MMM yyyy, hh:mm a").format(application.submissionDate)}',
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          );

                          if (isCompact) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                headerText,
                                if (actionBtn != null) ...[
                                  const SizedBox(height: AppSpacing.m),
                                  actionBtn,
                                ],
                              ],
                            );
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: headerText),
                              if (actionBtn != null) ...[
                                const SizedBox(width: AppSpacing.m),
                                actionBtn,
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.l),

              // Next Action Banner (Prominently displayed)
              NextActionBanner(
                application: application,
                isProminent: true,
                onActionPressed: () {
                  if (status == AppStatus.informationRequired) {
                    onResolveRequired();
                  } else if (status == AppStatus.certificateGenerated || status == AppStatus.approved) {
                    onViewCertificate();
                  } else if (status == AppStatus.rejected) {
                    onViewRejection();
                  }
                },
              ),
              const SizedBox(height: AppSpacing.l),

              // Two Column: Timeline and Application Dossier
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 850;

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: TimelineWidget(application: application),
                        ),
                        const SizedBox(width: AppSpacing.l),
                        Expanded(
                          flex: 4,
                          child: _buildDossierDetails(context),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        TimelineWidget(application: application),
                        const SizedBox(height: AppSpacing.l),
                        _buildDossierDetails(context),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDossierDetails(BuildContext context) {
    return Column(
      children: [
        // Dossier Summary Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Application Dossier', style: AppTypography.h3),
                const Divider(),
                const SizedBox(height: AppSpacing.s),

                _infoRow('Applicant', application.citizenName),
                _infoRow('Aadhaar', application.citizenAadhaar),
                _infoRow('Mobile', application.citizenPhone),
                _infoRow('Assigned Officer', application.assignedOfficerName ?? 'Under Allocation'),
                _infoRow('Last Status Update', DateFormat('dd MMM yyyy, hh:mm a').format(application.lastUpdated)),

                if (application.certificateNumber != null) ...[
                  const Divider(),
                  _infoRow('Certificate No', application.certificateNumber!),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        // Submitted Documents List Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enclosed Documents (${application.documents.length})', style: AppTypography.h3),
                const Divider(),
                const SizedBox(height: AppSpacing.s),

                if (application.documents.isEmpty)
                  Text('No documents attached.', style: AppTypography.bodySmall)
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: application.documents.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final doc = application.documents[index];
                      final isFlagged = doc.isFlagged;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              isFlagged ? Icons.warning_amber_rounded : Icons.description_outlined,
                              size: 18,
                              color: isFlagged ? AppColors.danger : AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppSpacing.s),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(doc.name, style: AppTypography.labelBold.copyWith(fontSize: 12)),
                                  Text(
                                    '${doc.fileName} • ${(doc.fileSizeBytes / 1024).toStringAsFixed(0)} KB',
                                    style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                  ),
                                  if (doc.officerComment != null)
                                    Text(
                                      'Officer note: ${doc.officerComment}',
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.danger, fontSize: 11),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: doc.isVerified
                                    ? AppColors.successLight
                                    : (isFlagged ? AppColors.dangerLight : AppColors.surfaceSubtle),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                doc.isVerified ? 'Verified' : (isFlagged ? 'Action Needed' : 'Pending Check'),
                                style: AppTypography.labelSmall.copyWith(
                                  fontSize: 10,
                                  color: doc.isVerified
                                      ? AppColors.success
                                      : (isFlagged ? AppColors.danger : AppColors.textMuted),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
          ),
          Expanded(
            child: Text(val, style: AppTypography.labelBold.copyWith(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
