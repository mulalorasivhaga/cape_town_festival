import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/features/auth_screens/model/admin_model.dart' as admin_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ct_festival/utils/logger.dart';
import '../../auth_screens/controller/auth_service.dart';
import '../model/event_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance
  );
  final AppLogger _logger = AppLogger();

  /// get all events
  Future<List<Event>> getAllEvents() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
        'events').get();

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
      await FirebaseFirestore.instance.collection('events')
          .doc(event.id)
          .update(event.toMap());
      return 'Event updated successfully';
    } catch (e) {
      return 'Failed to update event: $e';
    }
  }

  /// Get Event by ID
  Future<Event> getEventById(String eventId) async {
    final docSnapshot = await FirebaseFirestore.instance.collection('events')
        .doc(eventId)
        .get();
    if (docSnapshot.exists) {
      return Event.fromMap(docSnapshot.data()!);
    } else {
      throw Exception('Event not found');
    }
  }

  /// Archive event
  Future<String> archiveEvent(String eventId) async {
    try {
      //_logger.logInfo('📦 Starting archive process for event: $eventId');

      final admin = _auth.currentUser;
      if (admin == null) {
        _logger.logWarning('⚠️ Archive attempt without admin authentication');
        return 'Admin not authenticated';
      }

      final authAdmin = await _authService.getCurrentUser();
      if (authAdmin is! admin_auth.Admin) {
        _logger.logWarning(
            '⚠️ Non-admin user attempted to archive event: ${admin.email}');
        return 'Only admins can archive events';
      }

      // Get the event document
      _logger.logInfo('🔍 Fetching event document: $eventId');
      final eventDoc = await _firestore.collection('events').doc(eventId).get();

      if (!eventDoc.exists) {
        _logger.logWarning(
            '⚠️ Attempted to archive non-existent event: $eventId');
        return 'Event not found';
      }

      _logger.logInfo('📝 Starting batch write for event archival');
      // Start a batch write
      final batch = _firestore.batch();

      // Add to archived events collection
      _logger.logInfo('➕ Adding event to archived collection: $eventId');
      batch.set(
        _firestore.collection('archivedEvents').doc(eventId),
        {
          ...eventDoc.data()!,
          'archivedAt': FieldValue.serverTimestamp(),
        },
      );

      // Delete from events collection
      _logger.logInfo('❌ Removing event from active collection: $eventId');
      batch.delete(_firestore.collection('events').doc(eventId));

      // Commit the batch
      await batch.commit();

      _logger.logInfo('✅ Successfully archived event: $eventId');
      return 'Event archived successfully';
    } catch (e) {
      _logger.logError('❌ Failed to archive event: $eventId', e);
      return 'Failed to archive event: ${e.toString()}';
    }
  }
}