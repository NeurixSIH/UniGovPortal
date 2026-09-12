import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/models/application_status.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/status_badge.dart';

class OfficerDashboardScreen extends StatelessWidget {
  final VoidCallback onOpenQueue;
  final ValueChanged<String> onReviewApplication;

  const OfficerDashboardScreen({
    super.key,
    required this.onOpenQueue,
    required this.onReviewApplication,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final officer = state.currentOfficer;
    final allApps = state.applications;

    // Filter applications matching officer's department (or show all for demo flexibility)
    final deptApps = allApps;

    final totalCount = deptApps.length;
    final newCount = deptApps.where((a) => a.status == AppStatus.submitted).length;
    final pendingCount = deptApps.where((a) => a.status == AppStatus.underReview || a.status == AppStatus.documentsUnderVerification).length;
    final infoReqCount = deptApps.where((a) => a.status == AppStatus.informationRequired).length;
    final resubmittedCount = deptApps.where((a) => a.status == AppStatus.resubmitted).length;
    final approvedCount = deptApps.where((a) => a.status == AppStatus.approved || a.status == AppStatus.certificateGenerated || a.status == AppStatus.completed).length;
    final rejectedCount = deptApps.where((a) => a.status == AppStatus.rejected).length;

    // Active workload = submitted + underReview + resubmitted
    final workloadCount = newCount + pendingCount + resubmittedCount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Officer Welcome Hero
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              boxShadow: const [
                BoxShadow(color: Color(0x1F064E3B), blurRadius: 16, offset: Offset(0, 4)),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 650;
                final textColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(
                        'DEPARTMENT: ${officer?.departmentName.toUpperCase() ?? "MUNICIPAL CORPORATION"}',
                        style: AppTypography.labelSmall.copyWith(color: Colors.white, letterSpacing: 1.0),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      'Welcome, ${officer?.fullName ?? "Priya Desai"}',
                      style: AppTypography.h1.copyWith(color: Colors.white, fontSize: isNarrow ? 20 : 24),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Department: ${officer?.departmentName ?? "Municipal Corporation"} • $workloadCount active applications in queue.',
                      style: AppTypography.bodyMedium.copyWith(color: const Color(0xFFD1FAE5)),
                    ),
                  ],
                );

                final actionBtn = AppButton(
                  label: 'Open Queue ($workloadCount)',
                  variant: AppButtonVariant.secondary,
                  size: isNarrow ? AppButtonSize.medium : AppButtonSize.large,
                  leadingIcon: Icons.format_list_bulleted_rounded,
                  onPressed: onOpenQueue,
                );

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textColumn,
                      const SizedBox(height: AppSpacing.m),
                      actionBtn,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: textColumn),
                    const SizedBox(width: AppSpacing.m),
                    actionBtn,
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Workload Metrics Grid
          Text("Today's Caseload Statistics", style: AppTypography.h3),
          const SizedBox(height: AppSpacing.m),

          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 700;

