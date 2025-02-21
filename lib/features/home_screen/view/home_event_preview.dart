import 'package:flutter/material.dart';
import 'package:ct_festival/features/events_screen/model/event_model.dart';
import 'package:ct_festival/utils/logger.dart';
import 'package:intl/intl.dart';
import 'package:web/web.dart' as web;
import 'dart:ui_web' as ui_web;
import 'package:ct_festival/config/api_keys.dart';

class HomeEventPreview extends StatefulWidget {
  final Event event;
  final bool showMap;

  const HomeEventPreview({
    super.key,
    required this.event,
    this.showMap = false,
  });

  @override
  State<HomeEventPreview> createState() => _HomeEventPreviewState();
}

class _HomeEventPreviewState extends State<HomeEventPreview> {
  bool isMapLoaded = false;
  final AppLogger logger = AppLogger();

  @override
  void initState() {
    super.initState();
    // Register the view factory for this specific event
    final String viewId = 'google-map-${widget.event.title}';
    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final iframe = web.HTMLIFrameElement()
          ..style.border = 'none'
          ..style.height = '100%'
          ..style.width = '100%'
          ..src = 'https://www.google.com/maps/embed/v1/place'
              '?key=${ApiKeys.googleMapsKey}'
              '&q=${Uri.encodeComponent(widget.event.location)}'
              '&zoom=15';
        
        // Add load event listener
        iframe.onLoad.listen((_) {
          if (mounted) {
            setState(() {
              isMapLoaded = true;
            });
          }
        });
        
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
            if (widget.showMap) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFF2AF29),
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: HtmlElementView(
                          viewType: 'google-map-${widget.event.title}',
                        ),
                      ),
                      if (!isMapLoaded)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Color(0xFFAD343E),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Loading Map...',
                                  style: TextStyle(
                                    color: Color(0xFFAD343E),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                widget.event.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ), // title
              const SizedBox(height: 10),
              Text(
                'Max Capacity: ${widget.event.maxParticipants}',
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
              //logger.logDebug('Closing event dialog for ${widget.event.title}');
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
              'Category: ${widget.event.category}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ), // category
            const SizedBox(height: 20),
            Text(
              widget.event.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ), // description
            const SizedBox(height: 50),
            Text(
              'Location: ${widget.event.location}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ), // location
            const SizedBox(height: 10),
            Text(
              'Start Date: ${_formatDateTime(widget.event.startDate)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ), // startDate
            const SizedBox(height: 10),
            Text(
              'End Date: ${_formatDateTime(widget.event.endDate)}',
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