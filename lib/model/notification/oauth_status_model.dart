class OAuthStatusResponse {
  final bool connected;
  final bool oauthConfigured;
  final String? email;
  final DateTime? connectedAt;

  OAuthStatusResponse({
    required this.connected,
    required this.oauthConfigured,
    this.email,
    this.connectedAt,
  });

  factory OAuthStatusResponse.fromJson(Map<String, dynamic> json) {
    try {
      return OAuthStatusResponse(
        connected: json['connected'] ?? false,
        oauthConfigured: json['oauthConfigured'] ?? false,
        email: json['email']?.toString(),
        connectedAt: json['connectedAt'] != null
            ? DateTime.tryParse(json['connectedAt'].toString())
            : null,
      );
    } catch (e) {
      throw Exception('Error in OAuthStatusResponse: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'connected': connected,
      'oauthConfigured': oauthConfigured,
      'email': email,
      'connectedAt': connectedAt?.toIso8601String(),
    };
  }

  bool get isConnected => connected;

  String get displayEmail => email ?? 'Not available';
}
