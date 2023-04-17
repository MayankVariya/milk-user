class MonthDataModel{
  String? monthName;
  List<DateData>? dates;
  MonthDataModel({required this.monthName,required this.dates});
}

class DateData {
  String? day;
  String? morning;
  String? evening;

  DateData({required this.day, required this.morning, required this.evening});

  factory DateData.fromMap(Map<String, dynamic> map) {
    return DateData(
      day: map['Date'],
      morning: map['morning'],
      evening: map['evening'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Date': day,
      'morning': morning,
      'evening': evening,
    };
  }
}
