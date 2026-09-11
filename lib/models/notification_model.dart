import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notificationId;
  final String userId;
  final String type;
  final String title;
  final String message;
  final String applicationId;
  final bool isRead;
  final Timestamp createdAt;

  const NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.applicationId,
    required this.isRead,
    required this.createdAt,
  });

  // Notification type constants
  static const String typeApplicationUpdate = 'application_update';
  static const String typeConsentRequest = 'consent_request';
  static const String typeSyncMessage = 'sync_message';
  static const String typeGeneral = 'general';

  factory NotificationModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return NotificationModel(
      notificationId: map['notificationId'] ?? docId ?? '',
      userId: map['userId'] ?? '',
      type: map['type'] ?? typeGeneral,
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      applicationId: map['applicationId'] ?? '',
      isRead: map['isRead'] is bool ? map['isRead'] : (map['isRead'] == 'true'),
      createdAt: map['createdAt'] is Timestamp
          ? map['createdAt']
          : Timestamp.now(),
    );
  }

  factory NotificationModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return NotificationModel.fromMap(doc.data() ?? {}, docId: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'type': type,
      'title': title,
      'message': message,
      'applicationId': applicationId,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }

  NotificationModel copyWith({
    String? notificationId,
    String? userId,
    String? type,
    String? title,
    String? message,
    String? applicationId,
    bool? isRead,
    Timestamp? createdAt,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      applicationId: applicationId ?? this.applicationId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
