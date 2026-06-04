class TranslationResponse {
  final String version;
  final Map<String, String> translations;

  const TranslationResponse({
    required this.version,
    required this.translations,
  });

  factory TranslationResponse.fromJson(Map<String, dynamic> json) {
    return TranslationResponse(
      version: json['version']?.toString() ?? '',
      translations: Map<String, String>.from(json['translations'] as Map),
    );
  }
}
