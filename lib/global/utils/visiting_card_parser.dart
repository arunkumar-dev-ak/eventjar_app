import 'package:eventjar/model/card_info.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

/// Shared utility for parsing visiting card text into [VisitingCardInfo].
/// Used by both ScanCardController and AddContactController.
class VisitingCardParser {
  // ── Static data (mirrors ScanCardState) ────────────────────────────────────

  static const List<String> fallbackRegions = [
    'IN', 'US', 'GB', 'AE', 'AU', 'CA',
    'SG', 'MY', 'NZ', 'ZA', 'PH', 'TH', 'ID', 'VN',
  ];

  static const List<String> businessTerms = [
    'address', 'street', 'road', 'city', 'state', 'zip',
    'phone', 'tel', 'fax', 'email', 'website', 'www', 'http',
    'pvt', 'ltd', 'inc', 'llc', 'corp', 'private', 'limited',
    'floor', 'building', 'office', 'tower', 'plaza', 'complex',
    'nagar', 'colony', 'sector', 'phase', 'block', 'survey',
    'services', 'solutions', 'mapping', 'civil', 'infra',
    'gis', 'remote', 'sensing', 'drone', 'lidar', 'dgps',
    'station', 'end-to-end', 'land', 'total',
    'technologies', 'technology', 'systems', 'system',
    'consulting', 'enterprises', 'industries', 'group',
    'company', 'works', 'agency', 'studio', 'labs', 'lab',
    'digital', 'media', 'creative', 'designs',
    'construction', 'builders', 'realty', 'properties', 'estates',
    'trading', 'exports', 'imports', 'logistics', 'transport',
    'motors', 'auto', 'electronics', 'electrical',
    'pharma', 'healthcare', 'medical', 'dental', 'clinic', 'hospital',
    'foods', 'beverages', 'textiles', 'garments',
    'jewellers', 'jewellery', 'furniture', 'interiors', 'interior',
    'exterior', 'architects', 'engineering',
    'manufacturers', 'distributors', 'retailers', 'wholesale',
    'designing', 'desinging', 'design', 'visualization', 'visualizations',
    '3d', 'planning', 'supervising', 'supervision', 'renovation',
    'decorat', 'modular', 'kitchen', 'wardrobe', 'cupboard',
    'false ceiling', 'painting', 'plumbing', 'carpentry',
    'flooring', 'tiling', 'contractor', 'contracting',
    'institute', 'institution', 'academy', 'school', 'college',
    'university', 'training', 'tally', 'online', 'coaching',
    'tuition', 'classes', 'centre', 'center',
  ];

  static const List<String> designations = [
    'manager', 'director', 'ceo', 'cto', 'cfo', 'coo',
    'president', 'vice president', 'vp',
    'head', 'lead', 'senior', 'junior',
    'executive', 'officer', 'engineer', 'developer', 'designer',
    'analyst', 'consultant', 'architect', 'specialist',
    'coordinator', 'administrator', 'assistant', 'associate',
    'supervisor', 'founder', 'co-founder', 'partner',
    'proprietor', 'owner', 'chairman', 'managing',
    'general', 'regional', 'national', 'global', 'chief', 'principal',
    'sales', 'marketing', 'finance', 'operations', 'technical',
    'software', 'hardware', 'business', 'product', 'project',
    'program', 'account', 'customer', 'client',
    'support', 'service', 'secretary', 'clerk',
    'trainee', 'intern', 'member', 'team',
  ];

