import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/dashboard_screen/user/model/rsvp_model.dart';
import 'package:ct_festival/features/dashboard_screen/user/controller/rsvp_service.dart';
import 'package:ct_festival/features/events_screen/controller/event_service.dart';
import 'package:ct_festival/features/auth_screens/controller/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:ct_festival/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewRsvpDialog extends ConsumerStatefulWidget {
  const ViewRsvpDialog({super.key});

  @override
  ViewRsvpDialogState createState() => ViewRsvpDialogState();
}

class ViewRsvpDialogState extends ConsumerState<ViewRsvpDialog> {
  late Future<List<Rsvp>> _rsvpEventsFuture;
  late Future<List<String>> _eventTitlesFuture;
  final RsvpService rsvpService = RsvpService();
  final EventService eventService = EventService();
  final AuthService authService = AuthService(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
  final AppLogger logger = AppLogger();

  @override
  void initState() {
    super.initState();
    logger.logInfo('Initializing ViewRsvpDialog');
    _rsvpEventsFuture = rsvpService.fetchUserRsvps(ref);
    _eventTitlesFuture = rsvpService.fetchEventTitles(ref);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF474747),
      title: const Text(
        'RSVP\'d Events',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white,),
      ),
      content: FutureBuilder<List<Rsvp>>(
        future: _rsvpEventsFuture,
        builder: (context, rsvpSnapshot) {
          if (rsvpSnapshot.connectionState == ConnectionState.waiting) {
            logger.logInfo('Loading RSVP events...');
            return const Center(child: CircularProgressIndicator());
          } else if (rsvpSnapshot.hasError) {
            logger.logError('Error loading RSVP events: ${rsvpSnapshot.error}');
            return Center(child: Text('Error: ${rsvpSnapshot.error}'));
          } else if (!rsvpSnapshot.hasData || rsvpSnapshot.data!.isEmpty) {
            logger.logWarning('No RSVP\'d events found.');
            return const Center(child: Text('No RSVP\'d events found.'));
          } else {
            final events = rsvpSnapshot.data!;
            logger.logInfo('Loaded ${events.length} RSVP events.');
            return FutureBuilder<List<String>>(
              future: _eventTitlesFuture,
              builder: (context, titleSnapshot) {
                if (titleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (titleSnapshot.hasError) {
                  return Center(child: Text('Error: ${titleSnapshot.error}'));
                } else if (!titleSnapshot.hasData || titleSnapshot.data!.isEmpty) {
                  return const Center(child: Text('No event titles found.'));
                } else {
                  final titles = titleSnapshot.data!;
                  return SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        final title = titles[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text('Event: $title', style: const TextStyle(fontSize: 16, color: Colors.black)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status: ${event.status}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black)),
                                Text('Created At: ${DateFormat('dd/MM/yy (HH:mm a)').format(event.createdAt)}', style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            );
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            logger.logInfo('Closing ViewRsvpDialog');
            Navigator.of(context).pop();
          },
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      ],
    );
  }
}