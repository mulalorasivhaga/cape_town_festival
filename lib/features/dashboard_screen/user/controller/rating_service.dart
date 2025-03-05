import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ct_festival/utils/logger.dart';
import 'package:ct_festival/features/events_screen/controller/event_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EventService _eventService = EventService();
  final AppLogger logger = AppLogger();

  /// Fetch event titles for RSVPs
  Future<Map<String, String>> fetchEventTitles(WidgetRef ref) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get all RSVPs for the current user
      final querySnapshot = await _firestore
          .collection('rsvp')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'CONFIRMED')
          .get();

      final Map<String, String> rsvpToEventTitle = {};

      for (var doc in querySnapshot.docs) {
        final eventId = doc.data()['eventId'] as String;
        final event = await _eventService.getEventById(eventId);
        rsvpToEventTitle[doc.id] = event?.title ?? 'Unknown Event'; // Updated line
      }

      return rsvpToEventTitle;
    } catch (e) {
      logger.logError('Error fetching event titles: $e');
      rethrow;
    }
  }

  /// Check if user has already rated this RSVP
  Future<bool> hasUserRatedRsvp(String rsvpId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final querySnapshot = await _firestore
          .collection('ratings')
          .where('rsvpId', isEqualTo: rsvpId)
          .where('userId', isEqualTo: user.uid)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      logger.logError('Error checking existing rating: $e');
      rethrow;
    }
  }

  /// Create a new rating
  Future<void> createRating(String rsvpId, int rating, String comment) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore.collection('ratings').add({
        'userId': user.uid,
        'rsvpId': rsvpId,
        'rating': rating,
        'comment': comment,
        'createdAt': DateTime.now().toIso8601String(),
      });
      logger.logInfo('Rating created successfully');
    } catch (e) {
      logger.logError('Error creating rating: $e');
      rethrow;
    }
  }

}