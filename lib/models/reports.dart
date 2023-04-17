class MyData {

   String? day;
   String? morning;
   String? evening;

  MyData(
      {
      required this.day,
      required this.morning,
      required this.evening});

  factory MyData.fromMap(Map<String, dynamic> map) {
    return MyData(
     
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
