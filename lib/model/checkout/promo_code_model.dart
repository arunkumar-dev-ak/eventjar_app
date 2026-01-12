class PromoCodeValidationResponse {
  final bool valid;
  final String message;
  final double discountAmount;
  final String? promoCodeId;

  PromoCodeValidationResponse({
    required this.valid,
    required this.message,
    required this.discountAmount,
    this.promoCodeId,
  });

  factory PromoCodeValidationResponse.fromJson(Map<String, dynamic> json) {
    return PromoCodeValidationResponse(
      valid: json['valid'] ?? false,
      message: json['message'] ?? '',
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      promoCodeId: json['promo_code_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valid': valid,
      'message': message,
      'discount_amount': discountAmount,
      'promo_code_id': promoCodeId,
    };
  }
}
