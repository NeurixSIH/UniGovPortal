import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/application_model.dart';
import '../models/document_model.dart';
import '../models/consent_model.dart';
import '../models/audit_log_model.dart';
import '../models/notification_model.dart';
import '../models/service_model.dart';

class DemoRepository extends ChangeNotifier {
  static final DemoRepository _instance = DemoRepository._internal();
  factory DemoRepository() => _instance;
  DemoRepository._internal() {
    _initData();
  }

  // Active Role State ('citizen', 'departmentAdmin', 'systemAdmin')
  String _activeRole = UserModel.roleCitizen;
  String get activeRole => _activeRole;

  void setActiveRole(String role) {
    _activeRole = role;
    notifyListeners();
  }

  // Citizen Profile
  late UserModel citizenUser;
  late UserModel deptOfficer;
  late UserModel systemAdmin;

  // Collections
  List<ApplicationModel> applications = [];
  List<DocumentModel> documents = [];
  List<ConsentModel> consents = [];
  List<AuditLogModel> syncLogs = [];
  List<NotificationModel> notifications = [];
  List<ServiceModel> services = [];
  List<UserModel> officers = [];

  // Interoperability stats
  int synchronizedFieldsCount = 24;
  DateTime lastSyncTime = DateTime.now().subtract(const Duration(minutes: 8));

