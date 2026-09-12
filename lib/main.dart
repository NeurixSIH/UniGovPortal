import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/state/app_state_provider.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/quick_role_bar.dart';
import 'core/widgets/responsive_scaffold.dart';

// Auth Screens
import 'features/auth/admin_login_screen.dart';
import 'features/auth/citizen_login_screen.dart';
import 'features/auth/officer_login_screen.dart';

// Citizen Screens
import 'features/citizen/application_wizard/application_wizard_screen.dart';
import 'features/citizen/citizen_dashboard_screen.dart';
import 'features/citizen/documents/my_documents_screen.dart';
import 'features/citizen/history/application_history_screen.dart';
import 'features/citizen/profile/citizen_profile_screen.dart';
import 'features/citizen/service_catalog_screen.dart';
import 'features/citizen/service_details_screen.dart';
import 'features/citizen/tracking/application_tracking_screen.dart';
import 'features/citizen/tracking/certificate_viewer_screen.dart';
import 'features/citizen/tracking/info_required_screen.dart';
import 'features/citizen/tracking/rejection_screen.dart';

// Officer Screens
import 'features/officer/department_records_screen.dart';
import 'features/officer/officer_dashboard_screen.dart';
import 'features/officer/officer_queue_screen.dart';
import 'features/officer/officer_reports_screen.dart';
import 'features/officer/officer_review_screen.dart';
import 'features/officer/officer_settings_screen.dart';

// Admin Screens
import 'features/admin/admin_dashboard_screen.dart';
import 'features/admin/admin_departments_screen.dart';
import 'features/admin/admin_reports_screen.dart';
import 'features/admin/admin_settings_screen.dart';
import 'features/admin/officer_management_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ],
      child: const SetuApp(),
    ),
  );
}

