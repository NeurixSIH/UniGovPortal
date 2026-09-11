import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/department_model.dart';

class DepartmentService {
  static final DepartmentService _instance = DepartmentService._internal();
  factory DepartmentService() => _instance;
  DepartmentService._internal();

  final CollectionReference<Map<String, dynamic>> _deptCollection =
      FirebaseFirestore.instance.collection('departments');

  /// Add or set a department document in Firestore
  Future<void> addDepartment(DepartmentModel department) async {
    await _deptCollection.doc(department.departmentId).set(department.toMap());
  }

  /// Get a department by ID
  Future<DepartmentModel?> getDepartment(String departmentId) async {
    final doc = await _deptCollection.doc(departmentId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return DepartmentModel.fromFirestore(doc);
  }

  /// Update department details
  Future<void> updateDepartment(
    String departmentId,
    Map<String, dynamic> updates,
  ) async {
    updates['updatedAt'] = Timestamp.now();
    await _deptCollection.doc(departmentId).update(updates);
  }

  /// Delete a department
  Future<void> deleteDepartment(String departmentId) async {
    await _deptCollection.doc(departmentId).delete();
  }

  /// Stream a single department in real-time
  Stream<DepartmentModel?> streamDepartment(String departmentId) {
    return _deptCollection.doc(departmentId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return DepartmentModel.fromFirestore(doc);
    });
  }

  /// Stream all departments
  Stream<List<DepartmentModel>> streamAllDepartments() {
    return _deptCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DepartmentModel.fromFirestore(doc))
            .toList());
  }

  /// Stream only active departments
  Stream<List<DepartmentModel>> streamActiveDepartments() {
    return _deptCollection
        .where('status', isEqualTo: DepartmentModel.statusActive)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DepartmentModel.fromFirestore(doc))
            .toList());
  }
}