  static const Map<String, String> dialCodeToRegion = {
    '+880': 'BD', '+886': 'TW', '+852': 'HK', '+853': 'MO',
    '+855': 'KH', '+856': 'LA', '+960': 'MV', '+961': 'LB',
    '+962': 'JO', '+963': 'SY', '+964': 'IQ', '+965': 'KW',
    '+966': 'SA', '+967': 'YE', '+968': 'OM', '+971': 'AE',
    '+972': 'IL', '+973': 'BH', '+974': 'QA', '+975': 'BT',
    '+976': 'MN', '+977': 'NP', '+992': 'TJ', '+993': 'TM',
    '+994': 'AZ', '+995': 'GE', '+996': 'KG', '+998': 'UZ',
    '+350': 'GI', '+351': 'PT', '+352': 'LU', '+353': 'IE',
    '+354': 'IS', '+355': 'AL', '+356': 'MT', '+357': 'CY',
    '+358': 'FI', '+359': 'BG', '+370': 'LT', '+371': 'LV',
    '+372': 'EE', '+373': 'MD', '+374': 'AM', '+375': 'BY',
    '+380': 'UA', '+381': 'RS', '+385': 'HR', '+386': 'SI',
    '+387': 'BA', '+420': 'CZ', '+421': 'SK',
    '+212': 'MA', '+213': 'DZ', '+216': 'TN', '+218': 'LY',
    '+233': 'GH', '+234': 'NG', '+254': 'KE', '+255': 'TZ',
    '+256': 'UG', '+260': 'ZM', '+263': 'ZW',
    '+501': 'BZ', '+502': 'GT', '+503': 'SV', '+504': 'HN',
    '+505': 'NI', '+506': 'CR', '+507': 'PA',
    '+591': 'BO', '+593': 'EC', '+595': 'PY', '+598': 'UY',
    '+20': 'EG', '+27': 'ZA',
    '+30': 'GR', '+31': 'NL', '+32': 'BE', '+33': 'FR',
    '+34': 'ES', '+36': 'HU', '+39': 'IT',
    '+40': 'RO', '+41': 'CH', '+43': 'AT', '+44': 'GB',
    '+45': 'DK', '+46': 'SE', '+47': 'NO', '+48': 'PL', '+49': 'DE',
    '+51': 'PE', '+52': 'MX', '+53': 'CU', '+54': 'AR',
    '+55': 'BR', '+56': 'CL', '+57': 'CO', '+58': 'VE',
    '+60': 'MY', '+61': 'AU', '+62': 'ID', '+63': 'PH',
    '+64': 'NZ', '+65': 'SG', '+66': 'TH',
    '+81': 'JP', '+82': 'KR', '+84': 'VN', '+86': 'CN',
    '+90': 'TR', '+91': 'IN', '+92': 'PK', '+93': 'AF',
    '+94': 'LK', '+95': 'MM', '+98': 'IR',
    '+7': 'RU',
    '+1': 'US',
  };

  // ── Public entry point ──────────────────────────────────────────────────────

  static Future<VisitingCardInfo> extractCardInfo(String text) async {
    final info = VisitingCardInfo(rawText: text);

    info.email = extractEmail(text);

    final allPhones = await extractAllPhonesParsed(text);
    if (allPhones.isNotEmpty) {
      info.phoneParsed = allPhones[0];
      info.phone = allPhones[0].phoneNumber;
    }
    if (allPhones.length >= 2) {
      info.phone2Parsed = allPhones[1];
      info.phone2 = allPhones[1].phoneNumber;
    }

    info.website = extractWebsite(text);
    info.address = extractAddress(text);
    info.company = extractCompany(text);
    info.name = extractName(text, info.email, info.phone);

    return info;
  }

  // ── Phone extraction ────────────────────────────────────────────────────────

  static Future<List<PhoneParsed>> extractAllPhonesParsed(
    String text, {
    int limit = 2,
  }) async {
    final potentialNumbers = extractPotentialNumbers(text);
    if (potentialNumbers.isEmpty) return [];

    final List<PhoneParsed> result = [];
    final Set<String> seen = {};

    for (final number in potentialNumbers) {
      if (result.length >= limit) break;
      final parsed =
          await parsePhoneWithLibrary(number, fallbackRegions) ??
          fallbackPhoneParsing(number);
      if (parsed != null && !seen.contains(parsed.fullNumber)) {
        result.add(parsed);
        seen.add(parsed.fullNumber);
      }
    }

    return result;
  }

