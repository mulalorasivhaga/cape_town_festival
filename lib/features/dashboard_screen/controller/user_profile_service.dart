import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/utils/logger.dart';


class UserProfileService {
  final AppLogger logger = AppLogger();
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// function to get the user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          logger.logInfo('✅ User data retrieved successfully: ${user.uid}');
          return userDoc.data();
        } else {
          logger.logWarning('⚠️ User profile not found in Firestore.');
          return null;
        }
      } else {
        logger.logWarning('⚠️ No user is currently signed in.');
        return null;
      }
    } catch (e) {
      logger.logError('❌ Error fetching user data: $e');
      return null;
    }
  }

  /// function to get the admin profile
  Future<Map<String, dynamic>?> getAdminProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _firestore.collection('admins').doc(user.uid).get();
        if (userDoc.exists) {
          logger.logInfo('✅ User data retrieved successfully: ${user.uid}');
          return userDoc.data();
        } else {
          logger.logWarning('⚠️ User profile not found in Firestore.');
          return null;
        }
      } else {
        logger.logWarning('⚠️ No user is currently signed in.');
        return null;
      }
    } catch (e) {
      logger.logError('❌ Error fetching user data: $e');
      return null;
    }
  }

}
