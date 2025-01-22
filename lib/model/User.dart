class User {
  final String username;
  final String email;
  final String password;
  final String country;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.country,
  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      country: json['country'],
    );
  }

  // Method to convert a User to JSON format
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'country': country,
    };
  }
}
