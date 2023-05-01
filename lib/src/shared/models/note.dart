class Note {
  String? id;
  String title;
  String text;
  String topicId;
  String userId;
  int createdAt;

  Note({
    this.id,
    required this.title,
    required this.text,
    required this.topicId,
    required this.userId,
    required this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      text: json['text'],
      topicId: json['topicId'],
      userId: json['userId'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'title': title,
    'text': text,
    'topicId': topicId,
  };
}