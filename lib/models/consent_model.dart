import 'package:cloud_firestore/cloud_firestore.dart';

class ConsentModel {
  final String consentId;
  final String userId;
  final String departmentId;
  final String serviceId;
  final List<String> dataFields;
  final String status;
  final Timestamp grantedAt;
  final Timestamp expiresAt;
  final Timestamp updatedAt;

  const ConsentModel({
    required this.consentId,
    required this.userId,
    required this.departmentId,
    required this.serviceId,
    required this.dataFields,
    required this.status,
    required this.grantedAt,
    required this.expiresAt,
    required this.updatedAt,
  });

  // Status constants
  static const String statusGranted = 'granted';
  static const String statusDenied = 'denied';
  static const String statusRevoked = 'revoked';

  factory ConsentModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return ConsentModel(
      consentId: map['consentId'] ?? docId ?? '',
      userId: map['userId'] ?? '',
      departmentId: map['departmentId'] ?? '',
      serviceId: map['serviceId'] ?? '',
      dataFields: (map['dataFields'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      status: map['status'] ?? statusGranted,
      grantedAt: map['grantedAt'] is Timestamp
          ? map['grantedAt']
          : Timestamp.now(),
      expiresAt: map['expiresAt'] is Timestamp
          ? map['expiresAt']
          : Timestamp.now(),
      updatedAt: map['updatedAt'] is Timestamp
          ? map['updatedAt']
          : Timestamp.now(),
    );
  }

  factory ConsentModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ConsentModel.fromMap(doc.data() ?? {}, docId: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'consentId': consentId,
      'userId': userId,
      'departmentId': departmentId,
      'serviceId': serviceId,
      'dataFields': dataFields,
      'status': status,
      'grantedAt': grantedAt,
      'expiresAt': expiresAt,
      'updatedAt': updatedAt,
    };
  }

  ConsentModel copyWith({
    String? consentId,
    String? userId,
    String? departmentId,
    String? serviceId,
    List<String>? dataFields,
    String? status,
    Timestamp? grantedAt,
    Timestamp? expiresAt,
    Timestamp? updatedAt,
  }) {
    return ConsentModel(
      consentId: consentId ?? this.consentId,
      userId: userId ?? this.userId,
      departmentId: departmentId ?? this.departmentId,
      serviceId: serviceId ?? this.serviceId,
      dataFields: dataFields ?? this.dataFields,
      status: status ?? this.status,
      grantedAt: grantedAt ?? this.grantedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
