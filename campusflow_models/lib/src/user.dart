/// L'utilisateur de l'application (l'étudiant).
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.filiere = '',
  });

  final int id;
  final String name;
  final String email;
  final String filiere;

  User copyWith({int? id, String? name, String? email, String? filiere}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      filiere: filiere ?? this.filiere,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final email = json['email'];
    if (id is! int || name is! String || email is! String) {
      throw const FormatException('Utilisateur invalide');
    }
    return User(
      id: id,
      name: name,
      email: email,
      filiere: (json['filiere'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'email': email, 'filiere': filiere};

  @override
  bool operator ==(Object other) =>
      other is User &&
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.filiere == filiere;

  @override
  int get hashCode => Object.hash(id, name, email, filiere);
}
