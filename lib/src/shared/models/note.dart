class Note {
  String? id;
  String title;
  String text;
  String topicId;
  String? userId;
  int? createdAt;

  Note({
    this.id,
    required this.title,
    required this.text,
    required this.topicId,
    this.userId,
    this.createdAt,
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
    // id and createdAt are commented out to remove them from patch request which doesn't allow those fields to be included
    // if (id != null) 'id': id,
    'title': title,
    'text': text,
    'topicId': topicId,
    if (userId != null) 'userId': userId,
    // if (createdAt != null) 'createdAt': createdAt,
  };

  @override
  String toString() {
    return 'Note: id = $id, title = $title, text = $text, topicId = $topicId, userId = $userId, createdAt = $createdAt';
  }
}