class SetuApp extends StatelessWidget {
  const SetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Setu | Government of India Civic Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainShellScreen(),
    );
  }
}

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  // Navigation tabs for each role
  int _citizenNavIndex = 0;
  int _officerNavIndex = 0;
  int _adminNavIndex = 0;

  // Navigation history stacks for back navigation
  final List<int> _citizenNavHistory = [0];
  final List<int> _officerNavHistory = [0];
  final List<int> _adminNavHistory = [0];

  // Active sub-view states
  String? _activeServiceDetailsId;
  String? _activeWizardServiceId;
  String? _activeTrackingAppId;
  bool _isViewingCertificate = false;
  bool _isViewingRejection = false;
  bool _isResolvingInfoRequired = false;

  // Officer sub-view
  String? _activeOfficerReviewAppId;

  bool _canPopRoot(AppStateProvider state) {
    if (_isViewingCertificate ||
        _isViewingRejection ||
        _isResolvingInfoRequired ||
        _activeTrackingAppId != null ||
        _activeWizardServiceId != null ||
        _activeServiceDetailsId != null ||
        _activeOfficerReviewAppId != null) {
      return false;
    }
    if (state.currentRole == UserRole.citizen) {
      return _citizenNavIndex == 0 && _citizenNavHistory.length <= 1;
    } else if (state.currentRole == UserRole.officer) {
      return _officerNavIndex == 0 && _officerNavHistory.length <= 1;
    } else if (state.currentRole == UserRole.admin) {
      return _adminNavIndex == 0 && _adminNavHistory.length <= 1;
    }
    return true;
  }

  bool _handleBackNavigation(AppStateProvider state) {
    if (_isViewingCertificate) {
      setState(() => _isViewingCertificate = false);
      return true;
    }
    if (_isViewingRejection) {
      setState(() => _isViewingRejection = false);
      return true;
    }
    if (_isResolvingInfoRequired) {
      setState(() => _isResolvingInfoRequired = false);
      return true;
    }
    if (_activeTrackingAppId != null) {
      setState(() => _activeTrackingAppId = null);
      return true;
    }
    if (_activeWizardServiceId != null) {
      setState(() => _activeWizardServiceId = null);
      return true;
    }
    if (_activeServiceDetailsId != null) {
      setState(() => _activeServiceDetailsId = null);
      return true;
    }
    if (_activeOfficerReviewAppId != null) {
      setState(() => _activeOfficerReviewAppId = null);
      return true;
    }

    if (state.currentRole == UserRole.citizen) {
      if (_citizenNavHistory.length > 1) {
        setState(() {
          _citizenNavHistory.removeLast();
          _citizenNavIndex = _citizenNavHistory.last;
        });
        return true;
      } else if (_citizenNavIndex != 0) {
        setState(() {
          _citizenNavIndex = 0;
          _citizenNavHistory.clear();
          _citizenNavHistory.add(0);
        });
        return true;
      }
    } else if (state.currentRole == UserRole.officer) {
      if (_officerNavHistory.length > 1) {
        setState(() {
          _officerNavHistory.removeLast();
          _officerNavIndex = _officerNavHistory.last;
        });
        return true;
      } else if (_officerNavIndex != 0) {
        setState(() {
          _officerNavIndex = 0;
          _officerNavHistory.clear();
          _officerNavHistory.add(0);
        });
        return true;
      }
    } else if (state.currentRole == UserRole.admin) {
      if (_adminNavHistory.length > 1) {
        setState(() {
          _adminNavHistory.removeLast();
          _adminNavIndex = _adminNavHistory.last;
        });
        return true;
      } else if (_adminNavIndex != 0) {
        setState(() {
          _adminNavIndex = 0;
          _adminNavHistory.clear();
          _adminNavHistory.add(0);
        });
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();

    if (!state.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const QuickRoleBar(),
            Expanded(child: _buildLoginScreen(state)),
          ],
        ),
      );
    }

    Widget shell;
    switch (state.currentRole) {
      case UserRole.citizen:
        shell = _buildCitizenShell(state);
        break;
      case UserRole.officer:
        shell = _buildOfficerShell(state);
        break;
      case UserRole.admin:
        shell = _buildAdminShell(state);
        break;
    }

    return PopScope(
      canPop: _canPopRoot(state),
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        _handleBackNavigation(state);
      },
      child: shell,
    );
  }

  Widget _buildLoginScreen(AppStateProvider state) {
    switch (state.currentRole) {
      case UserRole.citizen:
        return CitizenLoginScreen(onLoginSuccess: () => setState(() {}));
      case UserRole.officer:
        return OfficerLoginScreen(onLoginSuccess: () => setState(() {}));
      case UserRole.admin:
        return AdminLoginScreen(onLoginSuccess: () => setState(() {}));
    }
  }

  // ==========================================
  // CITIZEN SHELL & SUB-VIEWS
  // ==========================================
  Widget _buildCitizenShell(AppStateProvider state) {
    // 1. Wizard Sub-view
    if (_activeWizardServiceId != null) {
      final srv = state.services.firstWhere(
        (s) => s.id == _activeWizardServiceId,
        orElse: () => state.services.first,
      );
      return SubViewScaffold(
        title: 'Application Form: ${srv.name}',
        onBack: () => _handleBackNavigation(state),
        body: ApplicationWizardScreen(
          service: srv,
          onCancel: () => _handleBackNavigation(state),
          onSubmittedSuccess: (appId) {
            setState(() {
              _activeWizardServiceId = null;
              _activeTrackingAppId = appId;
            });
          },
        ),
      );
    }

    // 2. Service Details Sub-view
    if (_activeServiceDetailsId != null) {
      final srv = state.services.firstWhere(
        (s) => s.id == _activeServiceDetailsId,
        orElse: () => state.services.first,
      );
      return SubViewScaffold(
        title: srv.name,
        onBack: () => _handleBackNavigation(state),
        body: ServiceDetailsScreen(
          service: srv,
          onBack: () => _handleBackNavigation(state),
          onApply: () {
            setState(() {
              _activeWizardServiceId = srv.id;
              _activeServiceDetailsId = null;
            });
          },
        ),
      );
    }

    // 3. Application Tracking / Resolving / Certificate / Rejection Sub-views
    if (_activeTrackingAppId != null) {
      final app = state.applications.firstWhere(
        (a) => a.id == _activeTrackingAppId,
        orElse: () => state.applications.first,
      );

      Widget subView;
      String subTitle;
      if (_isViewingCertificate) {
        subTitle = 'Verified Digital Certificate';
        subView = CertificateViewerScreen(
          application: app,
          onBack: () => _handleBackNavigation(state),
        );
      } else if (_isViewingRejection) {
        subTitle = 'Review Grounds Dossier';
        subView = RejectionScreen(
          application: app,
          onBack: () => _handleBackNavigation(state),
          onApplyAgain: () {
            setState(() {
              _isViewingRejection = false;
              _activeTrackingAppId = null;
              _activeWizardServiceId = app.serviceId;
            });
          },
          onViewDossier: () => _handleBackNavigation(state),
        );
      } else if (_isResolvingInfoRequired) {
        subTitle = 'Clarification & Deficiencies';
        subView = InfoRequiredScreen(
          application: app,
          onBack: () => _handleBackNavigation(state),
          onResolved: () => _handleBackNavigation(state),
        );
      } else {
        subTitle = 'Tracking Application ${app.id}';
        subView = ApplicationTrackingScreen(
          application: app,
          onBack: () => _handleBackNavigation(state),
          onResolveRequired: () => setState(() => _isResolvingInfoRequired = true),
          onViewCertificate: () => setState(() => _isViewingCertificate = true),
          onViewRejection: () => setState(() => _isViewingRejection = true),
        );
      }

      return SubViewScaffold(
        title: subTitle,
        onBack: () => _handleBackNavigation(state),
        body: subView,
      );
    }

    // Main Citizen Tabs
    final items = [
      const NavigationItem(
        label: 'Dashboard',
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard_rounded,
      ),
      const NavigationItem(
        label: 'Services Catalog',
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
      ),
      const NavigationItem(
        label: 'My Applications',
        icon: Icons.folder_open_outlined,
        activeIcon: Icons.folder_rounded,
      ),
      const NavigationItem(
        label: 'My Documents',
        icon: Icons.folder_shared_outlined,
        activeIcon: Icons.folder_shared_rounded,
      ),
      const NavigationItem(
        label: 'Profile & Privacy',
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
      ),
    ];

    Widget body;
    String title;
    switch (_citizenNavIndex) {
      case 0:
        title = 'Citizen Services Dashboard';
        body = CitizenDashboardScreen(
          onOpenApplication: (appId) => setState(() => _activeTrackingAppId = appId),
          onApplyService: (srvId) => setState(() => _activeWizardServiceId = srvId),
          onBrowseAllServices: () => setState(() {
            _citizenNavIndex = 1;
            if (_citizenNavHistory.isEmpty || _citizenNavHistory.last != 1) {
              _citizenNavHistory.add(1);
            }
          }),
          onViewAllApplications: () => setState(() {
            _citizenNavIndex = 2;
            if (_citizenNavHistory.isEmpty || _citizenNavHistory.last != 2) {
              _citizenNavHistory.add(2);
            }
          }),
          onOpenProfile: () => setState(() {
            _citizenNavIndex = 4;
            if (_citizenNavHistory.isEmpty || _citizenNavHistory.last != 4) {
              _citizenNavHistory.add(4);
            }
          }),
        );
        break;
      case 1:
        title = 'Public Service Catalog';
        body = ServiceCatalogScreen(
          onSelectService: (srvId) => setState(() => _activeServiceDetailsId = srvId),
          onApplyDirectly: (srvId) => setState(() => _activeWizardServiceId = srvId),
        );
        break;
      case 2:
        title = 'My Application History & Records';
        body = ApplicationHistoryScreen(
          onSelectApplication: (appId) => setState(() => _activeTrackingAppId = appId),
        );
        break;
      case 3:
        title = 'My Verified Documents';
        body = const MyDocumentsScreen();
        break;
      case 4:
      default:
        title = 'Citizen Demographic Profile';
        body = CitizenProfileScreen(
          onLogout: () => setState(() {
            _citizenNavIndex = 0;
            _citizenNavHistory.clear();
            _citizenNavHistory.add(0);
          }),
        );
        break;
    }

    return ResponsiveScaffold(
      currentIndex: _citizenNavIndex,
      showBackButton: _citizenNavIndex != 0 || _citizenNavHistory.length > 1,
      onBack: () => _handleBackNavigation(state),
      onIndexChanged: (idx) {
        if (_citizenNavIndex == idx) return;
        setState(() {
          _citizenNavIndex = idx;
          if (_citizenNavHistory.isEmpty || _citizenNavHistory.last != idx) {
            _citizenNavHistory.add(idx);
          }
          _activeServiceDetailsId = null;
          _activeWizardServiceId = null;
          _activeTrackingAppId = null;
          _isViewingCertificate = false;
          _isViewingRejection = false;
          _isResolvingInfoRequired = false;
        });
      },
      items: items,
      title: title,
      body: body,
    );
  }

  // ==========================================
  // OFFICER SHELL & SUB-VIEWS
  // ==========================================
  Widget _buildOfficerShell(AppStateProvider state) {
    if (_activeOfficerReviewAppId != null) {
      final app = state.applications.firstWhere(
        (a) => a.id == _activeOfficerReviewAppId,
        orElse: () => state.applications.first,
      );

      return SubViewScaffold(
        title: 'Scrutiny Case: ${app.id}',
        onBack: () => _handleBackNavigation(state),
        body: OfficerReviewScreen(
          application: app,
          onBack: () => _handleBackNavigation(state),
          onActionCompleted: () => setState(() => _activeOfficerReviewAppId = null),
        ),
      );
    }

    final items = [
      const NavigationItem(
        label: 'Dashboard',
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard_rounded,
      ),
      const NavigationItem(
        label: 'Scrutiny Queue',
        icon: Icons.format_list_bulleted_rounded,
        activeIcon: Icons.format_list_bulleted_rounded,
      ),
      const NavigationItem(
        label: 'Dept Records',
        icon: Icons.account_balance_outlined,
        activeIcon: Icons.account_balance_rounded,
      ),
      const NavigationItem(
        label: 'Reports',
        icon: Icons.analytics_outlined,
        activeIcon: Icons.analytics_rounded,
      ),
      const NavigationItem(
        label: 'Settings',
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings_rounded,
      ),
    ];

    Widget body;
    String title;
    switch (_officerNavIndex) {
      case 0:
        title = 'Officer Workstation Overview';
        body = OfficerDashboardScreen(
          onOpenQueue: () => setState(() {
            _officerNavIndex = 1;
            if (_officerNavHistory.isEmpty || _officerNavHistory.last != 1) {
              _officerNavHistory.add(1);
            }
          }),
          onReviewApplication: (appId) => setState(() => _activeOfficerReviewAppId = appId),
        );
        break;
      case 1:
        title = 'Statutory Application Queue';
        body = OfficerQueueScreen(
          onReviewApplication: (appId) => setState(() => _activeOfficerReviewAppId = appId),
        );
        break;
      case 2:
        title = 'Interoperable Department Records';
        body = const DepartmentRecordsScreen();
        break;
      case 3:
        title = 'Officer Performance & Analytics';
        body = const OfficerReportsScreen();
        break;
      case 4:
      default:
        title = 'Workstation Settings';
        body = OfficerSettingsScreen(
          onLogout: () => setState(() {
            _officerNavIndex = 0;
            _officerNavHistory.clear();
            _officerNavHistory.add(0);
          }),
        );
        break;
    }

    return ResponsiveScaffold(
      currentIndex: _officerNavIndex,
      showBackButton: _officerNavIndex != 0 || _officerNavHistory.length > 1,
      onBack: () => _handleBackNavigation(state),
      onIndexChanged: (idx) {
        if (_officerNavIndex == idx) return;
        setState(() {
          _officerNavIndex = idx;
          if (_officerNavHistory.isEmpty || _officerNavHistory.last != idx) {
            _officerNavHistory.add(idx);
          }
          _activeOfficerReviewAppId = null;
        });
      },
      items: items,
      title: title,
      body: body,
    );
  }

  // ==========================================
  // ADMIN SHELL & SUB-VIEWS
  // ==========================================
  Widget _buildAdminShell(AppStateProvider state) {
    final items = [
      const NavigationItem(
        label: 'Admin Overview',
        icon: Icons.analytics_outlined,
        activeIcon: Icons.analytics_rounded,
      ),
      const NavigationItem(
        label: 'Officers Directory',
        icon: Icons.people_alt_outlined,
        activeIcon: Icons.people_alt_rounded,
      ),
      const NavigationItem(
        label: 'Departments',
        icon: Icons.apartment_outlined,
        activeIcon: Icons.apartment_rounded,
      ),
      const NavigationItem(
        label: 'System Reports',
        icon: Icons.assessment_outlined,
        activeIcon: Icons.assessment_rounded,
      ),
      const NavigationItem(
        label: 'Admin Settings',
        icon: Icons.admin_panel_settings_outlined,
        activeIcon: Icons.admin_panel_settings_rounded,
      ),
    ];

    Widget body;
    String title;
    switch (_adminNavIndex) {
      case 0:
        title = 'System Administration Console';
        body = AdminDashboardScreen(
          onManageOfficers: () => setState(() {
            _adminNavIndex = 1;
            if (_adminNavHistory.isEmpty || _adminNavHistory.last != 1) {
              _adminNavHistory.add(1);
            }
          }),
        );
        break;
      case 1:
        title = 'Department Officers Directory';
        body = const OfficerManagementScreen();
        break;
      case 2:
        title = 'Department Management Registry';
        body = const AdminDepartmentsScreen();
        break;
      case 3:
        title = 'System Oversight & Analytics Reports';
        body = const AdminReportsScreen();
        break;
      case 4:
      default:
        title = 'System Administration Settings';
        body = AdminSettingsScreen(
          onLogout: () => setState(() {
            _adminNavIndex = 0;
            _adminNavHistory.clear();
            _adminNavHistory.add(0);
          }),
        );
        break;
    }

    return ResponsiveScaffold(
      currentIndex: _adminNavIndex,
      showBackButton: _adminNavIndex != 0 || _adminNavHistory.length > 1,
      onBack: () => _handleBackNavigation(state),
      onIndexChanged: (idx) {
        if (_adminNavIndex == idx) return;
        setState(() {
          _adminNavIndex = idx;
          if (_adminNavHistory.isEmpty || _adminNavHistory.last != idx) {
            _adminNavHistory.add(idx);
          }
        });
      },
      items: items,
      title: title,
      body: body,
    );
  }
}
