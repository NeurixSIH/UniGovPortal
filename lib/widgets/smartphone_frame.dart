import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/demo_repository.dart';

class SmartphoneFrame extends StatefulWidget {
  final Widget child;
  final String? activeScreenTitle;
  final Function(String screenKey)? onNavigateTo;

  const SmartphoneFrame({
    super.key,
    required this.child,
    this.activeScreenTitle,
    this.onNavigateTo,
  });

  @override
  State<SmartphoneFrame> createState() => _SmartphoneFrameState();
}

class _SmartphoneFrameState extends State<SmartphoneFrame> {
  final DemoRepository _repo = DemoRepository();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isWide = screenSize.width > 600;

    // Mobile View (Native smartphone experience on physical devices like Motorola, iPhone, etc.)
    if (!isWide) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              // Mobile compact role switcher bar
              _buildMobileTopBar(),

              // Full native screen body
              Expanded(child: widget.child),
            ],
          ),
        ),
      );
    }

    // Desktop / Presentation View (Realistic smartphone showroom frame with notch & status bar)
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark slate showroom backdrop for wow factor
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // Top Presentation Bar (Allows switching roles & jump to screens easily in hackathon demo)
              _buildTopPresentationBar(),

              // Smartphone Device Body
              Expanded(
                child: Center(
                  child: Container(
                    width: 412,
                    constraints: const BoxConstraints(maxWidth: 430),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundLight,
                      borderRadius: BorderRadius.circular(44),
                      border: Border.all(color: const Color(0xFF334155), width: 7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(120),
                          blurRadius: 36,
                          offset: const Offset(0, 16),
                        ),
                        BoxShadow(
                          color: AppTheme.primaryBlue.withAlpha(40),
                          blurRadius: 60,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        // Smartphone Status Bar (9:41, Notch / Camera, Icons)
                        _buildSmartphoneStatusBar(),

                        // Screen Content Area
                        Expanded(child: widget.child),

                        // Smartphone Bottom Home Indicator
                        _buildBottomHomeIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileTopBar() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(bottom: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield, size: 14, color: AppTheme.primaryBlue),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Gov of Maharashtra Interoperability Hub',
              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AnimatedBuilder(
            animation: _repo,
            builder: (context, _) {
              return PopupMenuButton<String>(
                initialValue: _repo.activeRole,
                tooltip: 'Switch Persona',
                onSelected: (roleKey) {
                  _repo.setActiveRole(roleKey);
                  if (widget.onNavigateTo != null) {
                    if (roleKey == 'citizen') widget.onNavigateTo!('citizen_home');
                    if (roleKey == 'departmentAdmin') widget.onNavigateTo!('dept_dashboard');
                    if (roleKey == 'systemAdmin') widget.onNavigateTo!('system_home');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlueLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white38),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _roleLabel(_repo.activeRole),
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.arrow_drop_down, size: 16, color: Colors.white),
                    ],
                  ),
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'citizen',
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 16, color: AppTheme.primaryBlue),
                        SizedBox(width: 8),
                        Text('Citizen (Krisha Patel)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'departmentAdmin',
                    child: Row(
                      children: [
                        Icon(Icons.verified_user, size: 16, color: AppTheme.primaryBlue),
                        SizedBox(width: 8),
                        Text('Dept Admin (Sanjay Deshmukh)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'systemAdmin',
                    child: Row(
                      children: [
                        Icon(Icons.admin_panel_settings, size: 16, color: AppTheme.primaryBlue),
                        SizedBox(width: 8),
                        Text('System Admin (Aaditya Thackeray)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _roleLabel(String roleKey) {
    if (roleKey == 'departmentAdmin') return 'Dept Admin';
    if (roleKey == 'systemAdmin') return 'System Admin';
    return 'Citizen';
  }

  Widget _buildTopPresentationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(bottom: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        children: [
          // Maharashtra Emblem Badge
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield, size: 16, color: AppTheme.primaryBlue),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SIH26129 • Maharashtra Interoperability Hub',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Single Citizen Profile • Multi-Dept Live Sync',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                ),
              ],
            ),
          ),

          // Role Switcher Chips
          AnimatedBuilder(
            animation: _repo,
            builder: (context, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _roleChip('Citizen', 'citizen', Icons.person),
                  const SizedBox(width: 4),
                  _roleChip('Dept Admin', 'departmentAdmin', Icons.verified_user),
                  const SizedBox(width: 4),
                  _roleChip('System Admin', 'systemAdmin', Icons.admin_panel_settings),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _roleChip(String label, String roleKey, IconData icon) {
    final isSelected = _repo.activeRole == roleKey;
    return InkWell(
      onTap: () {
        _repo.setActiveRole(roleKey);
        if (widget.onNavigateTo != null) {
          if (roleKey == 'citizen') widget.onNavigateTo!('citizen_home');
          if (roleKey == 'departmentAdmin') widget.onNavigateTo!('dept_dashboard');
          if (roleKey == 'systemAdmin') widget.onNavigateTo!('system_home');
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlueLight : const Color(0xFF334155),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartphoneStatusBar() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time: 9:41
          const Text(
            '9:41',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              letterSpacing: -0.2,
            ),
          ),

          // Speaker / Camera Notch Capsule
          Container(
            width: 96,
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // Icons: Cellular, WiFi, Battery
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.signal_cellular_4_bar, size: 14, color: AppTheme.textPrimary),
              const SizedBox(width: 4),
              const Icon(Icons.wifi, size: 14, color: AppTheme.textPrimary),
              const SizedBox(width: 4),
              Container(
                width: 22,
                height: 11,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: AppTheme.textPrimary, width: 1),
                ),
                padding: const EdgeInsets.all(1.5),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.indiaGreen,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomHomeIndicator() {
    return Container(
      height: 18,
      color: Colors.white,
      alignment: Alignment.center,
      child: Container(
        width: 134,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFF94A3B8),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
