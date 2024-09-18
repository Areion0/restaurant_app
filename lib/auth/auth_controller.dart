import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Signs in the user with Google.
Future<UserCredential?> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final OAuthCredential? credential;

  try {
    credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
  } catch (e) {
    throw Exception("Failed to create credential: $e");
  }

  // Once signed in, return the UserCredential
  UserCredential? userCredential;

  try {
    userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  } on Exception catch (e) {
    throw Exception("Failed to sign in with credential: $e");
  }

  return userCredential;
}

/// Signs out the current user.
Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
}