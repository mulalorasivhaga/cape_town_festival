import 'package:flutter/material.dart';
import 'package:ct_festival/features/events_screen/model/event_model.dart';

class EventHeader extends StatelessWidget {
  final Event event;

  const EventHeader({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final titleFontSize = 24.0;
    final textFontSize = 16.0;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 75, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                event.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                'Max Capacity: ${event.maxParticipants}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: textFontSize,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
