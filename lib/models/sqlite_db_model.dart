class Task {
  int? id;
  final String time;
  final String task;

  Task({
    this.id,
    required this.time,
    required this.task,
  });

  factory Task.fromMap({required Map<String,dynamic> data}){
    return Task(
      id: data['id'],
      time: data['time'],
      task: data['task'],
    );
  }
}
