import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/application_model.dart';
import '../models/application_status.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class TimelineWidget extends StatelessWidget {
  final ApplicationModel application;

  const TimelineWidget({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    // Collect actual events
    final events = application.timeline;
    final currentStatus = application.status;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              Text('Processing Timeline', style: AppTypography.h3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: currentStatus.backgroundColor,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  border: Border.all(color: currentStatus.borderColor),
                ),
                child: Text(
                  currentStatus.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: currentStatus.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),

          // Render event items
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final isLast = index == events.length - 1;
              final isCurrent = index == events.length - 1;

              return _buildTimelineItem(
                event: event,
                isLast: isLast,
                isCurrent: isCurrent,
              );
            },
          ),

          // If not completed or rejected, show next prospective stage
          if (currentStatus != AppStatus.completed &&
              currentStatus != AppStatus.rejected &&
              currentStatus != AppStatus.certificateGenerated) ...[
            _buildUpcomingStageHint(currentStatus),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required TimelineEvent event,
    required bool isLast,
    required bool isCurrent,
  }) {
    final statusColor = event.stage.color;
    final formattedTime = DateFormat('dd MMM yyyy, hh:mm a').format(event.timestamp);

    return Stack(
      children: [
        if (!isLast)
          Positioned(
            left: 17,
            top: 28,
            bottom: 0,
            child: Container(
              width: 2,
              color: AppColors.border,
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline Indicator Node
            SizedBox(
              width: 36,
              child: Center(
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCurrent ? statusColor : statusColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCurrent ? statusColor : statusColor.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    event.stage.icon,
                    size: 14,
                    color: isCurrent ? Colors.white : statusColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.m),

          // Event Details Card
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.l),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: isCurrent ? AppColors.surfaceSubtle : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: isCurrent ? AppColors.borderFocus : AppColors.borderSubtle,
                    width: isCurrent ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 280) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: AppTypography.labelBold.copyWith(
                                  fontSize: 14,
                                  color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formattedTime,
                                style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                              ),
                            ],
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                event.title,
                                style: AppTypography.labelBold.copyWith(
                                  fontSize: 14,
                                  color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.s),
                            Text(
                              formattedTime,
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    if (event.actorName != null || event.remarks != null) ...[
                      const SizedBox(height: AppSpacing.s),
                      Wrap(
                        spacing: AppSpacing.s,
                        runSpacing: 4,
                        children: [
                          if (event.actorName != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primarySurface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${event.actorRole}: ${event.actorName}',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primaryAccent,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          if (event.remarks != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.warningLight,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.warningBorder),
                              ),
                              child: Text(
                                'Note: "${event.remarks}"',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.warning,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildUpcomingStageHint(AppStatus currentStatus) {
    String upcomingStage = 'Next: Department Scrutiny & Approval';
    if (currentStatus == AppStatus.informationRequired) {
      upcomingStage = 'Next: Citizen Resubmission of Corrected Files';
    } else if (currentStatus == AppStatus.underReview) {
      upcomingStage = 'Next: Formal Competent Authority Approval & Digital Certificate Generation';
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.m, left: 36 + AppSpacing.m),
      child: Row(
        children: [
          const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textLight),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              upcomingStage,
              style: AppTypography.bodySmall.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
