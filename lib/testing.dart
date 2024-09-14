import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TestNotificationPage extends StatefulWidget {
  @override
  _TestNotificationPageState createState() => _TestNotificationPageState();
}

class _TestNotificationPageState extends State<TestNotificationPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    tz.initializeTimeZones();
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _testNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'test_channel_id',
        'Test Channel',
        channelDescription: 'Test notification channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is a test notification.',
      notificationDetails,
    );
  }

Future<void> _scheduleNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: 'Scheduled Notification',
      body: 'This notification is scheduled to appear in 30 seconds.',
    ),
    schedule: NotificationCalendar(
      year: DateTime.now().year,
      month: DateTime.now().month,
      day: DateTime.now().day,
      hour: DateTime.now().hour,
      minute: DateTime.now().minute,
      second: DateTime.now().second + 5,
      millisecond: 0,
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Notifications')),
      body: Center(
        child: ElevatedButton(
          onPressed: _scheduleNotification,
          child: Text('Schedule Test Notification'),
        ),
      ),
    );
  }
}
