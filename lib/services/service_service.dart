import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_model.dart';

class ServiceService {
  static final ServiceService _instance = ServiceService._internal();
  factory ServiceService() => _instance;
  ServiceService._internal();

  final CollectionReference<Map<String, dynamic>> _servicesCollection =
      FirebaseFirestore.instance.collection('services');

  /// Add or set a service document in Firestore
  Future<void> addService(ServiceModel service) async {
    await _servicesCollection.doc(service.serviceId).set(service.toMap());
  }

  /// Get a service by serviceId
  Future<ServiceModel?> getService(String serviceId) async {
    final doc = await _servicesCollection.doc(serviceId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return ServiceModel.fromFirestore(doc);
  }

  /// Update service details
  Future<void> updateService(
    String serviceId,
    Map<String, dynamic> updates,
  ) async {
    updates['updatedAt'] = Timestamp.now();
    await _servicesCollection.doc(serviceId).update(updates);
  }

  /// Delete a service
  Future<void> deleteService(String serviceId) async {
    await _servicesCollection.doc(serviceId).delete();
  }

  /// Stream a single service in real-time
  Stream<ServiceModel?> streamService(String serviceId) {
    return _servicesCollection.doc(serviceId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return ServiceModel.fromFirestore(doc);
    });
  }

  /// Stream all services
  Stream<List<ServiceModel>> streamAllServices() {
    return _servicesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ServiceModel.fromFirestore(doc))
            .toList());
  }

  /// Stream services by departmentId
  Stream<List<ServiceModel>> streamServicesByDepartment(String departmentId) {
    return _servicesCollection
        .where('departmentId', isEqualTo: departmentId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ServiceModel.fromFirestore(doc))
            .toList());
  }

  /// Stream services by category
  Stream<List<ServiceModel>> streamServicesByCategory(String category) {
    return _servicesCollection
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ServiceModel.fromFirestore(doc))
            .toList());
  }

  /// Stream only active services
  Stream<List<ServiceModel>> streamActiveServices() {
    return _servicesCollection
        .where('status', isEqualTo: ServiceModel.statusActive)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ServiceModel.fromFirestore(doc))
            .toList());
  }
}
