enum UserRole { admin, customer }

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final UserRole role;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.role,
  });

  bool get isAdmin => role == UserRole.admin;

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        uid: data["uid"],
        email: data["email"],
        displayName: data["displayName"],
        photoURL: data["photoURL"],
        role: UserRole.values.firstWhere((e) => e.name == data["role"]),
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "email": email,
        "displayName": displayName,
        "photoURL": photoURL,
        "role": role,
      };
}
