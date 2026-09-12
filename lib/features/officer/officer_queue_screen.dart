import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/models/application_model.dart';
import '../../core/models/application_status.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/status_badge.dart';

class OfficerQueueScreen extends StatefulWidget {
  final ValueChanged<String> onReviewApplication;

  const OfficerQueueScreen({
    super.key,
    required this.onReviewApplication,
  });

  @override
  State<OfficerQueueScreen> createState() => _OfficerQueueScreenState();
}

class _OfficerQueueScreenState extends State<OfficerQueueScreen> {
  String _activeTab = 'ALL'; // ALL, NEW, PENDING, INFO_REQUIRED, RESUBMITTED, APPROVED, REJECTED
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final apps = state.applications;

    final filtered = apps.where((app) {
      // Status filter
      if (_activeTab == 'NEW' && app.status != AppStatus.submitted) return false;
      if (_activeTab == 'PENDING' &&
          (app.status != AppStatus.underReview && app.status != AppStatus.documentsUnderVerification)) {
        return false;
      }
      if (_activeTab == 'INFO_REQUIRED' && app.status != AppStatus.informationRequired) return false;
      if (_activeTab == 'RESUBMITTED' && app.status != AppStatus.resubmitted) return false;
      if (_activeTab == 'APPROVED' &&
          (app.status != AppStatus.approved && app.status != AppStatus.certificateGenerated && app.status != AppStatus.completed)) {
        return false;
      }
      if (_activeTab == 'REJECTED' && app.status != AppStatus.rejected) return false;

      // Search
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return app.id.toLowerCase().contains(q) ||
            app.citizenName.toLowerCase().contains(q) ||
            app.serviceName.toLowerCase().contains(q);
      }

      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Officer Application Queue', style: AppTypography.h1),
          Text('Statutory review docket for scrutinizing citizen files, verifying enclosures, and granting certificates.', style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.l),

          // Search and Filters Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.search_rounded, color: AppColors.textMuted),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: 'Search queue by application ID, citizen name, or service...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
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
                  const SizedBox(height: AppSpacing.s),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All (${apps.length})',
                          isSelected: _activeTab == 'ALL',
                          onTap: () => setState(() => _activeTab = 'ALL'),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        _FilterChip(
                          label: 'New Intake (${apps.where((a) => a.status == AppStatus.submitted).length})',
                          isSelected: _activeTab == 'NEW',
                          onTap: () => setState(() => _activeTab = 'NEW'),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        _FilterChip(
                          label: 'Pending Scrutiny (${apps.where((a) => a.status == AppStatus.underReview || a.status == AppStatus.documentsUnderVerification).length})',
                          isSelected: _activeTab == 'PENDING',
                          onTap: () => setState(() => _activeTab = 'PENDING'),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        _FilterChip(
                          label: 'Resubmitted (${apps.where((a) => a.status == AppStatus.resubmitted).length})',
                          isSelected: _activeTab == 'RESUBMITTED',
                          onTap: () => setState(() => _activeTab = 'RESUBMITTED'),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        _FilterChip(
                          label: 'Info Requested (${apps.where((a) => a.status == AppStatus.informationRequired).length})',
                          isSelected: _activeTab == 'INFO_REQUIRED',
                          onTap: () => setState(() => _activeTab = 'INFO_REQUIRED'),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        _FilterChip(
                          label: 'Approved (${apps.where((a) => a.status == AppStatus.approved || a.status == AppStatus.certificateGenerated || a.status == AppStatus.completed).length})',
                          isSelected: _activeTab == 'APPROVED',
                          onTap: () => setState(() => _activeTab = 'APPROVED'),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        _FilterChip(
                          label: 'Rejected (${apps.where((a) => a.status == AppStatus.rejected).length})',
                          isSelected: _activeTab == 'REJECTED',
                          onTap: () => setState(() => _activeTab = 'REJECTED'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // Queue Items List
          if (filtered.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxxl),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.inbox_outlined, size: 48, color: AppColors.textLight),
                      const SizedBox(height: AppSpacing.m),
                      Text('No files found in this filter queue', style: AppTypography.h3),
                      Text('Select another status tab to inspect other active cases.', style: AppTypography.bodySmall),
                    ],
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
              itemBuilder: (context, index) {
                final app = filtered[index];
                return _OfficerQueueCard(
                  application: app,
                  onReview: () => widget.onReviewApplication(app.id),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF059669) : AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected ? const Color(0xFF059669) : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _OfficerQueueCard extends StatelessWidget {
  final ApplicationModel application;
  final VoidCallback onReview;

  const _OfficerQueueCard({
    required this.application,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final verifiedDocsCount = application.documents.where((d) => d.isVerified).length;
    final totalDocsCount = application.documents.length;
    final isPriority = application.status == AppStatus.resubmitted;

    return Card(
      child: InkWell(
        onTap: onReview,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            border: isPriority ? Border.all(color: const Color(0xFF0284C7), width: 1.5) : null,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 620;

              if (isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: application.status.backgroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(application.status.icon, color: application.status.color, size: 20),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: AppSpacing.xs,
                                runSpacing: 2,
                                children: [
                                  Text(
                                    application.id,
                                    style: AppTypography.code.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryAccent),
                                  ),
                                  StatusBadge(status: application.status, isCompact: true),
                                ],
                              ),
                              if (isPriority) ...[
                                const SizedBox(height: 3),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F9FF),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFFBAE6FD)),
                                  ),
                                  child: Text(
                                    'PRIORITY RESUBMITTED',
                                    style: AppTypography.labelSmall.copyWith(fontSize: 9, color: const Color(0xFF0284C7), fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(application.serviceName, style: AppTypography.h3.copyWith(fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(
                      'Citizen: ${application.citizenName} (${application.citizenAadhaar}) • ${application.citizenPhone}',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Wrap(
                      spacing: AppSpacing.m,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text(
                              'Filed: ${DateFormat("dd MMM yyyy").format(application.submissionDate)}',
                              style: AppTypography.bodySmall.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.attach_file_rounded, size: 13, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text(
                              'Docs: $verifiedDocsCount/$totalDocsCount Verified',
                              style: AppTypography.bodySmall.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.m),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: 'Review Case Scrutiny',
                        size: AppButtonSize.small,
                        leadingIcon: Icons.folder_open_rounded,
                        onPressed: onReview,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: application.status.backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(application.status.icon, color: application.status.color, size: 24),
                  ),
                  const SizedBox(width: AppSpacing.m),

                  // Application Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              application.id,
                              style: AppTypography.code.copyWith(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryAccent),
                            ),
                            const SizedBox(width: AppSpacing.s),
                            if (isPriority)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F9FF),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color(0xFFBAE6FD)),
                                ),
                                child: Text(
                                  'PRIORITY RESUBMITTED',
                                  style: AppTypography.labelSmall.copyWith(fontSize: 9, color: const Color(0xFF0284C7), fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(application.serviceName, style: AppTypography.h3.copyWith(fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(
                          'Citizen: ${application.citizenName} (${application.citizenAadhaar}) • Mobile: ${application.citizenPhone}',
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(height: AppSpacing.s),

                        // Info row
                        Wrap(
                          spacing: AppSpacing.m,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.textMuted),
                                const SizedBox(width: 4),
                                Text(
                                  'Filed: ${DateFormat("dd MMM yyyy").format(application.submissionDate)}',
                                  style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.attach_file_rounded, size: 13, color: AppColors.textMuted),
                                const SizedBox(width: 4),
                                Text(
                                  'Documents: $verifiedDocsCount of $totalDocsCount Verified',
                                  style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),

                  // Status & Review CTA
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatusBadge(status: application.status),
                      const SizedBox(height: AppSpacing.m),
                      AppButton(
                        label: 'Review Case',
                        size: AppButtonSize.small,
                        leadingIcon: Icons.folder_open_rounded,
                        onPressed: onReview,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
