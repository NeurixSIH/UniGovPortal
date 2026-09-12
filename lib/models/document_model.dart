import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentModel {
  final String documentId;
  final String userId;
  final String documentType;
  final String documentNumber;
  final String fileUrl;
  final Map<String, dynamic> documentData;
  final bool verified;
  final String status; // 'verified', 'pending', 'rejected'
  final String? rejectionReason;
  final String issuedBy;
  final Timestamp issuedAt;
  final Timestamp uploadedAt;

  const DocumentModel({
    required this.documentId,
    required this.userId,
    required this.documentType,
    required this.documentNumber,
    required this.fileUrl,
    required this.documentData,
    required this.verified,
    this.status = statusPending,
    this.rejectionReason,
    required this.issuedBy,
    required this.issuedAt,
    required this.uploadedAt,
  });

  // Document type constants
  static const String docTypeAadhaar = 'Aadhaar Card';
  static const String docTypePan = 'PAN Card';
  static const String docTypeIncomeCertificate = 'Income Certificate';
  static const String docTypeRationCard = 'Ration Card';
  static const String docTypeElectricityBill = 'Electricity Bill';
  static const String docTypeDomicileCertificate = 'Domicile Certificate';
  static const String docTypeBirthCertificate = 'Birth Certificate';

  // Status constants
  static const String statusVerified = 'verified';
  static const String statusPending = 'pending';
  static const String statusRejected = 'rejected';

  bool get isVerified => status == statusVerified || verified;

  factory DocumentModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    final bool rawVerified = map['verified'] is bool
        ? map['verified']
        : (map['verified'] == 'true');
    final String resolvedStatus = map['status'] != null
        ? ((map['status'] == statusPending && rawVerified) ? statusVerified : map['status'])
        : (rawVerified ? statusVerified : statusPending);

    return DocumentModel(
      documentId: map['documentId'] ?? docId ?? '',
      userId: map['userId'] ?? '',
      documentType: map['documentType'] ?? '',
      documentNumber: map['documentNumber'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      documentData: map['documentData'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(map['documentData'])
          : (map['documentData'] is Map
              ? Map<String, dynamic>.from(map['documentData'])
              : {}),
      verified: resolvedStatus == statusVerified || rawVerified,
      status: resolvedStatus,
      rejectionReason: map['rejectionReason'] as String?,
      issuedBy: map['issuedBy'] ?? '',
      issuedAt: map['issuedAt'] is Timestamp
          ? map['issuedAt']
          : Timestamp.now(),
      uploadedAt: map['uploadedAt'] is Timestamp
          ? map['uploadedAt']
          : Timestamp.now(),
    );
  }

  factory DocumentModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return DocumentModel.fromMap(doc.data() ?? {}, docId: doc.id);
  }

  Map<String, dynamic> toMap() {
    final effStatus = (status == statusPending && verified) ? statusVerified : status;
    return {
      'documentId': documentId,
      'userId': userId,
      'documentType': documentType,
      'documentNumber': documentNumber,
      'fileUrl': fileUrl,
      'documentData': documentData,
      'verified': isVerified,
      'status': effStatus,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      'issuedBy': issuedBy,
      'issuedAt': issuedAt,
      'uploadedAt': uploadedAt,
    };
  }

  DocumentModel copyWith({
    String? documentId,
    String? userId,
    String? documentType,
    String? documentNumber,
    String? fileUrl,
    Map<String, dynamic>? documentData,
    bool? verified,
    String? status,
    String? rejectionReason,
    String? issuedBy,
    Timestamp? issuedAt,
    Timestamp? uploadedAt,
  }) {
    final newStatus = status ?? this.status;
    return DocumentModel(
      documentId: documentId ?? this.documentId,
      userId: userId ?? this.userId,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      fileUrl: fileUrl ?? this.fileUrl,
      documentData: documentData ?? this.documentData,
      verified: verified ?? (newStatus == statusVerified),
      status: newStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      issuedBy: issuedBy ?? this.issuedBy,
      issuedAt: issuedAt ?? this.issuedAt,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}
