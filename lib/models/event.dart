import 'package:intl/intl.dart';

class Event {
  int id;
  String name;
  String description;
  DateTime startTime;
  DateTime endTime;
  int marks;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.marks,
  });

  factory Event.fromJSON(Map<String, dynamic> body) {
    return Event(
      id: body["id"],
      name: body["event_name"],
      description: body["description"],
      startTime: DateFormat("yyyy-MM-dd").parse(body["starting_time"]),
      endTime: DateFormat("yyyy-MM-dd").parse(body["ending_time"]),
      marks: body["marks"] ?? -1,
    );
  }
}
