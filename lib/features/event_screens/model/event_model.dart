// collection of event details
class Event {
  final String title;
  final String description;
  final String maxParticipants;
  final String category;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  Event({
    required this.title,
    required this.description,
    required this.maxParticipants,
    required this.category,
    required this.location,
    required this.startDate,
    required this.endDate,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
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

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      maxParticipants: map['maxParticipants'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
      startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : DateTime.now(),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : DateTime.now(),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
    );
  }

  Event copyWith({
    String? title,
    String? description,
    String? maxParticipants,
    String? category,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
  }) {
    return Event(
      title: title ?? this.title,
      description: description ?? this.description,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      category: category ?? this.category,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Event(title: $title,'
        ' description: $description,'
        ' maxParticipants: $maxParticipants,'
        ' category: $category,'
        ' location: $location,'
        ' startDate: $startDate,'
        ' endDate: $endDate,'
        ' createdAt: $createdAt)';
  }
}