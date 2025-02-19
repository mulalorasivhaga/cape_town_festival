import 'package:flutter/material.dart';

class LeaderboardTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const LeaderboardTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Sort the data by RSVP count in descending order
    data.sort((a, b) => b['rsvpCount'].compareTo(a['rsvpCount']));

    return Container(
      width: screenWidth * 0.9, // Adjust width to fit the screen
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          DataTable(
            columnSpacing: 20.0,
            columns: const [
              DataColumn(
                label: Expanded(child: Text('Event Title', style: TextStyle(fontWeight: FontWeight.bold))),
              ),
              DataColumn(
                label: Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('RSVP Count', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                numeric: true,
              ),
            ],
            rows: data.map((event) {
              return DataRow(cells: [
                DataCell(Text(event['eventTitle'])),
                DataCell(
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(event['rsvpCount'].toString()),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
