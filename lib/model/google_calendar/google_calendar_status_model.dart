class GoogleCalendarStatusModel {
  final bool connected;
  final String? email;
  final String? timezone;
  final String? connectedAt;
  final bool oauthConfigured;

  GoogleCalendarStatusModel({
    required this.connected,
    this.email,
    this.timezone,
    this.connectedAt,
    required this.oauthConfigured,
  });

  factory GoogleCalendarStatusModel.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] ?? json;

      return GoogleCalendarStatusModel(
        connected: data['connected'] ?? false,
        email: data['email']?.toString(),
        timezone: data['timezone']?.toString(),
        connectedAt: data['connectedAt']?.toString(),
        oauthConfigured: data['oauthConfigured'] ?? false,
      );
    } catch (e) {
      throw Exception('Error in GoogleCalendarStatusModel: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'connected': connected,
      'email': email,
      'timezone': timezone,
      'connectedAt': connectedAt,
      'oauthConfigured': oauthConfigured,
    };
  }
}
