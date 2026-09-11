import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/audit_log_model.dart';

class AuditLogService {
  static final AuditLogService _instance = AuditLogService._internal();
  factory AuditLogService() => _instance;
  AuditLogService._internal();

  final CollectionReference<Map<String, dynamic>> _auditLogsCollection =
      FirebaseFirestore.instance.collection('auditLogs');

  /// Add an audit log entry in Firestore
  Future<void> addAuditLog(AuditLogModel log) async {
    await _auditLogsCollection.doc(log.logId).set(log.toMap());
  }

  /// Convenience method to log a system or user action
  Future<void> logAction({
    required String logId,
    required String userId,
    required String departmentId,
    required String serviceId,
    required String action,
    Map<String, dynamic> dataChanged = const {},
    required String performedBy,
  }) async {
    final log = AuditLogModel(
      logId: logId,
      userId: userId,
      departmentId: departmentId,
      serviceId: serviceId,
      action: action,
      dataChanged: dataChanged,
      performedBy: performedBy,
      timestamp: Timestamp.now(),
    );
    await addAuditLog(log);
  }

  /// Get a single audit log entry by logId
  Future<AuditLogModel?> getAuditLog(String logId) async {
    final doc = await _auditLogsCollection.doc(logId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return AuditLogModel.fromFirestore(doc);
  }

  /// Stream all audit logs in real-time ordered by timestamp descending
  Stream<List<AuditLogModel>> streamAllAuditLogs() {
    return _auditLogsCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AuditLogModel.fromFirestore(doc))
            .toList());
  }

  /// Stream audit logs for a specific user
  Stream<List<AuditLogModel>> streamAuditLogsByUser(String userId) {
    return _auditLogsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AuditLogModel.fromFirestore(doc))
            .toList());
  }

  /// Stream audit logs for a specific department
  Stream<List<AuditLogModel>> streamAuditLogsByDepartment(String departmentId) {
    return _auditLogsCollection
        .where('departmentId', isEqualTo: departmentId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AuditLogModel.fromFirestore(doc))
            .toList());
  }

  /// Stream audit logs for a specific service
  Stream<List<AuditLogModel>> streamAuditLogsByService(String serviceId) {
    return _auditLogsCollection
        .where('serviceId', isEqualTo: serviceId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AuditLogModel.fromFirestore(doc))
            .toList());
  }

  /// Stream audit logs filtered by action performed
  Stream<List<AuditLogModel>> streamAuditLogsByAction(String action) {
    return _auditLogsCollection
        .where('action', isEqualTo: action)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AuditLogModel.fromFirestore(doc))
            .toList());
  }
}
