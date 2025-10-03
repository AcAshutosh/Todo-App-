import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/controller/theme_controller.dart';
import 'package:todo_app/app/screens/list_of_tasks_screen.dart';
import 'package:todo_app/app/services/notification_service.dart';
import 'package:todo_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ThemeController());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService notificationService = NotificationService();
  await notificationService.initialize();
  await initializeNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final themeCtrl = Get.find<ThemeController>();
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'To-Do List App',
        debugShowCheckedModeBanner: false,
        theme: themeCtrl.lightTheme,
        darkTheme: themeCtrl.darkTheme,
        themeMode: themeCtrl.themeMode.value,
        home: ListOfTasksScreen(),
      ),
    );
  }
}
