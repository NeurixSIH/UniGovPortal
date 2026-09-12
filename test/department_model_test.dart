import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_gov_portal/models/department_model.dart';
import 'package:uni_gov_portal/services/service_seed_data.dart';

void main() {
  group('DepartmentModel Tests', () {
    test('toMap and fromMap serialize and deserialize correctly', () {
      final now = Timestamp.now();
      final dept = DepartmentModel(
        departmentId: 'DEPT_TEST_001',
        departmentName: 'Test Department',
        description: 'Test Description',
        logo: 'https://example.com/logo.png',
        contactEmail: 'dept@test.gov.in',
        contactNumber: '+911234567890',
        status: DepartmentModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'ADMIN',
      );

      final map = dept.toMap();
      final fromMapDept = DepartmentModel.fromMap(map, docId: 'DEPT_TEST_001');

      expect(fromMapDept.departmentId, equals('DEPT_TEST_001'));
      expect(fromMapDept.departmentName, equals('Test Department'));
      expect(fromMapDept.description, equals('Test Description'));
      expect(fromMapDept.logo, equals('https://example.com/logo.png'));
      expect(fromMapDept.contactEmail, equals('dept@test.gov.in'));
      expect(fromMapDept.contactNumber, equals('+911234567890'));
      expect(fromMapDept.status, equals(DepartmentModel.statusActive));
      expect(fromMapDept.createdBy, equals('ADMIN'));
    });

    test('copyWith works properly for department model', () {
      final now = Timestamp.now();
      final dept = DepartmentModel(
        departmentId: 'DEPT_TEST_002',
        departmentName: 'Original Dept',
        description: 'Original Desc',
        logo: '',
        contactEmail: 'test@gov.in',
        contactNumber: '12345',
        status: DepartmentModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'ADMIN',
      );

      final updated = dept.copyWith(
        departmentName: 'New Dept Name',
        status: DepartmentModel.statusInactive,
        contactNumber: '99999',
      );

      expect(updated.departmentId, equals('DEPT_TEST_002'));
      expect(updated.departmentName, equals('New Dept Name'));
      expect(updated.status, equals(DepartmentModel.statusInactive));
      expect(updated.contactNumber, equals('99999'));
      expect(updated.contactEmail, equals('test@gov.in'));
    });

    test('All seed departments have valid fields and active status', () {
      final depts = ServiceSeedData.getDepartments();
      expect(depts.length, equals(6));

      for (final dept in depts) {
        expect(dept.departmentId.startsWith('DEPT_'), isTrue);
        expect(dept.departmentName.isNotEmpty, isTrue);
        expect(dept.contactEmail.contains('@'), isTrue);
        expect(dept.status, equals(DepartmentModel.statusActive));
      }
    });
  });
}
