import 'package:flutter/material.dart';

enum NotificationType {
  submitted,
  documentUploaded,
  infoRequired,
  resubmitted,
  approved,
  rejected,
  certificateReady,
  systemAlert,
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final String? applicationId;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.applicationId,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    String? applicationId,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      applicationId: applicationId ?? this.applicationId,
      isRead: isRead ?? this.isRead,
    );
  }

  IconData get icon {
    switch (type) {
      case NotificationType.submitted:
        return Icons.send_rounded;
      case NotificationType.documentUploaded:
        return Icons.upload_file_rounded;
      case NotificationType.infoRequired:
        return Icons.warning_amber_rounded;
      case NotificationType.resubmitted:
        return Icons.update_rounded;
      case NotificationType.approved:
        return Icons.check_circle_outline_rounded;
      case NotificationType.rejected:
        return Icons.cancel_outlined;
      case NotificationType.certificateReady:
        return Icons.verified_rounded;
      case NotificationType.systemAlert:
        return Icons.campaign_rounded;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.submitted:
        return const Color(0xFF2563EB);
      case NotificationType.documentUploaded:
        return const Color(0xFF0D9488);
      case NotificationType.infoRequired:
        return const Color(0xFFD97706);
      case NotificationType.resubmitted:
        return const Color(0xFF0284C7);
      case NotificationType.approved:
      case NotificationType.certificateReady:
        return const Color(0xFF059669);
      case NotificationType.rejected:
        return const Color(0xFFDC2626);
      case NotificationType.systemAlert:
        return const Color(0xFF7C3AED);
    }
  }
}
