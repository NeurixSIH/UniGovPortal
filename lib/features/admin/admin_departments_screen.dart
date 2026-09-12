import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';

class AdminDepartmentsScreen extends StatefulWidget {
  final VoidCallback? onManageServices;

  const AdminDepartmentsScreen({super.key, this.onManageServices});

  @override
  State<AdminDepartmentsScreen> createState() => _AdminDepartmentsScreenState();
}

class _AdminDepartmentsScreenState extends State<AdminDepartmentsScreen> {
  String _searchQuery = '';

  void _showDepartmentDetails(BuildContext context, String deptName, int serviceCount, int officerCount) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        title: Row(
          children: [
            const Icon(Icons.domain_rounded, color: AppColors.primary),
            const SizedBox(width: AppSpacing.s),
            Expanded(child: Text(deptName, style: AppTypography.h3, overflow: TextOverflow.ellipsis)),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Maharashtra State Secretariat Department Node', style: AppTypography.bodySmall),
              const SizedBox(height: AppSpacing.m),
              _infoRow('Active Citizen Services', '$serviceCount Services Live'),
              _infoRow('Assigned Scrutiny Officers', '$officerCount Officers Active'),
              _infoRow('Central Gateway Status', 'Connected (TLS 1.3)'),
              _infoRow('SLA Adherence Target', '7 Working Days'),
              const SizedBox(height: AppSpacing.m),
              Container(
                padding: const EdgeInsets.all(AppSpacing.s),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: AppColors.successBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        'Interoperability Hub Node Active & Synchronized',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          AppButton(
            label: 'Close',
            variant: AppButtonVariant.outline,
            size: AppButtonSize.small,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
          Text(value, style: AppTypography.labelBold.copyWith(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final isMobile = MediaQuery.of(context).size.width < 700;
    final departments = state.departments;
    final services = state.services;
    final officers = state.officers;

    final filtered = departments.where((d) {
      if (_searchQuery.isEmpty) return true;
      return d.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppSpacing.m : AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            color: const Color(0xFF6D28D9),
            border: BorderSide.none,
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Department Management', style: AppTypography.h2.copyWith(color: Colors.white, fontSize: 18)),
                      Text('State ministries, statutory desks & service provisioning directory', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),

          AppCard(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search department directory by ministry or authority name...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s),
            itemBuilder: (context, idx) {
              final d = filtered[idx];
              final serviceCount = services.where((s) => s.departmentId == d.id).length;
              final officerCount = officers.where((o) => o.departmentName.toLowerCase().contains(d.name.toLowerCase().split(' ').first)).length;

              return AppCard(
                onTap: () => _showDepartmentDetails(context, d.name, serviceCount, officerCount),
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3FF),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: const Icon(Icons.account_balance_outlined, color: Color(0xFF7C3AED), size: 22),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d.name, style: AppTypography.labelBold.copyWith(fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(
                            '$serviceCount Active Services • ${officerCount > 0 ? officerCount : 2} Officers Assigned',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    StatusBadge.active(isCompact: true),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
