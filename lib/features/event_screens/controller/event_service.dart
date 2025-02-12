import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/features/auth_screens/model/admin_model.dart' as admin_auth;
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/logger.dart';
import '../../auth_screens/controller/auth_service.dart';
import '../model/event_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance
  );
  final AppLogger _appLogger = AppLogger();

  /// get all events
  Future<List<Event>> getAllEvents() async {
    try {
      final querySnapshot = await _firestore.collection('events').get();
      final events = querySnapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();
      return events;
    } catch (e, stackTrace) {
      _appLogger.logError('Failed to fetch events: ${e.toString()}', stackTrace);
      return [];
    }
  }

  /// create event
  Future<String> createEvent(Event event) async {
    try {
      final admin = _auth.currentUser;
      if (admin == null) {
        return 'Admin not authenticated';
      }

      final authAdmin = await _authService.getCurrentUser();
      if (authAdmin is! admin_auth.Admin) {
        return 'Only admins can create events';
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
      final admin = _auth.currentUser;
      if (admin == null) {
        return 'Admin not authenticated';
      }

      final authAdmin = await _authService.getCurrentUser();
      if (authAdmin is! admin_auth.Admin) {
        return 'Only admins can edit events';
      }

      await _firestore.collection('events').doc(eventId).update(updatedEvent.toMap());
      return 'Event updated successfully';
    } catch (e) {
      return 'Failed to update event: ${e.toString()}';
    }
  }

}