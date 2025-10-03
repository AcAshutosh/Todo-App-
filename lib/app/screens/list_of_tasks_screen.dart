import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/controller/task_controller.dart';
import 'package:todo_app/app/controller/theme_controller.dart';
import 'package:todo_app/app/model/task_model.dart';

class ListOfTasksScreen extends StatefulWidget {
  const ListOfTasksScreen({super.key});

  @override
  State<ListOfTasksScreen> createState() => _ListOfTasksScreenState();
}

class _ListOfTasksScreenState extends State<ListOfTasksScreen> {
  final TaskController ctr = Get.put(TaskController());
  final ThemeController themeCtrl = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(
                themeCtrl.themeMode.value == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              onPressed: themeCtrl.toggleTheme,
            );
          }),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              ctr.getTaskList();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ctr.taskNameCtrl.clear();
          showDialog(
            context: context,
            useSafeArea: true,
            barrierDismissible: true,
            builder: (context) {
              return AlertDialog(
                title: Text("Add Task"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: ctr.taskNameCtrl,
                      decoration: InputDecoration(
                        hint: Text("Enter Task Name"),
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        ctr.addTask();
                      },
                      child: Text("Add Task"),
                    ),
                  ],
                ),
              );
            },
          );
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Obx(() {
          if (ctr.taskList.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.checklist_rtl, size: 72),
                  SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + below to add your first task',
                    style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                  ),
                ],
              ),
            ).paddingOnly(bottom: 60);
          }
          return ListView.builder(
            itemCount: ctr.taskList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final TaskModel taskDet = ctr.taskList[index];
              return Row(
                children: [
                  Checkbox(
                    value: taskDet.isCompleted ?? false,
                    onChanged: (value) {
                      ctr.updateStatus(
                        taskName: taskDet.taskName ?? "",
                        isCompleted: value ?? false,
                      );
                    },
                  ),
                  Expanded(child: Text(taskDet.taskName ?? "")),
                  IconButton(
                    onPressed: () {
                      ctr.taskNameCtrl.text = taskDet.taskName ?? "";
                      showDialog(
                        context: context,
                        useSafeArea: true,
                        barrierDismissible: true,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Edit Task"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TextField(
                                  controller: ctr.taskNameCtrl,
                                  decoration: InputDecoration(
                                    hint: Text("Enter Task Name"),
                                  ),
                                ),
                                SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    ctr.editTask(taskDet);
                                  },
                                  child: Text("Edit Task"),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      ctr.deleteTask(taskName: taskDet.taskName ?? "");
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
