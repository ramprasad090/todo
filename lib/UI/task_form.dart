import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/UI/custom_button.dart';
import 'package:todo/UI/custom_text_form_field.dart';
import '../models/task.dart';
import '../controllers/task_controller.dart';

class TaskFormPage extends StatefulWidget {
  final Task? task;
  final int? index;

  TaskFormPage({this.task, this.index});

  @override
  _TaskFormPageState createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final TaskController taskController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  int selectedPriority = 1;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      selectedDate = widget.task!.dueDate;
      selectedPriority = widget.task!.priorityLevel;
    }
  }

  void saveTask() {
    Task newTask = Task(
      title: titleController.text,
      description: descriptionController.text,
      dueDate: selectedDate ?? DateTime.now(),
      priorityLevel: selectedPriority,
      createdAt: DateTime.now(),
    );

    if (widget.task == null) {
      taskController.addTask(newTask);
    } else {
      taskController.updateTask(widget.index!, newTask);
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar:
          AppBar(title: Text(widget.task == null ? 'Add Task' : 'Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(
              textEditingController: titleController,
              heading: "Title",
              filled: true,
              fillColor: Theme.of(context).canvasColor,
              prefixIcon: Icon(Icons.title_rounded),
            ),
            SizedBox(
              height: 6,
            ),
            CustomTextFormField(
              textEditingController: descriptionController,
              heading: "Description",
              prefixIcon: Icon(Icons.description_rounded),
              maxLines: null,
              filled: true,
              fillColor: Theme.of(context).canvasColor,
            ),
            SizedBox(
              height: 6,
            ),
            CustomTextFormField(
              filled: true,
              fillColor: Theme.of(context).canvasColor,
              heading: "Due Date",
              isReadOnly: true,
              prefixIcon: Icon(Icons.calendar_month_rounded),
              hintText: selectedDate == null
                  ? ""
                  : DateFormat('yMMMd').format(selectedDate as DateTime),
              onTap: () async {
                selectedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  currentDate: DateTime.now(),
                  lastDate: DateTime(2025),
                );
                setState(() {
                  
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButton<int>(
              alignment: Alignment.centerLeft,
              value: selectedPriority,
              items: [
                DropdownMenuItem(value: 1, child: Text('Low')),
                DropdownMenuItem(value: 2, child: Text('Medium')),
                DropdownMenuItem(value: 3, child: Text('High')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPriority = value!;
                });
              },
              hint: Text('Select Priority'),
            ),
            Spacer(),
            CustomButton(
              title: "Save Task",
              onPressed: saveTask,
            )
          ],
        ),
      ),
    );
  }
}
