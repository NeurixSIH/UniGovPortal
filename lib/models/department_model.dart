import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentModel {
  final String departmentId;
  final String departmentName;
  final String description;
  final String logo;
  final String contactEmail;
  final String contactNumber;
  final String status; // 'active', 'inactive'
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String createdBy;

  const DepartmentModel({
    required this.departmentId,
    required this.departmentName,
    required this.description,
    required this.logo,
    required this.contactEmail,
    required this.contactNumber,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  // Status constants
  static const String statusActive = 'active';
  static const String statusInactive = 'inactive';

  factory DepartmentModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return DepartmentModel(
      departmentId: map['departmentId'] ?? docId ?? '',
      departmentName: map['departmentName'] ?? '',
      description: map['description'] ?? '',
      logo: map['logo'] ?? '',
      contactEmail: map['contactEmail'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      status: map['status'] ?? statusActive,
      createdAt: map['createdAt'] is Timestamp ? map['createdAt'] : Timestamp.now(),
      updatedAt: map['updatedAt'] is Timestamp ? map['updatedAt'] : Timestamp.now(),
      createdBy: map['createdBy'] ?? '',
    );
  }

  factory DepartmentModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return DepartmentModel.fromMap(doc.data() ?? {}, docId: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'departmentId': departmentId,
      'departmentName': departmentName,
      'description': description,
      'logo': logo,
      'contactEmail': contactEmail,
      'contactNumber': contactNumber,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
    };
  }

  DepartmentModel copyWith({
    String? departmentId,
    String? departmentName,
    String? description,
    String? logo,
    String? contactEmail,
    String? contactNumber,
    String? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? createdBy,
  }) {
    return DepartmentModel(
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      contactEmail: contactEmail ?? this.contactEmail,
      contactNumber: contactNumber ?? this.contactNumber,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