  static List<String> extractPotentialNumbers(String text) {
    final List<String> potentialNumbers = [];
    final Set<String> addedNumbers = {};
    final lines = text.split('\n');

    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;
      if (trimmedLine.contains('@') ||
          trimmedLine.toLowerCase().contains('www') ||
          trimmedLine.toLowerCase().contains('http')) {
        continue;
      }

      for (final match in RegExp(
        r'(?:\+|00)\s*\d{1,4}[\s\-\(\)\.]*\d[\d\s\-\(\)\.]{6,}',
      ).allMatches(trimmedLine)) {
        final n = match.group(0)?.trim() ?? '';
        final dc = n.replaceAll(RegExp(r'[^\d]'), '').length;
        if (dc >= 7 && dc <= 15) {
          final key = n.replaceAll(RegExp(r'[^\d+]'), '');
          if (!addedNumbers.contains(key)) {
            potentialNumbers.add(n);
            addedNumbers.add(key);
          }
        }
      }

      for (final match in RegExp(r'\b\d[\d\s\-\(\)\.]{6,}\b').allMatches(trimmedLine)) {
        final n = match.group(0)?.trim() ?? '';
        final dc = n.replaceAll(RegExp(r'[^\d]'), '').length;
        if (dc >= 7 && dc <= 15) {
          final key = n.replaceAll(RegExp(r'[^\d+]'), '');
          if (!addedNumbers.contains(key)) {
            potentialNumbers.add(n);
            addedNumbers.add(key);
          }
        }
      }

      for (final match in RegExp(r'\d{4,5}[\s\-\.]+\d{4,6}').allMatches(trimmedLine)) {
        final n = match.group(0)?.trim() ?? '';
        final dc = n.replaceAll(RegExp(r'[^\d]'), '').length;
        if (dc >= 7 && dc <= 15) {
          final key = n.replaceAll(RegExp(r'[^\d+]'), '');
          if (!addedNumbers.contains(key)) {
            potentialNumbers.add(n);
            addedNumbers.add(key);
          }
        }
      }
    }

