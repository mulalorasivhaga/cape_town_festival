class Rating {
  final String userId;
  final String rsvpId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  Rating({
    required this.userId,
    required this.rsvpId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Rating.fromMap(Map<String, dynamic> map, String docId) {
    return Rating(
      userId: map['userId'] ?? '',
      rsvpId: map['rsvpId'] ?? '',
      rating: map['rating'] ?? 0,
      comment: map['comment'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rsvpId': rsvpId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}