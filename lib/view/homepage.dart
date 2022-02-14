import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:uponly_task/data/model/employee.dart';
import 'package:uponly_task/util/states.dart';
import 'package:uponly_task/view/employee_edit.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final searchText = "".inj();

  final _dataColumns = [
    const DataColumn(label: Text("ID")),
    const DataColumn(label: Text("Name")),
    const DataColumn(label: Text("Department")),
    const DataColumn(label: Text("Attendance"))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employee Dashboard")),
      body: OnBuilder(
        listenToMany: [listOfEmployees, searchText],
        sideEffects: SideEffects(
            initState: () => print("Employees List is ${listOfEmployees.state.toString()}"),
            onSetState: (snapState) => print("Employees List is ${listOfEmployees.state.toString()}")),
        builder: () {
          return Column(
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  decoration: const InputDecoration(label: Text("Search"), icon: Icon(Icons.search)),
                  onChanged: (value) => searchText.setState((s) => value.trim()),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: _dataColumns,
                    rows: (searchText.state.isNotEmpty
                            ? employees.where((element) =>
                                element.name.toLowerCase().contains(searchText.state.toLowerCase()) ||
                                element.id.toString().toLowerCase().contains(searchText.state.toLowerCase()) ||
                                element.department.toLowerCase().contains(searchText.state.toLowerCase()))
                            : employees)
                        .map((e) {
                      return DataRow(cells: [
                        DataCell((Text(e.id.toString()))),
                        DataCell(Text(e.name)),
                        DataCell(Text(e.department)),
                        DataCell(IconButton(icon: const Icon(Icons.edit), onPressed: () => RM.navigate.to(EmployeeEdit(employeeId: e.id))))
                      ]);
                    }).toList(),
                  ),
                ),
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => RM.navigate.to(EmployeeEdit()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