  void _initData() {
    // 1. Citizen: Krisha Patel
    citizenUser = UserModel(
      userId: 'MH123456789',
      fullName: 'Krisha Patel',
      email: 'krisha.patel@maharashtra.gov.in',
      mobileNumber: '+91 98765 43210',
      dob: Timestamp.fromDate(DateTime(1996, 5, 14)),
      gender: 'Female',
      address: {
        'line1': 'Flat 402, Shivam Apts, Shivaji Nagar',
        'city': 'Pune',
        'state': 'Maharashtra',
        'pincode': '411005',
      },
      city: 'Pune',
      state: 'Maharashtra',
      pincode: '411005',
      income: 250000,
      category: 'General',
      role: UserModel.roleCitizen,
      status: UserModel.statusActive,
      departmentId: '',
      landOwnership: '2.5 Acres (Agricultural)',
      incomeBracket: '₹1,50,000 - ₹3,00,000',
      extraInformation: {
        'profileCompletion': 80,
        'maritalStatus': 'Single',
        'occupation': 'Agriculture & Private Sector',
      },
      createdAt: Timestamp.fromDate(DateTime(2025, 1, 10)),
      updatedAt: Timestamp.now(),
    );

    // 2. Department Admin
    deptOfficer = UserModel(
      userId: 'OFF_REV_408',
      fullName: 'Sanjay Deshmukh',
      email: 'sanjay.deshmukh@revenue.maha.gov.in',
      mobileNumber: '+91 94220 12345',
      dob: Timestamp.fromDate(DateTime(1982, 3, 22)),
      gender: 'Male',
      address: {'line1': 'Collectorate Office', 'city': 'Pune', 'state': 'Maharashtra', 'pincode': '411001'},
      city: 'Pune',
      state: 'Maharashtra',
      pincode: '411001',
      income: 800000,
      category: 'General',
      role: UserModel.roleDepartmentAdmin,
      status: UserModel.statusActive,
      departmentId: 'Revenue Department',
      createdAt: Timestamp.fromDate(DateTime(2024, 6, 1)),
      updatedAt: Timestamp.now(),
    );

    // 3. System Admin
    systemAdmin = UserModel(
      userId: 'SYS_ADMIN_01',
      fullName: 'Aaditya Thackeray (Admin)',
      email: 'admin.interop@maha.gov.in',
      mobileNumber: '+91 98200 99999',
      dob: Timestamp.fromDate(DateTime(1990, 6, 13)),
      gender: 'Male',
      address: {'line1': 'Mantralaya', 'city': 'Mumbai', 'state': 'Maharashtra', 'pincode': '400032'},
      city: 'Mumbai',
      state: 'Maharashtra',
      pincode: '400032',
      income: 1200000,
      category: 'General',
      role: UserModel.roleSystemAdmin,
      status: UserModel.statusActive,
      departmentId: 'Information Technology',
      createdAt: Timestamp.fromDate(DateTime(2023, 1, 1)),
      updatedAt: Timestamp.now(),
    );

    // 4. Officers List
    officers = [
      deptOfficer,
      UserModel(
        userId: 'OFF_MUN_201',
        fullName: 'Pooja Jadhav',
        email: 'pooja.j@pmc.gov.in',
        mobileNumber: '+91 98111 22334',
        dob: Timestamp.fromDate(DateTime(1987, 8, 19)),
        gender: 'Female',
        address: {'line1': 'PMC HQ', 'city': 'Pune', 'state': 'Maharashtra', 'pincode': '411005'},
        city: 'Pune',
        state: 'Maharashtra',
        pincode: '411005',
        income: 750000,
        category: 'OBC',
        role: UserModel.roleDepartmentAdmin,
        status: UserModel.statusActive,
        departmentId: 'Municipal Corporation',
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      ),
      UserModel(
        userId: 'OFF_LND_105',
        fullName: 'Vikas Kulkarni',
        email: 'vikas.k@landrecords.maha.gov.in',
        mobileNumber: '+91 97654 33221',
        dob: Timestamp.fromDate(DateTime(1984, 11, 2)),
        gender: 'Male',
        address: {'line1': 'Bhumilekh Bhavan', 'city': 'Pune', 'state': 'Maharashtra', 'pincode': '411001'},
        city: 'Pune',
        state: 'Maharashtra',
        pincode: '411001',
        income: 780000,
        category: 'General',
        role: UserModel.roleDepartmentAdmin,
        status: UserModel.statusActive,
        departmentId: 'Land Records',
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      ),
      UserModel(
        userId: 'OFF_AGR_330',
        fullName: 'Sunil Shinde',
        email: 'sunil.s@agri.maha.gov.in',
        mobileNumber: '+91 94230 77889',
        dob: Timestamp.fromDate(DateTime(1979, 4, 12)),
        gender: 'Male',
        address: {'line1': 'Krishi Bhavan', 'city': 'Pune', 'state': 'Maharashtra', 'pincode': '411005'},
        city: 'Pune',
        state: 'Maharashtra',
        pincode: '411005',
        income: 820000,
        category: 'Open',
        role: UserModel.roleDepartmentAdmin,
        status: UserModel.statusActive,
        departmentId: 'Agriculture Department',
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      ),
    ];

    // 5. Applications
    final now = DateTime.now();
    applications = [
      ApplicationModel(
        applicationId: 'APP20260904',
        userId: 'MH123456789',
        departmentId: 'Revenue Department',
        serviceId: 'SRV_INCOME_CERT',
        applicationData: {
          'serviceName': 'Income Certificate',
          'annualIncome': 250000,
          'purpose': 'Education Fee Concession & Scholarship',
          'financialYear': '2025-2026',
        },
        documents: ['DOC_AADHAAR', 'DOC_INCOME', 'DOC_ADDRESS'],
        status: ApplicationModel.statusUnderReview,
        remarks: 'Verification in progress by Talathi officer.',
        submittedAt: Timestamp.fromDate(now.subtract(const Duration(days: 3))),
        updatedAt: Timestamp.fromDate(now.subtract(const Duration(hours: 4))),
        processedBy: 'Sanjay Deshmukh (Revenue)',
        timeline: [
          {
            'stage': 'Submitted',
            'status': 'submitted',
            'remarks': 'Application submitted with auto-verified profile data.',
            'timestamp': Timestamp.fromDate(now.subtract(const Duration(days: 3))),
            'processedBy': 'Krisha Patel',
          },
          {
            'stage': 'Under Review',
            'status': 'under_review',
            'remarks': 'Cross-referencing bank income declaration and Aadhaar link.',
            'timestamp': Timestamp.fromDate(now.subtract(const Duration(days: 1))),
            'processedBy': 'Sanjay Deshmukh (Talathi / Revenue Officer)',
          },
        ],
      ),
      ApplicationModel(
        applicationId: 'APP20260815',
        userId: 'MH123456789',
        departmentId: 'Food & Civil Supplies',
        serviceId: 'SRV_RATION_CARD',
        applicationData: {
          'serviceName': 'Ration Card Endorsement',
          'familyMembers': 3,
        },
        documents: ['DOC_AADHAAR', 'DOC_ADDRESS'],
        status: ApplicationModel.statusApproved,
        remarks: 'Approved. Digital Smart Ration card issued.',
        submittedAt: Timestamp.fromDate(now.subtract(const Duration(days: 20))),
        updatedAt: Timestamp.fromDate(now.subtract(const Duration(days: 12))),
        processedBy: 'Rationing Officer Zone 4',
        timeline: [
          {
            'stage': 'Submitted',
            'status': 'submitted',
            'remarks': 'Submitted online.',
            'timestamp': Timestamp.fromDate(now.subtract(const Duration(days: 20))),
            'processedBy': 'Krisha Patel',
          },
          {
            'stage': 'Approved',
            'status': 'approved',
            'remarks': 'Eligible for NFSA subsidized quota.',
            'timestamp': Timestamp.fromDate(now.subtract(const Duration(days: 12))),
            'processedBy': 'Zonal Supply Officer',
          },
        ],
      ),
      ApplicationModel(
        applicationId: 'APP20260720',
        userId: 'MH123456789',
        departmentId: 'Education Department',
        serviceId: 'SRV_SCHOLARSHIP',
        applicationData: {
          'serviceName': 'State Higher Education Scholarship',
          'course': 'B.Tech / Engineering',
        },
        documents: ['DOC_AADHAAR', 'DOC_INCOME'],
        status: ApplicationModel.statusCompleted,
        remarks: 'Scholarship disbursement of ₹25,000 sent via DBT.',
        submittedAt: Timestamp.fromDate(now.subtract(const Duration(days: 45))),
        updatedAt: Timestamp.fromDate(now.subtract(const Duration(days: 30))),
        processedBy: 'MahaDBT Officer',
        timeline: [
          {
            'stage': 'Submitted',
            'status': 'submitted',
            'remarks': 'Submitted on MahaDBT.',
            'timestamp': Timestamp.fromDate(now.subtract(const Duration(days: 45))),
            'processedBy': 'Krisha Patel',
          },
          {
            'stage': 'Completed',
            'status': 'completed',
            'remarks': 'DBT transaction confirmed to linked bank account.',
            'timestamp': Timestamp.fromDate(now.subtract(const Duration(days: 30))),
            'processedBy': 'Treasury System',
          },
        ],
      ),
    ];

    // 6. Documents
    documents = [
      DocumentModel(
        documentId: 'DOC_AADHAAR',
        userId: 'MH123456789',
        documentType: 'Aadhaar Card',
        documentNumber: 'XXXX-XXXX-8821',
        fileUrl: 'https://uidai.gov.in/sample_aadhaar.pdf',
        documentData: {'name': 'Krisha Patel', 'dob': '14/05/1996'},
        verified: true,
        status: DocumentModel.statusVerified,
        issuedBy: 'UIDAI - Government of India',
        issuedAt: Timestamp.fromDate(DateTime(2018, 2, 10)),
        uploadedAt: Timestamp.fromDate(DateTime(2025, 1, 12)),
      ),
      DocumentModel(
        documentId: 'DOC_ADDRESS',
        userId: 'MH123456789',
        documentType: 'Address Proof (Electricity Bill)',
        documentNumber: 'MSEB-889210452',
        fileUrl: 'https://mahadiscom.in/sample_bill.pdf',
        documentData: {'address': 'Flat 402, Shivam Apts, Pune 411005'},
        verified: true,
        status: DocumentModel.statusVerified,
        issuedBy: 'MSEDCL Maharashtra',
        issuedAt: Timestamp.fromDate(DateTime(2025, 8, 1)),
        uploadedAt: Timestamp.fromDate(DateTime(2025, 8, 5)),
      ),
      DocumentModel(
        documentId: 'DOC_INCOME',
        userId: 'MH123456789',
        documentType: 'Income Certificate',
        documentNumber: 'INC/2026/PUN/091',
        fileUrl: 'https://revenue.maha.gov.in/sample_inc.pdf',
        documentData: {'income': 250000},
        verified: false,
        status: DocumentModel.statusPending,
        issuedBy: 'Revenue Department - Tahsildar Pune',
        issuedAt: Timestamp.fromDate(DateTime(2025, 4, 1)),
        uploadedAt: Timestamp.fromDate(DateTime(2026, 9, 2)),
      ),
      DocumentModel(
        documentId: 'DOC_LAND',
        userId: 'MH123456789',
        documentType: 'Land Record (7/12 Extract)',
        documentNumber: '7-12-MH-PUN-4029',
        fileUrl: 'https://bhulekh.mahabhumi.gov.in/sample_712.pdf',
        documentData: {'area': '2.5 Acres', 'surveyNo': '42/1A'},
        verified: true,
        status: DocumentModel.statusVerified,
        issuedBy: 'Department of Land Records (Mahabhumi)',
        issuedAt: Timestamp.fromDate(DateTime(2024, 10, 15)),
        uploadedAt: Timestamp.fromDate(DateTime(2025, 2, 20)),
      ),
      DocumentModel(
        documentId: 'DOC_AGRI',
        userId: 'MH123456789',
        documentType: 'Agriculture Subsidy Document',
        documentNumber: 'AGR/SUB/2025/11',
        fileUrl: 'https://agri.maha.gov.in/sample_agri.pdf',
        documentData: {'crop': 'Soybean'},
        verified: false,
        status: DocumentModel.statusRejected,
        rejectionReason: 'Land survey number mismatch with 7/12 record.',
        issuedBy: 'Agriculture Department Maharashtra',
        issuedAt: Timestamp.fromDate(DateTime(2025, 6, 1)),
        uploadedAt: Timestamp.fromDate(DateTime(2025, 6, 15)),
      ),
    ];

    // 7. Consents
    consents = [
      ConsentModel(
        consentId: 'CNS_MUN_01',
        userId: 'MH123456789',
        departmentId: 'Municipal Corporation',
        serviceId: 'Property Tax & Water Connection',
        dataFields: ['Address', 'Property details'],
        purpose: 'Address verification and property assessment synchronization.',
        status: ConsentModel.statusGranted,
        grantedAt: Timestamp.fromDate(now.subtract(const Duration(days: 60))),
        expiresAt: Timestamp.fromDate(now.add(const Duration(days: 305))),
        updatedAt: Timestamp.now(),
      ),
      ConsentModel(
        consentId: 'CNS_BNK_02',
        userId: 'MH123456789',
        departmentId: 'Banking Department',
        serviceId: 'Direct Benefit Transfer (DBT)',
        dataFields: ['KYC', 'Account details', 'Income Bracket'],
        purpose: 'DBT verification and zero-balance citizen account linkage.',
        status: ConsentModel.statusGranted,
        grantedAt: Timestamp.fromDate(now.subtract(const Duration(days: 40))),
        expiresAt: Timestamp.fromDate(now.add(const Duration(days: 325))),
        updatedAt: Timestamp.now(),
      ),
      ConsentModel(
        consentId: 'CNS_LND_03',
        userId: 'MH123456789',
        departmentId: 'Land Records',
        serviceId: 'Mahabhumi Interop',
        dataFields: ['Land ownership', 'Property details'],
        purpose: 'Synchronize 7/12 mutation with revenue records.',
        status: ConsentModel.statusPending,
        grantedAt: Timestamp.now(),
        expiresAt: Timestamp.fromDate(now.add(const Duration(days: 180))),
        updatedAt: Timestamp.now(),
      ),
      ConsentModel(
        consentId: 'CNS_AGR_04',
        userId: 'MH123456789',
        departmentId: 'Agriculture Department',
        serviceId: 'Crop Insurance & PM-Kisan',
        dataFields: ['Land', 'Crop details'],
        purpose: 'Automatic eligibility for weather-based crop insurance.',
        status: ConsentModel.statusGranted,
        grantedAt: Timestamp.fromDate(now.subtract(const Duration(days: 90))),
        expiresAt: Timestamp.fromDate(now.add(const Duration(days: 275))),
        updatedAt: Timestamp.now(),
      ),
    ];

    // 8. Live Synchronization Audit Logs
    syncLogs = [
      AuditLogModel(
        logId: 'SYNC_001',
        userId: 'MH123456789',
        departmentId: 'Municipal Corporation',
        serviceId: 'INTEROP_SYNC',
        action: AuditLogModel.actionLiveSync,
        dataChanged: {'field': 'Address'},
        performedBy: 'Interoperability Hub',
        timestamp: Timestamp.fromDate(now.subtract(const Duration(minutes: 8))),
        sourceDepartment: 'Citizen Profile',
        targetDepartment: 'Municipal Corporation',
        fieldChanged: 'Address',
        oldValue: 'Flat 301, FC Road, Pune',
        newValue: 'Flat 402, Shivam Apts, Pune',
        status: AuditLogModel.statusSuccess,
        category: AuditLogModel.categoryAddress,
      ),
      AuditLogModel(
        logId: 'SYNC_002',
        userId: 'MH123456789',
        departmentId: 'Banking Department',
        serviceId: 'INTEROP_SYNC',
        action: AuditLogModel.actionLiveSync,
        dataChanged: {'field': 'Income'},
        performedBy: 'Interoperability Hub',
        timestamp: Timestamp.fromDate(now.subtract(const Duration(hours: 3))),
        sourceDepartment: 'Revenue Department',
        targetDepartment: 'Banking Department',
        fieldChanged: 'Income Verified',
        oldValue: '₹2,00,000',
        newValue: '₹2,50,000',
        status: AuditLogModel.statusSuccess,
        category: AuditLogModel.categoryProfile,
      ),
      AuditLogModel(
        logId: 'SYNC_003',
        userId: 'MH123456789',
        departmentId: 'Land Records',
        serviceId: 'INTEROP_SYNC',
        action: AuditLogModel.actionLiveSync,
        dataChanged: {'field': 'Land Ownership'},
        performedBy: 'Interoperability Hub',
        timestamp: Timestamp.fromDate(now.subtract(const Duration(days: 1))),
        sourceDepartment: 'Land Records',
        targetDepartment: 'Revenue Department',
        fieldChanged: 'Land Ownership',
        oldValue: 'Survey 42/1 (2.0 Acres)',
        newValue: 'Survey 42/1A (2.5 Acres)',
        status: AuditLogModel.statusSuccess,
        category: 'Land',
      ),
      AuditLogModel(
        logId: 'SYNC_004',
        userId: 'MH123456789',
        departmentId: 'All Connected Departments',
        serviceId: 'INTEROP_SYNC',
        action: AuditLogModel.actionLiveSync,
        dataChanged: {'field': 'Profile Details'},
        performedBy: 'Citizen Sync Gateway',
        timestamp: Timestamp.fromDate(now.subtract(const Duration(days: 2))),
        sourceDepartment: 'Citizen Profile',
        targetDepartment: 'Connected Departments',
        fieldChanged: 'Mobile Number Verified',
        oldValue: '+91 98765 00000',
        newValue: '+91 98765 43210',
        status: AuditLogModel.statusSuccess,
        category: AuditLogModel.categoryProfile,
      ),
    ];

    // 9. Notifications
    notifications = [
      NotificationModel(
        notificationId: 'NOTIF_01',
        userId: 'MH123456789',
        type: NotificationModel.typeConsentRequest,
        title: 'Consent Request',
        message: 'Municipal Corporation requests access to your Address & Property details for tax subsidy.',
        applicationId: '',
        consentId: 'CNS_MUN_01',
        departmentId: 'Municipal Corporation',
        actionPayload: {'canAllow': true, 'canDeny': true},
        isRead: false,
        createdAt: Timestamp.fromDate(now.subtract(const Duration(hours: 1))),
      ),
      NotificationModel(
        notificationId: 'NOTIF_02',
        userId: 'MH123456789',
        type: NotificationModel.typeApplicationUpdate,
        title: 'Application Update',
        message: 'Your Income Certificate (APP20260904) application is Under Review by Revenue Department.',
        applicationId: 'APP20260904',
        departmentId: 'Revenue Department',
        isRead: false,
        createdAt: Timestamp.fromDate(now.subtract(const Duration(hours: 4))),
      ),
      NotificationModel(
        notificationId: 'NOTIF_03',
        userId: 'MH123456789',
        type: NotificationModel.typeSyncMessage,
        title: 'Sync Confirmation',
        message: 'Your address was successfully synchronized with Municipal Corporation & Banking systems.',
        applicationId: '',
        departmentId: 'Municipal Corporation',
        isRead: true,
        createdAt: Timestamp.fromDate(now.subtract(const Duration(days: 1))),
      ),
    ];

    // 10. Services Catalog
    services = [
      ServiceModel(
        serviceId: 'SRV_INCOME_CERT',
        departmentId: 'Revenue Department',
        serviceName: 'Income Certificate',
        description: 'Official certificate stating family annual income for scholarships, fees, and government schemes.',
        category: 'Certificates',
        requiredDocuments: ['Aadhaar Card', 'Income Proof', 'Address Proof'],
        requiredFields: ['Annual Income', 'Purpose of Certificate', 'Financial Year'],
        eligibilityRules: ['income <= 800000', 'state == Maharashtra'],
        processingTime: '7 days',
        fee: 0,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: '',
        status: ServiceModel.statusActive,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        createdBy: 'Admin',
      ),
      ServiceModel(
        serviceId: 'SRV_CASTE_CERT',
        departmentId: 'Revenue Department',
        serviceName: 'Caste Certificate',
        description: 'Certification of caste for educational benefits and statutory reservations.',
        category: 'Certificates',
        requiredDocuments: ['Aadhaar Card', 'School Leaving Certificate', 'Father Caste Proof'],
        requiredFields: ['Caste', 'Sub-caste', 'District'],
        eligibilityRules: ['state == Maharashtra'],
        processingTime: '15 days',
        fee: 50,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: '',
        status: ServiceModel.statusActive,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        createdBy: 'Admin',
      ),
      ServiceModel(
        serviceId: 'SRV_SCHOLARSHIP',
        departmentId: 'Education Department',
        serviceName: 'Post-Matric Scholarship',
        description: 'Financial assistance for students pursuing higher education in Maharashtra colleges.',
        category: 'Schemes',
        requiredDocuments: ['Aadhaar Card', 'Income Certificate', 'College Admission Receipt'],
        requiredFields: ['College Name', 'Course', 'Academic Year'],
        eligibilityRules: ['income <= 300000'],
        processingTime: '10 days',
        fee: 0,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: '',
        status: ServiceModel.statusActive,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        createdBy: 'Admin',
      ),
      ServiceModel(
        serviceId: 'SRV_RATION_CARD',
        departmentId: 'Food & Civil Supplies',
        serviceName: 'New Smart Ration Card',
        description: 'Issue or update of National Food Security digital smart ration card.',
        category: 'Certificates',
        requiredDocuments: ['Aadhaar Card', 'Address Proof', 'Family Photo'],
        requiredFields: ['Family Members', 'Gas Connection Status'],
        eligibilityRules: ['income <= 1000000'],
        processingTime: '14 days',
        fee: 20,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: '',
        status: ServiceModel.statusActive,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        createdBy: 'Admin',
      ),
      ServiceModel(
        serviceId: 'SRV_LAND_CERT',
        departmentId: 'Land Records',
        serviceName: 'Digital 7/12 & 8A Mutation',
        description: 'Digitally signed land record extract and land ownership verification.',
        category: 'Land',
        requiredDocuments: ['Aadhaar Card', 'Old 7/12 Extract', 'Sale Deed'],
        requiredFields: ['District', 'Taluka', 'Village', 'Survey Number'],
        eligibilityRules: [],
        processingTime: '3 days',
        fee: 15,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: '',
        status: ServiceModel.statusActive,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        createdBy: 'Admin',
      ),
      ServiceModel(
        serviceId: 'SRV_PM_KISAN',
        departmentId: 'Agriculture Department',
        serviceName: 'Kisan Samman Subsidy',
        description: 'Direct agricultural support of ₹6,000 per year transferred to farmer bank accounts.',
        category: 'Agriculture',
        requiredDocuments: ['Aadhaar Card', 'Land 7/12 Extract', 'Bank Passbook'],
        requiredFields: ['Land Area in Acres', 'Crop Pattern'],
        eligibilityRules: ['landOwnership != None'],
        processingTime: '5 days',
        fee: 0,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: '',
        status: ServiceModel.statusActive,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        createdBy: 'Admin',
      ),
    ];
  }

