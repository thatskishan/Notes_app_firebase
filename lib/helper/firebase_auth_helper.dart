import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();
  static final FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper._();

  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>> logInAnonymously() async {
    Map<String, dynamic> data = {};

    try {
      UserCredential userCredential = await firebaseAuth.signInAnonymously();

      User? user = userCredential.user;
      data['user'] = user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case "admin-restricted-operation":
          data['msg'] = "This service is temporary disabled";
          break;
      }
    }
    return data;
  }

  Future<Map<String, dynamic>> signUp(
      {required String email, required String password}) async {
    Map<String, dynamic> data = {};

    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      data['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          data['msg'] = "This service is temporary disabled";
          break;
      }
    }

    return data;
  }

  Future<Map<String, dynamic>> logIn(
      {required String email, required String password}) async {
    Map<String, dynamic> data = {};

    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      data['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          data['msg'] = "This service is temporary disabled";
          break;
        case "wrong-password":
          data['msg'] = "Password incorrect.....";
          break;
        case "user-not-found":
          data['msg'] = "No user found on this email";
          break;
      }
    }

    return data;
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    Map<String, dynamic> data = {};
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    try {
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      User? user = userCredential.user;
      data['user'] = user;
    } on FirebaseAuthException catch (e) {
      print("=================");
      print(e.code);
      print("=================");
      switch (e.code) {
        case "operation-not-allowed":
          data['msg'] = "This Service is Temporary disabled...";
          break;
      }
    }
    return data;
  }

  Future<void> logOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
