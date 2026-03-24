import 'package:eventjar/logger_service.dart';

class NotificationSettingsEmailResponse {
  final String? id;
  final String? userId;
  final String? smtpHost;
  final int? smtpPort;
  final String? smtpUsername;
  final String? smtpPassword;
  final bool? smtpSecure;
  final String? fromName;
  final String? fromEmail;
  final String? replyToEmail;
  final DateTime? lastTested;
  final String? testStatus;
  final String? testError;
  final String? providerName;
  final int? monthlySent;
  final String? authType;
  final String? oauthAccessToken;
  final String? oauthRefreshToken;
  final DateTime? oauthTokenExpiry;
  final String? oauthEmail;
  final DateTime? oauthConnectedAt;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationSettingsEmailResponse({
    this.id,
    this.userId,
    this.smtpHost,
    this.smtpPort,
    this.smtpUsername,
    this.smtpPassword,
    this.smtpSecure,
    this.fromName,
    this.fromEmail,
    this.replyToEmail,
    this.lastTested,
    this.testStatus,
    this.testError,
    this.providerName,
    this.monthlySent,
    this.authType,
    this.oauthAccessToken,
    this.oauthRefreshToken,
    this.oauthTokenExpiry,
    this.oauthEmail,
    this.oauthConnectedAt,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  NotificationSettingsEmailResponse.empty()
    : id = null,
      userId = null,
      smtpHost = null,
      smtpPort = null,
      smtpUsername = null,
      smtpPassword = null,
      smtpSecure = null,
      fromName = null,
      fromEmail = null,
      replyToEmail = null,
      lastTested = null,
      testStatus = null,
      testError = null,
      providerName = null,
      monthlySent = null,
      authType = null,
      oauthAccessToken = null,
      oauthRefreshToken = null,
      oauthTokenExpiry = null,
      oauthEmail = null,
      oauthConnectedAt = null,
      status = null,
      createdAt = null,
      updatedAt = null;

  factory NotificationSettingsEmailResponse.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return NotificationSettingsEmailResponse.empty();
    }

    return NotificationSettingsEmailResponse(
      id: json['id'],
      userId: json['userId'],
      smtpHost: json['smtpHost'],
      smtpPort: json['smtpPort'],
      smtpUsername: json['smtpUsername'],
      smtpPassword: json['smtpPassword'],
      smtpSecure: json['smtpSecure'],
      fromName: json['fromName'],
      fromEmail: json['fromEmail'],
      replyToEmail: json['replyToEmail'],
      lastTested: json['lastTested'] != null
          ? DateTime.parse(json['lastTested'])
          : null,
      testStatus: json['testStatus'],
      testError: json['testError'],
      providerName: json['providerName'],
      monthlySent: json['monthlySent'],
      authType: json['authType'],
      oauthAccessToken: json['oauthAccessToken'],
      oauthRefreshToken: json['oauthRefreshToken'],
      oauthTokenExpiry: json['oauthTokenExpiry'] != null
          ? DateTime.parse(json['oauthTokenExpiry'])
          : null,
      oauthEmail: json['oauthEmail'],
      oauthConnectedAt: json['oauthConnectedAt'] != null
          ? DateTime.parse(json['oauthConnectedAt'])
          : null,
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "smtpHost": smtpHost,
      "smtpPort": smtpPort,
      "smtpUsername": smtpUsername,
      "smtpPassword": smtpPassword,
      "smtpSecure": smtpSecure,
      "fromName": fromName,
      "fromEmail": fromEmail,
      "replyToEmail": replyToEmail,
      "lastTested": lastTested?.toIso8601String(),
      "testStatus": testStatus,
      "testError": testError,
      "providerName": providerName,
      "monthlySent": monthlySent,
      "authType": authType,
      "oauthAccessToken": oauthAccessToken,
      "oauthRefreshToken": oauthRefreshToken,
      "oauthTokenExpiry": oauthTokenExpiry?.toIso8601String(),
      "oauthEmail": oauthEmail,
      "oauthConnectedAt": oauthConnectedAt?.toIso8601String(),
      "status": status,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}
