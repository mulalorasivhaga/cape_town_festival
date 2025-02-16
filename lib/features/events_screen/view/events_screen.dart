import 'package:ct_festival/features/events_screen/model/event_model.dart';
import 'package:ct_festival/features/events_screen/controller/event_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  EventsScreenState createState() => EventsScreenState();
}

class EventsScreenState extends State<EventsScreen> {
  late Future<List<Event>> _eventsFuture;
  final EventService eventService = EventService();

  @override
  void initState() {
    super.initState();
    _eventsFuture = eventService.getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFAD343E),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: const Color(0xFFAD343E),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found.'));
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final dateFormat = DateFormat('dd/MM/yy (HH:mm a)');
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: ${event.description}'),
                        Text('Location: ${event.location}'),
                        Text('Max Participants: ${event.maxParticipants}'),
                        Text('Start Date: ${dateFormat.format(event.startDate)}'),
                        Text('End Date: ${dateFormat.format(event.endDate)}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}