import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/events_screen/controller/event_service.dart';
import 'package:ct_festival/features/events_screen/model/event_model.dart';
import 'package:ct_festival/features/dashboard_screen/user/controller/rsvp_service.dart';
import 'package:ct_festival/utils/logger.dart';

class RsvpDialog extends StatefulWidget {
  const RsvpDialog({super.key});

  @override
  RsvpDialogState createState() => RsvpDialogState();
}

class RsvpDialogState extends State<RsvpDialog> {
  List<Event> events = [];
  Event? selectedEvent;
  bool isAttending = false;
  final AppLogger logger = AppLogger();
  final RsvpService rsvpService = RsvpService();

  @override
  void initState() {
    super.initState();
    logger.logInfo('Initializing RsvpDialog');
    _loadEvents();
  }

  /// Load all events
  Future<void> _loadEvents() async {
    final eventService = EventService();
    try {
      final fetchedEvents = await eventService.getAllEvents();
      if (!context.mounted) return;
      setState(() {
        events = fetchedEvents;
      });
      logger.logInfo('Loaded ${events.length} events');
    } catch (e) {
      logger.logError('Error loading events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('RSVP for Event', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<Event>(
            value: selectedEvent,
            hint: const Text('Select Event', style: TextStyle(fontSize: 16)),
            items: events.map((event) {
              return DropdownMenuItem<Event>(
                value: event,
                child: Text(event.title, style: const TextStyle(fontSize: 16)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedEvent = value;
              });
              logger.logInfo('Selected event: ${value?.title}');
            },
          ),
          Row(
            children: [
              Checkbox(
                value: isAttending,
                onChanged: (value) {
                  setState(() {
                    isAttending = value!;
                  });
                  logger.logInfo('Is attending: $isAttending');
                },
              ),
              const Text('I am attending', style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            logger.logInfo('User cancelled RSVP');
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 16)),
        ),
        ElevatedButton(
          onPressed: () async {
            final localContext = context;
            if (selectedEvent != null && isAttending) {
              final confirm = await showDialog<bool>(
                context: localContext,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirm RSVP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    content: Text('Are you sure you want to RSVP to ${selectedEvent!.title}?', style: const TextStyle(fontSize: 16)),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                          logger.logWarning('User cancelled RSVP confirmation');
                        },
                        child: const Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 16)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          logger.logInfo('User confirmed RSVP');
                        },
                        child: const Text('Confirm', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  try {
                    await rsvpService.createRsvp(user.uid, selectedEvent!.id, 'attending');
                    if (!localContext.mounted) return;
                    ScaffoldMessenger.of(localContext).showSnackBar(
                      const SnackBar(content: Text('RSVP confirmed')),
                    );
                    logger.logInfo('RSVP confirmed for event: ${selectedEvent!.title}');
                    Navigator.of(localContext).pop();
                  } catch (e) {
                    logger.logError('Error creating RSVP: $e');
                  }
                }
              }
            } else {
              ScaffoldMessenger.of(localContext).showSnackBar(
                const SnackBar(content: Text('Please select an event and confirm attendance')),
              );
              logger.logWarning('User did not select an event or confirm attendance');
            }
          },
          child: const Text('RSVP', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}