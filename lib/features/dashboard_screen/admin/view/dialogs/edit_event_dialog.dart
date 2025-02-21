import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ct_festival/utils/logger.dart';
import '../../../../events_screen/controller/event_service.dart';
import '../../../../events_screen/model/event_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ct_festival/features/home_screen/controller/cloudinary_service.dart';

class EditEventDialog extends StatefulWidget {
  const EditEventDialog({super.key});

  @override
  EditEventDialogState createState() => EditEventDialogState();
}

class EditEventDialogState extends State<EditEventDialog> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController maxParticipantsController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController imageNameController = TextEditingController();
  AppLogger logger = AppLogger();

  Event? selectedEvent;
  String? selectedEventId;
  List<Map<String, dynamic>> events = [];
  PlatformFile? selectedFile;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  /// Load all events
  Future<void> _loadEvents() async {
    final List<Event> eventDocs = await EventService().getAllEvents();
    setState(() {
      events = eventDocs.map((event) => {'id': event.id, 'data': event.toMap()}).toList();
    });
  }

  /// Event selected callback
  void _onEventSelected(Map<String, dynamic>? eventDoc) {
    if (eventDoc != null) {
      setState(() {
        selectedEventId = eventDoc['id'];
        selectedEvent = Event.fromMap(eventDoc['data']);
        eventNameController.text = selectedEvent!.title;
        eventDescriptionController.text = selectedEvent!.description;
        maxParticipantsController.text = selectedEvent!.maxParticipants;
        categoryController.text = selectedEvent!.category;
        locationController.text = selectedEvent!.location;
        startDateController.text = selectedEvent!.startDate.toString();
        endDateController.text = selectedEvent!.endDate.toString();
      });
    }
  }

  /// Build the dialog
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

  /// Build the header
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
            'Edit Event',
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

  /// Build the event form
  Widget _buildEventForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedEventId,
              hint: const Text('Select Event'),
              items: events.map((eventDoc) {
                return DropdownMenuItem<String>(
                  value: eventDoc['id'] as String,
                  child: Text(eventDoc['data']['title'] as String),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  final selectedEventDoc = events.firstWhere(
                    (event) => event['id'] == newValue,
                  );
                  _onEventSelected(selectedEventDoc);
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Event Information',
            style: TextStyle(
              color: Colors.white,
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
                _buildFormField('Event Title', eventNameController),
                _buildFormField('Event Description', eventDescriptionController),
                _buildFormField('Max Participants', maxParticipantsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                _buildFormField('Category', categoryController),
                _buildFormField('Location', locationController),
                _buildDateTimeField(context, 'Start Date', startDateController),
                _buildDateTimeField(context, 'End Date', endDateController),
                _buildImageUploadSection(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: isUploading ? null : () async {
                if (selectedEventId != null) {
                  try {
                    setState(() {
                      isUploading = true;
                    });

                    String imageUrl = selectedEvent!.imageUrl;
                    if (selectedFile != null) {
                      try {
                        String customName = imageNameController.text.trim();
                        if (customName.isEmpty) {
                          customName = selectedFile!.name.split('.').first;
                        }
                        imageUrl = await CloudinaryService().uploadImage(selectedFile!, customName);
                      } catch (uploadError) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Image upload failed: ${uploadError.toString()}')),
                        );
                        return;
                      }
                    }

                    final updatedEvent = Event(
                      id: selectedEvent!.id,
                      title: eventNameController.text,
                      description: eventDescriptionController.text,
                      maxParticipants: maxParticipantsController.text,
                      category: categoryController.text,
                      location: locationController.text,
                      startDate: DateTime.parse(startDateController.text),
                      endDate: DateTime.parse(endDateController.text),
                      createdAt: selectedEvent!.createdAt,
                      latitude: selectedEvent!.latitude,
                      longitude: selectedEvent!.longitude,
                      imageUrl: imageUrl,
                    );

                    final result = await EventService().editEvent(updatedEvent);
                    logger.logInfo(result);

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result)),
                    );

                    Navigator.of(context).pop();
                  } catch (e) {
                    logger.logError('Error updating event: $e');
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error updating event: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    setState(() {
                      isUploading = false;
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2AF29),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                isUploading ? 'Updating...' : 'Update Event',
                style: const TextStyle(
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

  /// Build the date time field
  Widget _buildDateTimeField(
      BuildContext context,
      String label,
      TextEditingController controller,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 1),
        ),
      ),
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
                  ), dialogTheme: DialogThemeData(backgroundColor: Colors.white), // background color
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
                    ), dialogTheme: DialogThemeData(backgroundColor: Colors.white), // background color
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
            }
          }
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  /// Build the text field
  Widget _buildFormField(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter> inputFormatters = const [],
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Event Image',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    selectedFile?.name ?? 'No new image selected',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );

                  if (result != null) {
                    setState(() {
                      selectedFile = result.files.single;
                      imageNameController.text = result.files.single.name.split('.').first;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2AF29),
                ),
                child: const Text(
                  'Choose Image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: imageNameController,
            decoration: const InputDecoration(
              labelText: 'Image Name',
              hintText: 'Enter a name for the image',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}