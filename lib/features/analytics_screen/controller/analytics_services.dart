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
      return querySnapshot.docs.length;
    } catch (e) {
      logger.logError("Error getting RSVP count for event $eventId: $e");
      return 0;
    }
  }

  /// Get event titles and RSVP count for each specific event and return data
  Future<List<Map<String, dynamic>>> getRsvpData() async {
    try {
      final querySnapshot = await _firestore.collection('events').get();
      List<Map<String, dynamic>> rsvpData = [];

      logger.logInfo("Found ${querySnapshot.docs.length} events");

      for (var doc in querySnapshot.docs) {
        String eventId = doc.id;
        Map<String, dynamic> data = doc.data();
        String eventTitle = data['title']?.toString() ?? 'Untitled Event';
        
        int rsvpCount = await getRsvpForEvent(eventId);
        
        // Always add the event
        Map<String, dynamic> eventData = {
          'label': eventTitle,
          'value': rsvpCount,
        };
        
        logger.logInfo("Adding event data: $eventData");
        rsvpData.add(eventData);
      }

      // Sort by RSVP count
      rsvpData.sort((a, b) => (b['value'] as int).compareTo(a['value'] as int));

      logger.logInfo("Final RSVP data: $rsvpData");
      return rsvpData;
    } catch (e) {
      logger.logError("Error in getRsvpData: $e");
      // Return empty list instead of throwing
      return [];
    }
  }

  /// Get event category and RSVP count for each specific event and return data
  Future<List<Map<String, dynamic>>> getRsvpCategoryData() async {
    try {
      final querySnapshot = await _firestore.collection('events').get();
      Map<String, int> categoryTotals = {};

      logger.logInfo("Found ${querySnapshot.docs.length} events for categories");

      // First, aggregate all RSVPs by category
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        String category = data['category']?.toString() ?? 'Uncategorized';
        int rsvpCount = await getRsvpForEvent(doc.id);
        
        logger.logInfo("Category: $category, RSVP Count: $rsvpCount");
        
        // Add to category total
        categoryTotals[category] = (categoryTotals[category] ?? 0) + rsvpCount;
      }

      // Convert to format expected by PieChartWidget
      List<Map<String, dynamic>> formattedData = categoryTotals.entries
          .map((entry) => {
                'label': entry.key,
                'value': entry.value,
              })
          .toList();

      // Sort by count
      formattedData.sort((a, b) => (b['value'] as int).compareTo(a['value'] as int));

      logger.logInfo("Final category data: $formattedData");
      return formattedData;
    } catch (e) {
      logger.logError("Error in getRsvpCategoryData: $e");
      // Return empty list instead of throwing
      return [];
    }
  }

  /// Get age per user
  Future<List<Map<String, dynamic>>> getAgePerUser() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      Map<String, int> ageGroups = {
        'Under 12': 0,
        '13-18': 0,
        '19-35': 0,
        '36-65': 0,
        'Over 65': 0,
      };

      for (var doc in querySnapshot.docs) {
        if (doc.data().containsKey('age')) {
          // Parse the age string to integer
          int age = int.parse(doc['age'].toString());
          if (age < 12) {
            ageGroups['Under 12'] = ageGroups['Under 12']! + 1;
          } else if (age >= 13 && age <= 18) {
            ageGroups['13-18'] = ageGroups['13-18']! + 1;
          } else if (age >= 19 && age <= 35) {
            ageGroups['19-35'] = ageGroups['19-35']! + 1;
          } else if (age >= 36 && age <= 65) {
            ageGroups['36-65'] = ageGroups['36-65']! + 1;
          } else {
            ageGroups['Over 65'] = ageGroups['Over 65']! + 1;
          }
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

  /// Get detailed RSVP information for a specific event
  Future<List<Map<String, dynamic>>> getEventRsvpDetails(String eventId) async {
    try {
      logger.logInfo('📊 Fetching RSVP details for event: $eventId');
      
      // Get all RSVPs for the specified event
      final rsvpQuerySnapshot = await _firestore
          .collection('rsvp')
          .where('eventId', isEqualTo: eventId)
          .get();

      logger.logInfo('📝 Found ${rsvpQuerySnapshot.docs.length} RSVPs for event');
      
      List<Map<String, dynamic>> rsvpDetails = [];

      // Process each RSVP
      for (var rsvpDoc in rsvpQuerySnapshot.docs) {
        try {
          final rsvpData = rsvpDoc.data();
          final userId = rsvpData['userId'];

          // Get user details
          logger.logInfo('👤 Fetching user details for: $userId');
          final userDoc = await _firestore.collection('users').doc(userId).get();
          
          if (!userDoc.exists) {
            logger.logWarning('⚠️ User not found for RSVP: $userId');
            continue;
          }

          final userData = userDoc.data()!;

          // Get rating/comment if exists
          logger.logInfo('⭐ Checking for rating/comment for RSVP: ${rsvpDoc.id}');
          final ratingDoc = await _firestore
              .collection('ratings')
              .where('rsvpId', isEqualTo: rsvpDoc.id)
              .get();

          String comment = 'N/A';
          if (ratingDoc.docs.isNotEmpty) {
            comment = ratingDoc.docs.first.data()['comment'] ?? 'N/A';
          }

          // Compile all information
          Map<String, dynamic> detailRow = {
            'userName': '${userData['firstName']} ${userData['lastName']}',
            'age': userData['age'] ?? 'N/A',
            'gender': userData['gender'] ?? 'N/A',
            'rsvpStatus': rsvpData['status'] ?? 'N/A',
            'comment': comment,
          };

          rsvpDetails.add(detailRow);
          logger.logInfo('✅ Added RSVP detail row for user: $userId');
        } catch (userError) {
          logger.logError('❌ Error processing individual RSVP', userError);
          continue; // Skip this RSVP but continue processing others
        }
      }

      // Sort by name
      rsvpDetails.sort((a, b) => a['userName'].compareTo(b['userName']));
      
      logger.logInfo('✅ Successfully compiled RSVP details for event: $eventId');
      return rsvpDetails;
    } catch (e) {
      logger.logError('❌ Failed to fetch RSVP details for event: $eventId', e);
      throw Exception('Failed to fetch RSVP details: ${e.toString()}');
    }
  }

  /// Get all event titles for dropdown
  Future<List<Map<String, dynamic>>> getEventTitlesForDropdown() async {
    try {
      logger.logInfo('📋 Fetching event titles for dropdown');
      
      final querySnapshot = await _firestore.collection('events').get();
      
      List<Map<String, dynamic>> eventOptions = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc.data()['title'] ?? 'Untitled Event',
        };
      }).toList();

      // Sort by title
      eventOptions.sort((a, b) => (a['title'] as String).compareTo(b['title'] as String));
      
      logger.logInfo('✅ Successfully fetched ${eventOptions.length} event titles');
      return eventOptions;
    } catch (e) {
      logger.logError('❌ Failed to fetch event titles for dropdown', e);
      throw Exception('Failed to fetch event titles: ${e.toString()}');
    }
  }
}


