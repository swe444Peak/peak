class Task {
  final String taskName;
  final bool done;
  Task(this.taskName, this.done);

  Map<String, dynamic> toMap(){
    return {
      "taskName": this.taskName,
      "done": this.done
    };
  }
}
