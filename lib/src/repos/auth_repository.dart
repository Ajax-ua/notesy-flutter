import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository._() : super();
  static final AuthRepository _instance = AuthRepository._();
  factory AuthRepository() {
    return _instance;
  }

  final FirebaseAuth _fbAuth = FirebaseAuth.instance;

  Future<UserCredential> signup({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _fbAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw('The account already exists for that email.');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _fbAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw('Wrong password provided for that user.');
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    await _fbAuth.signOut();
  }
}