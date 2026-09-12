import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_gov_portal/models/service_model.dart';
import 'package:uni_gov_portal/services/service_seed_data.dart';

void main() {
  group('ServiceModel Tests', () {
    test('toMap and fromMap serialize and deserialize correctly', () {
      final now = Timestamp.now();
      final service = ServiceModel(
        serviceId: 'SRV_TEST_001',
        departmentId: 'DEPT_TEST_001',
        serviceName: 'Test Certificate',
        description: 'Test Description',
        category: 'Certificates',
        requiredDocuments: ['Aadhaar', 'Income Proof'],
        requiredFields: ['fullName', 'income', 'address'],
        eligibilityRules: ['rule_1', 'rule_2'],
        processingTime: '5 Days',
        fee: 50,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://example.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'ADMIN',
      );

      final map = service.toMap();
      final fromMapService = ServiceModel.fromMap(map, docId: 'SRV_TEST_001');

      expect(fromMapService.serviceId, equals('SRV_TEST_001'));
      expect(fromMapService.departmentId, equals('DEPT_TEST_001'));
      expect(fromMapService.serviceName, equals('Test Certificate'));
      expect(fromMapService.description, equals('Test Description'));
      expect(fromMapService.category, equals('Certificates'));
      expect(fromMapService.requiredDocuments, containsAll(['Aadhaar', 'Income Proof']));
      expect(fromMapService.requiredFields, containsAll(['fullName', 'income', 'address']));
      expect(fromMapService.eligibilityRules, containsAll(['rule_1', 'rule_2']));
      expect(fromMapService.processingTime, equals('5 Days'));
      expect(fromMapService.fee, equals(50));
      expect(fromMapService.applicationType, equals(ServiceModel.applicationTypeOnline));
      expect(fromMapService.externalUrl, equals('https://example.gov.in'));
      expect(fromMapService.status, equals(ServiceModel.statusActive));
      expect(fromMapService.createdBy, equals('ADMIN'));
    });

    test('copyWith works properly for service model', () {
      final now = Timestamp.now();
      final service = ServiceModel(
        serviceId: 'SRV_TEST_002',
        departmentId: 'DEPT_TEST_002',
        serviceName: 'Original Name',
        description: 'Original Desc',
        category: 'General',
        requiredDocuments: [],
        requiredFields: [],
        eligibilityRules: [],
        processingTime: '10 Days',
        fee: 100,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: '',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'ADMIN',
      );

      final updated = service.copyWith(
        serviceName: 'Updated Name',
        fee: 150,
        status: ServiceModel.statusInactive,
      );

      expect(updated.serviceId, equals('SRV_TEST_002'));
      expect(updated.serviceName, equals('Updated Name'));
      expect(updated.fee, equals(150));
      expect(updated.status, equals(ServiceModel.statusInactive));
      expect(updated.description, equals('Original Desc'));
    });

    test('ServiceSeedData provides all 15 services across 6 departments', () {
      final departments = ServiceSeedData.getDepartments();
      final services = ServiceSeedData.getServices();

      expect(departments.length, equals(6));
      expect(services.length, equals(15));

      final deptIds = departments.map((d) => d.departmentId).toSet();
      expect(deptIds, containsAll([
        'DEPT_REVENUE',
        'DEPT_TRANSPORT',
        'DEPT_MUNICIPAL',
        'DEPT_LAND_RECORDS',
        'DEPT_AGRICULTURE',
        'DEPT_SOCIAL_WELFARE',
      ]));

      // Verify every service references a valid department
      for (final srv in services) {
        expect(deptIds.contains(srv.departmentId), isTrue,
            reason: 'Service ${srv.serviceId} has unknown departmentId: ${srv.departmentId}');
        expect(srv.serviceName.isNotEmpty, isTrue);
        expect(srv.requiredFields.isNotEmpty, isTrue);
        expect(srv.requiredDocuments.isNotEmpty, isTrue);
      }
    });
  });
}
