import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/model/task_model.dart';
import 'package:todo_app/app/services/services.dart';

class TaskController extends GetxController {
  RxList<TaskModel> taskList = <TaskModel>[].obs;
  final Services _storgeService = Services();
  TextEditingController taskNameCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getTaskList();
  }

  Future<void> getTaskList() async {
    taskList.clear();
    taskList.value = await _storgeService.getAllTaskList();
  }

  Future<void> addTask() async {
    if (taskNameCtrl.text.trim().isEmpty) {
      _showError("Please Enter the task Name");
      return;
    }
    final exists = taskList.any(
      (task) => (task.taskName ?? '').trim() == taskNameCtrl.text,
    );
    if (exists) {
      _showError('A task with that name already exists.');

      return;
    }
    TaskModel task = TaskModel(
      taskName: taskNameCtrl.text.trim(),
      isCompleted: false,
    );
    taskList.add(task);
    taskNameCtrl.clear();
    Get.back();
    await _storgeService.saveTask(tasks: taskList);
  }

  Future<void> updateStatus({
    required String taskName,
    required bool isCompleted,
  }) async {
    for (TaskModel task in taskList) {
      if ((task.taskName ?? "").trim() == taskName.trim()) {
        task.isCompleted = isCompleted;
      }
    }
    taskList.refresh();
    await _storgeService.saveTask(tasks: taskList);
  }

  Future<void> editTask(TaskModel task) async {
    final name = taskNameCtrl.text.trim();
    if (name.isEmpty) {
      return _showError('Please enter the task name.');
    }

    final duplicate = taskList.any(
      (t) =>
          t != task && t.taskName?.trim().toLowerCase() == name.toLowerCase(),
    );
    if (duplicate) {
      return _showError('A task with that name already exists.');
    }

    task.taskName = name;
    taskList.refresh();
    taskNameCtrl.clear();
    Get.back();
    await _storgeService.saveTask(tasks: taskList);
  }

  Future<void> deleteTask({required String taskName}) async {
    final tasksToRemove = taskList
        .where((task) => (task.taskName ?? "").trim() == taskName.trim())
        .toList();

    for (var task in tasksToRemove) {
      taskList.remove(task);
    }

    taskList.refresh();
    await _storgeService.saveTask(tasks: taskList);
  }

  void _showError(String message) {
    Get.back();
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[100],
      colorText: Colors.black,
      duration: Duration(seconds: 1),
    );
  }
}
