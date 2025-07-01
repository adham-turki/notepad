class User {
  final int? id;
  final String email;
  final String password;
  final String name;
  final String? profilePicture;
  final DateTime createdAt;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.name,
    this.profilePicture,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'profile_picture': profilePicture,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      name: map['name'],
      profilePicture: map['profile_picture'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
