class User {
  int id;
  String name;
  String email;
  int access;
  String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.access,
    required this.token,
  });

  factory User.fromJSON(Map<String, dynamic> body, String token) {
    return User(
      id: body["client_id"],
      name: body["name"],
      email: body["email"],
      access: body["access"],
      token: token,
    );
  }
}
