import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // Импортируйте ваши настройки Firebase
import 'screens/schedule_screen.dart'; // Импортируем экран расписания

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Расписание',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScheduleScreen(), // Экран расписания
      // Добавьте маршрутизацию для админ-панели, если потребуется
      // routes: {
      //   '/admin': (context) => AdminPanel(),
      // },
    );
  }
}
