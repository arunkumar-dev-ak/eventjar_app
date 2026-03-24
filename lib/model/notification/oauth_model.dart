class OAuthAuthUrlResponse {
  final String authUrl;

  OAuthAuthUrlResponse({required this.authUrl});

  factory OAuthAuthUrlResponse.fromJson(Map<String, dynamic> json) {
    return OAuthAuthUrlResponse(authUrl: json['authUrl'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'authUrl': authUrl};
  }
}
