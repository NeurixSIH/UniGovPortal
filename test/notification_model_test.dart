import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_gov_portal/models/notification_model.dart';

void main() {
  group('NotificationModel Tests', () {
    test('toMap and fromMap serialize and deserialize correctly', () {
      final now = Timestamp.now();
      final notification = NotificationModel(
        notificationId: 'NOTIF_SAMPLE_001',
        userId: 'USR_729326',
        type: NotificationModel.typeApplicationUpdate,
        title: 'Application Under Review',
        message: 'Your application for Income Certificate has been assigned to Revenue Officer.',
        applicationId: 'APP_SAMPLE_001',
        isRead: false,
        createdAt: now,
      );

      final map = notification.toMap();

      expect(map['notificationId'], 'NOTIF_SAMPLE_001');
      expect(map['userId'], 'USR_729326');
      expect(map['type'], NotificationModel.typeApplicationUpdate);
      expect(map['title'], 'Application Under Review');
      expect(map['message'], 'Your application for Income Certificate has been assigned to Revenue Officer.');
      expect(map['applicationId'], 'APP_SAMPLE_001');
      expect(map['isRead'], false);
      expect(map['createdAt'], now);

      final fromMapNotif = NotificationModel.fromMap(map);
      expect(fromMapNotif.notificationId, notification.notificationId);
      expect(fromMapNotif.userId, notification.userId);
      expect(fromMapNotif.type, notification.type);
      expect(fromMapNotif.title, notification.title);
      expect(fromMapNotif.message, notification.message);
      expect(fromMapNotif.applicationId, notification.applicationId);
      expect(fromMapNotif.isRead, false);
      expect(fromMapNotif.createdAt, notification.createdAt);
    });

    test('copyWith works properly for notification model', () {
      final now = Timestamp.now();
      final notification = NotificationModel(
        notificationId: 'NOTIF_001',
        userId: 'USR_001',
        type: NotificationModel.typeGeneral,
        title: 'System Notice',
        message: 'Maintenance scheduled',
        applicationId: '',
        isRead: false,
        createdAt: now,
      );

      final updated = notification.copyWith(
        isRead: true,
      );

      expect(updated.isRead, true);
      expect(updated.notificationId, 'NOTIF_001');
      expect(updated.title, 'System Notice');
    });
  });
}
