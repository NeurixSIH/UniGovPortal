import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/models/application_model.dart';
import '../../../core/state/app_state_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

class InfoRequiredScreen extends StatefulWidget {
  final ApplicationModel application;
  final VoidCallback onBack;
  final VoidCallback onResolved;

  const InfoRequiredScreen({
    super.key,
    required this.application,
    required this.onBack,
    required this.onResolved,
  });

  @override
  State<InfoRequiredScreen> createState() => _InfoRequiredScreenState();
}

class _InfoRequiredScreenState extends State<InfoRequiredScreen> {
  int _currentStep = 0; // 0: Notice & Reason (C-13), 1: Replace Document (C-14), 2: Review & Resubmit (C-15,16), 3: Success (C-17)

  final _citizenRemarksCtrl = TextEditingController();
  UploadedDocument? _newReplacedDoc;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  bool _declarationChecked = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _citizenRemarksCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_currentStep < 3) ...[
                TextButton.icon(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Back to Application Tracking'),
                ),
                const SizedBox(height: AppSpacing.s),
              ],

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_currentStep) {
      case 0:
        return _buildNoticeStep();
      case 1:
        return _buildReplaceDocStep();
      case 2:
        return _buildReviewAndResubmitStep();
      case 3:
        return _buildSuccessStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // C-13: Clarification Notice & Requirements
  Widget _buildNoticeStep() {
    final deadlineStr = widget.application.actionDeadline != null
        ? DateFormat('dd MMMM yyyy').format(widget.application.actionDeadline!)
        : '10 Days from Notice';

    // Find flagged document
    UploadedDocument? flaggedDoc;
    try {
      flaggedDoc = widget.application.documents.firstWhere((d) => d.isFlagged);
    } catch (_) {
      flaggedDoc = widget.application.documents.isNotEmpty ? widget.application.documents.first : null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.dangerLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.dangerBorder),
              ),
              child: const Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 30),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Action Required on Your Application', style: AppTypography.h2.copyWith(color: AppColors.danger)),
                  Text(
                    'Application Reference: ${widget.application.id} • ${widget.application.serviceName}',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.l),
        const Divider(),
        const SizedBox(height: AppSpacing.l),

        // What Happened & Why Box
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
              Text('What Happened?', style: AppTypography.labelBold),
              const SizedBox(height: 4),
              Text(
                'The examining revenue officer has scrutinized your application and flagged discrepancies that require your prompt correction.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.m),

              Text('Officer Observations & Remarks:', style: AppTypography.labelBold.copyWith(color: AppColors.danger)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: AppColors.warningBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.format_quote_rounded, color: AppColors.warning),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: Text(
                        flaggedDoc?.officerComment ??
                            widget.application.actionRequiredReason ??
                            'Please re-upload a clear, gazetted or employer-certified copy.',
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.m),

              // Statutory Deadline
              Row(
                children: [
                  const Icon(Icons.alarm_on_rounded, size: 18, color: AppColors.danger),
                  const SizedBox(width: AppSpacing.s),
                  Expanded(
                    child: Text(
                      'Statutory Resolution Deadline: $deadlineStr',
                      style: AppTypography.labelBold.copyWith(color: AppColors.danger),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Action CTA
        Wrap(
          spacing: AppSpacing.m,
          runSpacing: AppSpacing.m,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppButton(
              label: 'Return to Details',
              variant: AppButtonVariant.outline,
              onPressed: widget.onBack,
            ),
            AppButton(
              label: 'Resolve Now',
              variant: AppButtonVariant.primary,
              size: AppButtonSize.large,
              leadingIcon: Icons.bolt_rounded,
              onPressed: () => setState(() => _currentStep = 1),
            ),
          ],
        ),
      ],
    );
  }

  // C-14: Correct Documents
  Widget _buildReplaceDocStep() {
    UploadedDocument? flaggedDoc;
    try {
      flaggedDoc = widget.application.documents.firstWhere((d) => d.isFlagged);
    } catch (_) {
      flaggedDoc = widget.application.documents.isNotEmpty ? widget.application.documents.first : null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 1 of 2: Upload Corrected Document', style: AppTypography.h3),
        Text('Replace the defective file with a clear, high-resolution copy.', style: AppTypography.bodySmall),
        const SizedBox(height: AppSpacing.l),
        const Divider(),
        const SizedBox(height: AppSpacing.l),

        // Flagged Document Reference
        if (flaggedDoc != null) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              color: AppColors.dangerLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.dangerBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: AppColors.danger),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Flagged File: ${flaggedDoc.name}', style: AppTypography.labelBold),
                      Text('Original file: ${flaggedDoc.fileName}', style: AppTypography.bodySmall),
                      Text('Reason: ${flaggedDoc.officerComment ?? "Illegible / Blurry"}', style: AppTypography.bodySmall.copyWith(color: AppColors.danger)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.l),
        ],

        // Upload Sandbox
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: _newReplacedDoc != null ? AppColors.successLight : AppColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: _newReplacedDoc != null ? AppColors.successBorder : AppColors.border,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                _newReplacedDoc != null ? Icons.task_alt_rounded : Icons.cloud_upload_outlined,
                size: 48,
                color: _newReplacedDoc != null ? AppColors.success : AppColors.primaryAccent,
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                _newReplacedDoc != null
                    ? 'Corrected Document Ready: ${_newReplacedDoc!.fileName}'
                    : 'Select New Certified Document (PDF / JPG / PNG)',
                style: AppTypography.labelBold,
              ),
              const SizedBox(height: 4),
              Text(
                'Ensure document is well-lit, not tilted, and official seals are crisp.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.m),

              if (_isUploading)
                SizedBox(
                  width: 240,
                  child: Column(
                    children: [
                      LinearProgressIndicator(value: _uploadProgress),
                      const SizedBox(height: 4),
                      Text('${(_uploadProgress * 100).toInt()}% Uploading...', style: AppTypography.labelSmall),
                    ],
                  ),
                )
              else if (_newReplacedDoc != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                      label: 'Replace with Another File',
                      variant: AppButtonVariant.outline,
                      size: AppButtonSize.small,
                      onPressed: _simulateReplacementUpload,
                    ),
                  ],
                )
              else
                AppButton(
                  label: 'Browse & Upload Corrected File',
                  variant: AppButtonVariant.primary,
                  leadingIcon: Icons.upload_file_rounded,
                  onPressed: _simulateReplacementUpload,
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        AppTextField(
          label: 'Your Clarification Notes for the Officer',
          hint: 'Explain what you changed or why the new document satisfies the requirement...',
          controller: _citizenRemarksCtrl,
          maxLines: 3,
          isRequired: true,
        ),
        const SizedBox(height: AppSpacing.xl),

        Wrap(
          spacing: AppSpacing.m,
          runSpacing: AppSpacing.m,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppButton(
              label: 'Back',
              variant: AppButtonVariant.outline,
              onPressed: () => setState(() => _currentStep = 0),
            ),
            AppButton(
              label: 'Review Comparison',
              variant: AppButtonVariant.primary,
              trailingIcon: Icons.arrow_forward_rounded,
              onPressed: () {
                if (_newReplacedDoc == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please upload the corrected document before continuing.')),
                  );
                  return;
                }
                setState(() => _currentStep = 2);
              },
            ),
          ],
        ),
      ],
    );
  }

  void _simulateReplacementUpload() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.1;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 60));
      if (!mounted) return;
      setState(() => _uploadProgress = i / 10.0);
    }

    if (!mounted) return;
    setState(() {
      _isUploading = false;
      _newReplacedDoc = UploadedDocument(
        docId: widget.application.actionRequiredDocumentId ?? 'doc-replacement',
        name: 'Salary Proof / ITR Certificate (Gazetted Copy)',
        fileName: 'Salary_Slip_Attested_Clear.pdf',
        fileSizeBytes: 1540000,
        uploadedAt: DateTime.now(),
        isVerified: false,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Replacement file uploaded successfully.')),
    );
  }

  // C-15 & C-16: Review Comparison & Final Resubmit
  Widget _buildReviewAndResubmitStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 2 of 2: Compare & Resubmit', style: AppTypography.h3),
        Text('Side-by-side comparison of original vs updated submission.', style: AppTypography.bodySmall),
        const SizedBox(height: AppSpacing.l),
        const Divider(),
        const SizedBox(height: AppSpacing.l),

        // Comparison Table
        Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: AppColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 560;

                  final flaggedBox = Container(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    decoration: BoxDecoration(
                      color: AppColors.dangerLight,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(color: AppColors.dangerBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PREVIOUS (FLAGGED)', style: AppTypography.labelSmall.copyWith(color: AppColors.danger)),
                        const SizedBox(height: 4),
                        Text('Salary_Slip_FY2025.pdf', style: AppTypography.labelBold),
                        Text('Status: Rejected (Blurry / Low Quality)', style: AppTypography.bodySmall),
                      ],
                    ),
                  );

                  final replacedBox = Container(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(color: AppColors.successBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NEW (REPLACED)', style: AppTypography.labelSmall.copyWith(color: AppColors.success)),
                        const SizedBox(height: 4),
                        Text(_newReplacedDoc?.fileName ?? 'Attested.pdf', style: AppTypography.labelBold),
                        Text('Certified High-Resolution Copy', style: AppTypography.bodySmall),
                      ],
                    ),
                  );

                  if (isCompact) {
                    return Column(
                      children: [
                        flaggedBox,
                        const SizedBox(height: AppSpacing.s),
                        const Icon(Icons.arrow_downward_rounded, color: AppColors.primaryAccent),
                        const SizedBox(height: AppSpacing.s),
                        replacedBox,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: flaggedBox),
                      const SizedBox(width: AppSpacing.m),
                      const Icon(Icons.arrow_forward_rounded, color: AppColors.primaryAccent),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(child: replacedBox),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.m),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Citizen Explanation: ', style: AppTypography.labelBold.copyWith(fontSize: 12)),
                  Expanded(
                    child: Text(
                      _citizenRemarksCtrl.text.isNotEmpty ? _citizenRemarksCtrl.text : 'No extra notes provided.',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        // Declaration Checkbox
        CheckboxListTile(
          value: _declarationChecked,
          onChanged: (val) => setState(() => _declarationChecked = val ?? false),
          title: Text(
            'Declaration of Authenticity',
            style: AppTypography.labelBold.copyWith(fontSize: 13),
          ),
          subtitle: Text(
            'I certify that this replaced document is a true copy of the original official record.',
            style: AppTypography.bodySmall,
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpacing.xl),

        Wrap(
          spacing: AppSpacing.m,
          runSpacing: AppSpacing.m,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppButton(
              label: 'Back',
              variant: AppButtonVariant.outline,
              onPressed: () => setState(() => _currentStep = 1),
            ),
            AppButton(
              label: 'Resubmit Application',
              variant: _declarationChecked ? AppButtonVariant.primary : AppButtonVariant.outline,
              size: AppButtonSize.large,
              isLoading: _isSubmitting,
              leadingIcon: Icons.send_rounded,
              onPressed: _declarationChecked ? _handleResubmit : null,
            ),
          ],
        ),
      ],
    );
  }

  void _handleResubmit() async {
    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    final state = context.read<AppStateProvider>();
    final updatedList = widget.application.documents.map((d) {
      if (d.docId == _newReplacedDoc?.docId || d.isFlagged) {
        return _newReplacedDoc!;
      }
      return d;
    }).toList();

    state.resolveInformationRequired(
      applicationId: widget.application.id,
      updatedDocuments: updatedList,
      citizenRemarks: _citizenRemarksCtrl.text.trim(),
    );

    setState(() {
      _isSubmitting = false;
      _currentStep = 3;
    });
  }

  // C-17: Resubmission Success Screen
  Widget _buildSuccessStep() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.l),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.successBorder, width: 2),
              ),
              child: const Icon(Icons.done_all_rounded, color: AppColors.success, size: 54),
            ),
            const SizedBox(height: AppSpacing.l),
            Text('Application Resubmitted Successfully!', style: AppTypography.h1, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Your corrected documents have been queued for the Sub-Divisional Magistrate on priority scrutiny.',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),

            Container(
              padding: const EdgeInsets.all(AppSpacing.l),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Text('STATUS: RESUBMITTED (ON PRIORITY)', style: AppTypography.labelBold.copyWith(color: AppColors.primaryAccent)),
                  const SizedBox(height: 4),
                  Text('Reference: ${widget.application.id}', style: AppTypography.code.copyWith(fontWeight: FontWeight.w700)),
                  Text('Timestamp: ${DateFormat("dd MMM yyyy, hh:mm a").format(DateTime.now())}', style: AppTypography.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            AppButton(
              label: 'Track Application Status',
              size: AppButtonSize.large,
              leadingIcon: Icons.timeline_rounded,
              onPressed: widget.onResolved,
            ),
          ],
        ),
      ),
    );
  }
}
