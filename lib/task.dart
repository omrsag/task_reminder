class Task {
  int id;
  int userId;
  String title;
  String details;
  String dueDate;
  String dueTime;
  String remindAt;
  int isDone;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.details,
    required this.dueDate,
    required this.dueTime,
    required this.remindAt,
    required this.isDone,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: int.parse(json["id"].toString()),
      userId: int.parse(json["user_id"].toString()),
      title: json["title"].toString(),
      details: (json["details"] ?? "").toString(),
      dueDate: (json["due_date"] ?? "").toString(),
      dueTime: (json["due_time"] ?? "").toString(),
      remindAt: (json["remind_at"] ?? "").toString(),
      isDone: int.parse((json["is_done"] ?? "0").toString()),
    );
  }
}
