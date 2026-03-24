class TicketBadgeValidationModel {
  final bool success;
  final bool eligible;
  final String? reason;

  TicketBadgeValidationModel({
    required this.success,
    required this.eligible,
    this.reason,
  });

  factory TicketBadgeValidationModel.fromJson(Map<String, dynamic> json) {
    try {
      return TicketBadgeValidationModel(
        success: json['success'] ?? false,
        eligible: json['eligible'] ?? false,
        reason: json['reason']?.toString(),
      );
    } catch (e) {
      throw Exception('Error in TicketBadgeValidationModel: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'eligible': eligible, 'reason': reason};
  }

  /// Helper for UI
  bool get canProceed => success && eligible;

  String get validationMessage => reason ?? 'Badge validation failed';
}
