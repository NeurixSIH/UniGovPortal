import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/state/app_state_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class NotificationsScreen extends StatelessWidget {
  final ValueChanged<String> onOpenApplication;

  const NotificationsScreen({
    super.key,
    required this.onOpenApplication,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final notifications = state.notifications;
    final unreadCount = state.unreadNotificationsCount;

    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppSpacing.m : AppSpacing.l),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 550;

                  final titleCol = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Citizen Notifications & Alerts',
                        style: isMobile ? AppTypography.h2 : AppTypography.h1,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Real-time scrutiny status changes, official notices, and scheme alerts.',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: isMobile ? 12 : 13,
                        ),
                      ),
                    ],
                  );

                  if (isCompact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleCol,
                        if (unreadCount > 0) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () => state.markAllNotificationsAsRead(),
                              icon: const Icon(Icons.done_all_rounded, size: 16),
                              label: const Text('Mark All Read'),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: titleCol),
                      if (unreadCount > 0)
                        TextButton.icon(
                          onPressed: () => state.markAllNotificationsAsRead(),
                          icon: const Icon(Icons.done_all_rounded, size: 16),
                          label: const Text('Mark All Read'),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.m),

              if (notifications.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.notifications_none_rounded, size: 54, color: AppColors.textLight),
                          const SizedBox(height: AppSpacing.m),
                          Text('No notifications yet', style: AppTypography.h3),
                          Text('When your applications move through stages, alerts will show here.', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.s),
                  itemBuilder: (context, index) {
                    final notif = notifications[index];
                    return _NotificationTile(
                      notification: notif,
                      onTap: () {
                        state.markNotificationAsRead(notif.id);
                        if (notif.applicationId != null) {
                          onOpenApplication(notif.applicationId!);
                        }
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('dd MMM, hh:mm a').format(notification.timestamp);
    final isUnread = !notification.isRead;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: isUnread ? AppColors.primarySurface : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: isUnread ? AppColors.infoBorder : AppColors.border,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: notification.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(notification.icon, color: notification.color, size: 18),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTypography.labelBold.copyWith(
                              fontSize: 13,
                              color: isUnread ? AppColors.primary : AppColors.textPrimary,
                              fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        Text(
                          formattedTime,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    if (notification.applicationId != null) ...[
                      const SizedBox(height: AppSpacing.s),
                      Row(
                        children: [
                          const Icon(Icons.touch_app_outlined, size: 14, color: AppColors.primaryAccent),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Click to inspect application ${notification.applicationId}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.primaryAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
