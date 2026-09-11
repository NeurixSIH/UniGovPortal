import 'package:cloud_firestore/cloud_firestore.dart';

class EligibilityRuleModel {
  final String ruleId;
  final String serviceId;
  final String field;
  final String operator;
  final String value;
  final String logicalOperator;
  final String message;
  final String status;

  const EligibilityRuleModel({
    required this.ruleId,
    required this.serviceId,
    required this.field,
    required this.operator,
    required this.value,
    required this.logicalOperator,
    required this.message,
    required this.status,
  });

  // Operator constants
  static const String operatorEqual = '=';
  static const String operatorGreaterThan = '>';
  static const String operatorLessThan = '<';
  static const String operatorGreaterThanOrEqual = '>=';
  static const String operatorLessThanOrEqual = '<=';
  static const String operatorNotEqual = '!=';

  // Logical operator constants
  static const String logicalAnd = 'AND';
  static const String logicalOr = 'OR';

  // Status constants
  static const String statusActive = 'active';
  static const String statusInactive = 'inactive';

  factory EligibilityRuleModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return EligibilityRuleModel(
      ruleId: map['ruleId'] ?? docId ?? '',
      serviceId: map['serviceId'] ?? '',
      field: map['field'] ?? '',
      operator: map['operator'] ?? operatorEqual,
      value: (map['value'] != null) ? map['value'].toString() : '',
      logicalOperator: map['logicalOperator'] ?? logicalAnd,
      message: map['message'] ?? '',
      status: map['status'] ?? statusActive,
    );
  }

  factory EligibilityRuleModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return EligibilityRuleModel.fromMap(doc.data() ?? {}, docId: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'ruleId': ruleId,
      'serviceId': serviceId,
      'field': field,
      'operator': operator,
      'value': value,
      'logicalOperator': logicalOperator,
      'message': message,
      'status': status,
    };
  }

  EligibilityRuleModel copyWith({
    String? ruleId,
    String? serviceId,
    String? field,
    String? operator,
    String? value,
    String? logicalOperator,
    String? message,
    String? status,
  }) {
    return EligibilityRuleModel(
      ruleId: ruleId ?? this.ruleId,
      serviceId: serviceId ?? this.serviceId,
      field: field ?? this.field,
      operator: operator ?? this.operator,
      value: value ?? this.value,
      logicalOperator: logicalOperator ?? this.logicalOperator,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
