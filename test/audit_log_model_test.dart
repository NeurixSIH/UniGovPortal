import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_gov_portal/models/audit_log_model.dart';

void main() {
  group('AuditLogModel Tests', () {
    test('toMap and fromMap serialize and deserialize correctly', () {
      final now = Timestamp.now();
      final log = AuditLogModel(
        logId: 'LOG_SAMPLE_001',
        userId: 'USR_729326',
        departmentId: 'DEPT_SAMPLE_001',
        serviceId: 'SRV_INCOME_CERT_001',
        action: AuditLogModel.actionApplicationSubmitted,
        dataChanged: {
          'status': 'submitted',
          'applicationId': 'APP_SAMPLE_001',
        },
        performedBy: 'USR_729326',
        timestamp: now,
      );

      final map = log.toMap();

      expect(map['logId'], 'LOG_SAMPLE_001');
      expect(map['userId'], 'USR_729326');
      expect(map['departmentId'], 'DEPT_SAMPLE_001');
      expect(map['serviceId'], 'SRV_INCOME_CERT_001');
      expect(map['action'], AuditLogModel.actionApplicationSubmitted);
      expect(map['dataChanged']['status'], 'submitted');
      expect(map['performedBy'], 'USR_729326');
      expect(map['timestamp'], now);

      final fromMapLog = AuditLogModel.fromMap(map);
      expect(fromMapLog.logId, log.logId);
      expect(fromMapLog.userId, log.userId);
      expect(fromMapLog.departmentId, log.departmentId);
      expect(fromMapLog.serviceId, log.serviceId);
      expect(fromMapLog.action, log.action);
      expect(fromMapLog.dataChanged, log.dataChanged);
      expect(fromMapLog.performedBy, log.performedBy);
      expect(fromMapLog.timestamp, log.timestamp);
    });

    test('copyWith works properly for audit log model', () {
      final now = Timestamp.now();
      final log = AuditLogModel(
        logId: 'LOG_001',
        userId: 'USR_001',
        departmentId: 'DEPT_001',
        serviceId: 'SRV_001',
        action: AuditLogModel.actionDocumentUploaded,
        dataChanged: {},
        performedBy: 'USR_001',
        timestamp: now,
      );

      final updated = log.copyWith(
        action: AuditLogModel.actionDocumentVerified,
        performedBy: 'ADMIN_01',
      );

      expect(updated.action, AuditLogModel.actionDocumentVerified);
      expect(updated.performedBy, 'ADMIN_01');
      expect(updated.logId, 'LOG_001');
    });
  });
}
