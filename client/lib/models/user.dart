class User {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String companyName;
  final String companySector;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.companyName,
    required this.companySector,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      role: json['role'],
      companyName: json['companyName'],
      companySector: json['companySector'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      'companyName': companyName,
      'companySector': companySector,
    };
  }
} 