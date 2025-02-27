// import 'package:flutter/material.dart';
// import 'package:ct_festival/features/dashboard_screen/user/controller/rating_service.dart';
// import 'package:ct_festival/utils/logger.dart';
//
// import '../../../auth_screens/model/user_model.dart' as user_model;
//
// class CommentSection extends StatefulWidget {
//   final String eventId;
//
//   const CommentSection({super.key, required this.eventId});
//
//   @override
//   CommentSectionState createState() => CommentSectionState();
// }
//
// class CommentSectionState extends State<CommentSection> {
//   final RatingService _ratingService = RatingService();
//   List<Map<String, dynamic>> _ratingsWithUserNames = [];
//   final AppLogger logger = AppLogger();
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchRatings();
//   }
//
//   /// Fetch ratings for the specific event
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Comments',
//           style: TextStyle(fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.white
//           ),
//         ),
//         const SizedBox(height: 10),
//         if (_ratingsWithUserNames.isEmpty)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20),
//             child: Text(
//               'No comments for this event.',
//               style: TextStyle(color: Colors.grey),
//             ),
//           )
//         else
//           DataTable(
//             columns: const [
//               DataColumn(label: Text('First Name')),
//               DataColumn(label: Text('Comment')),
//               DataColumn(label: Text('Rating')),
//               DataColumn(label: Text('Date')),
//             ],
//             rows: _ratingsWithUserNames.map((ratingData) {
//               return DataRow(cells: [
//                 DataCell(Text(ratingData['firstName'])),
//                 DataCell(Text(ratingData['comment'])),
//                 DataCell(Text(ratingData['rating'].toString())),
//                 DataCell(Text(ratingData['createdAt'].toString())), // Format as needed
//               ]);
//             }).toList(),
//           ),
//       ],
//     );
//   }
// }