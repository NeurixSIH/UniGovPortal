import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  final String applicationId;
  final String userId;
  final String departmentId;
  final String serviceId;
  final Map<String, dynamic> applicationData;
  final List<String> documents;
  final String status;
  final String remarks;
  final Timestamp submittedAt;
  final Timestamp updatedAt;
  final String processedBy;

  const ApplicationModel({
    required this.applicationId,
    required this.userId,
    required this.departmentId,
    required this.serviceId,
    required this.applicationData,
    required this.documents,
    required this.status,
    required this.remarks,
    required this.submittedAt,
    required this.updatedAt,
    required this.processedBy,
  });

  // Status constants
  static const String statusSubmitted = 'submitted';
  static const String statusPending = 'pending';
  static const String statusUnderReview = 'under_review';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';

  factory ApplicationModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return ApplicationModel(
      applicationId: map['applicationId'] ?? docId ?? '',
      userId: map['userId'] ?? '',
      departmentId: map['departmentId'] ?? '',
      serviceId: map['serviceId'] ?? '',
      applicationData: map['applicationData'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(map['applicationData'])
          : (map['applicationData'] is Map
              ? Map<String, dynamic>.from(map['applicationData'])
              : {}),
      documents: (map['documents'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      status: map['status'] ?? statusSubmitted,
      remarks: map['remarks'] ?? '',
      submittedAt: map['submittedAt'] is Timestamp
          ? map['submittedAt']
          : Timestamp.now(),
      updatedAt: map['updatedAt'] is Timestamp
          ? map['updatedAt']
          : Timestamp.now(),
      processedBy: map['processedBy'] ?? '',
    );
  }

  factory ApplicationModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ApplicationModel.fromMap(doc.data() ?? {}, docId: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'applicationId': applicationId,
      'userId': userId,
      'departmentId': departmentId,
      'serviceId': serviceId,
      'applicationData': applicationData,
      'documents': documents,
      'status': status,
      'remarks': remarks,
      'submittedAt': submittedAt,
      'updatedAt': updatedAt,
      'processedBy': processedBy,
    };
  }

  ApplicationModel copyWith({
    String? applicationId,
    String? userId,
    String? departmentId,
    String? serviceId,
    Map<String, dynamic>? applicationData,
    List<String>? documents,
    String? status,
    String? remarks,
    Timestamp? submittedAt,
    Timestamp? updatedAt,
    String? processedBy,
  }) {
    return ApplicationModel(
      applicationId: applicationId ?? this.applicationId,
      userId: userId ?? this.userId,
      departmentId: departmentId ?? this.departmentId,
      serviceId: serviceId ?? this.serviceId,
      applicationData: applicationData ?? this.applicationData,
      documents: documents ?? this.documents,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      submittedAt: submittedAt ?? this.submittedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      processedBy: processedBy ?? this.processedBy,
    );
  }
}
