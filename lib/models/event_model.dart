class Event {
  final int? id;
  final String title;
  final String description;
  final DateTime date;
  final bool isAllDay;
  final DateTime? startTime;
  final DateTime? endTime;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isAllDay = false,
    this.startTime,
    this.endTime,
  });

  Event copy({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    bool? isAllDay,
    DateTime? startTime,
    DateTime? endTime,
  }) =>
      Event(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date ?? this.date,
        isAllDay: isAllDay ?? this.isAllDay,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
      );

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'date': date.toIso8601String(),
    'isAllDay': isAllDay ? 1 : 0,
    'startTime': startTime?.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
  };

  static Event fromJson(Map<String, Object?> json) => Event(
    id: json['id'] as int?,
    title: json['title'] as String,
    description: json['description'] as String,
    date: DateTime.parse(json['date'] as String),
    isAllDay: (json['isAllDay'] as int) == 1,
    startTime: json['startTime'] != null
        ? DateTime.parse(json['startTime'] as String)
        : null,
    endTime: json['endTime'] != null
        ? DateTime.parse(json['endTime'] as String)
        : null,
  );
}