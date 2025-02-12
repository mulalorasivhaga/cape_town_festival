import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:ct_festival/features/auth_screens/model/user_model.dart' as auth;
import 'package:ct_festival/features/auth_screens/model/admin_model.dart' as auth;
import 'package:ct_festival/features/auth_screens/controller/email_verification.dart';

class AuthService {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;

  AuthService({
    required FirebaseFirestore firestore,
    required firebase_auth.FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  Future<(Object?, String)> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          return (auth.User.fromMap(userDoc.data()!), 'Success');
        }

        final adminDoc = await _firestore
            .collection('admins')
            .doc(userCredential.user!.uid)
            .get();

        if (adminDoc.exists) {
          return (auth.Admin.fromMap(adminDoc.data()!), 'Success');
        }
      }
      return (null, 'Login failed');
    } catch (e) {
      return (null, e.toString());
    }
  }

  Future<(Object?, String)> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required String age,
    required String password,
  }) async {
    try {
      // Verify the email address
      final (isValid, message) = await EmailVerificationService().verifyEmail(email);
      if (!isValid) {
        return (null, message);
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Send email verification
        await userCredential.user!.sendEmailVerification();

        // Check if the email domain is 'uct.ac.za' or 'myuct.ac.za'
        bool isAdmin = email.endsWith('@uct.ac.za') || email.endsWith('@myuct.ac.za');

        if (isAdmin) {
          final admin = auth.Admin(
            firstName: firstName,
            lastName: lastName,
            email: email,
            createdAt: DateTime.now(),
          );

          await _firestore
              .collection('admins')
              .doc(userCredential.user!.uid)
              .set(admin.toMap());

          return (admin, 'Registration successful. Please verify your email.');
        } else {
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
      }
      return (null, 'Registration failed');
    } catch (e) {
      return (null, e.toString());
    }
  }

  Future<Object?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return auth.User.fromMap(userDoc.data()!);
        }

        final adminDoc = await _firestore.collection('admins').doc(user.uid).get();
        if (adminDoc.exists) {
          return auth.Admin.fromMap(adminDoc.data()!);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }


}

