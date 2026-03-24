class TicketPaymentModel {
  final bool success;
  final String? paymentId;
  final String? razorpayKeyId;
  final String? error;

  TicketPaymentModel({
    required this.success,
    this.paymentId,
    this.razorpayKeyId,
    this.error,
  });

  factory TicketPaymentModel.fromJson(Map<String, dynamic> json) {
    try {
      return TicketPaymentModel(
        success: json['success'] ?? false,
        paymentId: json['paymentId']?.toString(),
        razorpayKeyId: json['razorpayKeyId']?.toString(),
        error: json['error']?.toString(),
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
      'error': error,
    };
  }

  bool get canOpenRazorpay =>
      success && razorpayKeyId != null && paymentId != null;
  String get razorpayError => error ?? 'Payment initialization failed';
}
