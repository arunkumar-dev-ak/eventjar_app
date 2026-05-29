class GoogleCalendarConnectModel {
  final String authUrl;

  GoogleCalendarConnectModel({required this.authUrl});

  factory GoogleCalendarConnectModel.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] ?? json;

      return GoogleCalendarConnectModel(
        authUrl: data['authUrl']?.toString() ?? '',
      );
    } catch (e) {
      throw Exception('Error in GoogleCalendarConnectModel: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {'authUrl': authUrl};
  }
}
