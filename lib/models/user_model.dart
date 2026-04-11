class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String image;
  final String token;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.image,
    required this.token,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:        json['id']        ?? 0,
      firstName: json['firstName'] ?? '',
      lastName:  json['lastName']  ?? '',
      username:  json['username']  ?? '',
      email:     json['email']     ?? '',
      image:     json['image']     ?? '',
      token:     json['accessToken'] ?? json['token'] ?? '',
    );
  }
}
