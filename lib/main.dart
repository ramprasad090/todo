import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/UI/home_page.dart';
import 'package:todo/services/notification_service.dart';
import 'package:todo/services/task_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      onPrimary: Colors.white,
      secondary: Colors.green,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    ),
    // Define custom colors for priority levels
    primaryColor: Colors.blue,
    extensions: [
      TaskPriorityColors(
        lowPriorityColor: Colors.green[300]!,
        mediumPriorityColor: Colors.orange[300]!,
        highPriorityColor: Colors.red[300]!,
      ),
    ],
  );

  final darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(
      primary: Colors.blueGrey,
      onPrimary: Colors.white,
      secondary: Colors.teal,
      onSecondary: Colors.white,
      surface: Colors.grey[800]!,
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.white,
    ),
    // Define custom colors for priority levels
    primaryColor: Colors.blueGrey,
    extensions: [
      TaskPriorityColors(
        lowPriorityColor: Colors.green[600]!,
        mediumPriorityColor: Colors.orange[600]!,
        highPriorityColor: Colors.red[600]!,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      darkTheme: darkTheme,
      theme: lightTheme,
      home: HomePage(),
    );
  }
}
