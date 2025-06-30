class LuckyDrawHistory {
  final String username;
  final String luckyDrawId;
  final int pointsUsed;
  final String? personName;
  final String drawName;
  final String drawStatus;
  final int minimumPoints;

  LuckyDrawHistory({
    required this.username,
    required this.luckyDrawId,
    required this.pointsUsed,
    this.personName,
    required this.drawName,
    required this.drawStatus,
    required this.minimumPoints,
  });

  factory LuckyDrawHistory.fromJson(Map<String, dynamic> json) {
    return LuckyDrawHistory(
      username: json['username'] ?? '',
      luckyDrawId: json['lucky_draw_id'] ?? '',
      pointsUsed: json['points_used'] ?? 0,
      personName: json['person_name'],
      drawName: json['draw_name'] ?? '',
      drawStatus: json['draw_status'] ?? '',
      minimumPoints: json['minimum_points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'lucky_draw_id': luckyDrawId,
      'points_used': pointsUsed,
      'person_name': personName,
      'draw_name': drawName,
      'draw_status': drawStatus,
      'minimum_points': minimumPoints,
    };
  }
}