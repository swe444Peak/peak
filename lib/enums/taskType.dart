enum TaskType {
  once,
  daily,
  weekly,
  monthly,
}

extension ParseToString on TaskType {
  String toShortString() {
    return this.toString().split('.').last;
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
