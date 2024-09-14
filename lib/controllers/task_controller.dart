import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:todo/services/notification_service.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  SharedPreferences? prefs;
  var currentSortingCriterion =
      SortingCriterion.dueDate.obs; // Default sorting by due date
  var searchController = TextEditingController();
  var originalTasks = <Task>[].obs; // Store original tasks

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  // Load tasks from SharedPreferences
  Future loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString(_tasksKey);
    if (tasksString == null) {
      return [];
    }

    final List<dynamic> tasksJson = jsonDecode(tasksString);
    tasks.value = tasksJson.map((json) => Task.fromJson(json)).toList();
    sortTasks(currentSortingCriterion.value);
    originalTasks.value = tasksJson.map((json) => Task.fromJson(json)).toList();
  }

  Future<void> addTask(Task task) async {
    tasks.add(task);
    originalTasks.add(task);
    await saveTasks();

    // Schedule a notification for task reminder
    NotificationService().scheduleNotification(
      task.dueDate.hashCode, // Unique ID for the notification
      'Task Reminder: ${task.title}',
      'Your task is due soon!',
      task.dueDate
          .subtract(Duration(hours: 1)), // Schedule 1 hour before the due date
    );
  }

  Future<void> updateTask(int index, Task task) async {
    tasks[index] = task;
    await saveTasks();

    // Cancel any existing notification for this task and schedule a new one
    NotificationService().cancelNotification(task.dueDate.hashCode);
    NotificationService().scheduleNotification(
      task.dueDate.hashCode,
      'Task Reminder: ${task.title}',
      'Your task is due soon!',
      task.dueDate.subtract(Duration(hours: 1)),
    );
  }

  // Delete task

// Assume you have a global instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> deleteTask(int index) async {
    // Retrieve the task to be deleted
    Task task = tasks[index];

    // Cancel the scheduled notification if a notification ID exists
    if (task.notificationId != null) {
      await AwesomeNotifications().cancel(task.notificationId!);
    }

    // Remove the task from the list
    tasks.removeAt(index);
    originalTasks.removeAt(index);

    // Save the remaining tasks
    await saveTasks();
  }

  static const String _tasksKey = 'tasks';
  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString(_tasksKey);

    if (tasksString == null) {
      return [];
    }

    final List<dynamic> tasksJson = jsonDecode(tasksString);
    return tasksJson.map((json) => Task.fromJson(json)).toList();
  }

  // Save tasks to SharedPreferences
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> tasksJson =
        tasks.map((task) => task.toJson()).toList();
    final String tasksString = jsonEncode(tasksJson);
    await prefs.setString(_tasksKey, tasksString);
  }

  // Sort tasks based on the selected criterion
  void sortTasks(SortingCriterion criterion, {bool ascending = true}) {
    List<Task> sortedList;

    switch (criterion) {
      case SortingCriterion.priority:
        sortedList = List.from(tasks)
          ..sort((a, b) => a.priorityLevel - b.priorityLevel);
        break;
      case SortingCriterion.dueDate:
        sortedList = List.from(tasks)
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case SortingCriterion.creationDate:
        sortedList = List.from(tasks)
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }

    if (criterion == SortingCriterion.dueDate) {
      ascending = true;
    }

    // If descending order is selected, reverse the sorted list
    if (!ascending) {
      sortedList = sortedList.reversed.toList();
    }
    currentSortingCriterion.value = criterion;
    // Update the observable list with sorted data
    tasks.value = sortedList;
    tasks.refresh();
  }

  Map<dynamic, List<Task>> groupTasksByCriterion(List<Task> tasks) {
    final Map<dynamic, List<Task>> groupedTasks = {};

    for (var task in tasks) {
      dynamic groupKey;

      switch (currentSortingCriterion.value) {
        case SortingCriterion.priority:
          groupKey = task.priorityLevel; // Group by priority
          break;
        case SortingCriterion.dueDate:
          groupKey = DateTime(task.dueDate.year, task.dueDate.month,
              task.dueDate.day); // Group by date
          break;
        case SortingCriterion.creationDate:
          groupKey = DateTime(task.createdAt.year, task.createdAt.month,
              task.createdAt.day); // Group by creation date
          break;
      }

      if (groupedTasks.containsKey(groupKey)) {
        groupedTasks[groupKey]!.add(task);
      } else {
        groupedTasks[groupKey] = [task];
      }
    }

    return groupedTasks;
  }

  void searchTasks(String query) {
    if (query.isEmpty) {
      tasks.value = List.from(originalTasks); // Restore original tasks
    } else {
      String lowerQuery = query.toLowerCase();

      tasks.value = originalTasks.where((task) {
        // Check for fuzzy matches in title and description using string_similarity package
        bool fuzzyMatchTitle =
            task.title.toLowerCase().similarityTo(lowerQuery) > 0.5;
        bool fuzzyMatchDescription =
            task.description.toLowerCase().similarityTo(lowerQuery) > 0.5;

        bool matchTitle = task.title.toLowerCase().contains(lowerQuery);
        bool matchDescription =
            task.description.toLowerCase().contains(lowerQuery);

        // Format the task's due date and creation date into readable formats
        String dueDate =
            DateFormat('MMMM d, y').format(task.dueDate).toLowerCase();
        String createdAt =
            DateFormat('MMMM d, y').format(task.createdAt).toLowerCase();

        // Split the query by spaces and check if each part is in the date strings
        bool dateMatch = lowerQuery.split(' ').every(
            (part) => dueDate.contains(part) || createdAt.contains(part));

        // Return true if any condition is met (fuzzy match in title/description or date match)
        return fuzzyMatchTitle || fuzzyMatchDescription || dateMatch || matchDescription || matchTitle;
      }).toList();
    }

    tasks.refresh();
  }
}

enum SortingCriterion {
  priority,
  dueDate,
  creationDate,
}
