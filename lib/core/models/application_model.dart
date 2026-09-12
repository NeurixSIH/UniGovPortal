import 'application_status.dart';

class UploadedDocument {
  final String docId;
  final String name;
  final String fileName;
  final int fileSizeBytes;
  final DateTime uploadedAt;
  final bool isVerified;
  final bool isFlagged;
  final String? officerComment;

  const UploadedDocument({
    required this.docId,
    required this.name,
    required this.fileName,
    required this.fileSizeBytes,
    required this.uploadedAt,
    this.isVerified = false,
    this.isFlagged = false,
    this.officerComment,
  });

  UploadedDocument copyWith({
    String? docId,
    String? name,
    String? fileName,
    int? fileSizeBytes,
    DateTime? uploadedAt,
    bool? isVerified,
    bool? isFlagged,
    String? officerComment,
  }) {
    return UploadedDocument(
      docId: docId ?? this.docId,
      name: name ?? this.name,
      fileName: fileName ?? this.fileName,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      isVerified: isVerified ?? this.isVerified,
      isFlagged: isFlagged ?? this.isFlagged,
      officerComment: officerComment ?? this.officerComment,
    );
  }
}

class TimelineEvent {
  final AppStatus stage;
  final String title;
  final String description;
  final DateTime timestamp;
  final String actorRole;
  final String? actorName;
  final String? remarks;

  const TimelineEvent({
    required this.stage,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.actorRole,
    this.actorName,
    this.remarks,
  });
}

class ApplicationModel {
  final String id;
  final String serviceId;
  final String serviceName;
  final String departmentId;
  final String departmentName;
  final String citizenId;
  final String citizenName;
  final String citizenAadhaar;
  final String citizenPhone;
  final String citizenEmail;
  final String citizenAddress;
  final AppStatus status;
  final DateTime submissionDate;
  final DateTime lastUpdated;
  final String? assignedOfficerId;
  final String? assignedOfficerName;
  final Map<String, dynamic> formData;
  final List<UploadedDocument> documents;
  final List<TimelineEvent> timeline;
  final String? officerRemarks;
  final String? rejectionCategory;
  final String? rejectionRemarks;
  final DateTime? rejectionDate;
  final String? actionRequiredReason;
  final String? actionRequiredDocumentId;
  final DateTime? actionDeadline;
  final String? certificateNumber;
  final DateTime? certificateIssueDate;
  final DateTime? certificateExpiryDate;
  final String? certificateQrData;
  final String? certificateSignedBy;

  const ApplicationModel({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.departmentId,
    required this.departmentName,
    required this.citizenId,
    required this.citizenName,
    required this.citizenAadhaar,
    required this.citizenPhone,
    required this.citizenEmail,
    required this.citizenAddress,
    required this.status,
    required this.submissionDate,
    required this.lastUpdated,
    this.assignedOfficerId,
    this.assignedOfficerName,
    required this.formData,
    required this.documents,
    required this.timeline,
    this.officerRemarks,
    this.rejectionCategory,
    this.rejectionRemarks,
    this.rejectionDate,
    this.actionRequiredReason,
    this.actionRequiredDocumentId,
    this.actionDeadline,
    this.certificateNumber,
    this.certificateIssueDate,
    this.certificateExpiryDate,
    this.certificateQrData,
    this.certificateSignedBy,
  });

  ApplicationModel copyWith({
    String? id,
    String? serviceId,
    String? serviceName,
    String? departmentId,
    String? departmentName,
    String? citizenId,
    String? citizenName,
    String? citizenAadhaar,
    String? citizenPhone,
    String? citizenEmail,
    String? citizenAddress,
    AppStatus? status,
    DateTime? submissionDate,
    DateTime? lastUpdated,
    String? assignedOfficerId,
    String? assignedOfficerName,
    Map<String, dynamic>? formData,
    List<UploadedDocument>? documents,
    List<TimelineEvent>? timeline,
    String? officerRemarks,
    String? rejectionCategory,
    String? rejectionRemarks,
    DateTime? rejectionDate,
    String? actionRequiredReason,
    String? actionRequiredDocumentId,
    DateTime? actionDeadline,
    String? certificateNumber,
    DateTime? certificateIssueDate,
    DateTime? certificateExpiryDate,
    String? certificateQrData,
    String? certificateSignedBy,
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      citizenId: citizenId ?? this.citizenId,
      citizenName: citizenName ?? this.citizenName,
      citizenAadhaar: citizenAadhaar ?? this.citizenAadhaar,
      citizenPhone: citizenPhone ?? this.citizenPhone,
      citizenEmail: citizenEmail ?? this.citizenEmail,
      citizenAddress: citizenAddress ?? this.citizenAddress,
      status: status ?? this.status,
      submissionDate: submissionDate ?? this.submissionDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      assignedOfficerId: assignedOfficerId ?? this.assignedOfficerId,
      assignedOfficerName: assignedOfficerName ?? this.assignedOfficerName,
      formData: formData ?? this.formData,
      documents: documents ?? this.documents,
      timeline: timeline ?? this.timeline,
      officerRemarks: officerRemarks ?? this.officerRemarks,
      rejectionCategory: rejectionCategory ?? this.rejectionCategory,
      rejectionRemarks: rejectionRemarks ?? this.rejectionRemarks,
      rejectionDate: rejectionDate ?? this.rejectionDate,
      actionRequiredReason: actionRequiredReason ?? this.actionRequiredReason,
      actionRequiredDocumentId: actionRequiredDocumentId ?? this.actionRequiredDocumentId,
      actionDeadline: actionDeadline ?? this.actionDeadline,
      certificateNumber: certificateNumber ?? this.certificateNumber,
      certificateIssueDate: certificateIssueDate ?? this.certificateIssueDate,
      certificateExpiryDate: certificateExpiryDate ?? this.certificateExpiryDate,
      certificateQrData: certificateQrData ?? this.certificateQrData,
      certificateSignedBy: certificateSignedBy ?? this.certificateSignedBy,
    );
  }
}
