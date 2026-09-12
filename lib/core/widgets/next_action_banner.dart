import 'package:flutter/material.dart';
import '../models/application_model.dart';
import '../models/application_status.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_button.dart';

class NextActionBanner extends StatelessWidget {
  final ApplicationModel application;
  final VoidCallback? onActionPressed;
  final bool isProminent;

  const NextActionBanner({
    super.key,
    required this.application,
    this.onActionPressed,
    this.isProminent = false,
  });

  @override
  Widget build(BuildContext context) {
    final status = application.status;
    final isUrgent = status == AppStatus.informationRequired;

    String title;
    String description;
    String? ctaLabel = status.nextActionLabel;
    AppButtonVariant buttonVariant = AppButtonVariant.primary;

    switch (status) {
      case AppStatus.informationRequired:
        title = 'Action Required: Clarification Needed';
        description = application.actionRequiredReason ??
            'The officer requested updated documents or clarifications. Please review and resolve.';
        buttonVariant = AppButtonVariant.danger;
        break;
      case AppStatus.approved:
      case AppStatus.certificateGenerated:
        title = 'Application Approved';
        description = 'Official certificate has been generated with digital cryptographic seal and QR verification.';
        buttonVariant = AppButtonVariant.success;
        break;
      case AppStatus.rejected:
        title = 'Application Not Approved';
        description = application.rejectionRemarks ??
            'The application could not be processed due to statutory non-compliance.';
        buttonVariant = AppButtonVariant.outline;
        break;
      case AppStatus.underReview:
        title = 'Department Scrutiny In Progress';
        description = 'Assigned officer (${application.assignedOfficerName ?? "Competent Authority"}) is evaluating your dossier. No citizen action needed.';
        break;
      case AppStatus.documentsUnderVerification:
        title = 'Document Authenticity Check';
        description = 'Automated validation with central databases in progress.';
        break;
      case AppStatus.submitted:
        title = 'Queued for Verification';
        description = 'Your application has been received and allotted a tracking reference.';
        break;
      case AppStatus.resubmitted:
        title = 'Updated Submission Received';
        description = 'Your corrected submission is currently pending officer review.';
        break;
      case AppStatus.completed:
        title = 'Service Lifecycle Completed';
        description = 'This service request is archived in the state public register.';
        break;
      case AppStatus.draft:
        title = 'Draft Application Pending';
        description = 'Complete the remaining form steps to submit for department review.';
        break;
    }

    final bg = isUrgent
        ? AppColors.dangerLight
        : (status == AppStatus.approved || status == AppStatus.certificateGenerated
            ? AppColors.successLight
            : AppColors.primarySurface);

    final border = isUrgent
        ? AppColors.dangerBorder
        : (status == AppStatus.approved || status == AppStatus.certificateGenerated
            ? AppColors.successBorder
            : AppColors.infoBorder);

    final iconColor = isUrgent
        ? AppColors.danger
        : (status == AppStatus.approved || status == AppStatus.certificateGenerated
            ? AppColors.success
            : AppColors.primaryAccent);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: border, width: 1.5),
      ),
      padding: EdgeInsets.all(isProminent ? AppSpacing.xl : AppSpacing.m),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;

          final iconWidget = Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 2)),
              ],
            ),
            child: Icon(status.icon, color: iconColor, size: isProminent ? 26 : 22),
          );

          final textContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.h3.copyWith(
                        color: isUrgent
                            ? AppColors.danger
                            : (status == AppStatus.approved || status == AppStatus.certificateGenerated
                                ? AppColors.success
                                : AppColors.primary),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          );

          final actionButton = onActionPressed != null
              ? AppButton(
                  label: ctaLabel,
                  variant: buttonVariant,
                  size: isProminent ? AppButtonSize.large : AppButtonSize.medium,
                  onPressed: onActionPressed,
                  leadingIcon: status == AppStatus.informationRequired
                      ? Icons.bolt_rounded
                      : (status == AppStatus.certificateGenerated || status == AppStatus.approved
                          ? Icons.download_rounded
                          : Icons.arrow_forward_rounded),
                )
              : null;

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    iconWidget,
                    const SizedBox(width: AppSpacing.m),
                    Expanded(child: textContent),
                  ],
                ),
                if (actionButton != null) ...[
                  const SizedBox(height: AppSpacing.m),
                  SizedBox(width: double.infinity, child: actionButton),
                ],
              ],
            );
          }

          return Row(
            children: [
              iconWidget,
              const SizedBox(width: AppSpacing.m),
              Expanded(child: textContent),
              if (actionButton != null) ...[
                const SizedBox(width: AppSpacing.m),
                actionButton,
              ],
            ],
          );
        },
      ),
    );
  }
}
