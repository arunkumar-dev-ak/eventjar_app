class GoogleCalendarStatusModel {
  final bool connected;
  final String? email;
  final String? connectedAt;

  GoogleCalendarStatusModel({
    required this.connected,
    this.email,
    this.connectedAt,
  });

  factory GoogleCalendarStatusModel.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] ?? json;

      return GoogleCalendarStatusModel(
        connected: data['connected'] ?? false,
        email: data['email']?.toString(),
        connectedAt: data['connectedAt']?.toString(),
      );
    } catch (e) {
      throw Exception('Error in GoogleCalendarStatusModel: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {'connected': connected, 'email': email, 'connectedAt': connectedAt};
  }
}
