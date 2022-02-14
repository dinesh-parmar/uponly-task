class AttendanceReport {
  Set<DateTime>? presentDates;
  Set<DateTime>? halfPresentDates;

  AttendanceReport({this.presentDates, this.halfPresentDates});

  Map<String, dynamic> toJson() =>
      {"presentDates": presentDates?.map((e) => e.toString()).toList(), "halfPresentDates": halfPresentDates?.map((e) => e.toString()).toList()};

  factory AttendanceReport.fromJson(json) => AttendanceReport(
        presentDates: json["presentDates"] == "null" ? null : (json["presentDates"] as List<dynamic>?)?.map<DateTime>((e) => DateTime.parse(e)).toSet(),
        halfPresentDates: json["halfPresentDates"] == "null" ? null : (json["halfPresentDates"] as List<dynamic>?)?.map<DateTime>((e) => DateTime.parse(e)).toSet(),
      );
}
