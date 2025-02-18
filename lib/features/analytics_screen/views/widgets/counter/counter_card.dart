import 'package:ct_festival/utils/logger.dart';
import 'package:flutter/material.dart';

class CounterCard extends StatefulWidget {
  final String title;
  final Future<int> Function() fetchCount;

  const CounterCard({super.key, required this.title, required this.fetchCount});

  @override
  CounterCardState createState() => CounterCardState();
}

class CounterCardState extends State<CounterCard> {
  int _count = 0;
  bool _isLoading = true;
  AppLogger logger = AppLogger();

  @override
  void initState() {
    super.initState();
    _fetchCount();
  }

  Future<void> _fetchCount() async {
    try {
      final count = await widget.fetchCount();
      setState(() {
        _count = count;
        //logger.logInfo("${widget.title} count fetched successfully.");
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      logger.logError("Error fetching ${widget.title} count: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$_count',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}