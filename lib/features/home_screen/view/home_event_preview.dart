// lib/widgets/manifesto_dialog.dart

import 'package:flutter/material.dart';
import 'package:ct_festival/features/event_screens/model/event_model.dart';
import 'package:ct_festival/utils/logger.dart';

class HomeEventPreview extends StatelessWidget {
  final Event event;
  final AppLogger _logger = AppLogger();

  HomeEventPreview({
    super.key,
    required this.event,
  }) {
    _logger.logDebug('Initializing ManifestoDialog for ${event.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242F40),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildManifestoContainer(),
          ],
        ),
      ),
    );
  }

  /// This method builds the header of the dialog
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
                  color: Color(0xFFCCA43B),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                event.title,
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Color(0xFFCCA43B),
              size: 30,
            ),
            onPressed: () {
              _logger.logDebug('Closing manifesto dialog for ${event.title}');
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildManifestoContainer() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(
              color: Color(0xFFCCA43B),
              thickness: 2,
            ),
            const SizedBox(height: 20),
            Text(
              event.description,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}