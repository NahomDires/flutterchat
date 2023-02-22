class User {
  final String id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data['name'];
    final String email = data['email'];

    return User(
      id: documentId,
      name: name,
      email: email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
