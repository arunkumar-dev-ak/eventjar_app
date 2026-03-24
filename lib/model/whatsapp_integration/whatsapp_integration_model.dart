class WhatsAppIntegrationModel {
  final String? id;
  final String? userId;
  final String? apiToken;
  final String? verifiedName;
  final String? displayPhoneNumber;
  final String? qualityRating;
  final bool? isActive;
  final bool? isVerified;
  final DateTime? lastVerifiedAt;
  final DateTime? lastTested;
  final String? testStatus;
  final String? testError;
  final Map<String, dynamic>? eventIntegration;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WhatsAppIntegrationModel({
    this.id,
    this.userId,
    this.apiToken,
    this.verifiedName,
    this.displayPhoneNumber,
    this.qualityRating,
    this.isActive,
    this.isVerified,
    this.lastVerifiedAt,
    this.lastTested,
    this.testStatus,
    this.testError,
    this.eventIntegration,
    this.createdAt,
    this.updatedAt,
  });

  WhatsAppIntegrationModel.empty()
    : id = null,
      userId = null,
      apiToken = null,
      verifiedName = null,
      displayPhoneNumber = null,
      qualityRating = null,
      isActive = null,
      isVerified = null,
      lastVerifiedAt = null,
      lastTested = null,
      testStatus = null,
      testError = null,
      eventIntegration = null,
      createdAt = null,
      updatedAt = null;

  factory WhatsAppIntegrationModel.fromJson(dynamic json) {
    try {
      if (json == null || json is! Map<String, dynamic>) {
        return WhatsAppIntegrationModel.empty();
      }

      return WhatsAppIntegrationModel(
        id: json['id']?.toString(),
        userId: json['userId']?.toString(),
        apiToken: json['apiToken']?.toString(),
        verifiedName: json['verifiedName']?.toString(),
        displayPhoneNumber: json['displayPhoneNumber']?.toString(),
        qualityRating: json['qualityRating']?.toString(),
        isActive: json['isActive'] ?? false,
        isVerified: json['isVerified'] ?? false,
        lastVerifiedAt: json['lastVerifiedAt'] != null
            ? DateTime.tryParse(json['lastVerifiedAt'].toString())
            : null,
        lastTested: json['lastTested'] != null
            ? DateTime.tryParse(json['lastTested'].toString())
            : null,
        testStatus: json['testStatus']?.toString(),
        testError: json['testError']?.toString(),
        eventIntegration: json['eventIntegration'] != null
            ? Map<String, dynamic>.from(json['eventIntegration'])
            : {},
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString())
            : null,
      );
    } catch (e) {
      throw Exception('Error in WhatsAppIntegrationModel.fromJson: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "apiToken": apiToken,
      "verifiedName": verifiedName,
      "displayPhoneNumber": displayPhoneNumber,
      "qualityRating": qualityRating,
      "isActive": isActive,
      "isVerified": isVerified,
      "lastVerifiedAt": lastVerifiedAt?.toIso8601String(),
      "lastTested": lastTested?.toIso8601String(),
      "testStatus": testStatus,
      "testError": testError,
      "eventIntegration": eventIntegration,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}
