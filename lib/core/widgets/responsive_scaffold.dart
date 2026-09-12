import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_avatar.dart';
import 'quick_role_bar.dart';

class NavigationItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final int? badgeCount;

  const NavigationItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.badgeCount,
  });
}

class ResponsiveScaffold extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final List<NavigationItem> items;
  final Widget body;
  final String title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final VoidCallback? onBack;
  final bool showBackButton;

  const ResponsiveScaffold({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.items,
    required this.body,
    required this.title,
    this.actions,
    this.floatingActionButton,
    this.onBack,
    this.showBackButton = false,
  });

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  bool _isSidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;
    final isTablet = width >= 700 && width < 1024;
    final isMobile = width < 700;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: isMobile
          ? Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, -2)),
                ],
                border: Border(top: BorderSide(color: AppColors.border, width: 1)),
              ),
              child: SafeArea(
                child: BottomNavigationBar(
                  currentIndex: widget.currentIndex.clamp(0, widget.items.length - 1),
                  onTap: widget.onIndexChanged,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: AppColors.surface,
                  selectedItemColor: AppColors.primary,
                  unselectedItemColor: AppColors.textMuted,
                  selectedLabelStyle: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700, fontSize: 11),
                  unselectedLabelStyle: AppTypography.labelSmall.copyWith(fontSize: 10),
                  elevation: 0,
                  items: widget.items
                      .map(
                        (item) => BottomNavigationBarItem(
                          icon: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(item.icon, size: 22),
                              if ((item.badgeCount ?? 0) > 0)
                                Positioned(
                                  right: -6,
                                  top: -3,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: AppColors.danger,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                                    child: Text(
                                      '${item.badgeCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          activeIcon: Icon(item.activeIcon ?? item.icon, size: 22),
                          label: item.label,
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          : null,
      body: Column(
        children: [
          // Top Demo Quick Role Bar
          const QuickRoleBar(),

          // Full-width Desktop/Tablet Header
          if (isDesktop || isTablet)
            _buildDesktopFullHeader(context, state),

          // Main Responsive Layout
          Expanded(
            child: Row(
              children: [
                // Desktop or Tablet Sidebar
                if (isDesktop || isTablet)
                  _buildSidebar(context, state, isDesktop: isDesktop),

                // Main Content Area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mobile Header
                      if (isMobile)
                        _buildTopHeaderMobile(context, state),

                      // Desktop / Tablet Page Title
                      if (isDesktop || isTablet)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.l,
                            vertical: AppSpacing.m,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                          ),
                          child: Row(
                            children: [
                              if (widget.showBackButton && widget.onBack != null) ...[
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 22),
                                  onPressed: widget.onBack,
                                  tooltip: 'Back',
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                ),
                                const SizedBox(width: AppSpacing.s),
                              ],
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: AppTypography.h2.copyWith(fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.actions != null) ...widget.actions!,
                            ],
                          ),
                        ),

                      Expanded(
                        child: SelectionArea(
                          child: widget.body,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeaderMobile(BuildContext context, AppStateProvider state) {
    Color roleBadgeColor = AppColors.primary;
    if (state.currentRole == UserRole.officer) {
      roleBadgeColor = const Color(0xFF059669);
    } else if (state.currentRole == UserRole.admin) {
      roleBadgeColor = const Color(0xFF7C3AED);
    }

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(color: Color(0x1F000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          if (widget.showBackButton && widget.onBack != null) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
              onPressed: widget.onBack,
              tooltip: 'Back',
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
            const SizedBox(width: AppSpacing.xs),
          ] else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/images/gov_logo.png',
                height: 28,
                width: 28,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.account_balance_rounded, color: Colors.white, size: 24),
              ),
            ),
            const SizedBox(width: AppSpacing.s),
          ],

          // Current Page Title
          Expanded(
            child: Text(
              widget.title,
              style: AppTypography.h3.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if (widget.actions != null) ...widget.actions!,
          const SizedBox(width: AppSpacing.xs),

          _buildMobileAvatar(state, roleBadgeColor),
        ],
      ),
    );
  }

  Widget _buildDesktopFullHeader(BuildContext context, AppStateProvider state) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(color: Color(0x1F000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Left: Government Logo & Title
          Image.asset(
            'assets/images/gov_logo.png',
            height: 38,
            width: 38,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Government Interoperability Hub',
                style: AppTypography.h3.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                'Government of Maharashtra',
                style: AppTypography.bodySmall.copyWith(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),

          // Center: Search Bar
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, size: 18, color: Colors.white70),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Search services, documents or reference IDs...',
                          hintStyle: AppTypography.bodySmall.copyWith(color: Colors.white60, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right: Notifications, Language, Profile
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications panel available in sidebar'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Notifications',
          ),
          const SizedBox(width: AppSpacing.s),

          // Language Selector Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.translate_rounded, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  state.currentLanguage,
                  style: AppTypography.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.m),

          // User Profile Chip
          _buildUserChip(state),
        ],
      ),
    );
  }

  Widget _buildMobileAvatar(AppStateProvider state, Color roleColor) {
    String name = 'Krisha Patel';
    if (state.currentRole == UserRole.officer) {
      name = state.currentOfficer?.fullName ?? 'Priya Desai';
    } else if (state.currentRole == UserRole.admin) {
      name = 'Vikram Sen';
    }

    return AppAvatar(
      name: name,
      radius: 16,
      backgroundColor: Colors.white.withValues(alpha: 0.25),
      textColor: Colors.white,
    );
  }

  Widget _buildUserChip(AppStateProvider state) {
    String name = 'Krisha Patel';
    String subtitle = 'Verified Citizen';
    Color avatarBg = AppColors.primaryAccent;

    if (state.currentRole == UserRole.officer) {
      name = state.currentOfficer?.fullName ?? 'Priya Desai';
      subtitle = 'Municipal Officer';
      avatarBg = const Color(0xFF059669);
    } else if (state.currentRole == UserRole.admin) {
      name = 'Vikram Sen';
      subtitle = 'System Administrator';
      avatarBg = const Color(0xFF7C3AED);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppAvatar(
            name: name,
            radius: 14,
            backgroundColor: avatarBg,
            textColor: Colors.white,
          ),
          const SizedBox(width: AppSpacing.s),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: AppTypography.labelBold.copyWith(fontSize: 12, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(fontSize: 10, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, AppStateProvider state, {required bool isDesktop}) {
    final effectiveCollapsed = _isSidebarCollapsed || !isDesktop;
    final width = effectiveCollapsed ? 76.0 : 250.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
              child: Row(
                mainAxisAlignment: effectiveCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                children: [
                  if (!effectiveCollapsed)
                    Text(
                      'NAVIGATION',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMuted,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  IconButton(
                    icon: Icon(
                      effectiveCollapsed ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSidebarCollapsed = !_isSidebarCollapsed;
                      });
                    },
                    tooltip: effectiveCollapsed ? 'Expand sidebar' : 'Collapse sidebar',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s, horizontal: AppSpacing.s),
              itemCount: widget.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = index == widget.currentIndex;

                return InkWell(
                  onTap: () => widget.onIndexChanged(index),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.symmetric(
                      horizontal: effectiveCollapsed ? AppSpacing.s : AppSpacing.m,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Row(
                      mainAxisAlignment: effectiveCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                              size: 20,
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                            ),
                            if ((item.badgeCount ?? 0) > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: AppColors.danger,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                                  child: Text(
                                    '${item.badgeCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (!effectiveCollapsed) ...[
                          const SizedBox(width: AppSpacing.m),
                          Expanded(
                            child: Text(
                              item.label,
                              style: AppTypography.labelBold.copyWith(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                          if ((item.badgeCount ?? 0) > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white.withValues(alpha: 0.25) : AppColors.dangerLight,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                              ),
                              child: Text(
                                '${item.badgeCount}',
                                style: AppTypography.labelSmall.copyWith(
                                  color: isSelected ? Colors.white : AppColors.danger,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Portal Identity Card
          if (!effectiveCollapsed)
            Container(
              margin: const EdgeInsets.all(AppSpacing.m),
              padding: const EdgeInsets.all(AppSpacing.m),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.infoBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified_user_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'Digital India Certified',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '256-bit TLS • Aadhaar e-KYC',
                    style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class SubViewScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback onBack;
  final List<Widget>? actions;

  const SubViewScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.onBack,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const QuickRoleBar(),

          // Dedicated Unified Header
          if (isMobile)
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(color: Color(0x1F000000), blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                    onPressed: onBack,
                    tooltip: 'Back',
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.h3.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (actions != null) ...actions!,
                  const SizedBox(width: AppSpacing.xs),
                ],
              ),
            )
          else
            Column(
              children: [
                // Full-width Header on Desktop
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(color: Color(0x1F000000), blurRadius: 8, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Left: Logo & Name
                      Image.asset(
                        'assets/images/gov_logo.png',
                        height: 38,
                        width: 38,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Government Interoperability Hub',
                            style: AppTypography.h3.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Government of Maharashtra',
                            style: AppTypography.bodySmall.copyWith(fontSize: 11, color: Colors.white70),
                          ),
                        ],
                      ),

                      // Middle: Search Bar
                      Expanded(
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 420),
                            height: 38,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search_rounded, size: 18, color: Colors.white70),
                                const SizedBox(width: AppSpacing.s),
                                Expanded(
                                  child: TextField(
                                    style: const TextStyle(color: Colors.white, fontSize: 13),
                                    decoration: InputDecoration(
                                      hintText: 'Search services, documents or reference IDs...',
                                      hintStyle: AppTypography.bodySmall.copyWith(color: Colors.white60, fontSize: 13),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Subview Page Title Area
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                    vertical: AppSpacing.m,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 22),
                        onPressed: onBack,
                        tooltip: 'Go Back',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: Text(
                          title,
                          style: AppTypography.h2.copyWith(fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (actions != null) ...actions!,
                    ],
                  ),
                ),
              ],
            ),

          Expanded(
            child: SelectionArea(
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
