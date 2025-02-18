import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/features/dashboard_screen/user/model/rsvp_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ct_festival/providers/auth_provider.dart';
import 'package:ct_festival/utils/logger.dart';
import 'package:ct_festival/features/events_screen/controller/event_service.dart';

class RsvpService {
  final AppLogger logger = AppLogger();
  final EventService eventService = EventService();

  /// Create RSVP
  Future<void> createRsvp(String userId, String eventId, String status) async {
    final rsvp = Rsvp(
      userId: userId,
      eventId: eventId,
      status: status,
    );
    await FirebaseFirestore.instance.collection('rsvp').add(rsvp.toMap());
  }

  Future<List<Rsvp>> getAllRsvps() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('rsvp').get();
    return querySnapshot.docs.map((doc) => Rsvp.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<Rsvp>> getRsvpsByUserId(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('rsvp')
        .where('userId', isEqualTo: userId)
        .get();
    return querySnapshot.docs.map((doc) => Rsvp.fromMap(doc.data(), doc.id)).toList();
  }

  /// Fetch RSVPs for the current user
  Future<List<Rsvp>> fetchUserRsvps(WidgetRef ref) async {
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        logger.logInfo('Fetching RSVPs for user: ${currentUser.uid}');
        return getRsvpsByUserId(currentUser.uid);
      } else {
        logger.logError('User not logged in');
        throw Exception('User not logged in');
      }
    } catch (e) {
      logger.logError('Error fetching user RSVPs: $e');
      rethrow;
    }
  }

  /// Fetch event titles for RSVPs
  Future<List<String>> fetchEventTitles(WidgetRef ref) async {
    try {
      final rsvps = await fetchUserRsvps(ref);
      final eventTitles = <String>[];

      for (final rsvp in rsvps) {
        final event = await eventService.getEventById(rsvp.eventId);
        eventTitles.add(event.title);
      }
      return eventTitles;
    } catch (e) {
      logger.logError('Error fetching event titles: $e');
      rethrow;
    }
  }
}