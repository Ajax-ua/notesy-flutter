class User {
  String? id;
  String email;
  String name;

  User({ 
    this.id,
    required this.email,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'email': email,
    'name': name,
  };

  @override
  String toString() {
    return 'User: id = $id, email = $email, name = $name';
  }
}