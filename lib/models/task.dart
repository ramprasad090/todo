class Task {
  String title;
  String description;
  DateTime dueDate;
  int priorityLevel; // 1 = Low, 2 = Medium, 3 = High
  DateTime createdAt;
  int? notificationId; // Add this line

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priorityLevel,
    required this.createdAt,
    this.notificationId, // Add this line
  });

  // Convert Task to Map (for SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toString(),
      'priorityLevel': priorityLevel,
      "createdAt": createdAt.toString(),
      'notificationId': notificationId, // Add this line
    };
  }

  // Convert from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        title: json['title'],
        description: json['description'],
        dueDate: DateTime.parse(json['dueDate']),
        priorityLevel: json['priorityLevel'],
        createdAt: DateTime.parse(json['createdAt']),
        notificationId: json['notificationId']?.toInt(), // Add this line
    );
  }
}
