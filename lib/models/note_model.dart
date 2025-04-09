class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdTime;
  final int colorId;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdTime,
    required this.colorId,
  });

  Note copy({
    int? id,
    String? title,
    String? content,
    DateTime? createdTime,
    int? colorId,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdTime: createdTime ?? this.createdTime,
        colorId: colorId ?? this.colorId,
      );

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'createdTime': createdTime.toIso8601String(),
    'colorId': colorId,
  };

  static Note fromJson(Map<String, Object?> json) => Note(
    id: json['id'] as int?,
    title: json['title'] as String,
    content: json['content'] as String,
    createdTime: DateTime.parse(json['createdTime'] as String),
    colorId: json['colorId'] as int,
  );
}