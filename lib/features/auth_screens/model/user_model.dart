// lib/features/auth/models/user_model.dart

class User {

  final String firstName;
  final String lastName;
  final String email;
  final String age;
  final String gender;
  final DateTime createdAt;

  User({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.email,
    required this.gender,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'email': email,
      'gender': gender,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      age: map['age'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }

  User copyWith({
    String? firstName,
    String? lastName,
    String? age,
    String? email,
    String? gender,
    DateTime? createdAt,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User('
        'firstName: $firstName,'
        ' lastName: $lastName,'
        ' age: $age,'
        ' email: $email,'
        ' gender: $gender';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.age == age &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
    lastName.hashCode ^
    age.hashCode ^
    email.hashCode ^
    gender.hashCode;
  }
}