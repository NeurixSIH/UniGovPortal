import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final CollectionReference<Map<String, dynamic>> _notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  /// Add or send a notification to a user
  Future<void> addNotification(NotificationModel notification) async {
    await _notificationsCollection
        .doc(notification.notificationId)
        .set(notification.toMap());
  }

  /// Get a single notification by notificationId
  Future<NotificationModel?> getNotification(String notificationId) async {
    final doc = await _notificationsCollection.doc(notificationId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return NotificationModel.fromFirestore(doc);
  }

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    await _notificationsCollection.doc(notificationId).update({
      'isRead': true,
    });
  }

  /// Mark all unread notifications for a user as read
  Future<void> markAllAsRead(String userId) async {
    final query = await _notificationsCollection
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = FirebaseFirestore.instance.batch();
    for (final doc in query.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    await _notificationsCollection.doc(notificationId).delete();
  }

  /// Stream a single notification in real-time
  Stream<NotificationModel?> streamNotification(String notificationId) {
    return _notificationsCollection.doc(notificationId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return NotificationModel.fromFirestore(doc);
    });
  }

  /// Stream all notifications ordered by creation time
  Stream<List<NotificationModel>> streamAllNotifications() {
    return _notificationsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }

  /// Stream notifications for a specific user
  Stream<List<NotificationModel>> streamNotificationsByUser(String userId) {
    return _notificationsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }

  /// Stream only unread notifications for a user
  Stream<List<NotificationModel>> streamUnreadNotificationsByUser(String userId) {
    return _notificationsCollection
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }

  /// Stream notifications for a user filtered by notification type
  Stream<List<NotificationModel>> streamNotificationsByType(
    String userId,
    String type,
  ) {
    return _notificationsCollection
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: type)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }
}
