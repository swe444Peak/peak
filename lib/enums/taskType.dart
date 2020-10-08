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

extension ParseToTaskType on String {
  TaskType formString() {
    if (this.toLowerCase() == "daily") {
      return TaskType.daily;
    }
    if (this.toLowerCase() == "once") {
      return TaskType.once;
    }
    if (this.toLowerCase() == "weekly") {
      return TaskType.weekly;
    }
    if (this.toLowerCase() == "monthly") {
      return TaskType.monthly;
    }
  }
}

