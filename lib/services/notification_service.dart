import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> initNotifications() async {
    requestNotificationPermissions();
    AwesomeNotifications().initialize(
      'resource://mipmap/ic_launcher',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic notifications',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        )
      ],
    );
  }

  void requestNotificationPermissions() async {
    // Request the user to allow notifications
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      // This is where you can ask for notification permission
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    requestNotificationPermissions();
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduledTime),
    );
  }

  Future<void> cancelNotification(int id) async {
    AwesomeNotifications().cancel(id);
  }
}
