import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/features/auth_screens/view/login_view.dart';
import 'package:ct_festival/features/dashboard_screen/admin/view/admin_dashboard_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:ct_festival/features/auth_screens/model/user_model.dart' as auth;
import 'package:ct_festival/features/auth_screens/model/admin_model.dart' as auth;
import 'package:ct_festival/features/auth_screens/controller/email_verification.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/utils/logger.dart';

class AuthService {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;

  AuthService({
    required FirebaseFirestore firestore,
    required firebase_auth.FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  /// Login user
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

  /// Register user
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

  /// Get current user
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

  ///Check if user email is verified
  Future<bool> isEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }
  /// Check if the user is an admin
  Future<void> checkAdmin(BuildContext context) async {
    final AppLogger logger = AppLogger();
    final user = firebase_auth.FirebaseAuth.instance.currentUser;

    if (user == null) {
      logger.logDebug('No user is currently logged in.');
      if (!context.mounted) return; // Ensure context is still valid
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return;
    }

    logger.logDebug('User ID: ${user.uid}');
    final userDoc = await FirebaseFirestore.instance.collection('admins').doc(user.uid).get();

    if (!userDoc.exists) {
      logger.logDebug('Admin document does not exist.');
      if (!context.mounted) return; // Check if context is still valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This link is only for admin, not permitted for users')),
      );
      return;
    }

    logger.logDebug('User is an admin.');
    if (!context.mounted) return; // Check before navigation
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminDashboardView()),
    );
  }

  /// Get User Profile by ID
  Future<auth.User> getUserProfileById(String userId) async {
    final docSnapshot = await _firestore.collection('users').doc(userId).get();
    if (docSnapshot.exists) {
      return auth.User.fromMap(docSnapshot.data()!);
    } else {
      throw Exception('User not found');
    }
  }
}

