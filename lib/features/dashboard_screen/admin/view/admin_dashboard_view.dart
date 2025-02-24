// view total registered users
// view registered events
// create event
// edit event
// show event history (all events)
// view stats of events and users



import 'package:ct_festival/features/dashboard_screen/shared/mixin/dashboard_mixin.dart';
import 'package:ct_festival/features/dashboard_screen/shared/widgets/logout_nav.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/events_screen/controller/event_service.dart';

class AdminDashboardView extends StatelessWidget with DashboardMixin {
   AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: LogoutNavBar(),
      ),
      backgroundColor: Color(0xFF474747),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
        child: Center(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 24.0,
              mainAxisSpacing: 24.0,
              childAspectRatio: 1.5,
              mainAxisExtent: 300,
            ),
            children: [
              buildCard(
                title: 'View Current Events',
                onTap: () => showEventsScreen(context),
                color: Color(0xFFF2AF29),
              ),
              buildCard(
                title: 'Create Event',
                onTap: () => showCreateEventDialog(context),
                color: Color(0xFFF2AF29),
              ),
              buildCard(
                title: 'Edit Event',
                onTap: () => showEditEventDialog(context),
                color: Color(0xFFF2AF29),
              ),
              buildCard(
                title: 'Analytics',
                onTap: () => showAnalyticsView(context),
                color: Color(0xFFF2AF29),
              ),
              buildCard(
                title: 'RSVPs Analytics',
                onTap: () => showRsvpAnalyticsView(context),
                color: Color(0xFFF2AF29),
              ),
              buildCard(
                title: 'Archive Event',
                onTap: () async {
                  final eventService = EventService();
                  final events = await eventService.getAllEvents();
                  
                  if (!context.mounted) return;
                  
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Select Event to Archive'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              final event = events[index];
                              return ListTile(
                                title: Text(event.title),
                                onTap: () {
                                  Navigator.pop(context); // Close the selection dialog
                                  showArchiveEventDialog(
                                    context,
                                    event.id,
                                    event.title,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
                color: const Color(0xFFF2AF29),
              ),
            ],
          ),
        ),
      ),
    );
  }
}