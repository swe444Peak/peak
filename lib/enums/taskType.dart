enum TaskType {
  once,
  daily,
  weekly,
  monthly,
}

extension ParseToString on TaskType {
  String toShortString() {
    String type = this.toString().split('.').last;
    return type.substring(0, 1).toUpperCase() + type.substring(1);
  }
}

extension ParseTaskType on String {
  TaskType formString() {
    if (this.toLowerCase() == "once") return TaskType.once;
    if (this.toLowerCase() == "monthly") return TaskType.monthly;
    if (this.toLowerCase() == "daily") return TaskType.daily;
    if (this.toLowerCase() == "weekly") return TaskType.weekly;
  }
}
