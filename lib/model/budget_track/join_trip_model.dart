class JoinTripResponse {
  final String id;
  final String name;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String currency;
  final int memberCount;
  final JoinTripCreator? createdBy;
  final bool isAlreadyMember;

  JoinTripResponse({
    required this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.currency,
    required this.memberCount,
    this.createdBy,
    required this.isAlreadyMember,
  });

  factory JoinTripResponse.fromJson(Map<String, dynamic> json) {
    return JoinTripResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      destination: json['destination'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: json['status'] ?? '',
      currency: json['currency'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      createdBy: json['createdBy'] != null
          ? JoinTripCreator.fromJson(json['createdBy'])
          : null,
      isAlreadyMember: json['isAlreadyMember'] ?? false,
    );
  }
}

class JoinTripCreator {
  final String id;
  final String name;
  final String? avatarUrl;

  JoinTripCreator({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory JoinTripCreator.fromJson(Map<String, dynamic> json) {
    return JoinTripCreator(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'],
    );
  }
}
