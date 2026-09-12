import 'package:flutter_test/flutter_test.dart';
import 'package:citizen_connect/models/eligibility_rule_model.dart';

void main() {
  group('EligibilityRuleModel Tests', () {
    test('toMap and fromMap serialize and deserialize correctly', () {
      final rule = EligibilityRuleModel(
        ruleId: 'RULE_SAMPLE_001',
        serviceId: 'SRV_INCOME_CERT_001',
        field: 'annualIncome',
        operator: EligibilityRuleModel.operatorLessThanOrEqual,
        value: '800000',
        logicalOperator: EligibilityRuleModel.logicalAnd,
        message: 'Family annual income must not exceed 8,00,000 INR for eligibility.',
        status: EligibilityRuleModel.statusActive,
      );

      final map = rule.toMap();

      expect(map['ruleId'], 'RULE_SAMPLE_001');
      expect(map['serviceId'], 'SRV_INCOME_CERT_001');
      expect(map['field'], 'annualIncome');
      expect(map['operator'], EligibilityRuleModel.operatorLessThanOrEqual);
      expect(map['value'], '800000');
      expect(map['logicalOperator'], EligibilityRuleModel.logicalAnd);
      expect(map['message'], 'Family annual income must not exceed 8,00,000 INR for eligibility.');
      expect(map['status'], EligibilityRuleModel.statusActive);

      final fromMapRule = EligibilityRuleModel.fromMap(map);
      expect(fromMapRule.ruleId, rule.ruleId);
      expect(fromMapRule.serviceId, rule.serviceId);
      expect(fromMapRule.field, rule.field);
      expect(fromMapRule.operator, rule.operator);
      expect(fromMapRule.value, rule.value);
      expect(fromMapRule.logicalOperator, rule.logicalOperator);
      expect(fromMapRule.message, rule.message);
      expect(fromMapRule.status, rule.status);
    });

    test('copyWith works properly for eligibility rule model', () {
      final rule = EligibilityRuleModel(
        ruleId: 'RULE_002',
        serviceId: 'SRV_INCOME_CERT_001',
        field: 'state',
        operator: EligibilityRuleModel.operatorEqual,
        value: 'Gujarat',
        logicalOperator: EligibilityRuleModel.logicalAnd,
        message: 'Applicant must be a permanent resident of Gujarat.',
        status: EligibilityRuleModel.statusActive,
      );

      final updated = rule.copyWith(
        value: 'Maharashtra',
        status: EligibilityRuleModel.statusInactive,
      );

      expect(updated.value, 'Maharashtra');
      expect(updated.status, EligibilityRuleModel.statusInactive);
      expect(updated.ruleId, 'RULE_002');
      expect(updated.field, 'state');
    });
  });
}
