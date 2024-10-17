import 'package:google_maps_flutter/google_maps_flutter.dart';

enum UserRole { admin, customer }

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final UserRole role;
  final String fcmToken;
  final String? streetAddress;
  final LatLng? addressLocation;
  final List<String> favorites;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.role,
    this.fcmToken = "",
    this.streetAddress,
    this.addressLocation,
    this.favorites = const [],
  });

  bool get isAdmin => role == UserRole.admin;

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        uid: data["uid"],
        email: data["email"],
        displayName: data["displayName"],
        photoURL: data["photoURL"],
        role: UserRole.values.firstWhere((e) => e.name == data["role"]),
        fcmToken: data["fcmToken"] ?? "",
        streetAddress: data["streetAddress"],
        addressLocation: data["addressLocation"] != null
            ? LatLng(data["addressLocation"]["latitude"], data["addressLocation"]["longitude"])
            : null,
        favorites: data["favorites"] != null ? List<String>.from(data["favorites"]) : [],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "email": email,
        "displayName": displayName,
        "photoURL": photoURL,
        "role": role,
        "fcmToken": fcmToken,
        "streetAddress": streetAddress,
        "addressLocation": addressLocation != null
            ? {
                "latitude": addressLocation!.latitude,
                "longitude": addressLocation!.longitude,
              }
            : null,
        "favorites": favorites,
      };
}
