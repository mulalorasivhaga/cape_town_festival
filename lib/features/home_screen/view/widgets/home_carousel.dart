import 'package:ct_festival/features/events_screen/model/event_model.dart';
import 'package:ct_festival/features/events_screen/controller/event_service.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';

class HomeCarousel extends StatelessWidget {
  final Function(String) onEventTap;
  final EventService _eventService = EventService();

   HomeCarousel({
    super.key,
    required this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double carouselHeight = constraints.maxWidth > 700 ? 500 : 300;
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth > 1400 ? 1400 : constraints.maxWidth,
          ),
          color: Colors.transparent.withValues(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: FutureBuilder<List<Event>>(
            future: _eventService.getAllEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: carouselHeight,
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFFF2AF29)),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SizedBox(
                  height: carouselHeight,
                  child: const Center(
                    child: Text('No events available'),
                  ),
                );
              }

              return carousel.CarouselSlider.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index, realIndex) {
                  return _buildCarouselItem(snapshot.data![index], context);
                },
                options: carousel.CarouselOptions(
                  height: carouselHeight,
                  viewportFraction: constraints.maxWidth > 1200 ? 0.8 : 0.9,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCarouselItem(Event event, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            event.imageUrl,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent.withValues(),
                  Colors.transparent.withValues(),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onEventTap(event.id),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: Colors.white,
                        backgroundColor: Color(0xFFAD343E),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF2AF29),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        DateFormat('MMMM dd, yyyy').format(event.startDate),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}