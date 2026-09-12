import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/application_model.dart';

class ApplicationService {
  static final ApplicationService _instance = ApplicationService._internal();
  factory ApplicationService() => _instance;
  ApplicationService._internal();

  final CollectionReference<Map<String, dynamic>> _applicationsCollection =
      FirebaseFirestore.instance.collection('applications');

  /// Add or set an application document in Firestore with initial timeline
  Future<void> addApplication(ApplicationModel application) async {
    ApplicationModel appToSave = application;
    if (appToSave.timeline.isEmpty) {
      appToSave = appToSave.copyWith(
        timeline: [
          {
            'stage': 'Submitted',
            'status': application.status,
            'remarks': application.remarks.isNotEmpty
                ? application.remarks
                : 'Application submitted successfully',
            'timestamp': application.submittedAt,
            'processedBy': application.userId,
          }
        ],
      );
    }
    await _applicationsCollection
        .doc(appToSave.applicationId)
        .set(appToSave.toMap());
  }

  /// Get an application by applicationId
  Future<ApplicationModel?> getApplication(String applicationId) async {
    final doc = await _applicationsCollection.doc(applicationId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return ApplicationModel.fromFirestore(doc);
  }

  /// Update application details
  Future<void> updateApplication(
    String applicationId,
    Map<String, dynamic> updates,
  ) async {
    updates['updatedAt'] = Timestamp.now();
    await _applicationsCollection.doc(applicationId).update(updates);
  }

  /// Helper to convert status code to human readable timeline stage
  static String mapStatusToStage(String status) {
    switch (status) {
      case ApplicationModel.statusSubmitted:
        return 'Submitted';
      case ApplicationModel.statusUnderReview:
        return 'Under Review';
      case ApplicationModel.statusDocumentsRequired:
        return 'Documents Required';
      case ApplicationModel.statusApproved:
        return 'Approved';
      case ApplicationModel.statusCompleted:
        return 'Completed';
      case ApplicationModel.statusRejected:
        return 'Rejected';
      default:
        return 'Updated';
    }
  }

  /// Update application status, remarks, processor, and append to timeline history
  Future<void> updateApplicationStatus(
    String applicationId, {
    required String status,
    String? remarks,
    String? processedBy,
  }) async {
    final now = Timestamp.now();
    final timelineEntry = {
      'stage': mapStatusToStage(status),
      'status': status,
      'remarks': remarks ?? '',
      'timestamp': now,
      'processedBy': processedBy ?? 'Department Officer',
    };

    final Map<String, dynamic> updates = {
      'status': status,
      'updatedAt': now,
      'timeline': FieldValue.arrayUnion([timelineEntry]),
    };
    if (remarks != null) updates['remarks'] = remarks;
    if (processedBy != null) updates['processedBy'] = processedBy;
    await _applicationsCollection.doc(applicationId).update(updates);
  }

  /// Request additional documents from citizen
  Future<void> requestDocuments(
    String applicationId, {
    required String remarks,
    required String processedBy,
  }) async {
    await updateApplicationStatus(
      applicationId,
      status: ApplicationModel.statusDocumentsRequired,
      remarks: remarks,
      processedBy: processedBy,
    );
  }

  /// Approve citizen application
  Future<void> approveApplication(
    String applicationId, {
    String remarks = 'Application approved after document verification.',
    required String processedBy,
  }) async {
    await updateApplicationStatus(
      applicationId,
      status: ApplicationModel.statusApproved,
      remarks: remarks,
      processedBy: processedBy,
    );
  }

  /// Reject citizen application
  Future<void> rejectApplication(
    String applicationId, {
    required String remarks,
    required String processedBy,
  }) async {
    await updateApplicationStatus(
      applicationId,
      status: ApplicationModel.statusRejected,
      remarks: remarks,
      processedBy: processedBy,
    );
  }

  /// Delete an application
  Future<void> deleteApplication(String applicationId) async {
    await _applicationsCollection.doc(applicationId).delete();
  }

  /// Stream a single application in real-time
  Stream<ApplicationModel?> streamApplication(String applicationId) {
    return _applicationsCollection.doc(applicationId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return ApplicationModel.fromFirestore(doc);
    });
  }

  /// Stream all applications
  Stream<List<ApplicationModel>> streamAllApplications() {
    return _applicationsCollection
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ApplicationModel.fromFirestore(doc))
            .toList());
  }

  /// Stream applications submitted by a specific citizen/user
  Stream<List<ApplicationModel>> streamApplicationsByUser(String userId) {
    return _applicationsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ApplicationModel.fromFirestore(doc))
            .toList());
  }

  /// Stream applications assigned to a specific department
  Stream<List<ApplicationModel>> streamApplicationsByDepartment(
      String departmentId) {
    return _applicationsCollection
        .where('departmentId', isEqualTo: departmentId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ApplicationModel.fromFirestore(doc))
            .toList());
  }

  /// Stream applications for a specific service
  Stream<List<ApplicationModel>> streamApplicationsByService(String serviceId) {
    return _applicationsCollection
        .where('serviceId', isEqualTo: serviceId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ApplicationModel.fromFirestore(doc))
            .toList());
  }

  /// Stream applications by status
  Stream<List<ApplicationModel>> streamApplicationsByStatus(String status) {
    return _applicationsCollection
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ApplicationModel.fromFirestore(doc))
            .toList());
  }

  /// Stream applications by department and status
  Stream<List<ApplicationModel>> streamApplicationsByDepartmentAndStatus(
    String departmentId,
    String status,
  ) {
    return _applicationsCollection
        .where('departmentId', isEqualTo: departmentId)
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ApplicationModel.fromFirestore(doc))
            .toList());
  }
}
