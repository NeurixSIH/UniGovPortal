import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/data/demo_data.dart';
import '../../core/models/application_model.dart';
import '../../core/models/application_status.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_avatar.dart';
import '../../core/widgets/next_action_banner.dart';
import '../../core/widgets/status_badge.dart';

class CitizenDashboardScreen extends StatelessWidget {
  final ValueChanged<String> onOpenApplication;
  final ValueChanged<String> onApplyService;
  final VoidCallback onBrowseAllServices;
  final VoidCallback onViewAllApplications;

  const CitizenDashboardScreen({
    super.key,
    required this.onOpenApplication,
    required this.onApplyService,
    required this.onBrowseAllServices,
    required this.onViewAllApplications,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final apps = state.applications;
    final popularServices = state.services.where((s) => s.isPopular).take(4).toList();

    // Compute stats
    final pendingCount = apps
        .where((a) => a.status == AppStatus.submitted || a.status == AppStatus.documentsUnderVerification || a.status == AppStatus.resubmitted)
        .length;
    final underReviewCount = apps.where((a) => a.status == AppStatus.underReview).length;
    final approvedCount = apps.where((a) => a.status == AppStatus.approved || a.status == AppStatus.certificateGenerated || a.status == AppStatus.completed).length;
    final rejectedCount = apps.where((a) => a.status == AppStatus.rejected).length;

    // Action required application (if any)
    ApplicationModel? urgentApp;
    try {
      urgentApp = apps.firstWhere((a) => a.status == AppStatus.informationRequired);
    } catch (_) {
      urgentApp = null;
    }

    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppSpacing.m : AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Search Hero Card
          _buildHeroCard(context, state),
          const SizedBox(height: AppSpacing.l),

          // Action Required Prominent Section (C-02 requirement)
          if (urgentApp != null) ...[
            Text('ACTION REQUIRED IMMEDIATELY', style: AppTypography.labelBold.copyWith(color: AppColors.danger)),
            const SizedBox(height: AppSpacing.s),
            NextActionBanner(
              application: urgentApp,
              isProminent: true,
              onActionPressed: () => onOpenApplication(urgentApp!.id),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Stats Metrics Grid
          Text('Application Overview', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.m),
          _buildStatsGrid(
            pendingCount: pendingCount,
            underReviewCount: underReviewCount,
            approvedCount: approvedCount,
            rejectedCount: rejectedCount,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Quick Actions Row
          _buildQuickActions(context),
          const SizedBox(height: AppSpacing.xl),

          // Two-column layout for Recent Applications and Popular Services
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildRecentApplications(context, apps),
                    ),
                    const SizedBox(width: AppSpacing.l),
                    Expanded(
                      flex: 4,
                      child: _buildPopularServices(context, popularServices),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildRecentApplications(context, apps),
                    const SizedBox(height: AppSpacing.xl),
                    _buildPopularServices(context, popularServices),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, AppStateProvider state) {
    final name = DemoData.citizenProfile['fullName'] ?? 'Krisha Patel';
    final citizenId = 'Citizen ID: MH123456789';
    String greeting = 'Good Morning,';
    if (state.currentLanguage == 'Hindi') {
      greeting = 'शुभ प्रभात,';
    } else if (state.currentLanguage == 'Gujarati') {
      greeting = 'શુભ સવાર,';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusXl)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(
                name: name,
                radius: 24,
                backgroundColor: Colors.white.withValues(alpha: 0.25),
                textColor: Colors.white,
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                    ),
                    Text(
                      name,
                      style: AppTypography.h3.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      citizenId,
                      style: AppTypography.bodySmall.copyWith(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: AppSpacing.m),

          // Profile Completion Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_rounded, color: AppColors.success, size: 20),
                      const SizedBox(width: AppSpacing.s),
                      Flexible(
                        child: Text(
                          'Profile Completion',
                          style: AppTypography.labelBold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Text('80%', style: AppTypography.labelBold.copyWith(color: AppColors.primaryAccent)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid({
    required int pendingCount,
    required int underReviewCount,
    required int approvedCount,
    required int rejectedCount,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        if (isMobile) {
          // Use a Wrap for mobile to prevent aspect ratio issues
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _StatCard(title: 'Pending Verification', count: pendingCount, icon: Icons.pending_actions_rounded, color: AppColors.info, bg: AppColors.infoLight)),
                  const SizedBox(width: AppSpacing.s),
                  Expanded(child: _StatCard(title: 'Under Officer Review', count: underReviewCount, icon: Icons.hourglass_top_rounded, color: const Color(0xFF6366F1), bg: const Color(0xFFEEF2FF))),
                ],
              ),
              const SizedBox(height: AppSpacing.s),
              Row(
                children: [
                  Expanded(child: _StatCard(title: 'Approved / Issued', count: approvedCount, icon: Icons.verified_rounded, color: AppColors.success, bg: AppColors.successLight)),
                  const SizedBox(width: AppSpacing.s),
                  Expanded(child: _StatCard(title: 'Rejected / Returned', count: rejectedCount, icon: Icons.cancel_outlined, color: AppColors.danger, bg: AppColors.dangerLight)),
                ],
              ),
            ],
          );
        }

        return GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: AppSpacing.m,
          mainAxisSpacing: AppSpacing.m,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.0,
          children: [
            _StatCard(
              title: 'Pending Verification',
              count: pendingCount,
              icon: Icons.pending_actions_rounded,
              color: AppColors.info,
              bg: AppColors.infoLight,
            ),
            _StatCard(
              title: 'Under Officer Review',
              count: underReviewCount,
              icon: Icons.hourglass_top_rounded,
              color: const Color(0xFF6366F1),
              bg: const Color(0xFFEEF2FF),
            ),
            _StatCard(
              title: 'Approved / Issued',
              count: approvedCount,
              icon: Icons.verified_rounded,
              color: AppColors.success,
              bg: AppColors.successLight,
            ),
            _StatCard(
              title: 'Rejected / Returned',
              count: rejectedCount,
              icon: Icons.cancel_outlined,
              color: AppColors.danger,
              bg: AppColors.dangerLight,
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quick Actions', style: AppTypography.h3),
                const Icon(Icons.settings_suggest_rounded, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _QuickActionBtn(
                    icon: Icons.add_business_rounded,
                    label: 'Apply for\nService',
                    onTap: onBrowseAllServices,
                    color: AppColors.secondary,
                    bgColor: AppColors.secondaryLight,
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: _QuickActionBtn(
                    icon: Icons.upload_file_rounded,
                    label: 'Upload\nDocument',
                    onTap: onViewAllApplications,
                    color: const Color(0xFF6366F1),
                    bgColor: const Color(0xFFEEF2FF),
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: _QuickActionBtn(
                    icon: Icons.track_changes_rounded,
                    label: 'Track\nApplication',
                    onTap: onViewAllApplications,
                    color: const Color(0xFFD97706),
                    bgColor: const Color(0xFFFFFBEB),
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: _QuickActionBtn(
                    icon: Icons.admin_panel_settings_rounded,
                    label: 'Manage\nConsent',
                    onTap: () {},
                    color: const Color(0xFF059669),
                    bgColor: const Color(0xFFECFDF5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentApplications(BuildContext context, List<ApplicationModel> apps) {
    final recent = apps.take(4).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('Recent Applications', style: AppTypography.h3),
                ),
                TextButton(
                  onPressed: onViewAllApplications,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            if (recent.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Center(
                  child: Text('No applications submitted yet.', style: AppTypography.bodyMedium),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recent.length,
                separatorBuilder: (_, __) => const Divider(height: AppSpacing.l),
                itemBuilder: (context, index) {
                  final app = recent[index];
                  final formattedDate = DateFormat('dd MMM yyyy').format(app.submissionDate);

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 450;
                      return InkWell(
                        onTap: () => onOpenApplication(app.id),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: isCompact
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: AppColors.surfaceSubtle,
                                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                          ),
                                          child: Icon(app.status.icon, color: app.status.color, size: 16),
                                        ),
                                        const SizedBox(width: AppSpacing.s),
                                        Expanded(
                                          child: Text(
                                            app.id,
                                            style: AppTypography.code.copyWith(
                                              fontSize: 12,
                                              color: AppColors.primaryAccent,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        StatusBadge(status: app.status, isCompact: true),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            app.serviceName,
                                            style: AppTypography.labelBold.copyWith(fontSize: 13),
                                          ),
                                          Text(
                                            '${app.departmentName} • $formattedDate',
                                            style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceSubtle,
                                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                      ),
                                      child: Icon(app.status.icon, color: app.status.color, size: 22),
                                    ),
                                    const SizedBox(width: AppSpacing.m),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            spacing: AppSpacing.s,
                                            children: [
                                              Text(
                                                app.id,
                                                style: AppTypography.code.copyWith(
                                                  fontSize: 12,
                                                  color: AppColors.primaryAccent,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                '• $formattedDate',
                                                style: AppTypography.bodySmall,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            app.serviceName,
                                            style: AppTypography.labelBold,
                                          ),
                                          Text(
                                            app.departmentName,
                                            style: AppTypography.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.m),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        StatusBadge(status: app.status, isCompact: true),
                                        const SizedBox(height: 4),
                                        const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textLight),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularServices(BuildContext context, List<dynamic> popularServices) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('Popular Services', style: AppTypography.h3),
                ),
                TextButton(
                  onPressed: onBrowseAllServices,
                  child: const Text('Catalog'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: popularServices.length,
              separatorBuilder: (_, __) => const Divider(height: AppSpacing.m),
              itemBuilder: (context, index) {
                final srv = popularServices[index];

                return InkWell(
                  onTap: () => onApplyService(srv.id),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Icon(srv.icon, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                srv.name,
                                style: AppTypography.labelBold.copyWith(fontSize: 13),
                                // Removed maxLines to allow wrapping
                              ),
                              Text(
                                '${srv.departmentName} • ${srv.processingTimeDays} Days',
                                style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                // Removed maxLines to allow wrapping
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final Color bg;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.s),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$count',
                    style: AppTypography.h2.copyWith(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                  Text(
                    title,
                    style: AppTypography.bodySmall.copyWith(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color bgColor;

  const _QuickActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelBold.copyWith(fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
