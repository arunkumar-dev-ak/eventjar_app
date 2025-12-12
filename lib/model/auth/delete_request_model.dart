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
  final String? cancelledAt;
  final String? requestedAt;
  final String? scheduledFor;
  final int? remainingDays;
  final String? reason;

  DeleteRequestData({
    required this.hasPendingDeletion,
    required this.message,
    this.cancelledAt,
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
        cancelledAt: json['cancelledAt'],
        requestedAt: json['requestedAt'],
        scheduledFor: json['scheduledFor'],
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
    'requestedAt': requestedAt,
    'scheduledFor': scheduledFor,
    'remainingDays': remainingDays,
    'reason': reason,
  };
}
