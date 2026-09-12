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
  final String sourceDepartment;
  final String targetDepartment;
  final String fieldChanged;
  final String oldValue;
  final String newValue;
  final String status; // 'Success', 'Failed', 'Pending'
  final String category; // 'Profile', 'Address', 'Other'

  const AuditLogModel({
    required this.logId,
    required this.userId,
    required this.departmentId,
    required this.serviceId,
    required this.action,
    required this.dataChanged,
    required this.performedBy,
    required this.timestamp,
    this.sourceDepartment = '',
    this.targetDepartment = '',
    this.fieldChanged = '',
    this.oldValue = '',
    this.newValue = '',
    this.status = statusSuccess,
    this.category = categoryProfile,
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
  static const String actionLiveSync = 'live_sync';

  // Status constants
  static const String statusSuccess = 'Success';
  static const String statusFailed = 'Failed';
  static const String statusPending = 'Pending';

  // Category filter constants
  static const String categoryAll = 'All';
  static const String categoryProfile = 'Profile';
  static const String categoryAddress = 'Address';
  static const String categoryOther = 'Other';

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
      sourceDepartment: map['sourceDepartment'] ?? '',
      targetDepartment: map['targetDepartment'] ?? '',
      fieldChanged: map['fieldChanged'] ?? '',
      oldValue: map['oldValue']?.toString() ?? '',
      newValue: map['newValue']?.toString() ?? '',
      status: map['status'] ?? statusSuccess,
      category: map['category'] ?? categoryProfile,
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
      'sourceDepartment': sourceDepartment,
      'targetDepartment': targetDepartment,
      'fieldChanged': fieldChanged,
      'oldValue': oldValue,
      'newValue': newValue,
      'status': status,
      'category': category,
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
    String? sourceDepartment,
    String? targetDepartment,
    String? fieldChanged,
    String? oldValue,
    String? newValue,
    String? status,
    String? category,
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
      sourceDepartment: sourceDepartment ?? this.sourceDepartment,
      targetDepartment: targetDepartment ?? this.targetDepartment,
      fieldChanged: fieldChanged ?? this.fieldChanged,
      oldValue: oldValue ?? this.oldValue,
      newValue: newValue ?? this.newValue,
      status: status ?? this.status,
      category: category ?? this.category,
    );
  }
}
