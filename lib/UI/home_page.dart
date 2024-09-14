import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/UI/custom_button.dart';
import 'package:todo/UI/custom_text_form_field.dart';
import 'package:todo/UI/task_list.view.dart';
import 'package:todo/services/task_colors.dart';
import '../controllers/task_controller.dart';
import 'task_form.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [],
      ),
      appBar: AppBar(
        title: const Text('Todo Manager'),
        actions: [],
      ),
      bottomNavigationBar: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PopupMenuButton<SortingCriterion>(
            icon: const CircleAvatar(child: Icon(Icons.sort)),
            onSelected: (criterion) {
              taskController.sortTasks(criterion, ascending: false);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortingCriterion.priority,
                child: Text('Sort by Priority'),
              ),
              const PopupMenuItem(
                value: SortingCriterion.dueDate,
                child: Text('Sort by Due Date'),
              ),
              const PopupMenuItem(
                value: SortingCriterion.creationDate,
                child: Text('Sort by Creation Date'),
              ),
            ],
          ),
          SizedBox(
            width: context.mediaQuery.size.width * 0.82,
            child: CustomButton(
              title: "Add Todo",
              onPressed: () => Get.to(() => TaskFormPage()),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextFormField(
                heading: "Search",
                filled: true,
                fillColor: Theme.of(context).canvasColor,
                prefixIcon: const Icon(Icons.search_rounded),
                textEditingController: taskController.searchController,
                onChanged: (value) {
                  taskController.searchTasks(value);
                },
              ),
            ),
            TaskListView(taskController: taskController),
          ],
        ),
      ),
    );
  }

  // Get color based on priority level
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
