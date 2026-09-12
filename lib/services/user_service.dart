import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');

  /// Add or set a user document in Firestore
  Future<void> addUser(UserModel user) async {
    await _usersCollection.doc(user.userId).set(user.toMap());
  }

  /// Get a user by their unique userId
  Future<UserModel?> getUser(String userId) async {
    final doc = await _usersCollection.doc(userId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return UserModel.fromFirestore(doc);
  }

  /// Update user profile details
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    updates['updatedAt'] = Timestamp.now();
    await _usersCollection.doc(userId).update(updates);
  }

  /// Delete a user document
  Future<void> deleteUser(String userId) async {
    await _usersCollection.doc(userId).delete();
  }

  /// Stream a single user's real-time updates
  Stream<UserModel?> streamUser(String userId) {
    return _usersCollection.doc(userId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  /// Stream all users in real-time
  Stream<List<UserModel>> streamAllUsers() {
    return _usersCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromFirestore(doc))
            .toList());
  }

  /// Stream users filtered by role ('citizen', 'departmentAdmin', 'systemAdmin')
  Stream<List<UserModel>> streamUsersByRole(String role) {
    return _usersCollection
        .where('role', isEqualTo: role)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromFirestore(doc))
            .toList());
  }

  /// Stream all officers (departmentAdmin role)
  Stream<List<UserModel>> streamAllOfficers() {
    return streamUsersByRole(UserModel.roleDepartmentAdmin);
  }

  /// Stream officers belonging to a specific department
  Stream<List<UserModel>> streamOfficersByDepartment(String departmentId) {
    return _usersCollection
        .where('role', isEqualTo: UserModel.roleDepartmentAdmin)
        .where('departmentId', isEqualTo: departmentId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromFirestore(doc))
            .toList());
  }

  /// Activate or deactivate an officer account
  Future<void> updateOfficerStatus(String userId, String status) async {
    await updateUser(userId, {'status': status});
  }
}
