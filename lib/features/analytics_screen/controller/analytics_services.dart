import 'package:ct_festival/utils/logger.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:ct_festival/features/auth_screens/model/user_model.dart' as user_auth;
// import 'package:ct_festival/features/events_screen/model/event_model.dart' as event_model;
// import 'package:ct_festival/features/dashboard_screen/user/model/rsvp_model.dart' as rsvp_model;
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsService {
  final FirebaseFirestore _firestore;
  AppLogger logger = AppLogger();

  AnalyticsService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  /// Get total users
  Future<int> getTotalUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      final totalUsers = querySnapshot.docs.length;
      logger.logInfo("Total users: $totalUsers");
      return totalUsers;
    } catch (e) {
      logger.logError("Error fetching total users: $e");
      throw Exception('Error fetching total users: $e');
    }
  }
  /// Get total events
  Future<int> getTotalEvents() async {
    try {
      final querySnapshot = await _firestore.collection('events').get();
      final totalEvents = querySnapshot.docs.length;
      logger.logInfo("Total events: $totalEvents");
      return totalEvents;
    } catch (e) {
      logger.logError("Error fetching total events: $e");
      throw Exception('Error fetching total events: $e');
    }
  }
  /// Get total RSVP
  Future<int> getTotalRsvp() async {
    try {
      final querySnapshot = await _firestore.collection('rsvp').get();
      final totalRsvp = querySnapshot.docs.length;
      logger.logInfo("Total rsvp: $totalRsvp");
      return totalRsvp;
    } catch (e) {
      logger.logError("Error fetching total rsvp: $e");
      throw Exception('Error fetching total rsvp: $e');
    }
  }

  ///Get RSVPs for each specific event
  Future<int> getRsvpForEvent(String eventId) async {
    try {
      final querySnapshot = await _firestore
          .collection('rsvp')
          .where('eventId', isEqualTo: eventId)
          .get();
      final totalRsvp = querySnapshot.docs.length;
      logger.logInfo("Total RSVPs for event $eventId: $totalRsvp");
      return totalRsvp;
    } catch (e) {
      logger.logError("Error fetching RSVPs for event $eventId: $e");
      throw Exception('Error fetching RSVPs for event $eventId: $e');
    }
  }

  /// Get event titles and RSVP count for each specific event and return data
  Future<List<Map<String, dynamic>>> getRsvpData() async {
    try {
      final querySnapshot = await _firestore.collection('events').get();
      List<Map<String, dynamic>> rsvpData = [];

      for (var doc in querySnapshot.docs) {
        String eventId = doc.id;
        String eventTitle = doc['title'];
        int rsvpCount = await getRsvpForEvent(eventId);

        rsvpData.add({
          'eventTitle': eventTitle,
          'rsvpCount': rsvpCount,
        });
      }

      logger.logInfo("RSVP data for pie graph: $rsvpData");
      return rsvpData;
    } catch (e) {
      logger.logError("Error fetching RSVP data for pie graph: $e");
      throw Exception('Error fetching RSVP data for pie graph: $e');
    }
  }


  /// Get event category and RSVP count for each specific event and return data
  Future<List<Map<String, dynamic>>> getRsvpCategoryData() async {
    try {
      final querySnapshot = await _firestore.collection('events').get();
      List<Map<String, dynamic>> rsvpCategoryData = [];

      for (var doc in querySnapshot.docs) {
        String eventId = doc.id;
        String eventCategory = doc['category'];
        int rsvpCount = await getRsvpForEvent(eventId);

        rsvpCategoryData.add({
          'eventCategory': eventCategory,
          'rsvpCount': rsvpCount,
        });
      }

      logger.logInfo("RSVP data for category graph: $rsvpCategoryData");
      return rsvpCategoryData;
    } catch (e) {
      logger.logError("Error fetching RSVP data for category graph: $e");
      throw Exception('Error fetching RSVP data for category graph: $e');
    }
  }

}




