import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/models/application_model.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/modal_dialogs.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/timeline_widget.dart';
import 'document_inspector_modal.dart';

class OfficerReviewScreen extends StatefulWidget {
  final ApplicationModel application;
  final VoidCallback onBack;
  final VoidCallback onActionCompleted;

  const OfficerReviewScreen({
    super.key,
    required this.application,
    required this.onBack,
    required this.onActionCompleted,
  });

  @override
  State<OfficerReviewScreen> createState() => _OfficerReviewScreenState();
}

class _OfficerReviewScreenState extends State<OfficerReviewScreen> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    // Fetch latest instance of this application from provider
    final app = state.applications.firstWhere(
      (a) => a.id == widget.application.id,
      orElse: () => widget.application,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1050),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Back to Applications Queue'),
                ),
                const SizedBox(height: AppSpacing.s),

                // Top Case Header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: AppSpacing.s,
                                runSpacing: 4,
                                children: [
                                  Text(
                                    app.id,
                                    style: AppTypography.code.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryAccent,
                                    ),
                                  ),
                                  StatusBadge(status: app.status),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(app.serviceName, style: AppTypography.h2),
                              const SizedBox(height: 2),
                              Text(
                                '${app.departmentName} • ${DateFormat("dd MMM yyyy, hh:mm a").format(app.submissionDate)}',
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),

                // Two Column Layout
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 900;

                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: [
                                _buildCitizenAndAnswersCard(app),
                                const SizedBox(height: AppSpacing.l),
                                _buildDocumentScrutinyCard(context, state, app),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.l),
                          Expanded(
                            flex: 4,
                            child: TimelineWidget(application: app),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildCitizenAndAnswersCard(app),
                          const SizedBox(height: AppSpacing.l),
                          _buildDocumentScrutinyCard(context, state, app),
                          const SizedBox(height: AppSpacing.l),
                          TimelineWidget(application: app),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 80), // Padding for sticky bottom bar
              ],
            ),
          ),
        ),
      ),

      // Sticky Bottom Action Bar (O-04 requirement)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.s),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          boxShadow: [
            BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, -4)),
          ],
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 700;

              final buttonWrap = Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                alignment: isNarrow ? WrapAlignment.center : WrapAlignment.end,
                children: [
                  AppButton(
                    label: isNarrow ? 'Request Info' : 'Request Info / Correction',
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.small,
                    leadingIcon: Icons.help_outline_rounded,
                    onPressed: () async {
                      final result = await ModalDialogs.showRequestInfoModal(
                        context: context,
                        application: app,
                      );
                      if (result != null) {
                        state.officerRequestInformation(
                          applicationId: app.id,
                          reasonCategory: result['category']!,
                          documentId: result['docId']!,
                          message: result['message']!,
                        );
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notice dispatched to citizen. Status updated.')),
                        );
                        widget.onActionCompleted();
                      }
                    },
                  ),
                  AppButton(
                    label: isNarrow ? 'Reject' : 'Reject Application',
                    variant: AppButtonVariant.danger,
                    size: AppButtonSize.small,
                    leadingIcon: Icons.block_rounded,
                    onPressed: () async {
                      final result = await ModalDialogs.showRejectModal(
                        context: context,
                        application: app,
                      );
                      if (result != null) {
                        state.officerRejectApplication(
                          applicationId: app.id,
                          reasonCategory: result['category']!,
                          remarks: result['remarks']!,
                        );
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Application rejected with formal grounds recorded.')),
                        );
                        widget.onActionCompleted();
                      }
                    },
                  ),
                  AppButton(
                    label: isNarrow ? 'Approve & Issue' : 'Approve & Issue Certificate',
                    variant: AppButtonVariant.success,
                    size: AppButtonSize.small,
                    leadingIcon: Icons.verified_rounded,
                    onPressed: () async {
                      final remarks = await ModalDialogs.showApproveModal(
                        context: context,
                        application: app,
                      );
                      if (remarks != null) {
                        state.officerApproveApplication(
                          applicationId: app.id,
                          officerNotes: remarks,
                        );
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Application approved and official digital certificate generated!')),
                        );
                        widget.onActionCompleted();
                      }
                    },
                  ),
                ],
              );

              if (isNarrow) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Docket Reference: ${app.id}',
                      style: AppTypography.code.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    buttonWrap,
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Docket Reference: ${app.id}',
                    style: AppTypography.code.copyWith(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  buttonWrap,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCitizenAndAnswersCard(ApplicationModel app) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Citizen Profile & Application Responses', style: AppTypography.h3),
            const Divider(),
            const SizedBox(height: AppSpacing.s),

            _detailRow('Full Name', app.citizenName),
            _detailRow('Aadhaar (Masked)', app.citizenAadhaar),
            _detailRow('Mobile Phone', app.citizenPhone),
            _detailRow('Address', app.citizenAddress),

            if (app.formData.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.m),
              Text('Submitted Questionnaire Answers:', style: AppTypography.labelBold),
              const SizedBox(height: AppSpacing.xs),
              ...app.formData.entries.map((entry) {
                return _detailRow(entry.key, entry.value?.toString() ?? 'N/A');
              }),
            ],

            const SizedBox(height: AppSpacing.m),
            const Divider(),
            const SizedBox(height: AppSpacing.s),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Statutory Data Cross-Verification',
                    style: AppTypography.labelBold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                StatusBadge.matched(isCompact: true),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            _verificationRow('Aadhaar Demographics', 'Name & DOB Match (UIDAI)', StatusBadge.matched(isCompact: true)),
            _verificationRow('Municipal Ward Registry', 'Ward 14 • Property Tax Cleared', StatusBadge.matched(isCompact: true)),
            _verificationRow('Residential Domicile', 'Maharashtra State Resident Validated', StatusBadge.matched(isCompact: true)),
          ],
        ),
      ),
    );
  }

  Widget _verificationRow(String label, String value, Widget badge) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.labelBold.copyWith(fontSize: 12)),
                Text(value, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          badge,
        ],
      ),
    );
  }

  Widget _buildDocumentScrutinyCard(BuildContext context, AppStateProvider state, ApplicationModel app) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.s,
              runSpacing: 4,
              children: [
                Text('Enclosed Documents (${app.documents.length})', style: AppTypography.h3),
                Text('Inspect for preview & stamp', style: AppTypography.bodySmall),
              ],
            ),
            const Divider(),
            const SizedBox(height: AppSpacing.s),

            if (app.documents.isEmpty)
              Text('No documents attached.', style: AppTypography.bodySmall)
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: app.documents.length,
                separatorBuilder: (context, index) => const Divider(height: AppSpacing.m),
                itemBuilder: (context, index) {
                  final doc = app.documents[index];

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 460;
                      final iconBox = Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: doc.isVerified
                              ? AppColors.successLight
                              : (doc.isFlagged ? AppColors.dangerLight : AppColors.surfaceSubtle),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          doc.isVerified
                              ? Icons.verified_rounded
                              : (doc.isFlagged ? Icons.warning_amber_rounded : Icons.description_outlined),
                          size: 20,
                          color: doc.isVerified
                              ? AppColors.success
                              : (doc.isFlagged ? AppColors.danger : AppColors.textSecondary),
                        ),
                      );

                      final textDetails = Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc.name, style: AppTypography.labelBold, overflow: TextOverflow.ellipsis),
                            Text(
                              '${doc.fileName} • ${(doc.fileSizeBytes / 1024).toStringAsFixed(0)} KB',
                              style: AppTypography.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (doc.officerComment != null)
                              Text(
                                'Note: ${doc.officerComment}',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.danger, fontSize: 11),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      );

                      final inspectBtn = AppButton(
                        label: isCompact ? 'Inspect' : 'Inspect & Verify',
                        size: AppButtonSize.small,
                        variant: AppButtonVariant.outline,
                        leadingIcon: Icons.fullscreen_rounded,
                        onPressed: () {
                          DocumentInspectorModal.show(
                            context: context,
                            document: doc,
                            applicationId: app.id,
                            onVerdict: (isVerified, comment) {
                              state.verifyDocument(
                                applicationId: app.id,
                                docId: doc.docId,
                                isVerified: isVerified,
                                comment: comment,
                              );
                            },
                          );
                        },
                      );

                      if (isCompact) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                iconBox,
                                const SizedBox(width: AppSpacing.m),
                                textDetails,
                              ],
                            ),
                            const SizedBox(height: AppSpacing.s),
                            Align(
                              alignment: Alignment.centerRight,
                              child: inspectBtn,
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          iconBox,
                          const SizedBox(width: AppSpacing.m),
                          textDetails,
                          const SizedBox(width: AppSpacing.s),
                          inspectBtn,
                        ],
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
          ),
          Expanded(
            child: Text(value, style: AppTypography.labelBold.copyWith(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
