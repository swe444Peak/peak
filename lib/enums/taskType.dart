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
