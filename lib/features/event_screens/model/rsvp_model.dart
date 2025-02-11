// collection of user's (registered) rsvp status and event
class Rsvp {
  final String userId;
  final String eventId;
  final String status;
  final String ticketType;
  final DateTime createdAt;

  Rsvp({
    required this.userId,
    required this.eventId,
    required this.status,
    required this.ticketType,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'eventId': eventId,
      'status': status,
      'ticketType': ticketType,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Rsvp.fromMap(Map<String, dynamic> map) {
    return Rsvp(
      userId: map['userId'] ?? '',
      eventId: map['eventId'] ?? '',
      status: map['status'] ?? '',
      ticketType: map['ticketType'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
    );
  }

  Rsvp copyWith({
    String? userId,
    String? eventId,
    String? status,
    String? ticketType,
    DateTime? createdAt,
  }) {
    return Rsvp(
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      status: status ?? this.status,
      ticketType: ticketType ?? this.ticketType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Rsvp(userId: $userId, eventId: $eventId, status: $status, ticketType: $ticketType, createdAt: $createdAt)';
  }
}