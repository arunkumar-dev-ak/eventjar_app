class LanguageModel {
  final String code;
  final String name;
  final String nativeName;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      code: json['localeCode']?.toString() ?? json['code']?.toString() ?? '',
      name: json['englishName']?.toString() ?? json['name']?.toString() ?? '',
      nativeName: json['nativeName']?.toString() ?? '',
    );
  }

  Map<String, String> toJson() {
    return {
      'localeCode': code,
      'englishName': name,
      'nativeName': nativeName,
    };
  }
}
