import 'package:eventjar/logger_service.dart';

class EmailProvidersResponse {
  final List<EmailProvider> providers;

  EmailProvidersResponse({required this.providers});

  factory EmailProvidersResponse.fromJson(dynamic json) {
    try {
      final list = json is List
          ? json
          : (json['providers'] as List<dynamic>? ?? []);

      List<EmailProvider> providersList = list.map((item) {
        return EmailProvider.fromJson(item as Map<String, dynamic>);
      }).toList();

      return EmailProvidersResponse(providers: providersList);
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing EmailProvidersResponse');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'providers': providers.map((provider) => provider.toJson()).toList(),
  };
}

class EmailProvider {
  final String name;
  final String host;
  final int port;
  final bool secure;
  final String description;
  final String setupInstructions;
  final bool? supportsOAuth;
  final String? oauthProvider;

  EmailProvider({
    required this.name,
    required this.host,
    required this.port,
    required this.secure,
    required this.description,
    required this.setupInstructions,
    this.supportsOAuth,
    this.oauthProvider,
  });

  factory EmailProvider.fromJson(Map<String, dynamic> json) {
    try {
      return EmailProvider(
        name: json['name'] ?? '',
        host: json['host'] ?? '',
        port: (json['port'] as num?)?.toInt() ?? 587,
        secure: json['secure'] ?? false,
        description: json['description'] ?? '',
        setupInstructions: json['setupInstructions'] ?? '',
        supportsOAuth: json['supportsOAuth'],
        oauthProvider: json['oauthProvider'],
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing EmailProvider');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'host': host,
    'port': port,
    'secure': secure,
    'description': description,
    'setupInstructions': setupInstructions,
    'supportsOAuth': supportsOAuth,
    'oauthProvider': oauthProvider,
  };
}
