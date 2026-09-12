import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:citizen_connect/models/document_model.dart';

void main() {
  group('DocumentModel Tests', () {
    test('toMap and fromMap serialize and deserialize correctly including documentData map', () {
      final now = Timestamp.now();
      final doc = DocumentModel(
        documentId: 'DOC_SAMPLE_001',
        userId: 'USR_729326',
        documentType: DocumentModel.docTypeAadhaar,
        documentNumber: 'XXXX-XXXX-4321',
        fileUrl: 'https://storage.googleapis.com/unigovportal.appspot.com/documents/aadhaar.pdf',
        documentData: {
          'fullName': 'Priya Patel',
          'dob': '1998-08-20',
          'gender': 'Female',
          'maskedAadhaar': 'XXXX-XXXX-4321',
          'address': 'Surat, Gujarat',
          'verificationSource': 'UIDAI e-KYC',
        },
        verified: true,
        issuedBy: 'UIDAI',
        issuedAt: now,
        uploadedAt: now,
      );

      final map = doc.toMap();

      expect(map['documentId'], 'DOC_SAMPLE_001');
      expect(map['userId'], 'USR_729326');
      expect(map['documentType'], DocumentModel.docTypeAadhaar);
      expect(map['documentNumber'], 'XXXX-XXXX-4321');
      expect(map['fileUrl'], 'https://storage.googleapis.com/unigovportal.appspot.com/documents/aadhaar.pdf');
      expect(map['documentData']['fullName'], 'Priya Patel');
      expect(map['documentData']['verificationSource'], 'UIDAI e-KYC');
      expect(map['verified'], true);
      expect(map['issuedBy'], 'UIDAI');
      expect(map['issuedAt'], now);
      expect(map['uploadedAt'], now);

      final fromMapDoc = DocumentModel.fromMap(map);
      expect(fromMapDoc.documentId, doc.documentId);
      expect(fromMapDoc.userId, doc.userId);
      expect(fromMapDoc.documentType, doc.documentType);
      expect(fromMapDoc.documentNumber, doc.documentNumber);
      expect(fromMapDoc.fileUrl, doc.fileUrl);
      expect(fromMapDoc.documentData, doc.documentData);
      expect(fromMapDoc.verified, true);
      expect(fromMapDoc.issuedBy, doc.issuedBy);
      expect(fromMapDoc.issuedAt, doc.issuedAt);
      expect(fromMapDoc.uploadedAt, doc.uploadedAt);
    });

    test('copyWith works properly for document model', () {
      final now = Timestamp.now();
      final doc = DocumentModel(
        documentId: 'DOC_001',
        userId: 'USR_001',
        documentType: DocumentModel.docTypePan,
        documentNumber: 'ABCDE1234F',
        fileUrl: 'https://example.com/pan.pdf',
        documentData: {'pan': 'ABCDE1234F'},
        verified: false,
        issuedBy: 'Income Tax Department',
        issuedAt: now,
        uploadedAt: now,
      );

      final updated = doc.copyWith(
        verified: true,
        documentData: {
          'pan': 'ABCDE1234F',
          'holderName': 'Priya Patel',
          'verifiedBy': 'e-Tax Portal',
        },
      );

      expect(updated.verified, true);
      expect(updated.documentData['holderName'], 'Priya Patel');
      expect(updated.documentId, 'DOC_001');
    });
  });
}
