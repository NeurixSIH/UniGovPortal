import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/demo_repository.dart';
import '../../models/notification_model.dart';
import '../../models/consent_model.dart';

class NotificationsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String route, {dynamic arguments}) onNavigate;

  const NotificationsScreen({
    super.key,
    required this.onBack,
    required this.onNavigate,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final DemoRepository _repo = DemoRepository();
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Unread', 'Consent', 'Applications', 'Sync'];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _repo,
      builder: (context, _) {
        final filtered = _repo.notifications.where((n) {
          if (_selectedCategory == 'All') return true;
          if (_selectedCategory == 'Unread') return !n.isRead;
          if (_selectedCategory == 'Consent') return n.type == NotificationModel.typeConsentRequest;
          if (_selectedCategory == 'Applications') return n.type == NotificationModel.typeApplicationUpdate;
          if (_selectedCategory == 'Sync') return n.type == NotificationModel.typeSyncMessage;
          return true;
        }).toList();

        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: widget.onBack,
            ),
            title: const Text('Notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  _repo.markAllNotificationsAsRead();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All notifications marked as read.')),
                  );
                },
                child: const Text('Mark All Read', style: TextStyle(fontSize: 12, color: AppTheme.primaryBlue)),
              ),
            ],
          ),
          body: Column(
            children: [
              // Category Filter Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) setState(() => _selectedCategory = cat);
                          },
                          selectedColor: AppTheme.primaryBlue,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppTheme.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const Divider(height: 1, color: AppTheme.borderLight),

              // Notifications List
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text('No notifications in this category', style: TextStyle(color: AppTheme.textMuted)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final notif = filtered[index];
                          return _buildNotificationCard(notif);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notif) {
    final bool isConsent = notif.type == NotificationModel.typeConsentRequest;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: notif.isRead ? Colors.white : const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notif.isRead ? AppTheme.borderLight : AppTheme.primaryBlue.withAlpha(80),
          width: notif.isRead ? 1 : 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: _getIconBg(notif.type),
                child: Icon(_getIcon(notif.type), size: 18, color: _getIconColor(notif.type)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        if (!notif.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      notif.message,
                      style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Action Buttons for Consent Request Notifications
          if (isConsent && notif.consentId.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _repo.updateConsentStatus(notif.consentId, ConsentModel.statusDenied);
                    _repo.markNotificationAsRead(notif.notificationId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Access Denied.')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.statusRejected,
                    side: const BorderSide(color: AppTheme.statusRejected),
                    minimumSize: const Size(80, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('Deny', style: TextStyle(fontSize: 11)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _repo.updateConsentStatus(notif.consentId, ConsentModel.statusGranted);
                    _repo.markNotificationAsRead(notif.notificationId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Access Granted to Municipal Corporation.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.statusSuccess,
                    minimumSize: const Size(80, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('Allow Access', style: TextStyle(fontSize: 11, color: Colors.white)),
                ),
              ],
            ),
          ],

          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Today, 09:15 AM',
              style: TextStyle(fontSize: 9, color: AppTheme.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case NotificationModel.typeConsentRequest:
        return Icons.security;
      case NotificationModel.typeApplicationUpdate:
        return Icons.assignment_turned_in_outlined;
      case NotificationModel.typeSyncMessage:
        return Icons.sync;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconBg(String type) {
    switch (type) {
      case NotificationModel.typeConsentRequest:
        return AppTheme.saffronLight;
      case NotificationModel.typeApplicationUpdate:
        return AppTheme.primaryBlueLight.withAlpha(25);
      case NotificationModel.typeSyncMessage:
        return AppTheme.statusSuccessLight;
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case NotificationModel.typeConsentRequest:
        return AppTheme.saffron;
      case NotificationModel.typeApplicationUpdate:
        return AppTheme.primaryBlue;
      case NotificationModel.typeSyncMessage:
        return AppTheme.statusSuccess;
      default:
        return AppTheme.primaryBlue;
    }
  }
}
