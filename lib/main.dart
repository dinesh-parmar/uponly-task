import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:uponly_task/util/employee_persist_store.dart';
import 'package:uponly_task/view/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*final prefs = await SharedPreferences.getInstance();
  prefs.clear();*/
  await RM.storageInitializer(EmployeePersistStore());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: RM.navigate.navigatorKey,
      title: 'Employee Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}
