import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_gov_portal/models/consent_model.dart';

void main() {
  group('ConsentModel Tests', () {
    test('toMap and fromMap serialize and deserialize correctly', () {
      final now = Timestamp.now();
      final expiry = Timestamp.fromDate(DateTime.now().add(const Duration(days: 365)));

      final consent = ConsentModel(
        consentId: 'CONSENT_SAMPLE_001',
        userId: 'USR_729326',
        departmentId: 'DEPT_SAMPLE_001',
        serviceId: 'SRV_INCOME_CERT_001',
        dataFields: ['fullName', 'income', 'address', 'aadhaar'],
        status: ConsentModel.statusGranted,
        grantedAt: now,
        expiresAt: expiry,
        updatedAt: now,
      );

      final map = consent.toMap();

      expect(map['consentId'], 'CONSENT_SAMPLE_001');
      expect(map['userId'], 'USR_729326');
      expect(map['departmentId'], 'DEPT_SAMPLE_001');
      expect(map['serviceId'], 'SRV_INCOME_CERT_001');
      expect((map['dataFields'] as List).length, 4);
      expect(map['status'], ConsentModel.statusGranted);
      expect(map['grantedAt'], now);
      expect(map['expiresAt'], expiry);
      expect(map['updatedAt'], now);

      final fromMapConsent = ConsentModel.fromMap(map);
      expect(fromMapConsent.consentId, consent.consentId);
      expect(fromMapConsent.userId, consent.userId);
      expect(fromMapConsent.departmentId, consent.departmentId);
      expect(fromMapConsent.serviceId, consent.serviceId);
      expect(fromMapConsent.dataFields, consent.dataFields);
      expect(fromMapConsent.status, consent.status);
      expect(fromMapConsent.grantedAt, consent.grantedAt);
      expect(fromMapConsent.expiresAt, consent.expiresAt);
      expect(fromMapConsent.updatedAt, consent.updatedAt);
    });

    test('copyWith works properly for consent model', () {
      final now = Timestamp.now();
      final consent = ConsentModel(
        consentId: 'CONSENT_001',
        userId: 'USR_001',
        departmentId: 'DEPT_001',
        serviceId: 'SRV_001',
        dataFields: ['name'],
        status: ConsentModel.statusGranted,
        grantedAt: now,
        expiresAt: now,
        updatedAt: now,
      );

      final updated = consent.copyWith(
        status: ConsentModel.statusRevoked,
      );

      expect(updated.status, ConsentModel.statusRevoked);
      expect(updated.consentId, 'CONSENT_001');
    });
  });
}
