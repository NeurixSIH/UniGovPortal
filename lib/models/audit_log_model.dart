import 'package:cloud_firestore/cloud_firestore.dart';

class AuditLogModel {
  final String logId;
  final String userId;
  final String departmentId;
  final String serviceId;
  final String action;
  final Map<String, dynamic> dataChanged;
  final String performedBy;
  final Timestamp timestamp;

  const AuditLogModel({
    required this.logId,
    required this.userId,
    required this.departmentId,
    required this.serviceId,
    required this.action,
    required this.dataChanged,
    required this.performedBy,
    required this.timestamp,
  });

  // Action constants
  static const String actionUserCreated = 'user_created';
  static const String actionUserUpdated = 'user_updated';
  static const String actionDocumentUploaded = 'document_uploaded';
  static const String actionDocumentVerified = 'document_verified';
  static const String actionApplicationSubmitted = 'application_submitted';
  static const String actionApplicationStatusUpdated = 'application_status_updated';
  static const String actionConsentGranted = 'consent_granted';
  static const String actionConsentRevoked = 'consent_revoked';

  factory AuditLogModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return AuditLogModel(
      logId: map['logId'] ?? docId ?? '',
      userId: map['userId'] ?? '',
      departmentId: map['departmentId'] ?? '',
      serviceId: map['serviceId'] ?? '',
      action: map['action'] ?? '',
      dataChanged: map['dataChanged'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(map['dataChanged'])
          : (map['dataChanged'] is Map
              ? Map<String, dynamic>.from(map['dataChanged'])
              : {}),
      performedBy: map['performedBy'] ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? map['timestamp']
          : Timestamp.now(),
    );
  }

  factory AuditLogModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return AuditLogModel.fromMap(doc.data() ?? {}, docId: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'logId': logId,
      'userId': userId,
      'departmentId': departmentId,
      'serviceId': serviceId,
      'action': action,
      'dataChanged': dataChanged,
      'performedBy': performedBy,
      'timestamp': timestamp,
    };
  }

  AuditLogModel copyWith({
    String? logId,
    String? userId,
    String? departmentId,
    String? serviceId,
    String? action,
    Map<String, dynamic>? dataChanged,
    String? performedBy,
    Timestamp? timestamp,
  }) {
    return AuditLogModel(
      logId: logId ?? this.logId,
      userId: userId ?? this.userId,
      departmentId: departmentId ?? this.departmentId,
      serviceId: serviceId ?? this.serviceId,
      action: action ?? this.action,
      dataChanged: dataChanged ?? this.dataChanged,
      performedBy: performedBy ?? this.performedBy,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
