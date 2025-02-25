import 'package:flutter/material.dart';

class UserTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const UserTable({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure data is sorted and handle null values
    final sortedData = List<Map<String, dynamic>>.from(data)
      ..sort((a, b) {
        // Sort by last name, then first name
        final nameA = '${a['lastName']} ${a['firstName']}';
        final nameB = '${b['lastName']} ${b['firstName']}';
        return nameA.compareTo(nameB);
      });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Leaderboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3), // User name column
                1: FlexColumnWidth(2), // Email column
                2: FlexColumnWidth(1), // Gender column
                3: FlexColumnWidth(1), // Age column
              },
              children: [
                // Table header
                const TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'User Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Gender',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Age',
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
                        child: Text('${item['firstName']} ${item['lastName']}'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item['email']?.toString() ?? 'N/A'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item['gender']?.toString() ?? 'N/A'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text((item['age'] ?? 'N/A').toString()),
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