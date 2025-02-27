import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'dart:ui_web' as ui_web;
import 'package:ct_festival/config/api_keys.dart';

class MapWidget extends StatefulWidget {
  final String eventTitle;
  final String location;
  final double height;

  const MapWidget({
    super.key,
    required this.eventTitle,
    required this.location,
    this.height = 300.0,
  });

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  bool isMapLoaded = false;

  @override
  void initState() {
    super.initState();
    final String viewId = 'google-map-${widget.eventTitle}';

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
          ..style.pointerEvents = 'auto'
          ..style.overflow = 'hidden'
          ..style.userSelect = 'none'
          ..src = 'https://www.google.com/maps/embed/v1/place'
              '?key=${ApiKeys.googleMapsKey}'
              '&q=${Uri.encodeComponent(widget.location)}'
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: HtmlElementView(
              viewType: 'google-map-${widget.eventTitle}',
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
}
