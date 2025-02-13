import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/features/auth_screens/model/admin_model.dart' as admin_auth;
import 'package:firebase_auth/firebase_auth.dart';
//import '../../../utils/logger.dart';
import '../../auth_screens/controller/auth_service.dart';
import '../model/event_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance
  );
  //final AppLogger _appLogger = AppLogger();

  /// get all events
  Future<List<Event>> getAllEvents() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('events').get();

    return querySnapshot.docs.map((doc) {
      return Event.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
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
  Future<String> editEvent(Event event) async {
    try {
      // Assume Firestore or any async update logic here
      await FirebaseFirestore.instance.collection('events').doc(event.id).update(event.toMap());
      return 'Event updated successfully';
    } catch (e) {
      return 'Failed to update event: $e';
    }
  }

}