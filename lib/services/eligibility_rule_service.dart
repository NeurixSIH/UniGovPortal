import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/eligibility_rule_model.dart';

class EligibilityRuleService {
  static final EligibilityRuleService _instance = EligibilityRuleService._internal();
  factory EligibilityRuleService() => _instance;
  EligibilityRuleService._internal();

  final CollectionReference<Map<String, dynamic>> _rulesCollection =
      FirebaseFirestore.instance.collection('eligibilityRules');

  /// Add or set an eligibility rule in Firestore
  Future<void> addRule(EligibilityRuleModel rule) async {
    await _rulesCollection.doc(rule.ruleId).set(rule.toMap());
  }

  /// Get a single eligibility rule by ruleId
  Future<EligibilityRuleModel?> getRule(String ruleId) async {
    final doc = await _rulesCollection.doc(ruleId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return EligibilityRuleModel.fromFirestore(doc);
  }

  /// Update eligibility rule details
  Future<void> updateRule(
    String ruleId,
    Map<String, dynamic> updates,
  ) async {
    await _rulesCollection.doc(ruleId).update(updates);
  }

  /// Delete an eligibility rule
  Future<void> deleteRule(String ruleId) async {
    await _rulesCollection.doc(ruleId).delete();
  }

  /// Stream a single rule in real-time
  Stream<EligibilityRuleModel?> streamRule(String ruleId) {
    return _rulesCollection.doc(ruleId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return EligibilityRuleModel.fromFirestore(doc);
    });
  }

  /// Stream all eligibility rules
  Stream<List<EligibilityRuleModel>> streamAllRules() {
    return _rulesCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => EligibilityRuleModel.fromFirestore(doc))
        .toList());
  }

  /// Stream rules configured for a specific service
  Stream<List<EligibilityRuleModel>> streamRulesByService(String serviceId) {
    return _rulesCollection
        .where('serviceId', isEqualTo: serviceId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EligibilityRuleModel.fromFirestore(doc))
            .toList());
  }

  /// Stream only active eligibility rules for a service
  Stream<List<EligibilityRuleModel>> streamActiveRulesByService(String serviceId) {
    return _rulesCollection
        .where('serviceId', isEqualTo: serviceId)
        .where('status', isEqualTo: EligibilityRuleModel.statusActive)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EligibilityRuleModel.fromFirestore(doc))
            .toList());
  }
}
