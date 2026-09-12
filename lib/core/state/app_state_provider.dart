import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../models/application_model.dart';
import '../models/application_status.dart';
import '../models/department_model.dart';
import '../models/notification_model.dart';
import '../models/officer_model.dart';
import '../models/service_model.dart';

enum UserRole {
  citizen,
  officer,
  admin,
}

class AppStateProvider extends ChangeNotifier {
  // Current Role & Auth State
  UserRole _currentRole = UserRole.citizen;
  bool _isAuthenticated = true; // Auto-authenticated with demo user for smooth exploration
  String _currentLanguage = 'English';

  // Active Data Sets
  List<ApplicationModel> _applications = List.from(DemoData.applications);
  List<OfficerModel> _officers = List.from(DemoData.officers);
  List<NotificationModel> _notifications = List.from(DemoData.notifications);
  final List<DepartmentModel> _departments = List.from(DemoData.departments);
  final List<ServiceModel> _services = List.from(DemoData.services);

  // Active selections
  String? _selectedApplicationId;
  String? _selectedServiceId;
  String? _selectedOfficerId = 'off-01'; // Default logged-in officer (Priya Verma)

  // Getters
  UserRole get currentRole => _currentRole;
  bool get isAuthenticated => _isAuthenticated;
  String get currentLanguage => _currentLanguage;
  List<ApplicationModel> get applications => _applications;
  List<OfficerModel> get officers => _officers;
  List<NotificationModel> get notifications => _notifications;
  List<DepartmentModel> get departments => _departments;
  List<ServiceModel> get services => _services;
  String? get selectedApplicationId => _selectedApplicationId;
  String? get selectedServiceId => _selectedServiceId;
  String? get selectedOfficerId => _selectedOfficerId;

  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;
  int get draftApplicationsCount => _applications.where((a) => a.status == AppStatus.draft).length;
  List<ApplicationModel> get draftApplications => _applications.where((a) => a.status == AppStatus.draft).toList();

  OfficerModel? get currentOfficer {
    try {
      return _officers.firstWhere((o) => o.id == _selectedOfficerId);
    } catch (_) {
      return _officers.isNotEmpty ? _officers.first : null;
    }
  }

  ApplicationModel? get selectedApplication {
    if (_selectedApplicationId == null) return null;
    try {
      return _applications.firstWhere((a) => a.id == _selectedApplicationId);
    } catch (_) {
      return null;
    }
  }

  ServiceModel? get selectedService {
    if (_selectedServiceId == null) return null;
    try {
      return _services.firstWhere((s) => s.id == _selectedServiceId);
    } catch (_) {
      return null;
    }
  }

  // Role switching
  void setRole(UserRole role) {
    _currentRole = role;
    notifyListeners();
  }

  void login(UserRole role) {
    _currentRole = role;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _currentLanguage = lang;
    notifyListeners();
  }

  void selectApplication(String? id) {
    _selectedApplicationId = id;
    notifyListeners();
  }

  void selectService(String? id) {
    _selectedServiceId = id;
    notifyListeners();
  }

  void selectOfficer(String id) {
    _selectedOfficerId = id;
    notifyListeners();
  }

  // -------------------------------------------------------------
  // APPLICATION ACTIONS (CITIZEN & OFFICER)
  // -------------------------------------------------------------

  void submitNewApplication(ApplicationModel newApp) {
    _applications.insert(0, newApp);
    _notifications.insert(
      0,
      NotificationModel(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Application Submitted: ${newApp.serviceName}',
        message: 'Application ${newApp.id} was successfully submitted and queued for verification.',
        timestamp: DateTime.now(),
        type: NotificationType.submitted,
        applicationId: newApp.id,
      ),
    );
    _selectedApplicationId = newApp.id;
    notifyListeners();
  }

  void saveDraftApplication(ApplicationModel draftApp) {
    final index = _applications.indexWhere((a) => a.id == draftApp.id);
    if (index != -1) {
      _applications[index] = draftApp;
    } else {
      _applications.insert(0, draftApp);
    }
    notifyListeners();
  }

