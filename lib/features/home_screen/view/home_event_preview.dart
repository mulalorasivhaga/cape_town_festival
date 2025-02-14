// lib/widgets/manifesto_dialog.dart

import 'package:flutter/material.dart';
import 'package:ct_festival/features/event_screens/model/event_model.dart';
import 'package:ct_festival/utils/logger.dart';
import 'package:intl/intl.dart';

class HomeEventPreview extends StatelessWidget {
  final Event event;
  final AppLogger _logger = AppLogger();

  HomeEventPreview({
    super.key,
    required this.event,
  }) {
    _logger.logDebug('Initializing event dialog for ${event.title}');
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
                'Tickets Available: ${event.maxParticipants}',
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ) // Add ticket availability here // maxParticipants
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
              _logger.logDebug('Closing event dialog for ${event.title}');
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