  // Live Actions & Interoperability Event Dispatchers

  /// Update citizen personal details & trigger live sync with connected departments
  void updateCitizenDetails({
    required String fullName,
    required String mobileNumber,
    required String addressLine,
    required String city,
    required String state,
    required String pincode,
    required String incomeBracket,
    required String landOwnership,
  }) {
    final oldAddress = '${citizenUser.address['line1']}, ${citizenUser.city}';
    final newAddress = '$addressLine, $city';

    citizenUser = citizenUser.copyWith(
      fullName: fullName,
      mobileNumber: mobileNumber,
      address: {
        'line1': addressLine,
        'city': city,
        'state': state,
        'pincode': pincode,
      },
      city: city,
      state: state,
      pincode: pincode,
      incomeBracket: incomeBracket,
      landOwnership: landOwnership,
      updatedAt: Timestamp.now(),
    );

    // Create live interoperability audit event
    final newLog = AuditLogModel(
      logId: 'SYNC_${DateTime.now().millisecondsSinceEpoch}',
      userId: citizenUser.userId,
      departmentId: 'Municipal Corporation',
      serviceId: 'INTEROP_SYNC',
      action: AuditLogModel.actionLiveSync,
      dataChanged: {'field': 'Address & Profile'},
      performedBy: 'Citizen Self-Service Gateway',
      timestamp: Timestamp.now(),
      sourceDepartment: 'Citizen Profile',
      targetDepartment: 'Municipal Corporation & Banking',
      fieldChanged: 'Address',
      oldValue: oldAddress,
      newValue: newAddress,
      status: AuditLogModel.statusSuccess,
      category: AuditLogModel.categoryAddress,
    );

    syncLogs.insert(0, newLog);
    synchronizedFieldsCount += 3;
    lastSyncTime = DateTime.now();

    // Add confirmation notification
    notifications.insert(
      0,
      NotificationModel(
        notificationId: 'NOTIF_${DateTime.now().millisecondsSinceEpoch}',
        userId: citizenUser.userId,
        type: NotificationModel.typeSyncMessage,
        title: 'Live Sync Triggered',
        message: 'Your updated address has been automatically synchronized with Municipal Corporation & Banking systems.',
        applicationId: '',
        departmentId: 'Municipal Corporation',
        isRead: false,
        createdAt: Timestamp.now(),
      ),
    );

    notifyListeners();
  }

