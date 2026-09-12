import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'data/demo_repository.dart';
import 'widgets/smartphone_frame.dart';

// Citizen Screens
import 'screens/citizen/landing_screen.dart';
import 'screens/citizen/login_screen.dart';
import 'screens/citizen/citizen_home_dashboard.dart';
import 'screens/citizen/profile_screen.dart';
import 'screens/citizen/update_personal_details_screen.dart';
import 'screens/citizen/consent_management_screen.dart';
import 'screens/citizen/live_sync_dashboard.dart';
import 'screens/citizen/service_catalog_screen.dart';
import 'screens/citizen/service_details_eligibility_screen.dart';
import 'screens/citizen/dynamic_application_form_screen.dart';
import 'screens/citizen/my_documents_screen.dart';
import 'screens/citizen/application_status_tracker_screen.dart';
import 'screens/citizen/application_history_screen.dart';
import 'screens/citizen/notifications_screen.dart';
import 'screens/citizen/sync_audit_log_screen.dart';

// Department Admin Screens
import 'screens/dept_admin/dept_admin_login_screen.dart';
import 'screens/dept_admin/dept_admin_dashboard.dart';
import 'screens/dept_admin/application_review_screen.dart';

// System Admin Screens
import 'screens/system_admin/system_admin_login_screen.dart';
import 'screens/system_admin/system_admin_home_screen.dart';
import 'screens/system_admin/system_admin_profile_and_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Graceful fallback for offline / web preview testing
  }
  runApp(const UniGovApp());
}

class UniGovApp extends StatelessWidget {
  const UniGovApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maharashtra Interoperability Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MasterAppShell(),
    );
  }
}

class MasterAppShell extends StatefulWidget {
  const MasterAppShell({super.key});

  @override
  State<MasterAppShell> createState() => _MasterAppShellState();
}

class _MasterAppShellState extends State<MasterAppShell> {
  final DemoRepository _repo = DemoRepository();

