// create event
// edit event (change event details)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth_screens/controller/auth_service.dart';
import '../model/event_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance
  );
  /// get all events
  Future<List<Event>> getAllEvents() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return [];
      }

      final events = await _firestore.collection('events').get();
      return events.docs.map((e) => Event.fromMap(e.data())).toList();
    } catch (e) {
      return [];
    }
  }

  /// create event
  Future<String> createEvent(Event event) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return 'User not authenticated';
      }

      final authUser = await _authService.getCurrentUser();
      if (authUser == null || authUser.role != 'Admin') {
        return 'User not authorized to create events';
      }

      await _firestore.collection('events').add(event.toMap());
      return 'Event created successfully';
    } catch (e) {
      return 'Failed to create event: ${e.toString()}';
    }
  }

  /// edit event (change event details)
  Future<String> editEvent(String eventId, Event updatedEvent) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return 'User not authenticated';
      }

      final authUser = await _authService.getCurrentUser();
      if (authUser == null || authUser.role != 'Admin') {
        return 'User not authorized to edit events';
      }

      await _firestore.collection('events').doc(eventId).update(updatedEvent.toMap());
      return 'Event updated successfully';
    } catch (e) {
      return 'Failed to update event: ${e.toString()}';
    }
  }
}
