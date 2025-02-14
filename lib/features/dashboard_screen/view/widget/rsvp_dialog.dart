import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/event_screens/controller/event_service.dart';
import 'package:ct_festival/features/event_screens/model/event_model.dart';
import 'package:ct_festival/features/event_screens/controller/rsvp_service.dart';
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
    _loadEvents();
  }

  /// Load all events
  Future<void> _loadEvents() async {
    final eventService = EventService();
    final fetchedEvents = await eventService.getAllEvents();
    if (mounted) {
      setState(() {
        events = fetchedEvents;
      });
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
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 16)),
        ),
        ElevatedButton(
          onPressed: () async {
            if (selectedEvent != null && isAttending) {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirm RSVP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    content: Text('Are you sure you want to RSVP to ${selectedEvent!.title}?', style: const TextStyle(fontSize: 16)),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                          logger.logWarning('User cancelled RSVP');
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
                  await rsvpService.createRsvp(user.uid, selectedEvent!.id, 'attending');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('RSVP confirmed')),
                  );
                  Navigator.of(context).pop();
                }
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select an event and confirm attendance')),
              );
            }
          },
          child: const Text('RSVP', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}