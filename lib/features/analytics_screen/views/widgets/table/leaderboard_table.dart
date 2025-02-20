import 'package:flutter/material.dart';

class LeaderboardTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const LeaderboardTable({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure data is sorted and handle null values
    final sortedData = List<Map<String, dynamic>>.from(data)
      ..sort((a, b) {
        // Safely handle null values by treating them as 0
        final valueA = (a['value'] ?? 0) as int;
        final valueB = (b['value'] ?? 0) as int;
        return valueB.compareTo(valueA); // Sort in descending order
      });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Event RSVP Leaderboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3), // Event name column
                1: FlexColumnWidth(1), // RSVP count column
              },
              children: [
                // Table header
                const TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Event Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'RSVPs',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                // Table data
                ...sortedData.map((item) => TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['label']?.toString() ?? 'Untitled'),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text((item['value'] ?? 0).toString()),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
