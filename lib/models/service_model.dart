import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String serviceId;
  final String departmentId;
  final String serviceName;
  final String description;
  final String category;
  final List<String> requiredDocuments;
  final List<String> requiredFields;
  final List<String> eligibilityRules;
  final String processingTime;
  final num fee;
  final String applicationType; // 'Online', 'External', 'Hybrid'
  final String externalUrl;
  final String status; // 'active', 'inactive'
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String createdBy;

  const ServiceModel({
    required this.serviceId,
    required this.departmentId,
    required this.serviceName,
    required this.description,
    required this.category,
    required this.requiredDocuments,
    required this.requiredFields,
    required this.eligibilityRules,
    required this.processingTime,
    required this.fee,
    required this.applicationType,
    required this.externalUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  // Status constants
  static const String statusActive = 'active';
  static const String statusInactive = 'inactive';

  // Application type constants
  static const String applicationTypeOnline = 'Online';
  static const String applicationTypeExternal = 'External';
  static const String applicationTypeHybrid = 'Hybrid';

  factory ServiceModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return ServiceModel(
      serviceId: map['serviceId'] ?? docId ?? '',
      departmentId: map['departmentId'] ?? '',
      serviceName: map['serviceName'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      requiredDocuments: (map['requiredDocuments'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      requiredFields: (map['requiredFields'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      eligibilityRules: (map['eligibilityRules'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      processingTime: map['processingTime'] ?? '',
      fee: map['fee'] ?? 0,
      applicationType: map['applicationType'] ?? applicationTypeOnline,
      externalUrl: map['externalUrl'] ?? '',
      status: map['status'] ?? statusActive,
      createdAt: map['createdAt'] is Timestamp ? map['createdAt'] : Timestamp.now(),
      updatedAt: map['updatedAt'] is Timestamp ? map['updatedAt'] : Timestamp.now(),
      createdBy: map['createdBy'] ?? '',
    );
  }

  factory ServiceModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ServiceModel.fromMap(doc.data() ?? {}, docId: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'departmentId': departmentId,
      'serviceName': serviceName,
      'description': description,
      'category': category,
      'requiredDocuments': requiredDocuments,
      'requiredFields': requiredFields,
      'eligibilityRules': eligibilityRules,
      'processingTime': processingTime,
      'fee': fee,
      'applicationType': applicationType,
      'externalUrl': externalUrl,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
    };
  }

  ServiceModel copyWith({
    String? serviceId,
    String? departmentId,
    String? serviceName,
    String? description,
    String? category,
    List<String>? requiredDocuments,
    List<String>? requiredFields,
    List<String>? eligibilityRules,
    String? processingTime,
    num? fee,
    String? applicationType,
    String? externalUrl,
    String? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? createdBy,
  }) {
    return ServiceModel(
      serviceId: serviceId ?? this.serviceId,
      departmentId: departmentId ?? this.departmentId,
      serviceName: serviceName ?? this.serviceName,
      description: description ?? this.description,
      category: category ?? this.category,
      requiredDocuments: requiredDocuments ?? this.requiredDocuments,
      requiredFields: requiredFields ?? this.requiredFields,
      eligibilityRules: eligibilityRules ?? this.eligibilityRules,
      processingTime: processingTime ?? this.processingTime,
      fee: fee ?? this.fee,
      applicationType: applicationType ?? this.applicationType,
      externalUrl: externalUrl ?? this.externalUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
