class TicketEligibilityResponse {
  final bool success;
  final bool eligible;
  final String? reason;
  final TicketInfo ticketInfo;
  final EventInfoShort eventInfo;

  TicketEligibilityResponse({
    required this.success,
    required this.eligible,
    this.reason,
    required this.ticketInfo,
    required this.eventInfo,
  });

  factory TicketEligibilityResponse.fromJson(Map<String, dynamic> json) {
    return TicketEligibilityResponse(
      success: json['success'] ?? false,
      eligible: json['eligible'] ?? false,
      reason: json['reason'],
      ticketInfo: TicketInfo.fromJson(json['ticketInfo']),
      eventInfo: EventInfoShort.fromJson(json['eventInfo']),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'eligible': eligible,
    'reason': reason,
    'ticketInfo': ticketInfo.toJson(),
    'eventInfo': eventInfo.toJson(),
  };
}

class TicketInfo {
  final String id;
  final String name;
  final String price;
  final bool isFree;
  final int available;

  TicketInfo({
    required this.id,
    required this.name,
    required this.price,
    required this.isFree,
    required this.available,
  });

  factory TicketInfo.fromJson(Map<String, dynamic> json) {
    return TicketInfo(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      isFree: json['isFree'] ?? false,
      available: json['available'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'isFree': isFree,
    'available': available,
  };
}

class EventInfoShort {
  final String id;
  final String title;
  final bool isOneMeetingEnabled;

  EventInfoShort({
    required this.id,
    required this.title,
    required this.isOneMeetingEnabled,
  });

  factory EventInfoShort.fromJson(Map<String, dynamic> json) {
    return EventInfoShort(
      id: json['id'],
      title: json['title'],
      isOneMeetingEnabled: json['isOneMeetingEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isOneMeetingEnabled': isOneMeetingEnabled,
  };
}
