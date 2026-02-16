import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import '../../model/card_info.dart';
import '../../model/contact/mobile_contact_model.dart';
import '../../routes/route_name.dart';
import 'state.dart';

class ScanCardController extends GetxController
    with GetTickerProviderStateMixin {
  var appBarTitle = "Scan Visting Card";
  final state = ScanCardState();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();

  final Rx<VisitingCardInfo> cardInfo = VisitingCardInfo().obs;

  Color primaryColor = Color(0xFF1C56BF);
  Color secondaryColor = Color(0xFF167B4D);

  AnimationController? _scanLineController;
  AnimationController? _fadeController;
  AnimationController? _floatingIconsController;
  Animation<double>? _scanLineAnimation;
  Animation<double>? _fadeAnimation;

  AnimationController get scanLineController => _scanLineController!;
  AnimationController get fadeController => _fadeController!;
  AnimationController get floatingIconsController => _floatingIconsController!;
  Animation<double> get scanLineAnimation => _scanLineAnimation!;
  Animation<double> get fadeAnimation => _fadeAnimation!;

  bool get isInitialized => _floatingIconsController != null;

  @override
  void onInit() {
    super.onInit();

    // Initialize flutter_libphonenumber
    _initPhoneNumberLibrary();

    _scanLineController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _floatingIconsController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineController!, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController!, curve: Curves.easeOut));
  }

  Future<void> _initPhoneNumberLibrary() async {
    try {
      await init();
    } catch (e) {
      // Handle initialization error silently
    }
  }

  Future<void> pickImageFromCamera() async {
    await _pickAndProcessImage(ImageSource.camera);
  }

  Future<void> pickImageFromGallery() async {
    await _pickAndProcessImage(ImageSource.gallery);
  }

  Future<void> _pickAndProcessImage(ImageSource source) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 100,
      );

      if (image == null) {
        isLoading.value = false;
        return;
      }

      selectedImage.value = File(image.path);
      await _processImage(image.path);
    } catch (e) {
      errorMessage.value = 'Error picking image: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _processImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      final extractedText = recognizedText.text;

      // Check if any text was extracted
      if (extractedText.trim().isEmpty) {
        errorMessage.value =
            'No text detected. Please try again with a clearer image.';
        return;
      }

      // Check if multiple cards are detected
      if (_hasMultipleCards(extractedText)) {
        errorMessage.value =
            'Multiple cards detected. Please scan only one visiting card at a time.';
        return;
      }

      final info = await _extractCardInfo(extractedText);

      // Check if any useful data was extracted
      if (!info.hasData) {
        errorMessage.value =
            'Could not recognize card details. Please ensure the card is clearly visible and try again.';
      }

      cardInfo.value = info;
    } catch (e) {
      errorMessage.value = 'Error processing image: $e';
    }
  }

  bool _hasMultipleCards(String text) {
    // Count occurrences of email patterns
    final emailRegex = RegExp(
      r'[a-zA-Z0-9._%+-]+\s*@\s*[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
      caseSensitive: false,
    );
    final emailMatches = emailRegex.allMatches(text).toList();

    // Get unique emails (landscape mode may duplicate same email)
    final uniqueEmails = <String>{};
    for (final match in emailMatches) {
      final email = (match.group(0) ?? '').toLowerCase().replaceAll(' ', '');
      uniqueEmails.add(email);
    }

    // Check for different email domains - this is the ONLY reliable indicator of multiple cards
    // Business cards often have multiple phone numbers (landline, mobile, support, fax)
    // but they typically have only one email domain per company/person
    if (uniqueEmails.length > 1) {
      final domains = uniqueEmails.map((email) {
        final atIndex = email.indexOf('@');
        return atIndex > 0 ? email.substring(atIndex + 1) : '';
      }).toSet();

      // Different email domains = definitely multiple cards
      if (domains.length > 1) return true;
    }

    return false;
  }

  Future<VisitingCardInfo> _extractCardInfo(String text) async {
    final info = VisitingCardInfo(rawText: text);

    // Extract email - any text containing @ is email
    info.email = _extractEmail(text);

    // Extract phone number with country code
    final phoneParsed = await _extractPhoneParsed(text);
    info.phoneParsed = phoneParsed;
    info.phone = phoneParsed?.phoneNumber;

    // Extract name - usually in top portion of card
    info.name = _extractName(text, info.email, info.phone);

    return info;
  }

  String? _extractEmail(String text) {
    final lines = text.split('\n');

    for (final line in lines) {
      // Check if line contains @ (with or without spaces around it)
      if (line.contains('@')) {
        // First, try to find the email part by splitting on spaces
        // This handles cases like "M V2vdailyfuel @gmail.com" where M is an icon
        final parts = line.trim().split(RegExp(r'\s+'));

        // Find the part containing @ and combine with adjacent parts
        String emailPart = '';
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].contains('@')) {
            // Get part before @ if it exists and previous part looks like email prefix
            if (i > 0 && !_isSingleIconChar(parts[i - 1])) {
              emailPart = parts[i - 1] + parts[i];
            } else {
              emailPart = parts[i];
            }
            // Add part after @ if needed (for cases like "abc @ gmail.com")
            if (i + 1 < parts.length && !parts[i].contains('.')) {
              emailPart += parts[i + 1];
            }
            break;
          }
        }

        // If no email found from parts, try removing spaces around @
        if (emailPart.isEmpty) {
          emailPart = line.replaceAll(RegExp(r'\s*@\s*'), '@');
        }

        // Find email pattern
        final emailRegex = RegExp(
          r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
          caseSensitive: false,
        );

        final match = emailRegex.firstMatch(emailPart);
        if (match != null) {
          return match.group(0);
        }

        // Fallback: try with all spaces removed but skip single leading chars
        String cleanedLine = line.trim();
        // Remove common icon prefixes (single letter followed by space)
        cleanedLine = cleanedLine.replaceFirst(
          RegExp(r'^[A-Z]\s+', caseSensitive: false),
          '',
        );
        cleanedLine = cleanedLine.replaceAll(' ', '');

        final fallbackMatch = emailRegex.firstMatch(cleanedLine);
        if (fallbackMatch != null) {
          return fallbackMatch.group(0);
        }
      }
    }
    return null;
  }

  bool _isSingleIconChar(String text) {
    // Single character that's likely an icon indicator (M for mail, etc.)
    final trimmed = text.trim();
    return trimmed.length == 1 && RegExp(r'^[A-Z]$').hasMatch(trimmed);
  }

  Future<PhoneParsed?> _extractPhoneParsed(String text) async {
    // Extract all potential phone number strings from text
    final potentialNumbers = _extractPotentialNumbers(text);

    if (potentialNumbers.isEmpty) {
      return null;
    }

    // List of regions to try in order of priority
    final regionsToTry = [
      'IN',
      'US',
      'GB',
      'AE',
      'AU',
      'CA',
      'SG',
      'MY',
      'NZ',
      'ZA',
      'PH',
      'TH',
      'ID',
      'VN',
    ];

    // Try each potential number with the plugin
    for (final number in potentialNumbers) {
      // First try with the plugin
      final parsedPhone = await _parsePhoneWithLibrary(number, regionsToTry);
      if (parsedPhone != null) {
        return parsedPhone;
      }

      // If plugin fails, try fallback parsing
      final fallbackPhone = _fallbackPhoneParsing(number);
      if (fallbackPhone != null) {
        return fallbackPhone;
      }
    }

    return null;
  }

  List<String> _extractPotentialNumbers(String text) {
    final List<String> potentialNumbers = [];
    final Set<String> addedNumbers = {}; // Track to avoid duplicates
    final lines = text.split('\n');

    for (final line in lines) {
      final trimmedLine = line.trim();

      // Skip empty lines
      if (trimmedLine.isEmpty) continue;

      // Skip lines with email or website
      if (trimmedLine.contains('@') ||
          trimmedLine.toLowerCase().contains('www') ||
          trimmedLine.toLowerCase().contains('http')) {
        continue;
      }

      // Extract all digit sequences with common phone number separators
      // Pattern 1: International format with + or 00
      final internationalMatches = RegExp(
        r'(?:\+|00)\s*\d{1,4}[\s\-\(\)\.]*\d[\d\s\-\(\)\.]{6,}',
      ).allMatches(trimmedLine);

      for (final match in internationalMatches) {
        String potentialNumber = match.group(0)?.trim() ?? '';
        final digitCount = potentialNumber
            .replaceAll(RegExp(r'[^\d]'), '')
            .length;

        if (digitCount >= 7 && digitCount <= 15) {
          final digitsOnly = potentialNumber.replaceAll(RegExp(r'[^\d+]'), '');
          if (!addedNumbers.contains(digitsOnly)) {
            potentialNumbers.add(potentialNumber);
            addedNumbers.add(digitsOnly);
          }
        }
      }

      // Pattern 2: Phone numbers starting with digits (10 digit mobile, etc.)
      final localMatches = RegExp(
        r'\b\d[\d\s\-\(\)\.]{6,}\b',
      ).allMatches(trimmedLine);

      for (final match in localMatches) {
        String potentialNumber = match.group(0)?.trim() ?? '';
        final digitCount = potentialNumber
            .replaceAll(RegExp(r'[^\d]'), '')
            .length;

        // Accept 7-15 digits
        if (digitCount >= 7 && digitCount <= 15) {
          final digitsOnly = potentialNumber.replaceAll(RegExp(r'[^\d]'), '');
          if (!addedNumbers.contains(digitsOnly)) {
            potentialNumbers.add(potentialNumber);
            addedNumbers.add(digitsOnly);
          }
        }
      }

      // Pattern 3: Digits with spaces/dashes (like "98765 43210" or "9876-543-210")
      final spacedMatches = RegExp(
        r'\d{4,5}[\s\-\.]+\d{4,6}',
      ).allMatches(trimmedLine);

      for (final match in spacedMatches) {
        String potentialNumber = match.group(0)?.trim() ?? '';
        final digitCount = potentialNumber
            .replaceAll(RegExp(r'[^\d]'), '')
            .length;

        if (digitCount >= 7 && digitCount <= 15) {
          final digitsOnly = potentialNumber.replaceAll(RegExp(r'[^\d]'), '');
          if (!addedNumbers.contains(digitsOnly)) {
            potentialNumbers.add(potentialNumber);
            addedNumbers.add(digitsOnly);
          }
        }
      }
    }

    return potentialNumbers;
  }

  Future<PhoneParsed?> _parsePhoneWithLibrary(
    String phoneNumber,
    List<String> regionsToTry,
  ) async {
    // Clean the phone number but keep + for international format
    String cleaned = phoneNumber.trim();

    // Try parsing with each region using flutter_libphonenumber
    for (final region in regionsToTry) {
      try {
        // Use the plugin to parse and format the phone number
        final formattedData = await parse(cleaned, region: region);

        if (formattedData != null) {
          final String? e164 = formattedData['e164'];
          final String? national = formattedData['national'];

          // Check if parsing was successful and we have E.164 format
          if (e164 != null && e164.isNotEmpty && e164.startsWith('+')) {
            // Extract country code and national number from E.164 format
            final countryCode = _extractCountryCodeFromE164(e164);
            final nationalNumber = e164.substring(countryCode.length);

            // More lenient validation - accept if we have any reasonable length
            if (nationalNumber.isNotEmpty && nationalNumber.length >= 6) {
              return PhoneParsed(
                fullNumber: e164,
                countryCode: countryCode,
                phoneNumber: nationalNumber,
              );
            }
          }

          // Fallback: if E.164 failed but we have national format
          if (national != null && national.isNotEmpty) {
            final digitsOnly = national.replaceAll(RegExp(r'[^\d]'), '');
            if (digitsOnly.length >= 7) {
              // Use the region's country code
              String countryCode = _getCountryCodeForRegion(region);
              return PhoneParsed(
                fullNumber: '$countryCode$digitsOnly',
                countryCode: countryCode,
                phoneNumber: digitsOnly,
              );
            }
          }
        }
      } catch (e) {
        // Try next region if parsing fails
        continue;
      }
    }

    return null;
  }

  String _getCountryCodeForRegion(String region) {
    // Map common region codes to country codes
    final regionToCountryCode = {
      'IN': '+91',
      'US': '+1',
      'CA': '+1',
      'GB': '+44',
      'AE': '+971',
      'AU': '+61',
      'SG': '+65',
      'MY': '+60',
      'PK': '+92',
      'BD': '+880',
    };
    return regionToCountryCode[region] ?? '+91';
  }

  String _extractCountryCodeFromE164(String e164) {
    // E.164 format: +[country code][national number]
    // Country codes can be 1-4 digits
    if (!e164.startsWith('+')) return '+91'; // Default fallback

    // Try to match common country codes
    final commonCodes = [
      '+1',
      '+91',
      '+44',
      '+971',
      '+61',
      '+86',
      '+33',
      '+81',
    ];
    for (final code in commonCodes) {
      if (e164.startsWith(code)) {
        return code;
      }
    }

    // Extract first 1-4 digits after +
    final match = RegExp(r'^\+(\d{1,4})').firstMatch(e164);
    if (match != null) {
      return '+${match.group(1)}';
    }

    return '+91'; // Default fallback
  }

  PhoneParsed? _fallbackPhoneParsing(String phoneNumber) {
    // Clean the phone number - keep only digits and +
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleaned.isEmpty) return null;

    String countryCode = '+91'; // Default to India
    String nationalNumber = cleaned;

    // Check for international format with +
    if (cleaned.startsWith('+')) {
      // Try to identify country code
      if (cleaned.startsWith('+91') && cleaned.length >= 12) {
        // Indian number: +91XXXXXXXXXX (12-13 digits)
        countryCode = '+91';
        nationalNumber = cleaned.substring(3);
      } else if (cleaned.startsWith('+1') && cleaned.length >= 11) {
        // US/Canada: +1XXXXXXXXXX (11 digits)
        countryCode = '+1';
        nationalNumber = cleaned.substring(2);
      } else if (cleaned.startsWith('+44') && cleaned.length >= 12) {
        // UK: +44XXXXXXXXXX
        countryCode = '+44';
        nationalNumber = cleaned.substring(3);
      } else if (cleaned.startsWith('+971') && cleaned.length >= 12) {
        // UAE: +971XXXXXXXXX
        countryCode = '+971';
        nationalNumber = cleaned.substring(4);
      } else if (cleaned.startsWith('+61') && cleaned.length >= 11) {
        // Australia: +61XXXXXXXXX
        countryCode = '+61';
        nationalNumber = cleaned.substring(3);
      } else {
        // Generic extraction for other codes
        final match = RegExp(r'^\+(\d{1,4})').firstMatch(cleaned);
        if (match != null) {
          countryCode = '+${match.group(1)}';
          nationalNumber = cleaned.substring(countryCode.length);
        }
      }
    } else if (cleaned.startsWith('00')) {
      // International format without + (00XXXXXXXXXXX)
      if (cleaned.startsWith('0091') && cleaned.length >= 14) {
        countryCode = '+91';
        nationalNumber = cleaned.substring(4);
      } else {
        final match = RegExp(r'^00(\d{1,4})').firstMatch(cleaned);
        if (match != null) {
          countryCode = '+${match.group(1)}';
          nationalNumber = cleaned.substring(2 + match.group(1)!.length);
        }
      }
    } else if (cleaned.startsWith('91') && cleaned.length == 12) {
      // Indian number without + (91XXXXXXXXXX)
      countryCode = '+91';
      nationalNumber = cleaned.substring(2);
    } else if (cleaned.startsWith('0') && cleaned.length >= 10) {
      // Number with trunk prefix (0XXXXXXXXXX)
      nationalNumber = cleaned.substring(1);
    } else if (cleaned.length >= 10) {
      // Direct national number (XXXXXXXXXX)
      nationalNumber = cleaned;
    } else {
      // Too short to be valid
      return null;
    }

    // Validate national number length
    final digitsOnly = nationalNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Accept numbers with 7-15 digits (more lenient)
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      return null;
    }

    // For Indian numbers, prefer mobile numbers (starting with 6-9)
    // but accept landlines too
    if (countryCode == '+91' && digitsOnly.length == 10) {
      // Valid Indian number
      return PhoneParsed(
        fullNumber: '$countryCode$digitsOnly',
        countryCode: countryCode,
        phoneNumber: digitsOnly,
      );
    } else if (digitsOnly.length >= 7) {
      // Valid number for other countries
      return PhoneParsed(
        fullNumber: '$countryCode$digitsOnly',
        countryCode: countryCode,
        phoneNumber: digitsOnly,
      );
    }

    return null;
  }

  String? _extractName(String text, String? email, String? phone) {
    final lines = text
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    // Collect all valid name candidates with their cleaned versions
    final nameCandidates = <String>[];

    for (final line in lines) {
      String trimmedLine = line.trim();

      // Skip lines starting with dash/hyphen (like "-TALLY INSTITUTE")
      if (trimmedLine.startsWith('-') || trimmedLine.startsWith('–')) {
        continue;
      }

      // Clean up the line - remove trailing punctuation like commas, dashes
      trimmedLine = trimmedLine.replaceAll(RegExp(r'[,\-:;]+$'), '').trim();

      // Skip if line contains email
      if (email != null &&
          trimmedLine.toLowerCase().contains(email.toLowerCase())) {
        continue;
      }
      if (trimmedLine.contains('@')) {
        continue;
      }

      // Skip if line contains phone number
      if (phone != null && trimmedLine.contains(phone)) {
        continue;
      }

      // Skip if line has too many digits (likely phone/address)
      final digitCount = trimmedLine.replaceAll(RegExp(r'[^\d]'), '').length;
      if (digitCount > 3) {
        continue;
      }

      // Skip common business terms and designations
      if (_isCommonBusinessTerm(trimmedLine) || _isDesignation(trimmedLine)) {
        continue;
      }

      // Skip short abbreviations/logos (like BNI, ABC, etc.)
      if (_isAbbreviationOrLogo(trimmedLine)) {
        continue;
      }

      // Check if it looks like a name
      if (_looksLikeName(trimmedLine)) {
        nameCandidates.add(trimmedLine);
      }
    }

    if (nameCandidates.isEmpty) {
      return null;
    }

    // Score candidates and pick the best one
    String? bestCandidate;
    int bestScore = -1;

    for (final candidate in nameCandidates) {
      int score = _scoreNameCandidate(candidate);
      if (score > bestScore) {
        bestScore = score;
        bestCandidate = candidate;
      }
    }

    return bestCandidate;
  }

  int _scoreNameCandidate(String name) {
    int score = 0;

    final words = name
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();

    // 2-3 words is ideal for a full name
    if (words.length == 2) score += 10;
    if (words.length == 3) score += 8;
    if (words.length == 1) score += 3;

    // Names with initials like "S.THIYAGARAJAN" or "K. RAJ" are common
    if (name.contains('.')) score += 2;

    // All caps names are common on business cards
    if (name == name.toUpperCase()) score += 3;

    // Title case names
    if (_isTitleCase(name)) score += 3;

    // Longer names (but not too long) are more likely to be real names
    if (name.length >= 10 && name.length <= 30) score += 2;

    return score;
  }

  bool _isTitleCase(String text) {
    final words = text.split(RegExp(r'\s+'));
    for (final word in words) {
      if (word.isEmpty) continue;
      if (word[0] != word[0].toUpperCase()) return false;
    }
    return true;
  }

  bool _isAbbreviationOrLogo(String text) {
    final trimmed = text.trim();

    // Very short text (1-4 chars) is likely a logo/abbreviation
    if (trimmed.length <= 4) return true;

    // All caps single word with less than 6 chars (like BNI, HDFC, ICICI)
    if (!trimmed.contains(' ') &&
        trimmed == trimmed.toUpperCase() &&
        trimmed.length < 6) {
      return true;
    }

    return false;
  }

  bool _isCommonBusinessTerm(String text) {
    final lowerText = text.toLowerCase();
    final businessTerms = [
      'address',
      'street',
      'road',
      'city',
      'state',
      'zip',
      'phone',
      'tel',
      'fax',
      'email',
      'website',
      'www',
      'http',
      'pvt',
      'ltd',
      'inc',
      'llc',
      'corp',
      'private',
      'limited',
      'floor',
      'building',
      'office',
      'tower',
      'plaza',
      'complex',
      'nagar',
      'colony',
      'sector',
      'phase',
      'block',
      'survey',
      'services',
      'solutions',
      'mapping',
      'civil',
      'infra',
      'gis',
      'remote',
      'sensing',
      'drone',
      'lidar',
      'dgps',
      'station',
      'end-to-end',
      'land',
      'total',
      'technologies',
      'technology',
      'systems',
      'system',
      'consulting',
      'enterprises',
      'industries',
      'group',
      'company',
      'works',
      'agency',
      'studio',
      'labs',
      'lab',
      'digital',
      'media',
      'creative',
      'designs',
      'construction',
      'builders',
      'realty',
      'properties',
      'estates',
      'trading',
      'exports',
      'imports',
      'logistics',
      'transport',
      'motors',
      'auto',
      'electronics',
      'electrical',
      'pharma',
      'healthcare',
      'medical',
      'dental',
      'clinic',
      'hospital',
      'foods',
      'beverages',
      'textiles',
      'garments',
      'jewellers',
      'jewellery',
      'furniture',
      'interiors',
      'interior',
      'exterior',
      'architects',
      'engineering',
      'manufacturers',
      'distributors',
      'retailers',
      'wholesale',
      'designing',
      'desinging',
      'design',
      'visualization',
      'visualizations',
      '3d',
      'planning',
      'supervising',
      'supervision',
      'renovation',
      'decorat',
      'modular',
      'kitchen',
      'wardrobe',
      'cupboard',
      'false ceiling',
      'painting',
      'plumbing',
      'carpentry',
      'flooring',
      'tiling',
      'contractor',
      'contracting',
      'institute',
      'institution',
      'academy',
      'school',
      'college',
      'university',
      'training',
      'tally',
      'online',
      'coaching',
      'tuition',
      'classes',
      'centre',
      'center',
    ];
    return businessTerms.any((term) => lowerText.contains(term));
  }

  bool _isDesignation(String text) {
    final lowerText = text.toLowerCase();
    final designations = [
      'manager',
      'director',
      'ceo',
      'cto',
      'cfo',
      'coo',
      'president',
      'vice president',
      'vp',
      'head',
      'lead',
      'senior',
      'junior',
      'executive',
      'officer',
      'engineer',
      'developer',
      'designer',
      'analyst',
      'consultant',
      'architect',
      'specialist',
      'coordinator',
      'administrator',
      'assistant',
      'associate',
      'supervisor',
      'founder',
      'co-founder',
      'partner',
      'proprietor',
      'owner',
      'chairman',
      'managing',
      'general',
      'regional',
      'national',
      'global',
      'chief',
      'principal',
      'sales',
      'marketing',
      'finance',
      'operations',
      'technical',
      'software',
      'hardware',
      'business',
      'product',
      'project',
      'program',
      'account',
      'customer',
      'client',
      'support',
      'service',
      'secretary',
      'clerk',
      'trainee',
      'intern',
      'member',
      'team',
    ];
    return designations.any((term) => lowerText.contains(term));
  }

  bool _looksLikeName(String text) {
    final trimmed = text.trim();

    // Too short or too long
    if (trimmed.length < 2 || trimmed.length > 40) return false;

    // Names should NOT contain special characters like &, /, \, etc.
    if (trimmed.contains(RegExp(r'[&/\\|@#$%^*()+=\[\]{}<>]'))) return false;

    // Should be mostly letters and spaces (allow dots for initials like "K. Raj")
    final lettersAndSpaces = trimmed.replaceAll(RegExp(r'[^a-zA-Z\s.]'), '');
    if (lettersAndSpaces.length < trimmed.length * 0.9) return false;

    // Should have 1-4 words (names typically 1-4 parts)
    final words = trimmed
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty || words.length > 4) return false;

    // At least one word should have 2+ letters
    final hasValidWord = words.any(
      (w) => w.replaceAll(RegExp(r'[^a-zA-Z]'), '').length >= 2,
    );
    if (!hasValidWord) return false;

    // Names are typically in Title Case or ALL CAPS
    // Check if at least first letter is uppercase
    final hasUppercase = trimmed.contains(RegExp(r'[A-Z]'));
    if (!hasUppercase) return false;

    return true;
  }

  void clearData() {
    cardInfo.value = VisitingCardInfo();
    selectedImage.value = null;
    errorMessage.value = '';
  }

  Future<void> navigateToAddContact(BuildContext context) async {
    Get.toNamed(RouteName.addContactPage, arguments: cardInfo.value)?.then((
      result,
    ) async {
      if (result == "refresh") {
        Navigator.pop(Get.context!, "refresh");
      }
    });
  }

  @override
  void onClose() {
    _scanLineController?.dispose();
    _fadeController?.dispose();
    _floatingIconsController?.dispose();
    super.onClose();
  }
}
