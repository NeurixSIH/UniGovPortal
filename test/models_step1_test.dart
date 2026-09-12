import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_gov_portal/models/user_model.dart';
import 'package:uni_gov_portal/models/document_model.dart';
import 'package:uni_gov_portal/models/audit_log_model.dart';
import 'package:uni_gov_portal/models/application_model.dart';
import 'package:uni_gov_portal/models/consent_model.dart';
import 'package:uni_gov_portal/models/notification_model.dart';

void main() {
  group('Step 1 Models Verification', () {
    test('UserModel supports departmentId, landOwnership, incomeBracket', () {
      final user = UserModel(
        userId: 'MH123456789',
        fullName: 'Krisha Patel',
        email: 'krisha.patel@example.com',
        mobileNumber: '+919876543210',
        dob: Timestamp.now(),
        gender: 'Female',
        address: {'line1': 'Flat 402, Shivam Apts', 'city': 'Pune', 'state': 'Maharashtra', 'pincode': '411001'},
        city: 'Pune',
        state: 'Maharashtra',
        pincode: '411001',
        income: 250000,
        category: 'General',
        role: UserModel.roleCitizen,
        status: UserModel.statusActive,
        departmentId: '',
        landOwnership: 'None',
        incomeBracket: '₹1,00,000 - ₹3,00,000',
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      expect(user.citizenId, 'MH123456789');
      expect(user.landOwnership, 'None');
      expect(user.incomeBracket, '₹1,00,000 - ₹3,00,000');

      final map = user.toMap();
      final fromMapUser = UserModel.fromMap(map);
      expect(fromMapUser.userId, user.userId);
      expect(fromMapUser.incomeBracket, user.incomeBracket);
    });

    test('DocumentModel supports 3-state verification status', () {
      final doc = DocumentModel(
        documentId: 'DOC001',
        userId: 'MH123456789',
        documentType: DocumentModel.docTypeAadhaar,
        documentNumber: 'XXXX-XXXX-1234',
        fileUrl: 'https://example.com/doc.pdf',
        documentData: {},
        verified: true,
        status: DocumentModel.statusVerified,
        issuedBy: 'UIDAI',
        issuedAt: Timestamp.now(),
        uploadedAt: Timestamp.now(),
      );

      expect(doc.isVerified, true);
      expect(doc.status, DocumentModel.statusVerified);

      final rejectedDoc = doc.copyWith(
        status: DocumentModel.statusRejected,
        rejectionReason: 'Blurry document image',
      );
      expect(rejectedDoc.isVerified, false);
      expect(rejectedDoc.status, DocumentModel.statusRejected);
      expect(rejectedDoc.rejectionReason, 'Blurry document image');
    });

    test('AuditLogModel supports live interoperability sync fields', () {
      final log = AuditLogModel(
        logId: 'LOG001',
        userId: 'MH123456789',
        departmentId: 'DEPT_MUNICIPAL',
        serviceId: 'SYNC_SERVICE',
        action: AuditLogModel.actionLiveSync,
        dataChanged: {'field': 'Address'},
        performedBy: 'Interoperability Hub',
        timestamp: Timestamp.now(),
        sourceDepartment: 'Citizen Profile',
        targetDepartment: 'Municipal Corporation',
        fieldChanged: 'Address',
        oldValue: 'Mumbai',
        newValue: 'Pune',
        status: AuditLogModel.statusSuccess,
        category: AuditLogModel.categoryAddress,
      );

      expect(log.sourceDepartment, 'Citizen Profile');
      expect(log.targetDepartment, 'Municipal Corporation');
      expect(log.status, AuditLogModel.statusSuccess);
      expect(log.category, AuditLogModel.categoryAddress);
    });

    test('ApplicationModel supports documents_required status and timeline', () {
      final now = Timestamp.now();
      final app = ApplicationModel(
        applicationId: 'APP20260904',
        userId: 'MH123456789',
        departmentId: 'DEPT_REVENUE',
        serviceId: 'SRV_INCOME',
        applicationData: {'annualIncome': 250000},
        documents: ['DOC001'],
        status: ApplicationModel.statusDocumentsRequired,
        remarks: 'Please upload recent electricity bill',
        submittedAt: now,
        updatedAt: now,
        processedBy: 'OFFICER_01',
        timeline: [
          {'stage': 'Submitted', 'status': 'submitted', 'remarks': 'Initial submission', 'timestamp': now},
          {'stage': 'Documents Required', 'status': 'documents_required', 'remarks': 'Need address proof', 'timestamp': now},
        ],
      );

      expect(app.status, ApplicationModel.statusDocumentsRequired);
      expect(app.timeline.length, 2);
      expect(app.timeline.last['stage'], 'Documents Required');
    });

    test('ConsentModel supports purpose and pending status', () {
      final consent = ConsentModel(
        consentId: 'CNS001',
        userId: 'MH123456789',
        departmentId: 'DEPT_BANKING',
        serviceId: 'SRV_KYC',
        dataFields: ['Address', 'Income'],
        purpose: 'Direct Benefit Transfer Account Validation',
        status: ConsentModel.statusPending,
        grantedAt: Timestamp.now(),
        expiresAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      expect(consent.status, ConsentModel.statusPending);
      expect(consent.purpose, 'Direct Benefit Transfer Account Validation');
    });

    test('NotificationModel supports consentId and actionPayload', () {
      final notif = NotificationModel(
        notificationId: 'NOTIF001',
        userId: 'MH123456789',
        type: NotificationModel.typeConsentRequest,
        title: 'Consent Request',
        message: 'Municipal Corporation requests access to your Address.',
        applicationId: '',
        consentId: 'CNS001',
        departmentId: 'DEPT_MUNICIPAL',
        actionPayload: {'canAllow': true, 'canDeny': true},
        isRead: false,
        createdAt: Timestamp.now(),
      );

      expect(notif.consentId, 'CNS001');
      expect(notif.departmentId, 'DEPT_MUNICIPAL');
      expect(notif.actionPayload['canAllow'], true);
    });
  });
}
