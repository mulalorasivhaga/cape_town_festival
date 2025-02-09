import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:ct_festival/features/auth_screens/model/user_model.dart' as auth;

class AuthService {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;

// AuthService class constructor
  AuthService({
    required FirebaseFirestore firestore,
    required firebase_auth.FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  // Login user method
  Future<(auth.User?, String)> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final docSnapshot = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (docSnapshot.exists) {
          return (auth.User.fromMap(docSnapshot.data()!), 'Success');
        }
      }
      return (null, 'Login failed');
    } catch (e) {
      return (null, e.toString());
    }
  }

  // Register user method
  Future<(auth.User?, String)> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required String age,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Send email verification
        await userCredential.user!.sendEmailVerification();

        final user = auth.User(
          firstName: firstName,
          lastName: lastName,
          email: email,
          gender: gender,
          age: age,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toMap());

        return (user, 'Registration successful. Please verify your email.');
      }
      return (null, 'Registration failed');
    } catch (e) {
      return (null, e.toString());
    }
  }

  // getCurrentUser method
  Future<auth.User?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return auth.User.fromMap(doc.data()!);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Check email verification status
  Future<bool> isEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

}