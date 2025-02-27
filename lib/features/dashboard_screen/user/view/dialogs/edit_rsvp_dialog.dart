import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ct_festival/features/dashboard_screen/user/controller/rsvp_service.dart';
import 'package:ct_festival/features/dashboard_screen/user/model/rsvp_model.dart';
import 'package:ct_festival/utils/logger.dart';

class EditRsvpDialog extends ConsumerStatefulWidget {
  const EditRsvpDialog({super.key});

  @override
  EditRsvpDialogState createState() => EditRsvpDialogState();
}

class EditRsvpDialogState extends ConsumerState<EditRsvpDialog> {
  final RsvpService _rsvpService = RsvpService();
  final AppLogger logger = AppLogger();
  
  Rsvp? selectedRsvp;
  String? selectedStatus;
  List<Rsvp> userRsvps = [];
  Map<String, String> eventTitles = {};

  @override
  void initState() {
    super.initState();
    _loadUserRsvps();
  }

  Future<void> _loadUserRsvps() async {
    try {
      final rsvps = await _rsvpService.fetchUserRsvps(ref);
      final titles = <String, String>{};
      
      for (var rsvp in rsvps) {
        final event = await _rsvpService.eventService.getEventById(rsvp.eventId);
        titles[rsvp.eventId] = event.title;
      }

      setState(() {
        userRsvps = rsvps;
        eventTitles = titles;
      });
    } catch (e) {
      logger.logError('Error loading RSVPs: $e');
    }
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm RSVP Update'),
          content: Text(
            'Are you sure you want to change your RSVP status to ${selectedStatus?.toLowerCase()}?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close confirmation dialog
                await _updateRsvp();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateRsvp() async {
    if (selectedRsvp == null || selectedStatus == null) {
      throw Exception('Invalid RSVP data');
    }

    final updatedRsvp = selectedRsvp!.copyWith(status: selectedStatus!);
    final currentContext = context; // Store context in a local variable

    try {
      await _rsvpService.editRsvp(selectedRsvp!.id, updatedRsvp.status);

      if (!currentContext.mounted) return;  // Use currentContext.mounted instead of context.mounted

      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(content: Text('RSVP updated successfully')),
      );
      Navigator.of(currentContext).pop();
    } catch (e) {
      logger.logError('Error updating RSVP: $e');

      if (!currentContext.mounted) return;  // Use currentContext.mounted instead of context.mounted

      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(content: Text('Failed to update RSVP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(child: _buildRsvpForm(context)),
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
            'Edit RSVP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF000000)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildRsvpForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RSVP Information',
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Column(
              children: [
                _buildDropdownField(
                  'Select Event',
                  DropdownButton<Rsvp>(
                    isExpanded: true,
                    value: selectedRsvp,
                    hint: const Text('Select Event'),
                    items: userRsvps.map((rsvp) {
                      return DropdownMenuItem<Rsvp>(
                        value: rsvp,
                        child: Text(eventTitles[rsvp.eventId] ?? 'Unknown Event'),
                      );
                    }).toList(),
                    onChanged: (Rsvp? value) {
                      setState(() {
                        selectedRsvp = value;
                        selectedStatus = null; // Reset status when event changes
                      });
                    },
                  ),
                ),
                _buildDropdownField(
                  'Select Status',
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedStatus,
                    hint: const Text('Select Status'),
                    items: const [
                      DropdownMenuItem(value: 'CONFIRMED', child: Text('Confirmed')),
                      DropdownMenuItem(value: 'CANCELLED', child: Text('Cancelled')),
                    ],
                    onChanged: selectedRsvp == null
                        ? null
                        : (String? value) {
                            setState(() {
                              selectedStatus = value;
                            });
                          },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(

              onPressed: (selectedRsvp == null || selectedStatus == null)
                  ? null
                  : _showConfirmationDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAD343E),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),child: const Text(
                'Update',
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

  Widget _buildDropdownField(String label, Widget dropdown) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          dropdown,
        ],
      ),
    );
  }
}
