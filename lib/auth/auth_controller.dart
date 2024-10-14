import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:restaurant_app/misc/extensions.dart';

import '../firebase/firestore_controller.dart';
import '../models/user_model.dart';

class AuthController with ChangeNotifier {
  UserCredential? userCredential;
  User? firebaseUser;

  Future<String> get idToken async => await firebaseUser?.getIdToken() ?? "";
  UserModel? _user;

  UserModel? get user => _user;

  set user(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> refreshUserData({String? uid}) async {
    if (uid == null && user == null) return;
    uid ??= user!.uid;

    user = UserModel.fromMap(await FirestoreController.getDocument("users", uid));
  }

  Future<void> signIn() async =>
      await signInWithGoogle().then((credential) async => await signInWithCredential(credential));

  /// Signs in the user with Google.
  Future<OAuthCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    try {
      return GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
    } catch (e, s) {
      Logger().e(s);
      throw Exception("Failed to create credential: $e");
    }
  }

  Future<OAuthCredential> signInWithGoogleSilently() async {
    Logger logger = Logger();

    logger.i("Signing in with Google silently...");

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signInSilently();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    try {
      return GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
    } catch (e, s) {
      logger.e(s);
      throw Exception("Failed to create credential: $e");
    } finally {
      logger.i("Signed in with Google silently");
    }
  }

  /// Signs in the user to FirebaseAuth with [OAuthCredential].
  Future<UserCredential> signInWithCredential(OAuthCredential credential) async {
    try {
      userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      firebaseUser = userCredential?.user;
    } on FirebaseAuthException catch (e, s) {
      Logger().e(s);
      throw Exception("Failed to sign in with credential: ${e.message}");
    } catch (e, s) {
      Logger().e(s);
      throw Exception("An unknown error occurred during sign-in: $e");
    }

    if (userCredential?.user == null) {
      throw Exception("User is null after sign-in");
    }

    if (userCredential?.additionalUserInfo?.isNewUser ?? false) {
      try {
        await FirestoreController.addNewUser(userCredential!.user!);
        Logger().i("New user added to Firestore ${userCredential!.user!.toMap()} ");
      } on Exception catch (e, s) {
        Logger().e(s);
        throw Exception("Failed to add user to Firestore: $e");
      }
    }

    return userCredential!;
  }

  /// Signs out the current user.
  Future<void> signOut(BuildContext context) async {
    context.homeController.reset();
    context.cartController.clear(notify: false);

    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    user = null;
    firebaseUser = null;
    userCredential = null;
  }
}

extension UserExtension on User {
  Map<String, dynamic> toMap() => {
        "uid": uid,
        "email": email,
        "displayName": displayName,
        "photoURL": photoURL,
      };
}
