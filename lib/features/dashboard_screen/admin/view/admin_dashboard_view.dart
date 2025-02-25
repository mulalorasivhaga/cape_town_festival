import 'package:ct_festival/features/dashboard_screen/shared/mixin/dashboard_mixin.dart';
import 'package:ct_festival/features/dashboard_screen/shared/widgets/logout_nav.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/events_screen/controller/event_service.dart';

class AdminDashboardView extends StatelessWidget with DashboardMixin {
  AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: LogoutNavBar(),
      ),
      backgroundColor: const Color(0xFF474747),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
        child: Center(
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 3 : 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.0,
            ),
            children: [
              buildCard(
                title: 'View\nCurrent\nEvents',
                onTap: () => showEventsScreen(context),
                color: const Color(0xFFF2AF29),
              ),
              buildCard(
                title: 'Create\nEvent',
                onTap: () => showCreateEventDialog(context),
                color: const Color(0xFFF2AF29),
              ),
              buildCard(
                title: 'Edit\nEvent',
                onTap: () => showEditEventDialog(context),
                color: const Color(0xFFF2AF29),
              ),
              buildCard(
                title: 'Analytics\nCentre',
                onTap: () => showAnalyticsCentre(context),
                color: const Color(0xFFF2AF29),
              ),
              buildCard(
                title: 'Archive\nEvent',
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
                                  Navigator.pop(context);
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