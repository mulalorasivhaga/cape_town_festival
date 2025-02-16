import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ct_festival/utils/logger.dart';

import '../../../../events_screen/controller/event_service.dart';
import '../../../../events_screen/model/event_model.dart';

class CreateEventDialog extends StatefulWidget {
  const CreateEventDialog({super.key});

  @override
  CreateEventDialogState createState() => CreateEventDialogState();
}

class CreateEventDialogState extends State<CreateEventDialog> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController maxParticipantsController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  AppLogger logger = AppLogger();


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
            Expanded(child: _buildEventForm(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
              'Create Event',
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
      ),
    );
  }

  Widget _buildEventForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            'Event Title',
            eventNameController,
                (value) {},
                (value) => value?.isEmpty ?? true ? 'Please enter Event Title' : null,
          ),
          _buildTextField(
            'Event Description',
            eventDescriptionController,
                (value) {},
                (value) => value?.isEmpty ?? true ? 'Please enter Event Description' : null,
          ),
          _buildTextField(
            'Max Participants',
            maxParticipantsController,
                (value) {},
                (value) => value?.isEmpty ?? true ? 'Please enter Max Participants' : null,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          _buildTextField(
            'Category',
            categoryController,
                (value) {},
                (value) => value?.isEmpty ?? true ? 'Please enter Category' : null,
          ),
          _buildTextField(
            'Location',
            locationController,
                (value) {},
                (value) => value?.isEmpty ?? true ? 'Please enter Location' : null,
          ),
          Row(
            children: [
              Expanded(
                child: _buildDateTimeField(
                  context,
                  'Start Date',
                  startDateController,
                      (value) {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDateTimeField(
                  context,
                  'End Date',
                  endDateController,
                      (value) {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final event = Event(
                id: '',
                title: eventNameController.text,
                description: eventDescriptionController.text,
                maxParticipants: maxParticipantsController.text,
                category: categoryController.text,
                location: locationController.text,
                startDate: DateTime.parse(startDateController.text),
                endDate: DateTime.parse(endDateController.text),
                createdAt: DateTime.now(),
              );

              final result = await EventService().createEvent(event);
              logger.logInfo(result);

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result)),
              );

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF2AF29),
            ),
            child: const Text('Create Event', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildDateTimeField(
      BuildContext context,
      String label,
      TextEditingController controller,
      Function(DateTime) onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          if (!context.mounted) return;
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Color(0xFFAD343E), // header background color
                    onPrimary: Colors.white, // header text color
                    onSurface: Colors.black, // body text color
                  ),
                  dialogBackgroundColor: Colors.white, // background color
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            if (!context.mounted) return;
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Color(0xFFAD343E), // header background color
                      onPrimary: Colors.white, // header text color
                      onSurface: Colors.black, // body text color
                    ),
                    dialogBackgroundColor: Colors.white, // background color
                  ),
                  child: child!,
                );
              },
            );

            if (pickedTime != null) {
              final DateTime finalDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );

              if (!context.mounted) return;
              controller.text = finalDateTime.toString();
              onChanged(finalDateTime);
            }
          }
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF363636), width: 2),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFF2AF29), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      Function(String) onChanged,
      String? Function(String?)? validator, {
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter> inputFormatters = const [],
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator ?? (value) => value?.isEmpty ?? true ? 'Please enter $label' : null,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
    );
  }
}