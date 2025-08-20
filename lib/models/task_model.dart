class Task {
  int? id;
  String title;
  bool completed;

  Task({this.id, required this.title, this.completed = false});

  /// From json function
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: (json['completed'] as int) == 1,
    );
  }

  /// To json with ID function
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': completed ? 1 : 0,
  };

  // Convertit la tâche en Map pour l'insertion dans la DB (sans l'ID, car il est auto-incrémenté)
  Map<String, dynamic> toJsonWithoutId() => {
    'title': title,
    'completed': completed ? 1 : 0,
  };

  // Méthode copyWith pour créer une nouvelle instance de Task avec des propriétés modifiées
  Task copyWith({int? id, String? title, bool? completed}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
