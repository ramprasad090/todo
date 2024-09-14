# todo

A new Flutter project.

## Getting Started

Here’s a README file for your task management app:

---

# Task Management App

A Flutter-based task management application that supports creating, editing, deleting, and scheduling tasks with local notifications. The app integrates with the `awesome_notifications` package for advanced notification management.

## Features

- **Task Management**: Create, edit, and delete tasks with titles, descriptions, due dates, and priority levels.
- **Task Sorting**: Sort tasks by priority, due date, or creation date.
- **Notifications**: Schedule notifications for tasks using `awesome_notifications` and `flutter_local_notifications`.
- **Search Functionality**: Search tasks by title, description, or date with partial matching capabilities.
- **Custom Reminders**: Set custom reminders for tasks and display notifications accordingly.

## Packages Used

- **GetX**: State management (`get: ^4.6.5`)
- **Shared Preferences**: Storing tasks and user preferences (`shared_preferences: ^2.0.11`)
- **Intl**: Formatting dates (`intl: ^0.18.0`)
- **Flutter Local Notifications**: For local notifications (`flutter_local_notifications: ^17.2.2`)
- **Timezone**: Handling time zones (`timezone: ^0.9.4`)
- **Awesome Notifications**: Advanced notification management (`awesome_notifications: ^0.8.2`)
- **String Similarity**: Advanced Search for typos (`string_similarity: ^2.1.1`)

## Installation

1. **Clone the Repository**

    ```bash
    git clone https://github.com/ramprasad090/todo.git
    cd todo
    ```

2. **Install Dependencies**

    ```bash
    flutter pub get
    ```

3. **Configure Android Notifications**

    - Ensure that you have configured the required permissions and icons for notifications in your `AndroidManifest.xml`.

4. **Configure iOS Notifications**

    - Ensure that you have configured the required permissions and settings in your iOS project.

## Usage

1. **Initialize Notifications**

    Initialize notifications in the main entry point of your app:

    ```dart
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await NotificationService().initNotifications();
      runApp(MyApp());
    }
    ```

2. **Schedule a Notification**

    Use the `scheduleNotification` method to set up notifications:

    ```dart
    await NotificationService().scheduleNotification(
      id,
      'Task Reminder',
      'This is a reminder for your task.',
      DateTime.now().add(Duration(minutes: 10)),
    );
    ```

3. **Search Tasks**

    Search tasks by title, description, or date:

    ```dart
    taskController.searchTasks('your query');
    ```

4. **Custom Reminders**

    Use the custom reminder icon to set reminders and handle notifications:

    ```dart
    IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {
        // Open reminder dialog and handle scheduling
      },
    );
    ```
