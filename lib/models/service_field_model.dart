import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceFieldModel {
  final String fieldId;
  final String serviceId;
  final String fieldName;
  final String label;
  final String fieldType;
  final bool required;
  final List<String> options;
  final String dataSource;
  final num order;
  final String status;

  const ServiceFieldModel({
    required this.fieldId,
    required this.serviceId,
    required this.fieldName,
    required this.label,
    required this.fieldType,
    required this.required,
    required this.options,
    required this.dataSource,
    required this.order,
    required this.status,
  });

  // Field Type constants
  static const String fieldTypeText = 'text';
  static const String fieldTypeNumber = 'number';
  static const String fieldTypeDate = 'date';
  static const String fieldTypeDropdown = 'dropdown';
  static const String fieldTypeFile = 'file';
  static const String fieldTypeCheckbox = 'checkbox';

  // Data Source constants
  static const String dataSourceProfile = 'Profile';
  static const String dataSourceDepartment = 'Department';
  static const String dataSourceUserInput = 'User Input';

  // Status constants
  static const String statusActive = 'active';
  static const String statusInactive = 'inactive';

  factory ServiceFieldModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return ServiceFieldModel(
      fieldId: map['fieldId'] ?? docId ?? '',
      serviceId: map['serviceId'] ?? '',
      fieldName: map['fieldName'] ?? '',
      label: map['label'] ?? '',
      fieldType: map['fieldType'] ?? fieldTypeText,
      required: map['required'] is bool ? map['required'] : (map['required'] == 'true'),
      options: (map['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      dataSource: map['dataSource'] ?? dataSourceUserInput,
      order: map['order'] ?? 0,
      status: map['status'] ?? statusActive,
    );
  }

  factory ServiceFieldModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ServiceFieldModel.fromMap(doc.data() ?? {}, docId: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'fieldId': fieldId,
      'serviceId': serviceId,
      'fieldName': fieldName,
      'label': label,
      'fieldType': fieldType,
      'required': required,
      'options': options,
      'dataSource': dataSource,
      'order': order,
      'status': status,
    };
  }

  ServiceFieldModel copyWith({
    String? fieldId,
    String? serviceId,
    String? fieldName,
    String? label,
    String? fieldType,
    bool? required,
    List<String>? options,
    String? dataSource,
    num? order,
    String? status,
  }) {
    return ServiceFieldModel(
      fieldId: fieldId ?? this.fieldId,
      serviceId: serviceId ?? this.serviceId,
      fieldName: fieldName ?? this.fieldName,
      label: label ?? this.label,
      fieldType: fieldType ?? this.fieldType,
      required: required ?? this.required,
      options: options ?? this.options,
      dataSource: dataSource ?? this.dataSource,
      order: order ?? this.order,
      status: status ?? this.status,
    );
  }
}
