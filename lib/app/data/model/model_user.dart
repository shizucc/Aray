class UserModel {
  String? email;
  String? username;
  String role;

  UserModel({required this.email, required this.username, this.role = 'user'});

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
            email: json['email'],
            username: json['username'],
            role: json['role']);

  Map<String, Object?> toJson() {
    return {'email': email, 'username': username, 'role': role};
  }
}
