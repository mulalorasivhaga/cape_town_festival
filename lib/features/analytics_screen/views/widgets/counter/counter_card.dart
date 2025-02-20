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
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$_count',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFAD343E),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}