import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/models/application_model.dart';
import '../../../core/models/application_status.dart';
import '../../../core/state/app_state_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';

class ApplicationHistoryScreen extends StatefulWidget {
  final ValueChanged<String> onSelectApplication;

  const ApplicationHistoryScreen({
    super.key,
    required this.onSelectApplication,
  });

  @override
  State<ApplicationHistoryScreen> createState() => _ApplicationHistoryScreenState();
}

class _ApplicationHistoryScreenState extends State<ApplicationHistoryScreen> {
  String _searchQuery = '';
  String _filterTab = 'ALL'; // ALL, PENDING, APPROVED, REJECTED, ACTION_REQUIRED

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final allApps = state.applications;

    final filteredApps = allApps.where((app) {
      // Filter tab
      if (_filterTab == 'PENDING') {
        final isPending = app.status == AppStatus.submitted ||
            app.status == AppStatus.documentsUnderVerification ||
            app.status == AppStatus.underReview ||
            app.status == AppStatus.resubmitted;
        if (!isPending) return false;
      } else if (_filterTab == 'APPROVED') {
        final isApproved = app.status == AppStatus.approved ||
            app.status == AppStatus.certificateGenerated ||
            app.status == AppStatus.completed;
        if (!isApproved) return false;
      } else if (_filterTab == 'REJECTED') {
        if (app.status != AppStatus.rejected) return false;
      } else if (_filterTab == 'ACTION_REQUIRED') {
        if (app.status != AppStatus.informationRequired) return false;
      }

      // Search query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesId = app.id.toLowerCase().contains(q);
        final matchesService = app.serviceName.toLowerCase().contains(q);
        final matchesDept = app.departmentName.toLowerCase().contains(q);
        return matchesId || matchesService || matchesDept;
      }

      return true;
    }).toList();

    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppSpacing.m : AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blue Header matching mockup
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application History',
                  style: AppTypography.h2.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Comprehensive audit trail of all service requests and issued certificates.',
                  style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: AppSpacing.m),
                // Stats Chips Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _StatusChip(label: 'All', count: allApps.length, isSelected: _filterTab == 'ALL', onTap: () => setState(() => _filterTab = 'ALL')),
                      const SizedBox(width: AppSpacing.s),
                      _StatusChip(label: 'Pending', count: allApps.where((a) => a.status == AppStatus.submitted || a.status == AppStatus.underReview).length, isSelected: _filterTab == 'PENDING', onTap: () => setState(() => _filterTab = 'PENDING'), color: const Color(0xFF67E8F9)),
                      const SizedBox(width: AppSpacing.s),
                      _StatusChip(label: 'Approved', count: allApps.where((a) => a.status == AppStatus.approved || a.status == AppStatus.completed).length, isSelected: _filterTab == 'APPROVED', onTap: () => setState(() => _filterTab = 'APPROVED'), color: const Color(0xFF86EFAC)),
                      const SizedBox(width: AppSpacing.s),
                      _StatusChip(label: 'Rejected', count: allApps.where((a) => a.status == AppStatus.rejected).length, isSelected: _filterTab == 'REJECTED', onTap: () => setState(() => _filterTab = 'REJECTED'), color: const Color(0xFFFCA5A5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),

          // Filters Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? AppSpacing.s : AppSpacing.m),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          style: AppTypography.bodyMedium,
                          decoration: InputDecoration(
                            hintText: isMobile ? 'Search ID, service or department...' : 'Search by reference ID (e.g. APP-2026...), service or department...',
                            hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 18),
                                    onPressed: () => setState(() => _searchQuery = ''),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: AppSpacing.xs),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterTabBtn(
                          label: 'All (${allApps.length})',
                          isSelected: _filterTab == 'ALL',
                          onTap: () => setState(() => _filterTab = 'ALL'),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        _FilterTabBtn(
                          label: 'Action Required',
                          isSelected: _filterTab == 'ACTION_REQUIRED',
                          isDanger: true,
                          onTap: () => setState(() => _filterTab = 'ACTION_REQUIRED'),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        _FilterTabBtn(
                          label: 'In Progress / Pending',
                          isSelected: _filterTab == 'PENDING',
                          onTap: () => setState(() => _filterTab = 'PENDING'),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        _FilterTabBtn(
                          label: 'Approved & Issued',
                          isSelected: _filterTab == 'APPROVED',
                          onTap: () => setState(() => _filterTab = 'APPROVED'),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        _FilterTabBtn(
                          label: 'Rejected',
                          isSelected: _filterTab == 'REJECTED',
                          onTap: () => setState(() => _filterTab = 'REJECTED'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // Applications List
          if (filteredApps.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxxl),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.folder_off_outlined, size: 48, color: AppColors.textLight),
                      const SizedBox(height: AppSpacing.m),
                      Text('No matching applications found', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Try adjusting your search criteria or status filter.', style: AppTypography.bodySmall),
                    ],
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredApps.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
              itemBuilder: (context, index) {
                final app = filteredApps[index];
                return _ApplicationCard(
                  application: app,
                  onTap: () => widget.onSelectApplication(app.id),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _FilterTabBtn extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDanger;
  final VoidCallback onTap;

  const _FilterTabBtn({
    required this.label,
    required this.isSelected,
    this.isDanger = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = isSelected ? (isDanger ? AppColors.danger : AppColors.primaryAccent) : AppColors.surfaceSubtle;
    Color fg = isSelected ? Colors.white : (isDanger ? AppColors.danger : AppColors.textSecondary);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(color: isSelected ? bg : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: fg, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _StatusChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text('$count', style: AppTypography.h3.copyWith(color: color, fontWeight: FontWeight.w800)),
            Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final ApplicationModel application;
  final VoidCallback onTap;

  const _ApplicationCard({
    required this.application,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = application.status;
    final isActionReq = status == AppStatus.informationRequired;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            border: isActionReq ? Border.all(color: AppColors.dangerBorder, width: 1.5) : null,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 540;

              if (isCompact) {
                // Mobile compact card layout
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: status.backgroundColor,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Icon(status.icon, color: status.color, size: 20),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                application.id,
                                style: AppTypography.code.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryAccent,
                                ),
                              ),
                              Text(
                                'Submitted ${DateFormat("dd MMM yyyy").format(application.submissionDate)}',
                                style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        StatusBadge(status: status, isCompact: true),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      application.serviceName,
                      style: AppTypography.h3.copyWith(fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      application.departmentName,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isActionReq) ...[
                      const SizedBox(height: AppSpacing.s),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.dangerLight,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded, size: 16, color: AppColors.danger),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                application.actionRequiredReason ?? 'Clarification requested by officer.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.danger,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.m),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: isActionReq ? 'Resolve Clarification' : 'View Application File',
                        variant: isActionReq ? AppButtonVariant.danger : AppButtonVariant.outline,
                        size: AppButtonSize.small,
                        trailingIcon: Icons.arrow_forward_rounded,
                        onPressed: onTap,
                      ),
                    ),
                  ],
                );
              }

              // Desktop/Tablet layout
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: status.backgroundColor,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Icon(status.icon, color: status.color, size: 24),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: AppSpacing.s,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  application.id,
                                  style: AppTypography.code.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryAccent,
                                  ),
                                ),
                                Text(
                                  '• Submitted ${DateFormat("dd MMM yyyy").format(application.submissionDate)}',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              application.serviceName,
                              style: AppTypography.h3.copyWith(fontSize: 16),
                            ),
                            Text(
                              application.departmentName,
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StatusBadge(status: status),
                          const SizedBox(height: AppSpacing.s),
                          AppButton(
                            label: isActionReq ? 'Resolve' : 'View File',
                            variant: isActionReq ? AppButtonVariant.danger : AppButtonVariant.outline,
                            size: AppButtonSize.small,
                            trailingIcon: Icons.arrow_forward_rounded,
                            onPressed: onTap,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (isActionReq) ...[
                    const SizedBox(height: AppSpacing.m),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.dangerLight,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded, size: 16, color: AppColors.danger),
                          const SizedBox(width: AppSpacing.s),
                          Expanded(
                            child: Text(
                              application.actionRequiredReason ?? 'Clarification requested by officer.',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.danger, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
