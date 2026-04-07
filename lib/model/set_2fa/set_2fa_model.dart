class Generate2FAResponse {
  final String secret;
  final String qrCode;

  Generate2FAResponse({required this.secret, required this.qrCode});

  factory Generate2FAResponse.fromJson(Map<String, dynamic> json) {
    return Generate2FAResponse(
      secret: json['secret'] ?? '',
      qrCode: json['qrCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'secret': secret, 'qrCode': qrCode};
  }
}
