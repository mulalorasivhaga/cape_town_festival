// assign user to event ( status to 'going')
// remove user from event ( status to 'cancelled')
// update user status to event ( status to 'going' or 'cancelled')

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/features/event_screens/model/rsvp_model.dart';

class RsvpService {
  /// Create RSVP
  Future<void> createRsvp(String userId, String eventId, String status) async {
    final rsvp = Rsvp(
      userId: userId,
      eventId: eventId,
      status: status,
    );
    await FirebaseFirestore.instance.collection('rsvp').add(rsvp.toMap());

  }
}
