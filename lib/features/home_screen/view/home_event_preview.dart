import 'package:flutter/material.dart';
import 'package:ct_festival/features/events_screen/model/event_model.dart';
import 'package:ct_festival/utils/logger.dart';
import 'package:intl/intl.dart';
import 'package:web/web.dart' as web;
import 'dart:ui_web' as ui_web;
import 'package:ct_festival/config/api_keys.dart';

class HomeEventPreview extends StatelessWidget {
  final Event event;
  final bool showMap;
  final AppLogger logger = AppLogger();

  HomeEventPreview({
    super.key,
    required this.event,
    this.showMap = false,
  }) {
    // Register the view factory for this specific event
    final String viewId = 'google-map-${event.title}';
    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final iframe = web.HTMLIFrameElement()
          ..style.border = 'none'
          ..style.height = '100%'
          ..style.width = '100%'
          ..src = 'https://www.google.com/maps/embed/v1/place'
              '?key=${ApiKeys.googleMapsKey}'
              '&q=${Uri.encodeComponent(event.location)}'
              '&zoom=15';
        return iframe;
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy (HH:mm a)');
    return formatter.format(dateTime);
  }

  /// Build the event preview dialog
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAD343E),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildEventDetails(),
            if (showMap) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: HtmlElementView(
                  viewType: 'google-map-${event.title}',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build the header section
  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 16, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ), // title
              const SizedBox(height: 10),
              Text(
                'Max Capacity: ${event.maxParticipants}',
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ) 
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              //logger.logDebug('Closing event dialog for ${event.title}');
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  /// Build the event details
  Widget _buildEventDetails() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(
              color: Color(0xFFF2AF29),
              thickness: 2,
            ),
            const SizedBox(height: 20),
            Text(
              'Category: ${event.category}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ), // category
            const SizedBox(height: 20),
            Text(
              event.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ), // description
            const SizedBox(height: 50),
            Text(
              'Location: ${event.location}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ), // location
            const SizedBox(height: 10),
            Text(
              'Start Date: ${_formatDateTime(event.startDate)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ), // startDate
            const SizedBox(height: 10),
            Text(
              'End Date: ${_formatDateTime(event.endDate)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),// endDate
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}