  /// Update consent status
  void updateConsentStatus(String consentId, String newStatus) {
    final index = consents.indexWhere((c) => c.consentId == consentId);
    if (index != -1) {
      final old = consents[index];
      consents[index] = old.copyWith(
        status: newStatus,
        updatedAt: Timestamp.now(),
      );

      // Audit entry
      syncLogs.insert(
        0,
        AuditLogModel(
          logId: 'LOG_${DateTime.now().millisecondsSinceEpoch}',
          userId: citizenUser.userId,
          departmentId: old.departmentId,
          serviceId: old.serviceId,
          action: newStatus == ConsentModel.statusGranted
              ? AuditLogModel.actionConsentGranted
              : AuditLogModel.actionConsentRevoked,
          dataChanged: {'status': newStatus},
          performedBy: citizenUser.fullName,
          timestamp: Timestamp.now(),
          sourceDepartment: 'Citizen Consent Gateway',
          targetDepartment: old.departmentId,
          fieldChanged: 'Data Access Consent',
          oldValue: old.status,
          newValue: newStatus,
          status: AuditLogModel.statusSuccess,
          category: AuditLogModel.categoryProfile,
        ),
      );

      notifyListeners();
    }
  }

  /// Submit new application
  void submitApplication({
    required String serviceId,
    required String departmentId,
    required String serviceName,
    required Map<String, dynamic> data,
  }) {
    final now = DateTime.now();
    final newApp = ApplicationModel(
      applicationId: 'APP${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${applications.length + 1}',
      userId: citizenUser.userId,
      departmentId: departmentId,
      serviceId: serviceId,
      applicationData: {
        'serviceName': serviceName,
        ...data,
      },
      documents: ['DOC_AADHAAR', 'DOC_ADDRESS'],
      status: ApplicationModel.statusSubmitted,
      remarks: 'Application submitted successfully. Waiting for department review.',
      submittedAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      processedBy: 'Pending Assignment',
      timeline: [
        {
          'stage': 'Submitted',
          'status': 'submitted',
          'remarks': 'Application received at Central Interoperability Gateway.',
          'timestamp': Timestamp.now(),
          'processedBy': citizenUser.fullName,
        },
      ],
    );

    applications.insert(0, newApp);

    notifications.insert(
      0,
      NotificationModel(
        notificationId: 'NOTIF_${DateTime.now().millisecondsSinceEpoch}',
        userId: citizenUser.userId,
        type: NotificationModel.typeApplicationUpdate,
        title: 'Application Submitted',
        message: 'Your application for $serviceName (ID: ${newApp.applicationId}) has been received.',
        applicationId: newApp.applicationId,
        departmentId: departmentId,
        isRead: false,
        createdAt: Timestamp.now(),
      ),
    );

    notifyListeners();
  }

