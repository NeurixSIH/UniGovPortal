import 'package:flutter_test/flutter_test.dart';
import 'package:uni_gov_portal/models/service_field_model.dart';

void main() {
  group('ServiceFieldModel Tests', () {
    test('toMap and fromMap serialize and deserialize correctly', () {
      final field = ServiceFieldModel(
        fieldId: 'FIELD_ANNUAL_INCOME_001',
        serviceId: 'SRV_INCOME_CERT_001',
        fieldName: 'annualIncome',
        label: 'Annual Family Income (in INR)',
        fieldType: ServiceFieldModel.fieldTypeNumber,
        required: true,
        options: [],
        dataSource: ServiceFieldModel.dataSourceUserInput,
        order: 1,
        status: ServiceFieldModel.statusActive,
      );

      final map = field.toMap();

      expect(map['fieldId'], 'FIELD_ANNUAL_INCOME_001');
      expect(map['serviceId'], 'SRV_INCOME_CERT_001');
      expect(map['fieldName'], 'annualIncome');
      expect(map['label'], 'Annual Family Income (in INR)');
      expect(map['fieldType'], ServiceFieldModel.fieldTypeNumber);
      expect(map['required'], true);
      expect(map['options'], isEmpty);
      expect(map['dataSource'], ServiceFieldModel.dataSourceUserInput);
      expect(map['order'], 1);
      expect(map['status'], ServiceFieldModel.statusActive);

      final fromMapField = ServiceFieldModel.fromMap(map);
      expect(fromMapField.fieldId, field.fieldId);
      expect(fromMapField.serviceId, field.serviceId);
      expect(fromMapField.fieldName, field.fieldName);
      expect(fromMapField.label, field.label);
      expect(fromMapField.fieldType, field.fieldType);
      expect(fromMapField.required, true);
      expect(fromMapField.options, field.options);
      expect(fromMapField.dataSource, field.dataSource);
      expect(fromMapField.order, 1);
      expect(fromMapField.status, field.status);
    });

    test('dropdown options and copyWith work properly', () {
      final field = ServiceFieldModel(
        fieldId: 'FIELD_PURPOSE_001',
        serviceId: 'SRV_INCOME_CERT_001',
        fieldName: 'purpose',
        label: 'Purpose of Certificate',
        fieldType: ServiceFieldModel.fieldTypeDropdown,
        required: true,
        options: ['Scholarship', 'Govt Subsidy', 'Ration Card Updation', 'Other'],
        dataSource: ServiceFieldModel.dataSourceUserInput,
        order: 2,
        status: ServiceFieldModel.statusActive,
      );

      expect(field.options.length, 4);

      final updated = field.copyWith(
        order: 3,
        status: ServiceFieldModel.statusInactive,
      );

      expect(updated.order, 3);
      expect(updated.status, ServiceFieldModel.statusInactive);
      expect(updated.fieldId, 'FIELD_PURPOSE_001');
    });
  });
}
