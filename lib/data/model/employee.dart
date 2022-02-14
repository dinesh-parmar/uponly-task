import 'dart:convert';

import 'package:uponly_task/data/model/attendance_report.dart';

class Employee {
  int id;
  String name;
  String address;
  String department;
  AttendanceReport? attendanceReport;

  Employee({required this.id, required this.name, required this.address, this.attendanceReport, required this.department});

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "department": department,
        "attendanceReport": jsonEncode(attendanceReport?.toJson()),
      };

  factory Employee.fromJson(json) {
    return Employee(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      department: json["department"],
      attendanceReport: json["attendanceReport"] == "null" ? null : AttendanceReport.fromJson(jsonDecode(json["attendanceReport"])),
    );
  }
  @override
  String toString() => toJson().toString();
}
