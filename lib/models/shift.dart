
class Shift {
  String day;
  String startTime;
  String endTime;

  Shift({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'startTime': startTime,
    'endTime': endTime,
  };

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
    day: json['day'],
    startTime: json['startTime'],
    endTime: json['endTime'],
  );
}
