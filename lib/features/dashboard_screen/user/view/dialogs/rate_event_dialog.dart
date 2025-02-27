import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/rating_service.dart';
import 'package:ct_festival/utils/logger.dart';

class RateEventDialog extends ConsumerStatefulWidget {
  const RateEventDialog({super.key});

  @override
  RateEventDialogState createState() => RateEventDialogState();
}

class RateEventDialogState extends ConsumerState<RateEventDialog> {
  final RatingService _ratingService = RatingService();
  final AppLogger logger = AppLogger();
  final TextEditingController _commentController = TextEditingController();
  
  String? selectedRsvpId;
  int _selectedRating = 0;
  Map<String, String> eventTitles = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEventTitles();
  }

  Future<void> _loadEventTitles() async {
    try {
      final titles = await _ratingService.fetchEventTitles(ref);
      setState(() {
        eventTitles = titles;
        isLoading = false;
      });
    } catch (e) {
      logger.logError('Error loading event titles: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Dialog(
        backgroundColor: Color (0xFF474747),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading your events...',
              style: TextStyle(
                color: Colors.white
              ),),
            ],
          ),
        ),
      );
    }

    if (eventTitles.isEmpty) {
      return Dialog(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'No Events to Rate',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text('You have no confirmed RSVPs to rate.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: const Color(0xFFAD343E),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildRatingForm(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF2AF29), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Rate Event',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDropdown() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Event to Rate',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF474747),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF474747)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedRsvpId,
                hint: const Text('Choose an event'),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                items: eventTitles.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRsvpId = newValue;
                    _selectedRating = 0;
                    _commentController.clear();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                _buildEventDropdown(),
                if (selectedRsvpId != null) ...[
                  const Divider(height: 1, color: Color(0xFFF2AF29)),
                  _buildRatingStars(),
                  const Divider(height: 1, color: Color(0xFFF2AF29)),
                  _buildCommentField(),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (selectedRsvpId != null)
            Center(
              child: ElevatedButton(
                onPressed: _selectedRating == 0 ? null : _submitRating,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2AF29),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit Rating',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRatingStars() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'How would you rate this event?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF474747),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _selectedRating ? Icons.star : Icons.star_border,
                  color: const Color(0xFFF2AF29),
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    _selectedRating = index + 1;
                  });
                },
              );
            }),
          ),
          Text(
            _selectedRating > 0 ? '$_selectedRating/5' : 'Select your rating',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF474747),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentField() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comments',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF474747),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF474747)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Share your thoughts about the event...',
                contentPadding: EdgeInsets.all(12),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                color: Color(0xFF474747),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRating() async {
    if (selectedRsvpId == null) return;

    try {
      await _ratingService.createRating(
        selectedRsvpId!,
        _selectedRating,
        _commentController.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rating submitted successfully'),
          backgroundColor: Color(0xFF474747),
        ),
      );
    } catch (e) {
      logger.logError('Error submitting rating: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit rating: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}