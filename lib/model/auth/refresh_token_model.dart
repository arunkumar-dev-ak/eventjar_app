class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;

  RefreshTokenResponse({required this.accessToken, required this.refreshToken});

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    try {
      return RefreshTokenResponse(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
      );
    } catch (e) {
      throw Exception('Error in RefreshTokenResponse: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
}
