class Event {
  final String id;
  final String title;
  final String description;
  final String maxParticipants;
  final String category;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.maxParticipants,
    required this.category,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  // Convert from Map to Event object
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      maxParticipants: map['maxParticipants'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
      startDate: DateTime.parse(map['startDate'] ?? DateTime.now().toString()),
      endDate: DateTime.parse(map['endDate'] ?? DateTime.now().toString()),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toString()),
    );
  }

  // Convert Event object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'maxParticipants': maxParticipants,
      'category': category,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Factory method to create an Event from Firestore
  factory Event.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Event(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      maxParticipants: data['maxParticipants'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      startDate: DateTime.parse(data['startDate'] ?? DateTime.now().toString()),
      endDate: DateTime.parse(data['endDate'] ?? DateTime.now().toString()),
      createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toString()),
    );
  }
}