import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:todo/UI/task_form.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_service.dart';
import 'package:todo/services/task_colors.dart';

class TaskListView extends StatelessWidget {
  final TaskController taskController;

  TaskListView({required this.taskController});

  Future<void> _scheduleCustomNotification(
      Task task, BuildContext context) async {
    DateTime? selectedDateTime = await _selectDateTime(context);
    if (selectedDateTime != null) {
      NotificationService().scheduleNotification(
          task.dueDate.hashCode, // Unique ID for the notification
          'Task Reminder: ${task.title}',
          'Your task is due soon!',
          selectedDateTime);
    }
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    // Select Date
    selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      // Select Time
      selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
    }

    if (selectedDate != null && selectedTime != null) {
      final dateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      return dateTime;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final groupedTasks =
          taskController.groupTasksByCriterion(taskController.tasks);

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: groupedTasks.length,
        itemBuilder: (context, index) {
          final date = groupedTasks.keys.elementAt(index);
          final tasks = groupedTasks[date]!;

          String heading = "";

          if (taskController.currentSortingCriterion.value ==
              SortingCriterion.creationDate) {
            heading = DateFormat('yMMMMd').format(date as DateTime);
          } else if (taskController.currentSortingCriterion.value ==
              SortingCriterion.priority) {
            heading = "Priority $date";
          } else if (taskController.currentSortingCriterion.value ==
              SortingCriterion.dueDate) {
            heading =
                "Due Date ${DateFormat('yMMMMd').format(date as DateTime)}";
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  heading,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              ...tasks.map((task) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getPriorityColor(task.priorityLevel, context),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.titleLarge!.color,
                        ),
                      ),
                      subtitle: Text(
                        '${task.description}\nDue: ${DateFormat('yMMMMd').format(task.dueDate)} | Priority: ${task.priorityLevel}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              await Get.to(TaskFormPage(
                                task: task,
                                index: index,
                              ));
                              taskController.loadTasks();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => taskController.deleteTask(
                              taskController.tasks.indexOf(task),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () =>
                                _scheduleCustomNotification(task, context),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      );
    });
  }

  Color _getPriorityColor(int priorityLevel, BuildContext context) {
    final priorityColors = Theme.of(context).extension<TaskPriorityColors>();
    switch (priorityLevel) {
      case 1:
        return priorityColors?.lowPriorityColor ?? Colors.grey;
      case 2:
        return priorityColors?.mediumPriorityColor ?? Colors.grey;
      case 3:
        return priorityColors?.highPriorityColor ?? Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