  // Navigation state
  String _currentRoute = 'citizen_home';
  String _selectedServiceId = 'SRV_INCOME_CERT';
  String _selectedAppId = 'APP20260904';
  int _citizenBottomNavIndex = 0;
  int _deptBottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (_repo.activeRole == 'departmentAdmin' && !_currentRoute.startsWith('dept_')) {
      setState(() {
        _currentRoute = 'dept_dashboard';
      });
    } else if (_repo.activeRole == 'systemAdmin' && !_currentRoute.startsWith('system_')) {
      setState(() {
        _currentRoute = 'system_home';
      });
    } else if (_repo.activeRole == 'citizen' &&
        (_currentRoute.startsWith('dept_') || _currentRoute.startsWith('system_'))) {
      setState(() {
        _currentRoute = 'citizen_home';
      });
    }
  }

  void _navigateTo(String route, {dynamic arguments}) {
    setState(() {
      _currentRoute = route;
      if (route == 'service_detail' && arguments is String) {
        _selectedServiceId = arguments;
      }
      if ((route == 'tracker' || route == 'dept_review') && arguments is String) {
        _selectedAppId = arguments;
      }
      // Sync bottom nav index if matching tab
      if (route == 'citizen_home') _citizenBottomNavIndex = 0;
      if (route == 'services') _citizenBottomNavIndex = 1;
      if (route == 'applications') _citizenBottomNavIndex = 2;
      if (route == 'documents') _citizenBottomNavIndex = 3;
      if (route == 'profile') _citizenBottomNavIndex = 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _repo,
      builder: (context, _) {
        return SmartphoneFrame(
          activeScreenTitle: _getScreenTitle(_currentRoute),
          onNavigateTo: (screenKey) => _navigateTo(screenKey),
          child: Column(
            children: [
              // Screen Body
              Expanded(child: _buildCurrentScreen()),

              // Bottom Navigation Bar
              if (_shouldShowBottomNav()) _buildBottomNavigationBar(),
            ],
          ),
        );
      },
    );
  }

  bool _shouldShowBottomNav() {
    // Hide bottom nav on landing, login, forms, and deep review
    if (_currentRoute == 'landing' ||
        _currentRoute == 'login' ||
        _currentRoute == 'dept_login' ||
        _currentRoute == 'system_login' ||
        _currentRoute == 'dynamic_form') {
      return false;
    }
    return true;
  }

  Widget _buildBottomNavigationBar() {
    if (_repo.activeRole == 'citizen') {
      return NavigationBar(
        selectedIndex: _citizenBottomNavIndex,
        height: 62,
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.primaryBlue.withAlpha(25),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppTheme.primaryBlue),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view, color: AppTheme.primaryBlue),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: AppTheme.primaryBlue),
            label: 'Applications',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder, color: AppTheme.primaryBlue),
            label: 'Documents',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppTheme.primaryBlue),
            label: 'Profile',
          ),
        ],
        onDestinationSelected: (idx) {
          setState(() {
            _citizenBottomNavIndex = idx;
            switch (idx) {
              case 0:
                _currentRoute = 'citizen_home';
                break;
              case 1:
                _currentRoute = 'services';
                break;
              case 2:
                _currentRoute = 'applications';
                break;
              case 3:
                _currentRoute = 'documents';
                break;
              case 4:
                _currentRoute = 'profile';
                break;
            }
          });
        },
      );
    } else if (_repo.activeRole == 'departmentAdmin') {
      return NavigationBar(
        selectedIndex: _deptBottomNavIndex,
        height: 62,
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.primaryBlue.withAlpha(25),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppTheme.primaryBlue),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.rate_review_outlined),
            selectedIcon: Icon(Icons.rate_review, color: AppTheme.primaryBlue),
            label: 'Review',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_shared_outlined),
            selectedIcon: Icon(Icons.folder_shared, color: AppTheme.primaryBlue),
            label: 'Documents',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge, color: AppTheme.primaryBlue),
            label: 'Officer',
          ),
        ],
        onDestinationSelected: (idx) {
          setState(() {
            _deptBottomNavIndex = idx;
            switch (idx) {
              case 0:
                _currentRoute = 'dept_dashboard';
                break;
              case 1:
                _currentRoute = 'dept_review';
                break;
              case 2:
                _currentRoute = 'documents';
                break;
              case 3:
                _currentRoute = 'dept_dashboard';
                break;
            }
          });
        },
      );
    } else {
      // System Admin Navigation
      return NavigationBar(
        selectedIndex: _currentRoute == 'system_settings' ? 1 : 0,
        height: 62,
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.primaryBlue.withAlpha(25),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people, color: AppTheme.primaryBlue),
            label: 'Officers Directory',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: AppTheme.primaryBlue),
            label: 'Settings',
          ),
        ],
        onDestinationSelected: (idx) {
          setState(() {
            if (idx == 0) _currentRoute = 'system_home';
            if (idx == 1) _currentRoute = 'system_settings';
          });
        },
      );
    }
  }

  Widget _buildCurrentScreen() {
    switch (_currentRoute) {
      // 1. Landing Screen
      case 'landing':
        return LandingScreen(
          onGetStarted: () => _navigateTo('login'),
          onLogin: () => _navigateTo('login'),
        );

      // 2. Login Screen
      case 'login':
        return LoginScreen(
          onLoginSuccess: () => _navigateTo('citizen_home'),
          onBack: () => _navigateTo('landing'),
        );

      // 3. Citizen Home / Dashboard
      case 'citizen_home':
        return CitizenHomeDashboard(onNavigate: _navigateTo);

      // 4. My Profile
      case 'profile':
        return ProfileScreen(
          onEditProfile: () => _navigateTo('update_profile'),
          onBack: () => _navigateTo('citizen_home'),
        );

      // 5. Update Personal Details
      case 'update_profile':
        return UpdatePersonalDetailsScreen(
          onSaved: () => _navigateTo('live_sync'),
          onCancel: () => _navigateTo('profile'),
        );

      // 6. Consent Management
      case 'consent':
        return ConsentManagementScreen(
          onBack: () => _navigateTo('citizen_home'),
          onViewAuditLog: () => _navigateTo('audit_log'),
        );

      // 7. Live Synchronization Dashboard
      case 'live_sync':
        return LiveSyncDashboard(
          onBack: () => _navigateTo('citizen_home'),
          onViewAuditLog: () => _navigateTo('audit_log'),
        );

      // 8. Service Catalog
      case 'services':
        return ServiceCatalogScreen(
          onSelectService: (id) => _navigateTo('service_detail', arguments: id),
          onBack: () => _navigateTo('citizen_home'),
        );

      // 9. Service Details + Auto Eligibility
      case 'service_detail':
        return ServiceDetailsEligibilityScreen(
          serviceId: _selectedServiceId,
          onContinue: () => _navigateTo('dynamic_form'),
          onBack: () => _navigateTo('services'),
        );

      // 10. Dynamic Application Form
      case 'dynamic_form':
        return DynamicApplicationFormScreen(
          onSubmitSuccess: () => _navigateTo('tracker', arguments: 'APP20260904'),
          onBack: () => _navigateTo('service_detail', arguments: _selectedServiceId),
        );

      // 11. My Documents
      case 'documents':
        return MyDocumentsScreen(
          onBack: () => _navigateTo('citizen_home'),
        );

      // 12. Application Status Tracker
      case 'tracker':
        return ApplicationStatusTrackerScreen(
          applicationId: _selectedAppId,
          onBack: () => _navigateTo('applications'),
        );

      // 13. Application History
      case 'applications':
        return ApplicationHistoryScreen(
          onSelectApplication: (id) => _navigateTo('tracker', arguments: id),
          onBack: () => _navigateTo('citizen_home'),
        );

      // 14. Notifications
      case 'notifications':
        return NotificationsScreen(
          onBack: () => _navigateTo('citizen_home'),
          onNavigate: _navigateTo,
        );

      // 15. Sync Audit Log
      case 'audit_log':
        return SyncAuditLogScreen(
          onBack: () => _navigateTo('live_sync'),
        );

      // 16. Department Admin Login
      case 'dept_login':
        return DeptAdminLoginScreen(
          onLoginSuccess: () => _navigateTo('dept_dashboard'),
          onBack: () => _navigateTo('landing'),
        );

      // 17. Department Admin Dashboard
      case 'dept_dashboard':
        return DeptAdminDashboard(onNavigate: _navigateTo);

      // 18. Application Review
      case 'dept_review':
        return ApplicationReviewScreen(
          applicationId: _selectedAppId,
          onBack: () => _navigateTo('dept_dashboard'),
        );

      // 19. System Admin Login
      case 'system_login':
        return SystemAdminLoginScreen(
          onLoginSuccess: () => _navigateTo('system_home'),
          onBack: () => _navigateTo('landing'),
        );

      // 20-23. System Admin Home & Officers Management
      case 'system_home':
        return SystemAdminHomeScreen(onNavigate: _navigateTo);

      // 24-26. System Admin Profile & Settings
      case 'system_settings':
        return SystemAdminProfileAndSettings(
          onLogout: () => _navigateTo('system_login'),
          onBack: () => _navigateTo('system_home'),
        );

      default:
        return CitizenHomeDashboard(onNavigate: _navigateTo);
    }
  }

  String _getScreenTitle(String route) {
    switch (route) {
      case 'landing':
        return 'Landing Screen';
      case 'login':
        return 'Citizen Login';
      case 'citizen_home':
        return 'Citizen Dashboard';
      case 'profile':
        return 'My Profile';
      case 'update_profile':
        return 'Update Details';
      case 'consent':
        return 'Consent Hub';
      case 'live_sync':
        return 'Live Sync Hub';
      case 'services':
        return 'Service Catalog';
      case 'service_detail':
        return 'Service Details';
      case 'dynamic_form':
        return 'Apply Service';
      case 'documents':
        return 'My Documents';
      case 'tracker':
        return 'Status Tracker';
      case 'applications':
        return 'Application History';
      case 'notifications':
        return 'Notification Center';
      case 'audit_log':
        return 'Sync Audit Log';
      case 'dept_login':
        return 'Dept Admin Login';
      case 'dept_dashboard':
        return 'Dept Dashboard';
      case 'dept_review':
        return 'Application Review';
      case 'system_login':
        return 'System Admin Login';
      case 'system_home':
        return 'System Admin Console';
      case 'system_settings':
        return 'Admin Settings';
      default:
        return 'UniGov Portal';
    }
  }
}
