import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_gov_portal/models/application_model.dart';

void main() {
  group('ApplicationModel Tests', () {
    test('toMap and fromMap serialize and deserialize correctly', () {
      final now = Timestamp.now();
      final app = ApplicationModel(
        applicationId: 'APP_123456',
        userId: 'USR_789',
        departmentId: 'DEPT_REV',
        serviceId: 'SRV_INCOME_CERT',
        applicationData: {
          'annualIncome': 450000,
          'purpose': 'Higher Education Scholarship',
        },
        documents: [
          'https://storage.example.com/docs/aadhaar.pdf',
          'https://storage.example.com/docs/salary_slip.pdf',
        ],
        status: ApplicationModel.statusSubmitted,
        remarks: 'Application under verification',
        submittedAt: now,
        updatedAt: now,
        processedBy: 'ADMIN_01',
      );

      final map = app.toMap();

      expect(map['applicationId'], 'APP_123456');
      expect(map['userId'], 'USR_789');
      expect(map['departmentId'], 'DEPT_REV');
      expect(map['serviceId'], 'SRV_INCOME_CERT');
      expect(map['applicationData']['annualIncome'], 450000);
      expect((map['documents'] as List).length, 2);
      expect(map['status'], ApplicationModel.statusSubmitted);
      expect(map['remarks'], 'Application under verification');
      expect(map['submittedAt'], now);
      expect(map['updatedAt'], now);
      expect(map['processedBy'], 'ADMIN_01');

      final fromMapApp = ApplicationModel.fromMap(map);
      expect(fromMapApp.applicationId, app.applicationId);
      expect(fromMapApp.userId, app.userId);
      expect(fromMapApp.departmentId, app.departmentId);
      expect(fromMapApp.serviceId, app.serviceId);
      expect(fromMapApp.applicationData, app.applicationData);
      expect(fromMapApp.documents, app.documents);
      expect(fromMapApp.status, app.status);
      expect(fromMapApp.remarks, app.remarks);
      expect(fromMapApp.submittedAt, app.submittedAt);
      expect(fromMapApp.updatedAt, app.updatedAt);
      expect(fromMapApp.processedBy, app.processedBy);
    });

    test('copyWith works properly', () {
      final now = Timestamp.now();
      final app = ApplicationModel(
        applicationId: 'APP_001',
        userId: 'USR_001',
        departmentId: 'DEPT_001',
        serviceId: 'SRV_001',
        applicationData: {'note': 'initial'},
        documents: ['doc1.pdf'],
        status: ApplicationModel.statusSubmitted,
        remarks: '',
        submittedAt: now,
        updatedAt: now,
        processedBy: '',
      );

      final updated = app.copyWith(
        status: ApplicationModel.statusApproved,
        remarks: 'All documents verified',
        processedBy: 'ADMIN_02',
      );

      expect(updated.status, ApplicationModel.statusApproved);
      expect(updated.remarks, 'All documents verified');
      expect(updated.processedBy, 'ADMIN_02');
      expect(updated.applicationId, 'APP_001');
      expect(updated.userId, 'USR_001');
    });
  });
}
