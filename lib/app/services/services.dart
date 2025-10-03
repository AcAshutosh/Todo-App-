import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/app/model/task_model.dart';

class Services {
  static const String _taskListKey = 'taskList';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> saveTask({required List<TaskModel> tasks}) async {
    try {
      final prefs = await _prefs;
      List<String> taskToSave = [];
      if (tasks.isNotEmpty) {
        for (TaskModel task in tasks) {
          taskToSave.add(jsonEncode(task));
        }
      }
      await prefs.setStringList(_taskListKey, taskToSave);
    } catch (e) {
      print(e);
    }
  }

  Future<List<TaskModel>> getAllTaskList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final List? tasks = prefs.getStringList(_taskListKey);
      List<TaskModel> newTaskList = <TaskModel>[];
      if (tasks != null && tasks.isNotEmpty) {
        for (var t in tasks) {
          newTaskList.add(jsonDecode(t));
        }
      }
      return newTaskList;
    } catch (e) {
      return <TaskModel>[];
    }
  }
}
