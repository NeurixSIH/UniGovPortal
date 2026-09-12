import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/document_model.dart';

class DocumentService {
  static final DocumentService _instance = DocumentService._internal();
  factory DocumentService() => _instance;
  DocumentService._internal();

  final CollectionReference<Map<String, dynamic>> _documentsCollection =
      FirebaseFirestore.instance.collection('documents');

  /// Add or set a document in Firestore
  Future<void> addDocument(DocumentModel document) async {
    await _documentsCollection
        .doc(document.documentId)
        .set(document.toMap());
  }

  /// Get a document by documentId
  Future<DocumentModel?> getDocument(String documentId) async {
    final doc = await _documentsCollection.doc(documentId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return DocumentModel.fromFirestore(doc);
  }

  /// Update document metadata or details
  Future<void> updateDocument(
    String documentId,
    Map<String, dynamic> updates,
  ) async {
    await _documentsCollection.doc(documentId).update(updates);
  }

  /// Update verification status of a document
  Future<void> updateVerificationStatus(
    String documentId, {
    required bool verified,
  }) async {
    await _documentsCollection.doc(documentId).update({
      'verified': verified,
      'status': verified ? DocumentModel.statusVerified : DocumentModel.statusPending,
    });
  }

  /// Update document status to verified, pending, or rejected with optional reason
  Future<void> updateDocumentStatus(
    String documentId, {
    required String status,
    String? rejectionReason,
  }) async {
    final Map<String, dynamic> updates = {
      'status': status,
      'verified': status == DocumentModel.statusVerified,
    };
    if (rejectionReason != null) {
      updates['rejectionReason'] = rejectionReason;
    }
    await _documentsCollection.doc(documentId).update(updates);
  }

  /// Delete a document record
  Future<void> deleteDocument(String documentId) async {
    await _documentsCollection.doc(documentId).delete();
  }

  /// Stream a single document in real-time
  Stream<DocumentModel?> streamDocument(String documentId) {
    return _documentsCollection.doc(documentId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return DocumentModel.fromFirestore(doc);
    });
  }

  /// Stream all documents in real-time
  Stream<List<DocumentModel>> streamAllDocuments() {
    return _documentsCollection
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DocumentModel.fromFirestore(doc))
            .toList());
  }

  /// Stream all documents uploaded by a specific user/citizen
  Stream<List<DocumentModel>> streamDocumentsByUser(String userId) {
    return _documentsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DocumentModel.fromFirestore(doc))
            .toList());
  }

  /// Stream documents of a specific status for a user ('verified', 'pending', 'rejected')
  Stream<List<DocumentModel>> streamDocumentsByStatus(
    String userId,
    String status,
  ) {
    return _documentsCollection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DocumentModel.fromFirestore(doc))
            .toList());
  }

  /// Stream documents of a specific type for a user
  Stream<List<DocumentModel>> streamDocumentsByType(
    String userId,
    String documentType,
  ) {
    return _documentsCollection
        .where('userId', isEqualTo: userId)
        .where('documentType', isEqualTo: documentType)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DocumentModel.fromFirestore(doc))
            .toList());
  }

  /// Stream verified documents for a user
  Stream<List<DocumentModel>> streamVerifiedDocuments(String userId) {
    return _documentsCollection
        .where('userId', isEqualTo: userId)
        .where('verified', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DocumentModel.fromFirestore(doc))
            .toList());
  }
}
