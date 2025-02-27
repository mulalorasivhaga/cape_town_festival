import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ct_festival/features/events_screen/model/event_model.dart';

class EventDetails extends StatelessWidget {
  final Event event;

  const EventDetails({super.key, required this.event});

  String _formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy (HH:mm a)');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final textFontSize = 16.0;
    final verticalSpacing = 15.0;

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: verticalSpacing,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Color(0xFFF2AF29),
              thickness: 2,
            ),
            Text(
              'Category:\n${event.category}',
              style: TextStyle(
                color: Colors.white,
                fontSize: textFontSize,
              ),
            ),
            SizedBox(height: verticalSpacing),
            Text(
              'Description:\n${
                  event.description.isEmpty
                      ? 'No description available'
                      : event.description
              }',
              style: TextStyle(
                color: Colors.white,
                fontSize: textFontSize,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: verticalSpacing * 2),
            Text(
              'Location:\n${event.location}',
              style: TextStyle(
                color: Colors.white,
                fontSize: textFontSize,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: verticalSpacing),
            Text(
              'Start Date: ${_formatDateTime(event.startDate)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: textFontSize,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: verticalSpacing / 2),
            Text(
              'End Date: ${_formatDateTime(event.endDate)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: textFontSize,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: verticalSpacing / 2),
          ],
        ),
      ),
    );
  }
}
