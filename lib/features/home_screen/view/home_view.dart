import 'package:ct_festival/features/home_screen/view/widgets/home_carousel.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/events_screen/controller/event_service.dart';
import 'package:ct_festival/features/events_screen/model/event_model.dart';
import 'package:ct_festival/features/home_screen/view/home_event_preview.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

/// This class is the state for the HomeScreen shared_widget
class _HomeViewState extends State<HomeView> {
  final EventService _eventService = EventService();

  /// This method calculates the number of columns based on the screen width
  int _getCrossAxisCount(double width) {
    if (width > 1200) {
      return 3;  // Show 3 cards per row on large screens
    } else if (width > 800) {
      return 2;  // Show 2 cards per row on medium screens
    } else {
      return 1;  // Show 1 card per row on small screens
    }
  }


  /// This method builds the header section
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0CE),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1400),
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 600 ? 48.0 : 16.0,
                  vertical: 24.0,
                ),
                child: Column(
                  children: [
                    /// HomeCarousel widget
                    HomeCarousel(
                      onEventTap: (eventId) async {
                        final user = FirebaseAuth.instance.currentUser;

                        if (user != null) {
                          Navigator.pushNamed(context, '/dashboard');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please Register/Login for more access to events'),
                              backgroundColor: Color(0xFFAD343E),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                    ),
                    /// Header section
                    _buildHeader(constraints),
                    const SizedBox(height: 20),
                    /// Event grid
                    _buildEventGrid(constraints),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// This method builds the header section
  Widget _buildHeader(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;

    return Column(
      children: [
        Text(
          'Welcome to Cape Town Festival',
          style: TextStyle(
            color: const Color(0xFFAD343E),
            fontSize: isMobile ? 36 : 72,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? constraints.maxWidth * 0.9 : 800,
          ),
          child: const Text(
            "Cape Town Festival is an annual event that celebrates the rich cultural heritage of Cape Town."
                " Join us for a weekend of music, dance, food, and fun!",
            style: TextStyle(
              color: Color(0xFFAD343E),
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// This method builds the event grid
  Widget _buildEventGrid(BoxConstraints constraints) {
    return FutureBuilder<List<Event>>(
      future: _eventService.getAllEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFAD343E),
            ),
          );
        }

        final events = snapshot.data ?? [];
        final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
        final itemWidth = (constraints.maxWidth - (32.0 * (crossAxisCount - 1))) / crossAxisCount;

        return Wrap(
          spacing: 32,
          runSpacing: 32,
          alignment: WrapAlignment.center,
          children: events.map((event) => _buildEventCard(
            event: event,
            itemWidth: itemWidth.clamp(280, 380),
            constraints: constraints,
          )).toList(),
        );
      },
    );
  }

  /// This method calculates the number of columns based on the screen width
  Widget _buildEventCard({
    required Event event,
    required double itemWidth,
    required BoxConstraints constraints,
  }) {
    final bool isMobile = constraints.maxWidth <= 600;
    return Container(
      width: itemWidth,
      height: 500,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFAD343E),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: isMobile ? 250 : 300,
            height: isMobile ? 250 : 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              image: event.imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(event.imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              event.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
             'Date: ${DateFormat("dd MMMM yyyy - HH:mm a").format(event.startDate)} ',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 12 : 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _homeEventPreview(context, constraints, event),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF2AF29),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'More Information',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// This method shows the event preview dialog
  void _homeEventPreview(BuildContext context, BoxConstraints constraints, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * 0.9,
              // Increased width for better map display
              maxHeight: constraints.maxHeight * 0.9,
            ),
            child: HomeEventPreview(
              event: event,
              showMap: true,
            ),
          ),
        );
      },
    );
  }
}