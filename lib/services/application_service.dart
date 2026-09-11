import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/application_model.dart';

class ApplicationService {
  static final ApplicationService _instance = ApplicationService._internal();
  factory ApplicationService() => _instance;
  ApplicationService._internal();

  final CollectionReference<Map<String, dynamic>> _applicationsCollection =
      FirebaseFirestore.instance.collection('applications');

  /// Add or set an application document in Firestore
  Future<void> addApplication(ApplicationModel application) async {
    await _applicationsCollection
        .doc(application.applicationId)
        .set(application.toMap());
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

  /// Update application status, remarks, and processor
  Future<void> updateApplicationStatus(
    String applicationId, {
    required String status,
    String? remarks,
    String? processedBy,
  }) async {
    final Map<String, dynamic> updates = {
      'status': status,
      'updatedAt': Timestamp.now(),
    };
    if (remarks != null) updates['remarks'] = remarks;
    if (processedBy != null) updates['processedBy'] = processedBy;
    await _applicationsCollection.doc(applicationId).update(updates);
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
