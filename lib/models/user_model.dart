enum UserRole { admin, customer }

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final UserRole role;
  final String fcmToken;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.role,
    this.fcmToken = "",
  });

  bool get isAdmin => role == UserRole.admin;

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        uid: data["uid"],
        email: data["email"],
        displayName: data["displayName"],
        photoURL: data["photoURL"],
        role: UserRole.values.firstWhere((e) => e.name == data["role"]),
        fcmToken: data["fcmToken"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "email": email,
        "displayName": displayName,
        "photoURL": photoURL,
        "role": role,
        "fcmToken": fcmToken,
      };
}