              if (isNarrow) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _OfficerMetricCard(title: 'Total Applications', count: totalCount, icon: Icons.folder_copy_rounded, color: AppColors.primaryAccent, bg: AppColors.primarySurface)),
                        const SizedBox(width: AppSpacing.s),
                        Expanded(child: _OfficerMetricCard(title: 'New Intake (Unassigned)', count: newCount, icon: Icons.new_releases_outlined, color: const Color(0xFF0284C7), bg: const Color(0xFFF0F9FF))),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Row(
                      children: [
                        Expanded(child: _OfficerMetricCard(title: 'Active Scrutiny', count: pendingCount, icon: Icons.pending_actions_rounded, color: const Color(0xFF6366F1), bg: const Color(0xFFEEF2FF))),
                        const SizedBox(width: AppSpacing.s),
                        Expanded(child: _OfficerMetricCard(title: 'Resubmitted (Priority)', count: resubmittedCount, icon: Icons.update_rounded, color: const Color(0xFF0D9488), bg: const Color(0xFFCCFBF1))),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Row(
                      children: [
                        Expanded(child: _OfficerMetricCard(title: 'Info Requested (Pending Citizen)', count: infoReqCount, icon: Icons.warning_amber_rounded, color: AppColors.warning, bg: AppColors.warningLight)),
                        const SizedBox(width: AppSpacing.s),
                        Expanded(child: _OfficerMetricCard(title: 'Approved & Sealed', count: approvedCount, icon: Icons.verified_rounded, color: AppColors.success, bg: AppColors.successLight)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Row(
                      children: [
                        Expanded(child: _OfficerMetricCard(title: 'Rejected / Returned', count: rejectedCount, icon: Icons.cancel_outlined, color: AppColors.danger, bg: AppColors.dangerLight)),
                        const SizedBox(width: AppSpacing.s),
                        Expanded(child: _OfficerMetricCard(title: "Today's Workload Due", count: workloadCount, icon: Icons.alarm_rounded, color: const Color(0xFF854D0E), bg: const Color(0xFFFEF9C3))),
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
                childAspectRatio: 2.1,
                children: [
                  _OfficerMetricCard(
                    title: 'Total Applications',
                    count: totalCount,
                    icon: Icons.folder_copy_rounded,
                    color: AppColors.primaryAccent,
                    bg: AppColors.primarySurface,
                  ),
                  _OfficerMetricCard(
                    title: 'New Intake (Unassigned)',
                    count: newCount,
                    icon: Icons.new_releases_outlined,
                    color: const Color(0xFF0284C7),
                    bg: const Color(0xFFF0F9FF),
                  ),
                  _OfficerMetricCard(
                    title: 'Active Scrutiny',
                    count: pendingCount,
                    icon: Icons.pending_actions_rounded,
                    color: const Color(0xFF6366F1),
                    bg: const Color(0xFFEEF2FF),
                  ),
                  _OfficerMetricCard(
                    title: 'Resubmitted (Priority)',
                    count: resubmittedCount,
                    icon: Icons.update_rounded,
                    color: const Color(0xFF0D9488),
                    bg: const Color(0xFFCCFBF1),
                  ),
                  _OfficerMetricCard(
                    title: 'Info Requested (Pending Citizen)',
                    count: infoReqCount,
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.warning,
                    bg: AppColors.warningLight,
                  ),
                  _OfficerMetricCard(
                    title: 'Approved & Sealed',
                    count: approvedCount,
                    icon: Icons.verified_rounded,
                    color: AppColors.success,
                    bg: AppColors.successLight,
                  ),
                  _OfficerMetricCard(
                    title: 'Rejected / Returned',
                    count: rejectedCount,
                    icon: Icons.cancel_outlined,
                    color: AppColors.danger,
                    bg: AppColors.dangerLight,
                  ),
                  _OfficerMetricCard(
                    title: "Today's Workload Due",
                    count: workloadCount,
                    icon: Icons.alarm_rounded,
                    color: const Color(0xFF854D0E),
                    bg: const Color(0xFFFEF9C3),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.l),

          // Officer Quick Actions (Part 21)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Actions', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.m),
                  Row(
                    children: [
                      Expanded(
                        child: _OfficerQuickBtn(
                          icon: Icons.format_list_bulleted_rounded,
                          label: 'View\nApplications',
                          color: AppColors.primary,
                          bgColor: AppColors.primarySurface,
                          onTap: onOpenQueue,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: _OfficerQuickBtn(
                          icon: Icons.verified_user_rounded,
                          label: 'Verify\nCitizen Data',
                          color: const Color(0xFF059669),
                          bgColor: const Color(0xFFECFDF5),
                          onTap: () {
                            if (deptApps.isNotEmpty) {
                              onReviewApplication(deptApps.first.id);
                            } else {
                              onOpenQueue();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: _OfficerQuickBtn(
                          icon: Icons.account_balance_rounded,
                          label: 'Department\nRecords',
                          color: const Color(0xFFD97706),
                          bgColor: const Color(0xFFFFFBEB),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Department Records available in Records tab'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: _OfficerQuickBtn(
                          icon: Icons.insert_chart_outlined_rounded,
                          label: 'Officer\nReports',
                          color: const Color(0xFF7C3AED),
                          bgColor: const Color(0xFFF5F3FF),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Performance Reports available in Reports tab'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // High Priority Work Queue Preview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 560;
                      final textCol = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('High Priority Docket', style: AppTypography.h3),
                          Text('Cases requiring officer adjudication or verification.', style: AppTypography.bodySmall),
                        ],
                      );
                      final btn = AppButton(
                        label: 'View Full Queue',
                        variant: AppButtonVariant.outline,
                        size: AppButtonSize.small,
                        onPressed: onOpenQueue,
                      );

                      if (isNarrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textCol,
                            const SizedBox(height: AppSpacing.s),
                            btn,
                          ],
                        );
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: textCol),
                          const SizedBox(width: AppSpacing.m),
                          btn,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.m),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: deptApps.take(5).length,
                    separatorBuilder: (context, index) => const Divider(height: AppSpacing.m),
                    itemBuilder: (context, index) {
                      final app = deptApps[index];
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final isCompact = constraints.maxWidth < 520;
                          final statusBadge = StatusBadge(status: app.status, isCompact: true);

                          if (isCompact) {
                            return InkWell(
                              onTap: () => onReviewApplication(app.id),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: app.status.backgroundColor,
                                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                          ),
                                          child: Icon(app.status.icon, color: app.status.color, size: 18),
                                        ),
                                        const SizedBox(width: AppSpacing.s),
                                        Expanded(
                                          child: Text(
                                            app.id,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.code.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryAccent,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.s),
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(maxWidth: 110),
                                          child: statusBadge,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 36),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            app.serviceName,
                                            style: AppTypography.labelBold.copyWith(fontSize: 13),
                                          ),
                                          Text(
                                            '${app.citizenName} • ${DateFormat("dd MMM").format(app.submissionDate)} • ${app.documents.length} Docs',
                                            style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return InkWell(
                            onTap: () => onReviewApplication(app.id),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: app.status.backgroundColor,
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
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryAccent,
                                              ),
                                            ),
                                            Text(
                                              'Citizen: ${app.citizenName} • ${DateFormat("dd MMM").format(app.submissionDate)}',
                                              style: AppTypography.bodySmall,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(app.serviceName, style: AppTypography.labelBold),
                                        Text('${app.documents.length} Enclosed Documents', style: AppTypography.bodySmall),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.m),
                                  statusBadge,
                                  const SizedBox(width: AppSpacing.m),
                                  AppButton(
                                    label: 'Review File',
                                    size: AppButtonSize.small,
                                    leadingIcon: Icons.visibility_outlined,
                                    onPressed: () => onReviewApplication(app.id),
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
          ),
        ],
      ),
    );
  }
}

class _OfficerMetricCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final Color bg;

  const _OfficerMetricCard({
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
                  Text('$count', style: AppTypography.h2.copyWith(fontWeight: FontWeight.w800, fontSize: 18)),
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

class _OfficerQuickBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _OfficerQuickBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.labelBold.copyWith(fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