  void deleteDraftApplication(String draftId) {
    _applications.removeWhere((a) => a.id == draftId);
    notifyListeners();
  }

  void resolveInformationRequired({
    required String applicationId,
    required List<UploadedDocument> updatedDocuments,
    required String citizenRemarks,
  }) {
    final index = _applications.indexWhere((a) => a.id == applicationId);
    if (index != -1) {
      final app = _applications[index];
      final newTimeline = List<TimelineEvent>.from(app.timeline)
        ..add(
          TimelineEvent(
            stage: AppStatus.resubmitted,
            title: 'Discrepancy Resolved & Resubmitted',
            description: citizenRemarks.isNotEmpty
                ? citizenRemarks
                : 'Citizen uploaded corrected documents and certified validity.',
            timestamp: DateTime.now(),
            actorRole: 'Citizen',
            actorName: DemoData.citizenProfile['fullName'],
          ),
        );

      _applications[index] = app.copyWith(
        status: AppStatus.resubmitted,
        lastUpdated: DateTime.now(),
        documents: updatedDocuments,
        timeline: newTimeline,
      );

      _notifications.insert(
        0,
        NotificationModel(
          id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Application Resubmitted',
          message: 'Correction for application ${app.id} received. Queued for priority officer scrutiny.',
          timestamp: DateTime.now(),
          type: NotificationType.resubmitted,
          applicationId: app.id,
        ),
      );

      notifyListeners();
    }
  }

  void officerApproveApplication({
    required String applicationId,
    required String officerNotes,
  }) {
    final index = _applications.indexWhere((a) => a.id == applicationId);
    if (index != -1) {
      final app = _applications[index];
      final certNumber = 'CERT-${app.departmentName.split(' ').first.toUpperCase()}-2026-${(1000 + index * 37)}';
      final officerName = currentOfficer?.fullName ?? 'Priya Verma, IAS';

      final newTimeline = List<TimelineEvent>.from(app.timeline)
        ..add(
          TimelineEvent(
            stage: AppStatus.approved,
            title: 'Application Formally Approved',
            description: officerNotes.isNotEmpty ? officerNotes : 'All statutory verifications found in order.',
            timestamp: DateTime.now(),
            actorRole: 'Department Officer',
            actorName: officerName,
            remarks: officerNotes,
          ),
        )
        ..add(
          TimelineEvent(
            stage: AppStatus.certificateGenerated,
            title: 'Digital Certificate Generated with QR Seal',
            description: 'Digitally signed official certificate $certNumber issued.',
            timestamp: DateTime.now().add(const Duration(seconds: 1)),
            actorRole: 'System Security Engine',
          ),
        );

      _applications[index] = app.copyWith(
        status: AppStatus.certificateGenerated,
        lastUpdated: DateTime.now(),
        officerRemarks: officerNotes,
        timeline: newTimeline,
        certificateNumber: certNumber,
        certificateIssueDate: DateTime.now(),
        certificateExpiryDate: DateTime.now().add(const Duration(days: 365 * 3)),
        certificateSignedBy: '$officerName, Competent Authority',
        certificateQrData: 'https://setu.gov.in/verify/$certNumber',
      );

      _notifications.insert(
        0,
        NotificationModel(
          id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Application Approved: ${app.serviceName}',
          message: 'Congratulations! Application ${app.id} has been approved. Your official certificate is ready.',
          timestamp: DateTime.now(),
          type: NotificationType.certificateReady,
          applicationId: app.id,
        ),
      );

      notifyListeners();
    }
  }

