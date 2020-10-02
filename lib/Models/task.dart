class Task {
  final String taskName;
  final bool done;
  final String taskType;
  Task({this.taskName, this.done,this.taskType});

  Map<String, dynamic> toMap(){
    return {
      "taskName": this.taskName,
      "done": this.done,
      "taskType":this.taskType
    };
  }

  static Task fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return Task(
      taskName: map['taskName'],
      done: map['done'],
      taskType: map ['taskType']
    );
  }

}
