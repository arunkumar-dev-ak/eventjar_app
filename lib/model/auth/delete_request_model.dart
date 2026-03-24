class DeleteRequestResponse {
  final bool success;
  final DeleteRequestData data;

  DeleteRequestResponse({required this.success, required this.data});

  factory DeleteRequestResponse.fromJson(Map<String, dynamic> json) {
    try {
      return DeleteRequestResponse(
        success: json['success'] ?? false,
        data: DeleteRequestData.fromJson(json['data']),
      );
    } catch (e) {
      throw Exception('Error in DeleteRequestResponse: $e');
    }
  }

  Map<String, dynamic> toJson() => {'success': success, 'data': data.toJson()};
}

class DeleteRequestData {
  final bool hasPendingDeletion;
  final String message;
  final DateTime? cancelledAt;
  final DateTime? requestedAt;
  final DateTime? scheduledFor;
  final DateTime? deletedAt;
  final int? remainingDays;
  final String? reason;

  DeleteRequestData({
    required this.hasPendingDeletion,
    required this.message,
    this.cancelledAt,
    this.deletedAt,
    this.requestedAt,
    this.scheduledFor,
    this.remainingDays,
    this.reason,
  });

  factory DeleteRequestData.fromJson(Map<String, dynamic> json) {
    try {
      return DeleteRequestData(
        hasPendingDeletion: json['hasPendingDeletion'] ?? false,
        message: json['message'] ?? '',
        cancelledAt: json['cancelledAt'] != null
            ? DateTime.parse(json['cancelledAt'])
            : null,
        requestedAt: json['requestedAt'] != null
            ? DateTime.parse(json['requestedAt'])
            : null,
        scheduledFor: json['scheduledFor'] != null
            ? DateTime.parse(json['scheduledFor'])
            : null,
        deletedAt: json['deletedAt'] != null
            ? DateTime.parse(json['deletedAt'])
            : null,
        remainingDays: json['remainingDays'],
        reason: json['reason'],
      );
    } catch (e) {
      throw Exception('Error in DeleteRequestData: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'hasPendingDeletion': hasPendingDeletion,
    'message': message,
    'cancelledAt': cancelledAt,
    'deletedAt': deletedAt,
    'requestedAt': requestedAt,
    'scheduledFor': scheduledFor,
    'remainingDays': remainingDays,
    'reason': reason,
  };
}
