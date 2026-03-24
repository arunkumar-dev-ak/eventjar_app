import 'package:eventjar/logger_service.dart';

class ConfigStatusResponse {
  final bool emailConfig;
  final bool whatsappConfig;

  ConfigStatusResponse({
    required this.emailConfig,
    required this.whatsappConfig,
  });

  factory ConfigStatusResponse.fromJson(Map<String, dynamic> json) {
    try {
      return ConfigStatusResponse(
        emailConfig: json['emailConfig'] as bool,

        whatsappConfig: json['whatsappConfig'] as bool,
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing ConfigStatusResponse: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'emailConfig': emailConfig,
    'whatsappConfig': whatsappConfig,
  };
}
