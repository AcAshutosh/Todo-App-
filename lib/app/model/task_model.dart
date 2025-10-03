class TaskModel {
  String? taskName;
  bool? isCompleted;

  TaskModel({this.taskName, this.isCompleted});

  TaskModel.fromJson(Map<String, dynamic> json) {
    taskName = json['taskName'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taskName'] = taskName;
    data['isCompleted'] = isCompleted;
    return data;
  }
}
