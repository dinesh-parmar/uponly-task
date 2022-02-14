import 'dart:convert';

import 'package:states_rebuilder/states_rebuilder.dart';

import '../data/model/employee.dart';

final listOfEmployees = RM.inject<List<Employee>>(
  () => <Employee>[],
  initialState: <Employee>[],
  persist: () => PersistState(
    key: 'employees',
    toJson: (List<Employee>? list) => jsonEncode({"employees": list?.map((e) => e.toJson()).toList()}),
    fromJson: (String s) => (jsonDecode(s)["employees"] as List<dynamic>).map<Employee>((e) => Employee.fromJson(e)).toList(),
  ),
  debugPrintWhenNotifiedPreMessage: "List<Employee>",
  isLazy: false,
);

List<Employee> get employees => listOfEmployees.state;
