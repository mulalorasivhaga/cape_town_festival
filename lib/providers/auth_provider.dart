import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// State provider for the current user
final currentUserProvider = StateProvider<User?>((ref) {
  return FirebaseAuth.instance.currentUser;
});

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<User?> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  AuthNotifier() : super(null) {
    _auth.authStateChanges().listen((User? user) {
      state = user;
    });
  }

  bool get isAuthenticated => state != null;

  Future<void> signOut() async {
    await _auth.signOut();
  }
}