    return potentialNumbers;
  }

  static Future<PhoneParsed?> parsePhoneWithLibrary(
    String phoneNumber,
    List<String> regionsToTry,
  ) async {
    final String cleaned = phoneNumber.trim();
    List<String> regions;
    String? expectedDialCode;

    if (cleaned.startsWith('+') || cleaned.startsWith('00')) {
      final plusForm = cleaned.startsWith('00') ? '+${cleaned.substring(2)}' : cleaned;
      final detected = _regionFromDialCode(plusForm);
      expectedDialCode = _dialCodeFrom(plusForm);
      regions = detected != null ? [detected] : regionsToTry;
    } else {
      regions = regionsToTry;
    }

    for (final region in regions) {
      try {
        final result = await parse(cleaned, region: region);
        final rawCountryCode = result['country_code']?.toString();
        final e164 = result['e164']?.toString();

        if (rawCountryCode == null || rawCountryCode.isEmpty) continue;
        if (rawCountryCode.length > 3) continue;
        if (e164 == null || e164.isEmpty || !e164.startsWith('+')) continue;

        final countryCode = '+$rawCountryCode';
        if (expectedDialCode != null && countryCode != expectedDialCode) continue;

        final nationalDigits = e164.substring(countryCode.length);
        if (nationalDigits.isEmpty || nationalDigits.length < 6) continue;

        return PhoneParsed(
          fullNumber: e164,
          countryCode: countryCode,
          phoneNumber: nationalDigits,
        );
      } catch (_) {
        continue;
      }
    }

    return null;
  }

  static PhoneParsed? fallbackPhoneParsing(String phoneNumber) {
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.isEmpty) return null;

    String countryCode = '+91';
    String nationalNumber = cleaned;

    if (cleaned.startsWith('+')) {
      final code = _dialCodeFrom(cleaned);
      if (code != null) {
        countryCode = code;
        nationalNumber = cleaned.substring(code.length);
      }
    } else if (cleaned.startsWith('00')) {
      final withPlus = '+${cleaned.substring(2)}';
      final code = _dialCodeFrom(withPlus);
      if (code != null) {
        countryCode = code;
        nationalNumber = withPlus.substring(code.length);
      }
    } else if (cleaned.startsWith('0') && cleaned.length >= 10) {
      final possibleIntl = '+${cleaned.substring(1)}';
      final intlCode = _dialCodeFrom(possibleIntl);
      if (intlCode != null) {
        countryCode = intlCode;
        nationalNumber = possibleIntl.substring(intlCode.length);
      } else {
        nationalNumber = cleaned.substring(1);
      }
    } else {
      final possibleWithPlus = '+$cleaned';
      final embeddedCode = _dialCodeFrom(possibleWithPlus);
      if (embeddedCode != null) {
        countryCode = embeddedCode;
        nationalNumber = cleaned.substring(embeddedCode.length - 1);
      }
    }

    String digitsOnly = nationalNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 6 || digitsOnly.length > 15) return null;

    if (digitsOnly.length == 11 && countryCode == '+91') {
      final stripped = digitsOnly.substring(1);
      if (RegExp(r'^[6-9]\d{9}$').hasMatch(stripped)) digitsOnly = stripped;
    }

    return PhoneParsed(
      fullNumber: '$countryCode$digitsOnly',
      countryCode: countryCode,
      phoneNumber: digitsOnly,
    );
  }

  // ── Field extractors ────────────────────────────────────────────────────────

  static String? extractEmail(String text) {
    final lines = text.split('\n');
    for (final line in lines) {
      if (!line.contains('@')) continue;
      final parts = line.trim().split(RegExp(r'\s+'));
      String emailPart = '';
      for (int i = 0; i < parts.length; i++) {
        if (parts[i].contains('@')) {
          if (i > 0 && !_isSingleIconChar(parts[i - 1])) {
            emailPart = parts[i - 1] + parts[i];
          } else {
            emailPart = parts[i];
          }
          if (i + 1 < parts.length && !parts[i].contains('.')) {
            emailPart += parts[i + 1];
          }
          break;
        }
      }
      if (emailPart.isEmpty) emailPart = line.replaceAll(RegExp(r'\s*@\s*'), '@');
      final emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', caseSensitive: false);
      final match = emailRegex.firstMatch(emailPart);
      if (match != null) return match.group(0);
      String cleanedLine = line.trim().replaceFirst(RegExp(r'^[A-Z]\s+', caseSensitive: false), '').replaceAll(' ', '');
      final fallbackMatch = emailRegex.firstMatch(cleanedLine);
      if (fallbackMatch != null) return fallbackMatch.group(0);
    }
    return null;
  }

  static String? extractWebsite(String text) {
    final match = RegExp(r'(?:https?://|www\.)\S+', caseSensitive: false).firstMatch(text);
    return match?.group(0)?.trim().replaceAll(RegExp(r'[,;]+$'), '');
  }

  static String? extractAddress(String text) {
    final lines = text.split('\n');
    final addressLines = <String>[];
    bool capturing = false;

    final sectionHeader = RegExp(
      r'^(?:HEAD\s+OFFICE|OFFICE|BRANCH|ADDRESS|REGD\.?\s+OFFICE)',
      caseSensitive: false,
    );
    final addressKeywords = RegExp(
      r'\b(?:No\.|Road|Street|St\.|Floor|Level|Nagar|Colony|Dt\.|'
      r'Near|Opp(?:osite)?|NH\.|Plot|Phase|Sector|Block|Cross|Main|'
      r'Layout|Circle|Ave(?:nue)?|Lane|Ln\.|Drive|Dr\.|Boulevard|Blvd|'
      r'Court|Ct\.|Way|Place|Pl\.|Square|Sq\.|Park|Garden|'
      r'Gregory|Colombo|Mumbai|Delhi|Chennai|Bangalore|Hyderabad|'
      r'Dubai|Singapore|London|Sydney|Toronto|Sri\s+Lanka|India|'
      r'Malaysia|Australia|Canada|United\s+Kingdom)\b',
      caseSensitive: false,
    );

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      if (trimmed.contains('@') || trimmed.toLowerCase().contains('www')) continue;
      final digitCount = trimmed.replaceAll(RegExp(r'[^\d]'), '').length;
      if (digitCount > 4 && trimmed.length < 15) continue;

      if (sectionHeader.hasMatch(trimmed)) capturing = true;
      if (capturing) {
        addressLines.add(trimmed);
        if (addressLines.length >= 3) break;
        continue;
      }
      if (addressKeywords.hasMatch(trimmed)) {
        addressLines.add(trimmed);
        if (addressLines.length >= 3) break;
      }
    }

    return addressLines.isEmpty ? null : addressLines.join(', ');
  }

  static String? extractCompany(String text) {
    final companySuffixes = RegExp(
      r'\b(?:Pvt\.?\s*Ltd|Ltd\.?|LLP|Inc\.?|Corp\.?|Group|Industries|Technologies|Solutions|Services|Enterprises|Agriculture|Agri|Construction|Trading|Exports|Imports|Associates|Consultants|Foundation|Institute|Academy|College|Hospital|Clinic|Pharmacy|Retail|Wholesale|International|Global)\b',
      caseSensitive: false,
    );
    for (final line in text.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      if (trimmed.contains('@') || trimmed.toLowerCase().contains('www')) continue;
      if (trimmed.replaceAll(RegExp(r'[^\d]'), '').length > 3) continue;
      if (companySuffixes.hasMatch(trimmed)) return trimmed;
    }
    return null;
  }

  static String? extractName(String text, String? email, String? phone) {
    final lines = text.split('\n').where((l) => l.trim().isNotEmpty).toList();
    final candidates = <String>[];

    for (final line in lines) {
      String trimmed = line.trim();
      if (trimmed.startsWith('-') || trimmed.startsWith('–')) continue;
      trimmed = trimmed.replaceAll(RegExp(r'[,\-:;]+$'), '').trim();
      if (email != null && trimmed.toLowerCase().contains(email.toLowerCase())) continue;
      if (trimmed.contains('@')) continue;
      if (phone != null && trimmed.contains(phone)) continue;
      if (trimmed.replaceAll(RegExp(r'[^\d]'), '').length > 3) continue;
      if (_isCommonBusinessTerm(trimmed) || _isDesignation(trimmed)) continue;
      if (_isAbbreviationOrLogo(trimmed)) continue;
      if (_looksLikeName(trimmed)) candidates.add(trimmed);
    }

    if (candidates.isEmpty) return null;

    String? best;
    int bestScore = -1;
    for (final c in candidates) {
      final s = _scoreNameCandidate(c);
      if (s > bestScore) {
        bestScore = s;
        best = c;
      }
    }
    return best;
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  static String? _regionFromDialCode(String plusNumber) {
    for (final entry in dialCodeToRegion.entries) {
      if (plusNumber.startsWith(entry.key)) return entry.value;
    }
    return null;
  }

  static String? _dialCodeFrom(String plusNumber) {
    for (final code in dialCodeToRegion.keys) {
      if (plusNumber.startsWith(code)) return code;
    }
    return null;
  }

  static bool _isSingleIconChar(String text) {
    final trimmed = text.trim();
    return trimmed.length == 1 && RegExp(r'^[A-Z]$').hasMatch(trimmed);
  }

  static bool _isCommonBusinessTerm(String text) {
    final lower = text.toLowerCase();
    return businessTerms.any((t) => lower.contains(t));
  }

  static bool _isDesignation(String text) {
    final lower = text.toLowerCase();
    return designations.any((t) => lower.contains(t));
  }

  static bool _isAbbreviationOrLogo(String text) {
    final trimmed = text.trim();
    if (trimmed.length <= 4) return true;
    if (!trimmed.contains(' ') && trimmed == trimmed.toUpperCase() && trimmed.length < 6) return true;
    return false;
  }

  static bool _looksLikeName(String text) {
    final trimmed = text.trim();
    if (trimmed.length < 2 || trimmed.length > 40) return false;
    if (trimmed.contains(RegExp(r'[&/\\|@#$%^*()+=\[\]{}<>]'))) return false;
    final lettersAndSpaces = trimmed.replaceAll(RegExp(r'[^a-zA-Z\s.]'), '');
    if (lettersAndSpaces.length < trimmed.length * 0.9) return false;
    final words = trimmed.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty || words.length > 4) return false;
    if (!words.any((w) => w.replaceAll(RegExp(r'[^a-zA-Z]'), '').length >= 2)) return false;
    return trimmed.contains(RegExp(r'[A-Z]'));
  }

  static int _scoreNameCandidate(String name) {
    int score = 0;
    final words = name.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.length == 2) score += 10;
    if (words.length == 3) score += 8;
    if (words.length == 1) score += 3;
    if (name.contains('.')) score += 2;
    if (name == name.toUpperCase()) score += 3;
    if (_isTitleCase(name)) score += 3;
    if (name.length >= 10 && name.length <= 30) score += 2;
    return score;
  }

  static bool _isTitleCase(String text) {
    for (final word in text.split(RegExp(r'\s+'))) {
      if (word.isEmpty) continue;
      if (word[0] != word[0].toUpperCase()) return false;
    }
    return true;
  }
}
