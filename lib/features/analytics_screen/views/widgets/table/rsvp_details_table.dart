import 'package:flutter/material.dart';
import 'package:ct_festival/features/analytics_screen/controller/analytics_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/utils/logger.dart';

class RsvpDetailsTable extends StatefulWidget {
  const RsvpDetailsTable({super.key});

  @override
  State<RsvpDetailsTable> createState() => _RsvpDetailsTableState();
}

class _RsvpDetailsTableState extends State<RsvpDetailsTable> {
  final AnalyticsService _analyticsService = AnalyticsService(
    firestore: FirebaseFirestore.instance,
  );
  final AppLogger _logger = AppLogger();

  String? selectedEventId;
  List<Map<String, dynamic>> eventOptions = [];
  List<Map<String, dynamic>> rsvpDetails = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEventTitles();
  }

  Future<void> _loadEventTitles() async {
    try {
      setState(() => isLoading = true);
      final options = await _analyticsService.getEventTitlesForDropdown();
      setState(() {
        eventOptions = options;
        isLoading = false;
      });
    } catch (e) {
      _logger.logError('Error loading event titles: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadRsvpDetails(String eventId) async {
    try {
      setState(() => isLoading = true);
      final details = await _analyticsService.getEventRsvpDetails(eventId);
      setState(() {
        rsvpDetails = details;
        isLoading = false;
      });

      // Check if there's no data and show snackbar
      if (details.isEmpty) {
        // Need to use a post-frame callback to ensure the build is complete
        // before showing the snackbar
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No RSVP data found for this event'),
              backgroundColor: Color(0xFFAD343E),
              duration: Duration(seconds: 3),
            ),
          );
        });
      }
    } catch (e) {
      _logger.logError('Error loading RSVP details: $e');
      setState(() => isLoading = false);

      // Show error snackbar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load RSVP details: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }
  }

  Widget _buildMobileView() {
    return ListView.builder(
      itemCount: rsvpDetails.length,
      itemBuilder: (context, index) {
        final detail = rsvpDetails[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: ExpansionTile(
            title: Text(detail['userName'] ?? 'N/A'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Age', detail['age']),
                    _buildDetailRow('Gender', detail['gender']),
                    _buildDetailRow('RSVP Status', detail['rsvpStatus']),
                    _buildDetailRow('Comment', detail['comment']),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value ?? 'N/A'),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF2AF29)),
          columnSpacing: 24,
          horizontalMargin: 16,
          dataRowMinHeight: 60,
          dataRowMaxHeight: 80,
          columns: const [
            DataColumn(
              label: Expanded(
                child: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Age',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Gender',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'RSVP Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Comment',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
            rows: rsvpDetails.map((detail) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(detail['userName'] ?? 'N/A'),
                  ),
                  DataCell(
                    Text(detail['age'] ?? 'N/A'),
                  ),
                  DataCell(
                    Text(detail['gender'] ?? 'N/A'),
                  ),
                  DataCell(
                    Text(detail['rsvpStatus'] ?? 'N/A'),
                  ),
                  DataCell(
                    Text(
                      detail['comment'] ?? 'N/A',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              );
            }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Material(
      child: Container(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        decoration: BoxDecoration(
          color: const Color(0xFFAD343E),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RSVP Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: isDesktop ? 24 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isDesktop ? 24 : 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedEventId,
                  hint: const Text('Select an event'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedEventId = newValue;
                    });
                    if (newValue != null) {
                      _loadRsvpDetails(newValue);
                    }
                  },
                  items: eventOptions.map<DropdownMenuItem<String>>((Map<String, dynamic> event) {
                    return DropdownMenuItem<String>(
                      value: event['id']?.toString(),
                      child: Text(event['title']?.toString() ?? 'Untitled Event'),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: isDesktop ? 24 : 16),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFFAD343E)))
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
}