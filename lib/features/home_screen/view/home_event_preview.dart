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

  // Constants
  final double _mapHeight = 300.0;
  final double _padding = 20.0;

  @override
  void initState() {
    super.initState();
    final String viewId = 'google-map-${widget.event.title}';
    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
          (int viewId) {
        final iframe = web.HTMLIFrameElement()
          ..style.border = 'none'
          ..style.height = '100%'
          ..style.width = '100%'
          ..style.position = 'absolute'
          ..style.top = '0'
          ..style.left = '0'
          ..style.pointerEvents = 'none'
          ..style.overflow = 'hidden'
          ..style.userSelect = 'none'
          ..src = 'https://www.google.com/maps/embed/v1/place'
              '?key=${ApiKeys.googleMapsKey}'
              '&q=${Uri.encodeComponent(widget.event.location)}'
              '&zoom=15'
              '&language=en';

        iframe.onLoad.listen((_) {
          if (mounted) {
            setState(() => isMapLoaded = true);
          }
        });

        return iframe;
      },
    );
  }

  Widget _buildMap() {
    return Container(
      height: _mapHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF2AF29),
          width: 2,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          AbsorbPointer(
            absorbing: true,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: HtmlElementView(
                viewType: 'google-map-${widget.event.title}',
              ),
            ),
          ),
          if (!isMapLoaded)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFFAD343E)),
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
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy (HH:mm a)');
    return formatter.format(dateTime);
  }

  /// Build the event preview dialog
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFAD343E),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _padding),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildEventDetails(screenWidth),
              if (widget.showMap) ...[
                const SizedBox(height: 16),
                _buildMap(),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build the header section
  Widget _buildHeader(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = 24.0; // Consistent title font size
    final textFontSize = 16.0; // Consistent text font size

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 75, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.event.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                'Max Capacity: ${widget.event.maxParticipants}',
                style: TextStyle(
                  color: const Color(0xFFFFFFFF),
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

  /// Build the event details
  Widget _buildEventDetails(double screenWidth) {
    final textFontSize = 16.0; // Consistent text font size
    final verticalSpacing = 15.0; // Consistent vertical spacing

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 5.0, // Consistent horizontal padding
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
              'Category:\n${widget.event.category}',
              style: TextStyle(
                color: Colors.white,
                fontSize: textFontSize,
              ),
            ),
            SizedBox(height: verticalSpacing),
            Text(
              'Description:\n${
                  widget.event.description.isEmpty
                      ? 'No description available'
                      : widget.event.description
              }',
              style: TextStyle(
                color: Colors.white,
                fontSize: textFontSize,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: verticalSpacing * 2),
            Text(
              'Location:\n${widget.event.location}',
              style: TextStyle(
                color: Colors.white,
                fontSize: textFontSize,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: verticalSpacing),
            Text(
              'Start Date: ${_formatDateTime(widget.event.startDate)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: textFontSize,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: verticalSpacing / 2),
            Text(
              'End Date: ${_formatDateTime(widget.event.endDate)}',
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