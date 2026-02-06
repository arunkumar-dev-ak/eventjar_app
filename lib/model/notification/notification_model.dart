class NotificationSettingsEmailResponse {
  final bool success;
  final EmailConfig? emailConfig;
  final String? error;

  NotificationSettingsEmailResponse({
    required this.success,
    this.emailConfig,
    this.error,
  });

  factory NotificationSettingsEmailResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return NotificationSettingsEmailResponse(
      success: json['success'] ?? false,
      emailConfig: json['emailConfig'] != null
          ? EmailConfig.fromJson(json['emailConfig'])
          : null,
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'emailConfig': emailConfig?.toJson(),
    'error': error,
  };
}

class EmailConfig {
  final String id;
  final String userId;
  final String smtpHost;
  final int smtpPort;
  final String smtpUsername;
  final String smtpPassword;
  final bool smtpSecure;
  final String fromName;
  final String fromEmail;
  final String? replyToEmail;
  final String? lastTested;
  final String? testStatus;
  final String? testError;
  final String? providerName;
  final int monthlySent;
  final String authType;
  final String? oauthAccessToken;
  final String? oauthRefreshToken;
  final String? oauthTokenExpiry;
  final String? oauthEmail;
  final String? oauthConnectedAt;
  final String status;
  final String createdAt;
  final String updatedAt;

  EmailConfig({
    required this.id,
    required this.userId,
    required this.smtpHost,
    required this.smtpPort,
    required this.smtpUsername,
    required this.smtpPassword,
    required this.smtpSecure,
    required this.fromName,
    required this.fromEmail,
    this.replyToEmail,
    this.lastTested,
    this.testStatus,
    this.testError,
    this.providerName,
    required this.monthlySent,
    required this.authType,
    this.oauthAccessToken,
    this.oauthRefreshToken,
    this.oauthTokenExpiry,
    this.oauthEmail,
    this.oauthConnectedAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmailConfig.fromJson(Map<String, dynamic> json) {
    return EmailConfig(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      smtpHost: json['smtpHost'] ?? '',
      smtpPort: json['smtpPort'] ?? 587,
      smtpUsername: json['smtpUsername'] ?? '',
      smtpPassword: json['smtpPassword'] ?? '',
      smtpSecure: json['smtpSecure'] ?? false,
      fromName: json['fromName'] ?? '',
      fromEmail: json['fromEmail'] ?? '',
      replyToEmail: json['replyToEmail'],
      lastTested: json['lastTested'],
      testStatus: json['testStatus'],
      testError: json['testError'],
      providerName: json['providerName'],
      monthlySent: json['monthlySent'] ?? 0,
      authType: json['authType'] ?? 'password',
      oauthAccessToken: json['oauthAccessToken'],
      oauthRefreshToken: json['oauthRefreshToken'],
      oauthTokenExpiry: json['oauthTokenExpiry'],
      oauthEmail: json['oauthEmail'],
      oauthConnectedAt: json['oauthConnectedAt'],
      status: json['status'] ?? 'inactive',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'smtpHost': smtpHost,
    'smtpPort': smtpPort,
    'smtpUsername': smtpUsername,
    'smtpPassword': smtpPassword,
    'smtpSecure': smtpSecure,
    'fromName': fromName,
    'fromEmail': fromEmail,
    'replyToEmail': replyToEmail,
    'lastTested': lastTested,
    'testStatus': testStatus,
    'testError': testError,
    'providerName': providerName,
    'monthlySent': monthlySent,
    'authType': authType,
    'oauthAccessToken': oauthAccessToken,
    'oauthRefreshToken': oauthRefreshToken,
    'oauthTokenExpiry': oauthTokenExpiry,
    'oauthEmail': oauthEmail,
    'oauthConnectedAt': oauthConnectedAt,
    'status': status,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
