class UserModel {
  final String name;
  final String email;
  final String photoUrl;
  final String uid;
  final String? token;

  UserModel({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.uid,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      uid: json['_id'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'uid': uid,
      'token': token,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? uid,
    String? token,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      uid: uid ?? this.uid,
      token: token ?? this.token,
    );
  }
}
