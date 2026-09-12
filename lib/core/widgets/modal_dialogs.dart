import 'package:flutter/material.dart';
import '../models/application_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_button.dart';
import 'app_text_field.dart';

class ModalDialogs {
  /// Confirmation Modal
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
    IconData icon = Icons.help_outline_rounded,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        contentPadding: const EdgeInsets.all(AppSpacing.l),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  decoration: BoxDecoration(
                    color: isDestructive ? AppColors.dangerLight : AppColors.primarySurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: isDestructive ? AppColors.danger : AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                Text(title, style: AppTypography.h3, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.s),
                Text(
                  message,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.l),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: cancelLabel,
                        variant: AppButtonVariant.outline,
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: AppButton(
                        label: confirmLabel,
                        variant: isDestructive ? AppButtonVariant.danger : AppButtonVariant.primary,
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Officer Request Information Modal
  static Future<Map<String, String>?> showRequestInfoModal({
    required BuildContext context,
    required ApplicationModel application,
  }) {
    String selectedCategory = 'Illegible / Blurry Document';
    String selectedDocId = application.documents.isNotEmpty ? application.documents.first.docId : '';
    final messageCtrl = TextEditingController();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          final isSendEnabled = messageCtrl.text.trim().isNotEmpty;

          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
            contentPadding: const EdgeInsets.all(AppSpacing.l),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.s),
                          decoration: const BoxDecoration(
                            color: AppColors.warningLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.announcement_rounded, color: AppColors.warning, size: 22),
                        ),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Request Clarification / Document', style: AppTypography.h3),
                              Text('Application ID: ${application.id}', style: AppTypography.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.m),

                    // Reason Category
                    Text('Reason Category', style: AppTypography.labelBold),
                    const SizedBox(height: AppSpacing.xs),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                      items: const [
                        DropdownMenuItem(
                          value: 'Illegible / Blurry Document',
                          child: Text('Illegible / Blurry Document'),
                        ),
                        DropdownMenuItem(
                          value: 'Document Expired / Outdated',
                          child: Text('Document Expired / Outdated'),
                        ),
                        DropdownMenuItem(
                          value: 'Discrepancy in Name / Date of Birth',
                          child: Text('Discrepancy in Name / Date of Birth'),
                        ),
                        DropdownMenuItem(
                          value: 'Missing Official Stamp / Signature',
                          child: Text('Missing Official Stamp / Signature'),
                        ),
                        DropdownMenuItem(
                          value: 'Additional Corroborative Proof Needed',
                          child: Text('Additional Corroborative Proof Needed'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: AppSpacing.m),

                    // Target Document
                    if (application.documents.isNotEmpty) ...[
                      Text('Affected Document', style: AppTypography.labelBold),
                      const SizedBox(height: AppSpacing.xs),
                      DropdownButtonFormField<String>(
                        value: selectedDocId,
                        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                        items: application.documents
                            .map(
                              (d) => DropdownMenuItem(
                                value: d.docId,
                                child: Text(d.name, overflow: TextOverflow.ellipsis),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedDocId = val);
                        },
                      ),
                      const SizedBox(height: AppSpacing.m),
                    ],

                    // Officer Message
                    AppTextField(
                      label: 'Officer Instructions to Citizen',
                      hint: 'Clearly explain what document or clarification is required and why...',
                      controller: messageCtrl,
                      maxLines: 3,
                      isRequired: true,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.l),

                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'Cancel',
                            variant: AppButtonVariant.outline,
                            onPressed: () {
                              messageCtrl.dispose();
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: AppButton(
                            label: 'Send Request',
                            variant: AppButtonVariant.primary,
                            leadingIcon: Icons.send_rounded,
                            onPressed: isSendEnabled
                                ? () {
                                    final res = {
                                      'category': selectedCategory,
                                      'docId': selectedDocId,
                                      'message': messageCtrl.text.trim(),
                                    };
                                    messageCtrl.dispose();
                                    Navigator.of(dialogContext).pop(res);
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Officer Approve Modal
  static Future<String?> showApproveModal({
    required BuildContext context,
    required ApplicationModel application,
  }) {
    final remarksCtrl = TextEditingController(text: 'All submitted documents and statutory records verified. Recommended for digital certificate issuance.');

    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        contentPadding: const EdgeInsets.all(AppSpacing.l),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  decoration: const BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified_rounded, color: AppColors.success, size: 32),
                ),
                const SizedBox(height: AppSpacing.m),
                Text('Sanction & Approve Application', style: AppTypography.h3),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Approving will generate the official digitally-signed certificate and notify ${application.citizenName}.',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.l),
                AppTextField(
                  label: 'Approval Notes / Endorsement Remarks',
                  hint: 'Enter official remarks for the registry record...',
                  controller: remarksCtrl,
                  maxLines: 3,
                  isRequired: true,
                ),
                const SizedBox(height: AppSpacing.l),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Cancel',
                        variant: AppButtonVariant.outline,
                        onPressed: () {
                          remarksCtrl.dispose();
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: AppButton(
                        label: 'Confirm Approval',
                        variant: AppButtonVariant.success,
                        leadingIcon: Icons.check_circle_rounded,
                        onPressed: () {
                          final text = remarksCtrl.text.trim();
                          remarksCtrl.dispose();
                          Navigator.of(dialogContext).pop(text);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Officer Reject Modal (Reason mandatory per Part 28 & Part 64)
  static Future<Map<String, String>?> showRejectModal({
    required BuildContext context,
    required ApplicationModel application,
  }) {
    String selectedCategory = 'Eligibility Criteria Not Met';
    final remarksCtrl = TextEditingController();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          final isRejectEnabled = remarksCtrl.text.trim().isNotEmpty;

          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
            contentPadding: const EdgeInsets.all(AppSpacing.l),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.s),
                          decoration: const BoxDecoration(
                            color: AppColors.dangerLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.cancel_outlined, color: AppColors.danger, size: 24),
                        ),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Formal Application Rejection', style: AppTypography.h3.copyWith(color: AppColors.danger)),
                              Text('Application ID: ${application.id}', style: AppTypography.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Text(
                      'Per government standards, a rejection MUST clearly state the statutory clause and provide actionable next steps for the citizen.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.m),

                    Text('Rejection Category', style: AppTypography.labelBold),
                    const SizedBox(height: AppSpacing.xs),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                      items: const [
                        DropdownMenuItem(
                          value: 'Eligibility Criteria Not Met',
                          child: Text('Eligibility Criteria Not Met'),
                        ),
                        DropdownMenuItem(
                          value: 'Zoning & Master Plan Non-Compliance',
                          child: Text('Zoning & Master Plan Non-Compliance'),
                        ),
                        DropdownMenuItem(
                          value: 'Forged or Non-Authentic Documentation',
                          child: Text('Forged or Non-Authentic Documentation'),
                        ),
                        DropdownMenuItem(
                          value: 'Jurisdiction Outside Municipal Limits',
                          child: Text('Jurisdiction Outside Municipal Limits'),
                        ),
                        DropdownMenuItem(
                          value: 'Duplicate Active Application Exists',
                          child: Text('Duplicate Active Application Exists'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: AppSpacing.m),

                    AppTextField(
                      label: 'Detailed Official Grounds for Rejection (Required)',
                      hint: 'State the specific sections, missing prerequisites, or inspection findings...',
                      controller: remarksCtrl,
                      maxLines: 3,
                      isRequired: true,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.l),

                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'Cancel',
                            variant: AppButtonVariant.outline,
                            onPressed: () {
                              remarksCtrl.dispose();
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: AppButton(
                            label: 'Confirm Rejection',
                            variant: AppButtonVariant.danger,
                            leadingIcon: Icons.block_rounded,
                            onPressed: isRejectEnabled
                                ? () {
                                    final res = {
                                      'category': selectedCategory,
                                      'remarks': remarksCtrl.text.trim(),
                                    };
                                    remarksCtrl.dispose();
                                    Navigator.of(dialogContext).pop(res);
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

