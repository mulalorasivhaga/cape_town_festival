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
      //logger.logInfo("Total users: $totalUsers");
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
      //logger.logInfo("Total events: $totalEvents");
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
      //logger.logInfo("Total rsvp: $totalRsvp");
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
      //logger.logInfo("Total RSVPs for event $eventId: $totalRsvp");
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

      //logger.logInfo("RSVP data for pie graph: $rsvpData");
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

      //logInfo("RSVP data for category graph: $rsvpCategoryData");
      return rsvpCategoryData;
    } catch (e) {
      logger.logError("Error fetching RSVP data for category graph: $e");
      throw Exception('Error fetching RSVP data for category graph: $e');
    }
  }

  ///get age per user, count ages within age range and store in a list
  Future<List<Map<String, dynamic>>> getAgePerUser() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      Map<String, int> ageGroups = {
        '< 12': 0,
        '13-18': 0,
        '19-35': 0,
        '36-65': 0,
        '> 65': 0,
      };

      for (var doc in querySnapshot.docs) {
        try {
          if (doc.data().containsKey('age')) {
            var ageData = doc['age'];
            logger.logInfo('Raw age data for user ${doc.id}: $ageData (${ageData.runtimeType})');
            
            // Handle different age data types
            int age;
            if (ageData is int) {
              age = ageData;
            } else if (ageData is String) {
              age = int.tryParse(ageData) ?? 0;
            } else {
              logger.logError('Unexpected age data type for user ${doc.id}: ${ageData.runtimeType}');
              continue;
            }

            // Skip invalid ages
            if (age <= 0) {
              logger.logError('Invalid age value for user ${doc.id}: $age');
              continue;
            }

            // Group the age
            if (age < 12) {
              ageGroups['< 12'] = ageGroups['< 12']! + 1;
            } else if (age >= 13 && age <= 18) {
              ageGroups['13-18'] = ageGroups['13-18']! + 1;
            } else if (age >= 19 && age <= 35) {
              ageGroups['19-35'] = ageGroups['19-35']! + 1;
            } else if (age >= 36 && age <= 65) {
              ageGroups['36-65'] = ageGroups['36-65']! + 1;
            } else {
              ageGroups['< 65'] = ageGroups['> 65']! + 1;
            }
          }
        } catch (docError) {
          logger.logError('Error processing user ${doc.id}: $docError');
          continue; // Skip this document and continue with the next
        }
      }

      // Transform the ageGroups map to the desired format
      List<Map<String, dynamic>> formattedAgeGroups = ageGroups.entries.map((entry) => {
        'label': entry.key,
        'value': entry.value,
      }).toList();
      
      logger.logInfo('Age groups distribution: $formattedAgeGroups');
      return formattedAgeGroups;
    } catch (e) {
      logger.logError("Error fetching age groups data: $e");
      throw Exception('Error fetching age groups data: $e');
    }
  }

  /// get gender per user
  Future<List<Map<String, dynamic>>> getGenderPerUser() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      List<Map<String, dynamic>> genderData = [];

      for (var doc in querySnapshot.docs) {
        String userId = doc.id;
        String gender = doc['gender'];

        genderData.add({
          'userId': userId,
          'gender': gender,
        });
      }

      //logger.logInfo("Gender data for user: $genderData");
      return genderData;
    } catch (e) {
      logger.logError("Error fetching gender data for user: $e");
      throw Exception('Error fetching gender data for user: $e');
    }
  }

  ///get total gender in users collection
  Future<List<Map<String, dynamic>>> getTotalGenderCount() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      Map<String, int> genderCount = {'Male': 0, 'Female': 0};

      for (var doc in querySnapshot.docs) {
        if (doc.data().containsKey('gender')) {
          String gender = doc['gender'];
          if (genderCount.containsKey(gender)) {
            genderCount[gender] = genderCount[gender]! + 1;
          }
        }
      }

      // Transform the genderCount map to the desired format
      List<Map<String, dynamic>> formattedGenderCount = genderCount.entries.map((entry) => {
        'label': entry.key,
        'value': entry.value,
      }).toList();
      
      logger.logInfo('Total gender count: $formattedGenderCount');
      return formattedGenderCount;
    } catch (e) {
      logger.logError("Error fetching total gender count: $e");
      throw Exception('Error fetching total gender count: $e');
    }
  }
}
