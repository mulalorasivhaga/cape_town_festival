import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../utils/logger.dart';
import '../../../analytics_screen/controller/analytics_services.dart';

class CommentsTable extends StatefulWidget {
  final String eventId;

  const CommentsTable({
    super.key,
    required this.eventId,
  });

  @override
  State<CommentsTable> createState() => _CommentsTableState();
}

class _CommentsTableState extends State<CommentsTable> {
  // Initialize services
  final AnalyticsService _analyticsService = AnalyticsService(
    firestore: FirebaseFirestore.instance,
  );
  final AppLogger _logger = AppLogger();

  List<Map<String, dynamic>> commentsData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  /// This method loads the comments for the event
  Future<void> _loadComments() async {
    try {
      setState(() => isLoading = true);
      final details = await _analyticsService.getEventRsvpDetails(widget.eventId);

      // Filter out entries with no comments or "N/A" comments
      final List<Map<String, dynamic>> validComments = details.where((detail) {
        return detail['comment'] != null &&
            detail['comment'] != 'N/A' &&
            detail['rating'] != null; // Add rating check
      }).toList();

      setState(() {
        commentsData = validComments;
        isLoading = false;
      });

      if (validComments.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No comments found for this event'),
              backgroundColor: Color(0xFFAD343E),
              duration: Duration(seconds: 3),
            ),
          );
        });
      }
    } catch (e) {
      _logger.logError('Error loading comments: $e');
      setState(() => isLoading = false);
    }
  }

  /// This method builds the comments table
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 756;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        decoration: BoxDecoration(
          color: Color(0xFF474747),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 1), // Add black border
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Comments',
              style: TextStyle(
                color: Colors.white,
                fontSize: isDesktop ? 24 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFAD343E),
                  ),
                )
                    : isDesktop
                    ? _buildDesktopView()
                    : _buildMobileView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// This method builds the comments table for mobile view
  Widget _buildMobileView() {
    return ListView.builder(
      itemCount: commentsData.length,
      itemBuilder: (context, index) {
        final comment = commentsData[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.black), // Add black border
          ),
          child: ListTile(
            title: Text(
              comment['userName'] ?? 'Anonymous',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(comment['comment'] ?? 'No comment'),
            ),
          ),
        );
      },
    );
  }

  /// This method builds the comments table for desktop view
  Widget _buildDesktopView() {
    return SingleChildScrollView(
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.black,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF2AF29)),
              columnSpacing: 24,
              horizontalMargin: 16,
              border: const TableBorder(
                horizontalInside: BorderSide(color: Colors.black, width: 1),
                verticalInside: BorderSide(color: Colors.black, width: 1),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Comment',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Rating',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: commentsData.map((comment) {
                return DataRow(
                  cells: [
                    DataCell(Text(comment['userName'] ?? 'Anonymous')),
                    DataCell(
                      SizedBox(
                        width: 300,
                        child: Text(
                          comment['comment'] ?? 'No comment',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    DataCell(_buildStarRating(comment['rating'] ?? 0)),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: const Color(0xFFF2AF29),
          size: 20,
        );
      }),
    );
  }
}