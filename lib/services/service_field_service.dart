import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_field_model.dart';

class ServiceFieldService {
  static final ServiceFieldService _instance = ServiceFieldService._internal();
  factory ServiceFieldService() => _instance;
  ServiceFieldService._internal();

  final CollectionReference<Map<String, dynamic>> _fieldsCollection =
      FirebaseFirestore.instance.collection('serviceFields');

  /// Add or set a service field definition in Firestore
  Future<void> addField(ServiceFieldModel field) async {
    await _fieldsCollection.doc(field.fieldId).set(field.toMap());
  }

  /// Get a single service field by fieldId
  Future<ServiceFieldModel?> getField(String fieldId) async {
    final doc = await _fieldsCollection.doc(fieldId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return ServiceFieldModel.fromFirestore(doc);
  }

  /// Update field configuration
  Future<void> updateField(
    String fieldId,
    Map<String, dynamic> updates,
  ) async {
    await _fieldsCollection.doc(fieldId).update(updates);
  }

  /// Delete a service field definition
  Future<void> deleteField(String fieldId) async {
    await _fieldsCollection.doc(fieldId).delete();
  }

  /// Stream a single field in real-time
  Stream<ServiceFieldModel?> streamField(String fieldId) {
    return _fieldsCollection.doc(fieldId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return ServiceFieldModel.fromFirestore(doc);
    });
  }

  /// Stream all service fields
  Stream<List<ServiceFieldModel>> streamAllFields() {
    return _fieldsCollection
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ServiceFieldModel.fromFirestore(doc))
            .toList());
  }

  /// Stream all fields defined for a particular service, ordered by display order
  Stream<List<ServiceFieldModel>> streamFieldsByService(String serviceId) {
    return _fieldsCollection
        .where('serviceId', isEqualTo: serviceId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => ServiceFieldModel.fromFirestore(doc))
          .toList();
      list.sort((a, b) => a.order.compareTo(b.order));
      return list;
    });
  }

  /// Stream only active fields for a service form, ordered by display order
  Stream<List<ServiceFieldModel>> streamActiveFieldsByService(String serviceId) {
    return _fieldsCollection
        .where('serviceId', isEqualTo: serviceId)
        .where('status', isEqualTo: ServiceFieldModel.statusActive)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => ServiceFieldModel.fromFirestore(doc))
          .toList();
      list.sort((a, b) => a.order.compareTo(b.order));
      return list;
    });
  }
}
