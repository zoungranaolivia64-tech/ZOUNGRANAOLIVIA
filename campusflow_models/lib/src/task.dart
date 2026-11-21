/// Une tâche ou échéance d'un étudiant. Objet immuable : pour la modifier,
/// on crée une copie avec [copyWith].
class Task {
  const Task({
    this.id,
    required this.title,
    required this.courseId,
    required this.dueDate,
    this.description = '',
    this.done = false,
  });

  final int? id;
  final String title;
  final int courseId;
  final DateTime dueDate;
  final String description;
  final bool done;

  Task copyWith({
    int? id,
    String? title,
    int? courseId,
    DateTime? dueDate,
    String? description,
    bool? done,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      done: done ?? this.done,
    );
  }

  /// Construit une tâche depuis un document JSON.
  /// Lance une [FormatException] si un champ obligatoire est absent ou invalide.
  factory Task.fromJson(Map<String, dynamic> json) {
    final title = json['title'];
    if (title is! String || title.trim().isEmpty) {
      throw const FormatException('Champ "title" manquant ou vide');
    }
    final courseId = json['courseId'];
    if (courseId is! int) {
      throw const FormatException('Champ "courseId" manquant ou invalide');
    }
    final due = json['dueDate'] is String
        ? DateTime.tryParse(json['dueDate'] as String)
        : null;
    if (due == null) {
      throw const FormatException('Champ "dueDate" manquant ou invalide');
    }
    return Task(
      id: json['id'] as int?,
      title: title,
      courseId: courseId,
      dueDate: due,
      description: (json['description'] as String?) ?? '',
      done: (json['done'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'title': title,
        'courseId': courseId,
        'dueDate': dueDate.toIso8601String(),
        'description': description,
        'done': done,
      };

  /// Une tâche est en retard si elle n'est pas faite et que l'échéance est passée.
  bool isOverdue([DateTime? now]) => !done && dueDate.isBefore(now ?? DateTime.now());

  @override
  bool operator ==(Object other) =>
      other is Task &&
      other.id == id &&
      other.title == title &&
      other.courseId == courseId &&
      other.dueDate == dueDate &&
      other.description == description &&
      other.done == done;

  @override
  int get hashCode => Object.hash(id, title, courseId, dueDate, description, done);

  @override
  String toString() => 'Task($id, $title, done: $done)';
}