  /// Department review action: approve, request documents, or reject
  void reviewApplication(String appId, String newStatus, String remarks, String officerName) {
    final index = applications.indexWhere((a) => a.applicationId == appId);
    if (index != -1) {
      final current = applications[index];
      final newTimeline = List<Map<String, dynamic>>.from(current.timeline);
      
      String stageName = 'Under Review';
      if (newStatus == ApplicationModel.statusApproved) stageName = 'Approved';
      if (newStatus == ApplicationModel.statusDocumentsRequired) stageName = 'Documents Required';
      if (newStatus == ApplicationModel.statusRejected) stageName = 'Rejected';

      newTimeline.add({
        'stage': stageName,
        'status': newStatus,
        'remarks': remarks,
        'timestamp': Timestamp.now(),
        'processedBy': officerName,
      });

      applications[index] = current.copyWith(
        status: newStatus,
        remarks: remarks,
        processedBy: officerName,
        updatedAt: Timestamp.now(),
        timeline: newTimeline,
      );

      // Notify citizen
      notifications.insert(
        0,
        NotificationModel(
          notificationId: 'NOTIF_${DateTime.now().millisecondsSinceEpoch}',
          userId: current.userId,
          type: NotificationModel.typeApplicationUpdate,
          title: 'Application Update: $stageName',
          message: 'Application ${current.applicationId}: $remarks',
          applicationId: current.applicationId,
          departmentId: current.departmentId,
          isRead: false,
          createdAt: Timestamp.now(),
        ),
      );

      notifyListeners();
    }
  }

  /// Add Officer (System Admin)
  void addOfficer(UserModel officer) {
    officers.insert(0, officer);
    notifyListeners();
  }

  /// Update Officer (System Admin)
  void updateOfficer(UserModel officer) {
    final index = officers.indexWhere((o) => o.userId == officer.userId);
    if (index != -1) {
      officers[index] = officer;
      notifyListeners();
    }
  }

  /// Delete Officer (System Admin)
  void deleteOfficer(String userId) {
    officers.removeWhere((o) => o.userId == userId);
    notifyListeners();
  }

  /// Mark all notifications read
  void markAllNotificationsAsRead() {
    notifications = notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  /// Mark single notification read
  void markNotificationAsRead(String notifId) {
    final index = notifications.indexWhere((n) => n.notificationId == notifId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }
}
