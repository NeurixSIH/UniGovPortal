import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AppStatus {
  draft,
  submitted,
  documentsUnderVerification,
  underReview,
  informationRequired,
  resubmitted,
  approved,
  rejected,
  certificateGenerated,
  completed,
}

enum NextActionType {
  continueDraft,
  trackApplication,
  viewVerification,
  viewOfficerNotes,
  resolveNow,
  trackResubmission,
  downloadCertificate,
  viewRejectionReason,
  viewSummary,
  none,
}

extension AppStatusExtension on AppStatus {
  String get code {
    switch (this) {
      case AppStatus.draft:
        return 'DRAFT';
      case AppStatus.submitted:
        return 'SUBMITTED';
      case AppStatus.documentsUnderVerification:
        return 'DOCUMENTS_UNDER_VERIFICATION';
      case AppStatus.underReview:
        return 'UNDER_REVIEW';
      case AppStatus.informationRequired:
        return 'INFORMATION_REQUIRED';
      case AppStatus.resubmitted:
        return 'RESUBMITTED';
      case AppStatus.approved:
        return 'APPROVED';
      case AppStatus.rejected:
        return 'REJECTED';
      case AppStatus.certificateGenerated:
        return 'CERTIFICATE_GENERATED';
      case AppStatus.completed:
        return 'COMPLETED';
    }
  }

  String get label {
    switch (this) {
      case AppStatus.draft:
        return 'Draft';
      case AppStatus.submitted:
        return 'Submitted';
      case AppStatus.documentsUnderVerification:
        return 'Doc Verification';
      case AppStatus.underReview:
        return 'Under Review';
      case AppStatus.informationRequired:
        return 'Action Required';
      case AppStatus.resubmitted:
        return 'Resubmitted';
      case AppStatus.approved:
        return 'Approved';
      case AppStatus.rejected:
        return 'Rejected';
      case AppStatus.certificateGenerated:
        return 'Certificate Ready';
      case AppStatus.completed:
        return 'Completed';
    }
  }

  String get supportingText {
    switch (this) {
      case AppStatus.draft:
        return 'Application started but not yet submitted.';
      case AppStatus.submitted:
        return 'Application received and queued for department intake.';
      case AppStatus.documentsUnderVerification:
        return 'Automated and Level-1 document authenticity checks underway.';
      case AppStatus.underReview:
        return 'Assigned officer is actively scrutinizing the application dossier.';
      case AppStatus.informationRequired:
        return 'Officer flagged discrepancies. Immediate citizen action required.';
      case AppStatus.resubmitted:
        return 'Citizen submitted corrected files. Awaiting officer verification.';
      case AppStatus.approved:
        return 'Department has approved the request. Certificate generation initiated.';
      case AppStatus.rejected:
        return 'Application rejected with formal grounds and officer remarks.';
      case AppStatus.certificateGenerated:
        return 'Digitally signed official certificate is ready with QR verification.';
      case AppStatus.completed:
        return 'Service cycle complete and officially archived in state register.';
    }
  }

  Color get color {
    switch (this) {
      case AppStatus.draft:
        return AppColors.textMuted;
      case AppStatus.submitted:
        return AppColors.info;
      case AppStatus.documentsUnderVerification:
        return AppColors.primaryAccent;
      case AppStatus.underReview:
        return const Color(0xFF6366F1); // Indigo
      case AppStatus.informationRequired:
        return AppColors.warning;
      case AppStatus.resubmitted:
        return const Color(0xFF0284C7); // Sky
      case AppStatus.approved:
        return AppColors.success;
      case AppStatus.rejected:
        return AppColors.danger;
      case AppStatus.certificateGenerated:
        return AppColors.success;
      case AppStatus.completed:
        return const Color(0xFF047857);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case AppStatus.draft:
        return AppColors.surfaceSubtle;
      case AppStatus.submitted:
        return AppColors.infoLight;
      case AppStatus.documentsUnderVerification:
        return const Color(0xFFEEF2FF);
      case AppStatus.underReview:
        return const Color(0xFFEEF2FF);
      case AppStatus.informationRequired:
        return AppColors.warningLight;
      case AppStatus.resubmitted:
        return const Color(0xFFF0F9FF);
      case AppStatus.approved:
      case AppStatus.certificateGenerated:
      case AppStatus.completed:
        return AppColors.successLight;
      case AppStatus.rejected:
        return AppColors.dangerLight;
    }
  }

