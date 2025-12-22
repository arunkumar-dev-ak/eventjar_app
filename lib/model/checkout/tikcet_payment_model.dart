class TicketPaymentModel {
  final bool success;
  final String paymentId;
  final String razorpayKeyId;

  TicketPaymentModel({
    required this.success,
    required this.paymentId,
    required this.razorpayKeyId,
  });

  factory TicketPaymentModel.fromJson(Map<String, dynamic> json) {
    try {
      return TicketPaymentModel(
        success: json['success'] ?? false,
        paymentId: json['paymentId']?.toString() ?? '',
        razorpayKeyId: json['razorpayKeyId']?.toString() ?? '',
      );
    } catch (e) {
      throw Exception('Error in TicketPaymentModel: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'paymentId': paymentId,
      'razorpayKeyId': razorpayKeyId,
    };
  }
}
