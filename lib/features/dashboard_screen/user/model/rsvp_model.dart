// collection of user's (registered) rsvp status and event
class Rsvp {
  final String userId;
  final String eventId;
  final String status;
  final DateTime createdAt;
  final int? rating;
  final String? comment;

  Rsvp({
    required this.userId,
    required this.eventId,
    required this.status,
    DateTime? createdAt,
    this.rating,
    this.comment,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'eventId': eventId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'rating': rating,
      'comment': comment,
    };
  }

  factory Rsvp.fromMap(Map<String, dynamic> map, String id) {
    return Rsvp(
      userId: map['userId'] ?? '',
      eventId: map['eventId'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      rating: map['rating']?.toInt(),
      comment: map['comment'] ?? '',
    );
  }

  Rsvp copyWith({
    String? id,
    String? userId,
    String? eventId,
    String? status,
    DateTime? createdAt,
    int? rating,
    String? comment,
  }) {
    return Rsvp(
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
    );
  }

  @override
  String toString() {
    return 'Rsvp('
        'userId: $userId, '
        'eventId: $eventId,'
        ' status: $status,'
        ' createdAt: $createdAt,'
        ' rating: $rating,'
        ' comment: $comment,'
        ')';
  }
}