  Color get borderColor {
    switch (this) {
      case AppStatus.draft:
        return AppColors.border;
      case AppStatus.submitted:
        return AppColors.infoBorder;
      case AppStatus.documentsUnderVerification:
        return const Color(0xFFC7D2FE);
      case AppStatus.underReview:
        return const Color(0xFFC7D2FE);
      case AppStatus.informationRequired:
        return AppColors.warningBorder;
      case AppStatus.resubmitted:
        return const Color(0xFFBAE6FD);
      case AppStatus.approved:
      case AppStatus.certificateGenerated:
      case AppStatus.completed:
        return AppColors.successBorder;
      case AppStatus.rejected:
        return AppColors.dangerBorder;
    }
  }

  IconData get icon {
    switch (this) {
      case AppStatus.draft:
        return Icons.edit_note_rounded;
      case AppStatus.submitted:
        return Icons.send_rounded;
      case AppStatus.documentsUnderVerification:
        return Icons.document_scanner_rounded;
      case AppStatus.underReview:
        return Icons.pending_actions_rounded;
      case AppStatus.informationRequired:
        return Icons.warning_amber_rounded;
      case AppStatus.resubmitted:
        return Icons.update_rounded;
      case AppStatus.approved:
        return Icons.check_circle_outline_rounded;
      case AppStatus.rejected:
        return Icons.cancel_outlined;
      case AppStatus.certificateGenerated:
        return Icons.verified_rounded;
      case AppStatus.completed:
        return Icons.task_alt_rounded;
    }
  }

  NextActionType get nextActionType {
    switch (this) {
      case AppStatus.draft:
        return NextActionType.continueDraft;
      case AppStatus.submitted:
      case AppStatus.documentsUnderVerification:
        return NextActionType.trackApplication;
      case AppStatus.underReview:
        return NextActionType.viewOfficerNotes;
      case AppStatus.informationRequired:
        return NextActionType.resolveNow;
      case AppStatus.resubmitted:
        return NextActionType.trackResubmission;
      case AppStatus.approved:
      case AppStatus.certificateGenerated:
        return NextActionType.downloadCertificate;
      case AppStatus.rejected:
        return NextActionType.viewRejectionReason;
      case AppStatus.completed:
        return NextActionType.viewSummary;
    }
  }

  String get nextActionLabel {
    switch (this) {
      case AppStatus.draft:
        return 'Continue Application';
      case AppStatus.submitted:
      case AppStatus.documentsUnderVerification:
        return 'Track Application';
      case AppStatus.underReview:
        return 'View Progress';
      case AppStatus.informationRequired:
        return 'Resolve Now';
      case AppStatus.resubmitted:
        return 'Track Status';
      case AppStatus.approved:
      case AppStatus.certificateGenerated:
        return 'Download Certificate';
      case AppStatus.rejected:
        return 'View Reason / Re-apply';
      case AppStatus.completed:
        return 'View Archival Copy';
    }
  }

  String get nextActionDescription {
    switch (this) {
      case AppStatus.draft:
        return 'You have unsaved or pending steps. Complete them to submit.';
      case AppStatus.submitted:
        return 'Central registry acknowledged your submission.';
      case AppStatus.documentsUnderVerification:
        return 'Automated and OCR verification in progress. No citizen action needed.';
      case AppStatus.underReview:
        return 'The department officer is evaluating your file.';
      case AppStatus.informationRequired:
        return 'Action required: Upload requested document or provide missing details.';
      case AppStatus.resubmitted:
        return 'Your updated submission was queued for review on priority.';
      case AppStatus.approved:
      case AppStatus.certificateGenerated:
        return 'Your service request succeeded. Official certificate generated with QR code.';
      case AppStatus.rejected:
        return 'Review the rejection remarks and re-apply or raise a grievance.';
      case AppStatus.completed:
        return 'This service lifecycle is complete.';
    }
  }
}
