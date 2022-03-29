class EventEntry {
  int id;
  int userId;
  int eventId;
  int marks = 0;
  EventEntry({
    required this.id,
    required this.userId,
    required this.eventId,
  });
  factory EventEntry.fromJSON(Map<String, dynamic> body) {
    return EventEntry(
      id: body["id"],
      userId: body["user_id"],
      eventId: body["event_id"],
    );
  }
}
