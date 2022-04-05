import 'dart:convert';

class UserModel {
  String email;
  String username;
  String profilePhoto;
  UserModel({
    required this.email,
    required this.username,
    required this.profilePhoto,
  });

  UserModel copyWith({
    String? email,
    String? username,
    String? profilePhoto,
  }) {
    return UserModel(
      email: email ?? this.email,
      username: username ?? this.username,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Email': email,
      'Username': username,
      'Profile Picture': profilePhoto,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['Email'] ?? '',
      username: map['Username'] ?? '',
      profilePhoto: map['Profile Picture'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserModel(email: $email, username: $username, profilePhoto: $profilePhoto)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.email == email &&
        other.username == username &&
        other.profilePhoto == profilePhoto;
  }

  @override
  int get hashCode =>
      email.hashCode ^ username.hashCode ^ profilePhoto.hashCode;
}
