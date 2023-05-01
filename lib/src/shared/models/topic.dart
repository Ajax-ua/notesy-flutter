class Topic {
  String? id;
  String label;

  Topic({ this.id, required this.label });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'label': label,
  };

  @override
  String toString() {
    return 'Topic: id = $id, label = $label';
  }
}