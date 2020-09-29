class Task {
  final String taskName;
  final bool done;
  Task({this.taskName, this.done});

  Map<String, dynamic> toMap(){
    return {
      "taskName": this.taskName,
      "done": this.done
    };
  }

  static Task fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return Task(
      taskName: map['taskName'],
      done: map['done'],
    );
  }

}
