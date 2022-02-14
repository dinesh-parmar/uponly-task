import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/marked_date.dart';
import 'package:flutter_calendar_carousel/classes/multiple_marked_dates.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:uponly_task/data/model/attendance_report.dart';
import 'package:uponly_task/util/states.dart';

class EmployeeAttendanceTable extends StatelessWidget {
  final int employeeId;
  final String markFor;

  EmployeeAttendanceTable({Key? key, required this.employeeId, required this.markFor}) : super(key: key);

  final _markedDataIN = RM.inject<List<MarkedDate>>(() => <MarkedDate>[]);
  final _now = DateTime.now();
  MultipleMarkedDates get markedDates => MultipleMarkedDates(markedDates: _markedDataIN.state);

  bool get _markedForPresent => markFor == "present";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: OnBuilder(
        listenToMany: [listOfEmployees, _markedDataIN],
        sideEffects: SideEffects(
          initState: () {
            if (listOfEmployees.state[employeeId - 1].attendanceReport == null) return;
            _markedDataIN.setState((s) {
              if (_markedForPresent) {
                final listOfSelectedDates =
                    listOfEmployees.state[employeeId - 1].attendanceReport?.presentDates?.map((e) => MarkedDate(color: Colors.green, date: e)).toList() ?? <MarkedDate>[];
                s.addAll(listOfSelectedDates);
              } else {
                final listOfSelectedDates =
                    listOfEmployees.state[employeeId - 1].attendanceReport?.halfPresentDates?.map((e) => MarkedDate(color: Colors.purple, date: e)).toList() ??
                        <MarkedDate>[];
                s.addAll(listOfSelectedDates);
              }
              return s;
            });
          },
        ),
        builder: () => CalendarCarousel(
          onDayPressed: (DateTime dateTime, List event) {
            if (dateTime.weekday == DateTime.sunday) return;
            listOfEmployees.setState((s) {
              s[employeeId - 1].attendanceReport ??= AttendanceReport();
              final attendanceReport = s[employeeId - 1].attendanceReport;
              if (markFor == "present") {
                if (attendanceReport!.presentDates == null) attendanceReport.presentDates = {};
                _markedDataIN.setState((m) {
                  if (attendanceReport.presentDates!.contains(dateTime)) {
                    attendanceReport.presentDates?.remove(dateTime);
                    m.remove(MarkedDate(color: Colors.green, date: dateTime));
                  } else {
                    attendanceReport.presentDates?.add(dateTime);
                    m.add(MarkedDate(color: Colors.green, date: dateTime));
                  }
                });
              } else {
                if (attendanceReport!.halfPresentDates == null) attendanceReport.halfPresentDates = {};
                _markedDataIN.setState((m) {
                  if (attendanceReport.halfPresentDates!.contains(dateTime)) {
                    attendanceReport.halfPresentDates?.remove(dateTime);
                    m.remove(MarkedDate(color: Colors.purple, date: dateTime));
                  } else {
                    attendanceReport.halfPresentDates?.add(dateTime);
                    m.add(MarkedDate(color: Colors.purple, date: dateTime));
                  }
                });
              }
            });
          },
          pageScrollPhysics: const PageScrollPhysics(),
          multipleMarkedDates: markedDates,
          maxSelectedDate: _now,
          todayButtonColor: markedDates.isMarked(DateTime(_now.year, _now.month, _now.day)) ? Colors.green : Colors.transparent,
          todayTextStyle: TextStyle(color: markedDates.isMarked(DateTime(_now.year, _now.month, _now.day)) ? Colors.black : Colors.green),
        ),
      ),
    );
  }
}