  void officerRejectApplication({
    required String applicationId,
    required String reasonCategory,
    required String remarks,
  }) {
    final index = _applications.indexWhere((a) => a.id == applicationId);
    if (index != -1) {
      final app = _applications[index];
      final officerName = currentOfficer?.fullName ?? 'Competent Authority';

      final newTimeline = List<TimelineEvent>.from(app.timeline)
        ..add(
          TimelineEvent(
            stage: AppStatus.rejected,
            title: 'Application Rejected',
            description: 'Grounds: $reasonCategory. Remarks: $remarks',
            timestamp: DateTime.now(),
            actorRole: 'Department Officer',
            actorName: officerName,
            remarks: remarks,
          ),
        );

      _applications[index] = app.copyWith(
        status: AppStatus.rejected,
        lastUpdated: DateTime.now(),
        rejectionCategory: reasonCategory,
        rejectionRemarks: remarks,
        rejectionDate: DateTime.now(),
        timeline: newTimeline,
      );

      _notifications.insert(
        0,
        NotificationModel(
          id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Application Rejected: ${app.serviceName}',
          message: 'Application ${app.id} was rejected ($reasonCategory). View remarks and options to appeal or re-apply.',
          timestamp: DateTime.now(),
          type: NotificationType.rejected,
          applicationId: app.id,
        ),
      );

      notifyListeners();
    }
  }

  void officerRequestInformation({
    required String applicationId,
    required String reasonCategory,
    required String documentId,
    required String message,
  }) {
    final index = _applications.indexWhere((a) => a.id == applicationId);
    if (index != -1) {
      final app = _applications[index];
      final officerName = currentOfficer?.fullName ?? 'Department Officer';

      final updatedDocs = app.documents.map((d) {
        if (d.docId == documentId) {
          return d.copyWith(isFlagged: true, isVerified: false, officerComment: message);
        }
        return d;
      }).toList();

      final newTimeline = List<TimelineEvent>.from(app.timeline)
        ..add(
          TimelineEvent(
            stage: AppStatus.informationRequired,
            title: 'Information & Document Clarification Required',
            description: '$reasonCategory: $message',
            timestamp: DateTime.now(),
            actorRole: 'Department Officer',
            actorName: officerName,
            remarks: message,
          ),
        );

      _applications[index] = app.copyWith(
        status: AppStatus.informationRequired,
        lastUpdated: DateTime.now(),
        actionRequiredReason: '$reasonCategory: $message',
        actionRequiredDocumentId: documentId,
        actionDeadline: DateTime.now().add(const Duration(days: 10)),
        documents: updatedDocs,
        timeline: newTimeline,
      );

      _notifications.insert(
        0,
        NotificationModel(
          id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Action Required: ${app.serviceName}',
          message: 'Officer $officerName requested clarification for application ${app.id}. Resolve within 10 days.',
          timestamp: DateTime.now(),
          type: NotificationType.infoRequired,
          applicationId: app.id,
        ),
      );

      notifyListeners();
    }
  }

  void verifyDocument({
    required String applicationId,
    required String docId,
    required bool isVerified,
    String? comment,
  }) {
    final appIndex = _applications.indexWhere((a) => a.id == applicationId);
    if (appIndex != -1) {
      final app = _applications[appIndex];
      final updatedDocs = app.documents.map((d) {
        if (d.docId == docId) {
          return d.copyWith(
            isVerified: isVerified,
            isFlagged: !isVerified,
            officerComment: comment,
          );
        }
        return d;
      }).toList();

      _applications[appIndex] = app.copyWith(documents: updatedDocs);
      notifyListeners();
    }
  }

  // -------------------------------------------------------------
  // ADMIN ACTIONS (OFFICER MANAGEMENT)
  // -------------------------------------------------------------

  void addOfficer(OfficerModel officer) {
    _officers.insert(0, officer);
    notifyListeners();
  }

  void updateOfficer(OfficerModel officer) {
    final index = _officers.indexWhere((o) => o.id == officer.id);
    if (index != -1) {
      _officers[index] = officer;
      notifyListeners();
    }
  }

  void toggleOfficerActive(String id) {
    final index = _officers.indexWhere((o) => o.id == id);
    if (index != -1) {
      _officers[index] = _officers[index].copyWith(isActive: !_officers[index].isActive);
      notifyListeners();
    }
  }

  void deleteOfficer(String id) {
    _officers.removeWhere((o) => o.id == id);
    notifyListeners();
  }

  // -------------------------------------------------------------
  // NOTIFICATIONS
  // -------------------------------------------------------------

  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }
}
