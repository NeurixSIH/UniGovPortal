import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/consent_model.dart';

class ConsentService {
  static final ConsentService _instance = ConsentService._internal();
  factory ConsentService() => _instance;
  ConsentService._internal();

  final CollectionReference<Map<String, dynamic>> _consentsCollection =
      FirebaseFirestore.instance.collection('consents');

  /// Add or set a consent document in Firestore
  Future<void> addConsent(ConsentModel consent) async {
    await _consentsCollection
        .doc(consent.consentId)
        .set(consent.toMap());
  }

  /// Get a consent by consentId
  Future<ConsentModel?> getConsent(String consentId) async {
    final doc = await _consentsCollection.doc(consentId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return ConsentModel.fromFirestore(doc);
  }

  /// Update consent details
  Future<void> updateConsent(
    String consentId,
    Map<String, dynamic> updates,
  ) async {
    updates['updatedAt'] = Timestamp.now();
    await _consentsCollection.doc(consentId).update(updates);
  }

  /// Update consent status (e.g. granted, denied, revoked)
  Future<void> updateConsentStatus(
    String consentId,
    String status,
  ) async {
    await _consentsCollection.doc(consentId).update({
      'status': status,
      'updatedAt': Timestamp.now(),
    });
  }

  /// Grant citizen consent
  Future<void> grantConsent(String consentId) async {
    await updateConsentStatus(consentId, ConsentModel.statusGranted);
  }

  /// Deny citizen consent
  Future<void> denyConsent(String consentId) async {
    await updateConsentStatus(consentId, ConsentModel.statusDenied);
  }

  /// Revoke citizen consent
  Future<void> revokeConsent(String consentId) async {
    await updateConsentStatus(consentId, ConsentModel.statusRevoked);
  }

  /// Delete a consent record
  Future<void> deleteConsent(String consentId) async {
    await _consentsCollection.doc(consentId).delete();
  }

  /// Stream a single consent in real-time
  Stream<ConsentModel?> streamConsent(String consentId) {
    return _consentsCollection.doc(consentId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return ConsentModel.fromFirestore(doc);
    });
  }

  /// Stream all consents in real-time
  Stream<List<ConsentModel>> streamAllConsents() {
    return _consentsCollection
        .orderBy('grantedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConsentModel.fromFirestore(doc))
            .toList());
  }

  /// Stream consents given by a specific user/citizen
  Stream<List<ConsentModel>> streamConsentsByUser(String userId) {
    return _consentsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConsentModel.fromFirestore(doc))
            .toList());
  }

  /// Stream consents given to a specific department
  Stream<List<ConsentModel>> streamConsentsByDepartment(String departmentId) {
    return _consentsCollection
        .where('departmentId', isEqualTo: departmentId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConsentModel.fromFirestore(doc))
            .toList());
  }

  /// Stream consents for a specific service
  Stream<List<ConsentModel>> streamConsentsByService(String serviceId) {
    return _consentsCollection
        .where('serviceId', isEqualTo: serviceId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConsentModel.fromFirestore(doc))
            .toList());
  }

  /// Stream only currently granted consents for a citizen
  Stream<List<ConsentModel>> streamActiveConsentsByUser(String userId) {
    return _consentsCollection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: ConsentModel.statusGranted)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConsentModel.fromFirestore(doc))
            .toList());
  }

  /// Stream pending consent requests for a citizen
  Stream<List<ConsentModel>> streamPendingConsentsByUser(String userId) {
    return _consentsCollection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: ConsentModel.statusPending)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConsentModel.fromFirestore(doc))
            .toList());
  }
}
