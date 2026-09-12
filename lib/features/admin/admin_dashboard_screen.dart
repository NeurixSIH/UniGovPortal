import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';

class AdminDashboardScreen extends StatelessWidget {
  final VoidCallback onManageOfficers;

  const AdminDashboardScreen({super.key, required this.onManageOfficers});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final officers = state.officers;
    final departments = state.departments;

    final totalOfficers = officers.length;
    final activeOfficers = officers.where((o) => o.isActive).length;
    final inactiveOfficers = officers.where((o) => !o.isActive).length;
    final totalDepartments = departments.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4C1D95), Color(0xFF6D28D9), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              boxShadow: const [
                BoxShadow(color: Color(0x2A4C1D95), blurRadius: 16, offset: Offset(0, 4)),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 650;
                final textCol = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(
                        'CENTRAL ADMIN CONSOLE • AUDIT COMPLIANT',
                        style: AppTypography.labelSmall.copyWith(color: Colors.white, letterSpacing: 1.0),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      'System Administration Console',
                      style: AppTypography.h1.copyWith(color: Colors.white, fontSize: isNarrow ? 20 : 24),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Manage civil service department officers, access credentials, role allocations, and platform security policies.',
                      style: AppTypography.bodyMedium.copyWith(color: const Color(0xFFEDE9FE)),
                    ),
                  ],
                );

                final actionBtn = AppButton(
                  label: 'Manage Officers',
                  variant: AppButtonVariant.secondary,
                  size: isNarrow ? AppButtonSize.medium : AppButtonSize.large,
                  leadingIcon: Icons.manage_accounts_rounded,
                  onPressed: onManageOfficers,
                );

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textCol,
                      const SizedBox(height: AppSpacing.m),
                      actionBtn,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: textCol),
                    const SizedBox(width: AppSpacing.m),
                    actionBtn,
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // High-level Metrics (A-02)
          Text('System Metrics & Provisioning', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.m),

          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 700;
              
              if (isNarrow) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _AdminMetricCard(title: 'Total Officers', count: totalOfficers, icon: Icons.people_alt_rounded, color: const Color(0xFF7C3AED), bg: const Color(0xFFF5F3FF))),
                        const SizedBox(width: AppSpacing.s),
                        Expanded(child: _AdminMetricCard(title: 'Active Officers', count: activeOfficers, icon: Icons.check_circle_rounded, color: AppColors.success, bg: AppColors.successLight)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Row(
                      children: [
                        Expanded(child: _AdminMetricCard(title: 'Inactive / Suspended', count: inactiveOfficers, icon: Icons.pause_circle_outline_rounded, color: AppColors.danger, bg: AppColors.dangerLight)),
                        const SizedBox(width: AppSpacing.s),
                        Expanded(child: _AdminMetricCard(title: 'Total Departments', count: totalDepartments, icon: Icons.account_balance_rounded, color: AppColors.primaryAccent, bg: AppColors.primarySurface)),
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
                childAspectRatio: 2.2,
                children: [
                  _AdminMetricCard(
                    title: 'Total Officers',
                    count: totalOfficers,
                    icon: Icons.people_alt_rounded,
                    color: const Color(0xFF7C3AED),
                    bg: const Color(0xFFF5F3FF),
                  ),
                  _AdminMetricCard(
                    title: 'Active Officers',
                    count: activeOfficers,
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                    bg: AppColors.successLight,
                  ),
                  _AdminMetricCard(
                    title: 'Inactive / Suspended',
                    count: inactiveOfficers,
                    icon: Icons.pause_circle_outline_rounded,
                    color: AppColors.danger,
                    bg: AppColors.dangerLight,
                  ),
                  _AdminMetricCard(
                    title: 'Total Departments',
                    count: totalDepartments,
                    icon: Icons.account_balance_rounded,
                    color: AppColors.primaryAccent,
                    bg: AppColors.primarySurface,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.l),

          // Admin Quick Actions (Part 36)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Administrative Actions', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.m),
                  Row(
                    children: [
                      Expanded(
                        child: _AdminQuickBtn(
                          icon: Icons.people_alt_rounded,
                          label: 'Manage\nOfficers',
                          color: const Color(0xFF7C3AED),
                          bgColor: const Color(0xFFF5F3FF),
                          onTap: onManageOfficers,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: _AdminQuickBtn(
                          icon: Icons.domain_rounded,
                          label: 'Manage\nDepartments',
                          color: AppColors.primary,
                          bgColor: AppColors.primarySurface,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Departments Directory accessible via Departments tab'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: _AdminQuickBtn(
                          icon: Icons.dashboard_customize_rounded,
                          label: 'Manage\nServices',
                          color: const Color(0xFF0D9488),
                          bgColor: const Color(0xFFCCFBF1),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('State Services catalog accessible via Services tab'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: _AdminQuickBtn(
                          icon: Icons.analytics_rounded,
                          label: 'System\nReports',
                          color: const Color(0xFFD97706),
                          bgColor: const Color(0xFFFFFBEB),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('System Reports accessible via Reports tab'),
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

          // Recent Officer Activity Table Preview
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
                          Text('Recent Officer Activity', style: AppTypography.h3),
                          Text('Real-time scrutiny throughput across departments.', style: AppTypography.bodySmall),
                        ],
                      );
                      final btn = AppButton(
                        label: 'View All Officers',
                        variant: AppButtonVariant.outline,
                        size: AppButtonSize.small,
                        onPressed: onManageOfficers,
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
                    itemCount: officers.length,
                    separatorBuilder: (context, index) => const Divider(height: AppSpacing.m),
                    itemBuilder: (context, index) {
                      final officer = officers[index];
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final isCompact = constraints.maxWidth < 460;
                          final statusBadge = Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: officer.isActive ? AppColors.successLight : AppColors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                              border: Border.all(color: officer.isActive ? AppColors.successBorder : AppColors.border),
                            ),
                            child: Text(
                              officer.isActive ? 'ACTIVE' : 'DEACTIVATED',
                              style: AppTypography.labelSmall.copyWith(
                                color: officer.isActive ? AppColors.success : AppColors.textMuted,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );

                          if (isCompact) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: officer.isActive ? const Color(0xFF059669) : AppColors.textLight,
                                      child: Text(officer.fullName[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: AppSpacing.s),
                                    Expanded(
                                      child: Text(
                                        officer.fullName,
                                        style: AppTypography.labelBold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.s),
                                    statusBadge,
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Text(
                                    '${officer.designation} • ${officer.departmentName} • ${officer.resolvedCount} Decided',
                                    style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            );
                          }

                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: officer.isActive ? const Color(0xFF059669) : AppColors.textLight,
                                child: Text(officer.fullName[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                                        Text(officer.fullName, style: AppTypography.labelBold),
                                        Text('(${officer.userId})', style: AppTypography.code.copyWith(fontSize: 11, color: AppColors.textMuted)),
                                      ],
                                    ),
                                    Text(
                                      '${officer.designation} • ${officer.departmentName}',
                                      style: AppTypography.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.m),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  statusBadge,
                                  const SizedBox(height: 2),
                                  Text('${officer.resolvedCount} Cases Decided', style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                                ],
                              ),
                            ],
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

class _AdminMetricCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final Color bg;

  const _AdminMetricCard({
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

class _AdminQuickBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _AdminQuickBtn({
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
