import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:uponly_task/data/model/attendance_report.dart';
import 'package:uponly_task/data/model/employee.dart';
import 'package:uponly_task/util/helpers.dart';
import 'package:uponly_task/util/states.dart';
import 'package:uponly_task/view/widget/calendar_table.dart';

class EmployeeEdit extends StatelessWidget {
  final int? employeeId;

  EmployeeEdit({Key? key, this.employeeId}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _departmentValue = RM.inject<String>(() => "");
  final _departmentDropdownValue = RM.inject<Department?>(() => null);

  final _attendanceType = RM.inject(() => markFor.present);

  bool get markAttendance => employeeId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(markAttendance ? "Mark Attendance" : "Add Employee")),
      body: SafeArea(
        minimum: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: OnBuilder(
            listenToMany: [_departmentDropdownValue, _attendanceType],
            sideEffects: SideEffects(
              initState: () {
                if (!markAttendance) return;
                final employee = listOfEmployees.state[employeeId! - 1];
                if (markAttendance) {
                  _nameController.text = employee.name;
                  _addressController.text = employee.address;
                  _departmentDropdownValue.setState((s) {
                    return s = Department.values.firstWhere((element) => element.name == employee.department, orElse: () => Department.Others);
                  });
                  if (_departmentDropdownValue.state == Department.Others) {
                    _departmentValue.setState((s) => employee.department);
                  }
                }
              },
            ),
            builder: () => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Name"),
                    ),
                    readOnly: markAttendance,
                    validator: (value) {
                      if (value == null || (value.isEmpty)) {
                        return "This Field is mandatory";
                      }
                      return null;
                    },
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Address"),
                    ),
                    readOnly: markAttendance,
                    controller: _addressController,
                    validator: (value) {
                      if (value == null || (value.isEmpty)) {
                        return "This Field is mandatory";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<Department>(
                    hint: const Text("Department"),
                    value: _departmentDropdownValue.state,
                    items: Department.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
                    onChanged: markAttendance
                        ? null
                        : (value) {
                            _departmentValue.setState((s) {
                              if (value != null && value != Department.Others) return value.name;
                            });
                            _departmentDropdownValue.setState((s) => value);
                          },
                    validator: (value) {
                      if (value == null) {
                        return "This Field is mandatory";
                      }
                    },
                  ),
                  if (_departmentDropdownValue.state == Department.Others) ...{
                    TextFormField(
                      readOnly: markAttendance,
                      initialValue: _departmentValue.state,
                      decoration: const InputDecoration(label: Text("Please mention, if others")),
                      onChanged: (value) => _departmentValue.setState((s) => value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This Field is mandatory";
                        }
                      },
                    ),
                  },
                  if (markAttendance) ...{
                    SizedBox(
                      height: 80,
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<markFor>(
                              title: const Text("Present"),
                              value: markFor.present,
                              groupValue: _attendanceType.state,
                              onChanged: (value) => _attendanceType.setState((s) => value),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<markFor>(
                              title: const Text("Half Present"),
                              value: markFor.halfPresent,
                              groupValue: _attendanceType.state,
                              onChanged: (value) => _attendanceType.setState((s) => value),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 400,
                      child: EmployeeAttendanceTable(
                        key: UniqueKey(),
                        markFor: _attendanceType.state.name,
                        employeeId: employeeId!,
                      ),
                    ),
                    const Text(
                      '''• No Color = Absent.\n• Purple Color = Half Present.\n• Green Color =  Present.''',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                  },
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !markAttendance,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            child: const Text("Add Employee"),
            onPressed: () async {
              if (_formKey.currentState?.validate() != true) return;
              listOfEmployees.setState((s) {
                s.add(Employee(id: s.length + 1, name: _nameController.text, address: _addressController.text, department: _departmentValue.state));
              });
              await showSimpleDialog("Employee Added", message: "Employee has been added to database successfully");
              RM.navigate.back();
            },
          ),
        ),
      ),
    );
  }
}

enum Department {
  Technology,
  Operation,
  HR,
  Management,
  Marketing,
  Others,
}
enum markFor {
  present,
  halfPresent,
}
