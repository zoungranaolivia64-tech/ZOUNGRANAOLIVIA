/// Un cours suivi par l'étudiant.
class Course {
  const Course({
    required this.id,
    required this.name,
    required this.teacher,
    this.color = '#1E5AA8',
  });

  final int id;
  final String name;
  final String teacher;

  /// Couleur d'accent au format hexadécimal (#RRGGBB).
  final String color;

  Course copyWith({int? id, String? name, String? teacher, String? color}) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      teacher: teacher ?? this.teacher,
      color: color ?? this.color,
    );
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    if (id is! int || name is! String) {
      throw const FormatException('Cours invalide : "id" ou "name" manquant');
    }
    return Course(
      id: id,
      name: name,
      teacher: (json['teacher'] as String?) ?? '',
      color: (json['color'] as String?) ?? '#1E5AA8',
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'teacher': teacher, 'color': color};

  @override
  bool operator ==(Object other) =>
      other is Course &&
      other.id == id &&
      other.name == name &&
      other.teacher == teacher &&
      other.color == color;

  @override
  int get hashCode => Object.hash(id, name, teacher, color);
}
