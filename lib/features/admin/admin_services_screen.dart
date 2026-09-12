import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/service_model.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  State<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {
  String _searchQuery = '';
  final Set<String> _deactivatedServiceIds = {};

  void _toggleServiceStatus(String serviceId, String serviceName) {
    setState(() {
      if (_deactivatedServiceIds.contains(serviceId)) {
        _deactivatedServiceIds.remove(serviceId);
      } else {
        _deactivatedServiceIds.add(serviceId);
      }
    });

    final isActive = !_deactivatedServiceIds.contains(serviceId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$serviceName marked as ${isActive ? "Active" : "Inactive"}'),
        backgroundColor: isActive ? AppColors.success : AppColors.warning,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showServiceDetail(BuildContext context, ServiceModel srv, bool isActive) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        title: Row(
          children: [
            Icon(srv.icon, color: AppColors.primary),
            const SizedBox(width: AppSpacing.s),
            Expanded(child: Text(srv.name, style: AppTypography.h3, overflow: TextOverflow.ellipsis)),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(srv.description, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.m),
                const Divider(),
                const SizedBox(height: AppSpacing.s),
                _row('Service ID', srv.id),
                _row('Department', srv.departmentName),
                _row('Category', srv.category),
                _row('Government Fee', srv.governmentFee == 0 ? 'FREE' : '₹ ${srv.governmentFee.toStringAsFixed(0)}'),
                _row('Processing SLA', '${srv.processingTimeDays} Days'),
                _row('Required Documents', '${srv.requiredDocuments.length} Documents required'),
                _row('Form Fields', '${srv.formFields.length} Dynamic questions'),
                const SizedBox(height: AppSpacing.m),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Service Status', style: AppTypography.labelBold),
                    isActive ? StatusBadge.active(isCompact: true) : StatusBadge.inactive(isCompact: true),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          AppButton(
            label: isActive ? 'Deactivate' : 'Activate',
            variant: isActive ? AppButtonVariant.danger : AppButtonVariant.success,
            size: AppButtonSize.small,
            onPressed: () {
              Navigator.of(ctx).pop();
              _toggleServiceStatus(srv.id, srv.name);
            },
          ),
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

  Widget _row(String label, String value) {
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
    final services = state.services;

    final filtered = services.where((s) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return s.name.toLowerCase().contains(q) ||
          s.departmentName.toLowerCase().contains(q) ||
          s.category.toLowerCase().contains(q);
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
                  child: const Icon(Icons.dashboard_customize_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('State Service Directory & SLA Rules', style: AppTypography.h2.copyWith(color: Colors.white, fontSize: 18)),
                      Text('Central statutory catalog • Fee schedules • Verification workflow config', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
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
                hintText: 'Search services by title, category or department...',
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
              final srv = filtered[idx];
              final isActive = !_deactivatedServiceIds.contains(srv.id);

              return AppCard(
                onTap: () => _showServiceDetail(context, srv, isActive),
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Icon(srv.icon, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(srv.name, style: AppTypography.labelBold.copyWith(fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(
                            '${srv.departmentName} • ${srv.processingTimeDays} Days SLA • ${srv.governmentFee == 0 ? "FREE" : "₹ ${srv.governmentFee.toStringAsFixed(0)}"}',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    isActive ? StatusBadge.active(isCompact: true) : StatusBadge.inactive(isCompact: true),
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
