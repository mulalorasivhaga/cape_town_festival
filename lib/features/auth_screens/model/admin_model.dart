class Admin {
  final String firstName;
  final String lastName;
  final String email;
  final DateTime createdAt;

  Admin({
    required this.firstName,
    required this.lastName,
    required this.email,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  Admin copyWith({
    String? firstName,
    String? lastName,
    String? email,
    DateTime? createdAt,
  }) {
    return Admin(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Admin(firstName: $firstName,'
        'lastName: $lastName,'
        'email: $email';
  }
}
