import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/application_status.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/status_badge.dart';

class OfficerHistoryScreen extends StatefulWidget {
  final ValueChanged<String> onOpenApplication;

  const OfficerHistoryScreen({super.key, required this.onOpenApplication});

  @override
  State<OfficerHistoryScreen> createState() => _OfficerHistoryScreenState();
}

class _OfficerHistoryScreenState extends State<OfficerHistoryScreen> {
  String _filter = 'ALL'; // ALL, APPROVED, REJECTED, INFO_REQ

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final apps = state.applications;

    final decidedApps = apps.where((a) {
      if (_filter == 'APPROVED') {
        return a.status == AppStatus.approved || a.status == AppStatus.certificateGenerated || a.status == AppStatus.completed;
      } else if (_filter == 'REJECTED') {
        return a.status == AppStatus.rejected;
      } else if (_filter == 'INFO_REQ') {
        return a.status == AppStatus.informationRequired;
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Officer Adjudication History', style: AppTypography.h1),
          Text('Archived official decisions, approved certificate registers, and rejection orders.', style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.l),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterBtn(
                  label: 'All Decided Files (${apps.length})',
                  isSelected: _filter == 'ALL',
                  onTap: () => setState(() => _filter = 'ALL'),
                ),
                const SizedBox(width: AppSpacing.s),
                _FilterBtn(
                  label: 'Approved & Issued',
                  isSelected: _filter == 'APPROVED',
                  onTap: () => setState(() => _filter = 'APPROVED'),
                ),
                const SizedBox(width: AppSpacing.s),
                _FilterBtn(
                  label: 'Rejected',
                  isSelected: _filter == 'REJECTED',
                  onTap: () => setState(() => _filter = 'REJECTED'),
                ),
                const SizedBox(width: AppSpacing.s),
                _FilterBtn(
                  label: 'Clarification Notices',
                  isSelected: _filter == 'INFO_REQ',
                  onTap: () => setState(() => _filter = 'INFO_REQ'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // List
          if (decidedApps.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxxl),
                child: Center(
                  child: Text('No decision records found for this category.', style: AppTypography.bodyMedium),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: decidedApps.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
              itemBuilder: (context, index) {
                final app = decidedApps[index];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.l),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isCompact = constraints.maxWidth < 500;
                        
                        final iconBox = Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: app.status.backgroundColor,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Icon(app.status.icon, color: app.status.color, size: 22),
                        );
                        
                        final textDetails = Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: AppSpacing.s,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(app.id, style: AppTypography.code.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryAccent)),
                                  Text('• Citizen: ${app.citizenName}', style: AppTypography.bodySmall),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(app.serviceName, style: AppTypography.h3.copyWith(fontSize: 15)),
                              if (app.certificateNumber != null)
                                Text('Issued Certificate: ${app.certificateNumber}', style: AppTypography.code.copyWith(fontSize: 11, color: AppColors.success))
                              else if (app.rejectionCategory != null)
                                Text('Rejection: ${app.rejectionCategory}', style: AppTypography.bodySmall.copyWith(color: AppColors.danger)),
                            ],
                          ),
                        );
                        
                        final actionSection = Column(
                          crossAxisAlignment: isCompact ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                          children: [
                            StatusBadge(status: app.status, isCompact: true),
                            const SizedBox(height: AppSpacing.s),
                            AppButton(
                              label: 'Inspect File',
                              variant: AppButtonVariant.outline,
                              size: AppButtonSize.small,
                              onPressed: () => widget.onOpenApplication(app.id),
                            ),
                          ],
                        );

                        if (isCompact) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  iconBox,
                                  const SizedBox(width: AppSpacing.m),
                                  textDetails,
                                ],
                              ),
                              const SizedBox(height: AppSpacing.m),
                              Align(
                                alignment: Alignment.centerRight,
                                child: actionSection,
                              ),
                            ],
                          );
                        }

                        return Row(
                          children: [
                            iconBox,
                            const SizedBox(width: AppSpacing.m),
                            textDetails,
                            const SizedBox(width: AppSpacing.m),
                            actionSection,
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _FilterBtn extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterBtn({
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
          border: Border.all(color: isSelected ? const Color(0xFF059669) : AppColors.border),
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
