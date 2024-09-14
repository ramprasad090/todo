import 'package:flutter/material.dart';

class TaskPriorityColors extends ThemeExtension<TaskPriorityColors> {
  final Color lowPriorityColor;
  final Color mediumPriorityColor;
  final Color highPriorityColor;

  TaskPriorityColors({
    required this.lowPriorityColor,
    required this.mediumPriorityColor,
    required this.highPriorityColor,
  });

  @override
  TaskPriorityColors copyWith({
    Color? lowPriorityColor,
    Color? mediumPriorityColor,
    Color? highPriorityColor,
  }) {
    return TaskPriorityColors(
      lowPriorityColor: lowPriorityColor ?? this.lowPriorityColor,
      mediumPriorityColor: mediumPriorityColor ?? this.mediumPriorityColor,
      highPriorityColor: highPriorityColor ?? this.highPriorityColor,
    );
  }

  @override
  TaskPriorityColors lerp(ThemeExtension<TaskPriorityColors>? other, double t) {
    if (other is! TaskPriorityColors) return this;
    return TaskPriorityColors(
      lowPriorityColor: Color.lerp(lowPriorityColor, other.lowPriorityColor, t)!,
      mediumPriorityColor: Color.lerp(mediumPriorityColor, other.mediumPriorityColor, t)!,
      highPriorityColor: Color.lerp(highPriorityColor, other.highPriorityColor, t)!,
    );
  }
}
