import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/card_info.dart';
import '../../routes/route_name.dart';
import 'state.dart';

class ScanCardController extends GetxController
    with GetTickerProviderStateMixin {
  var appBarTitle = "Scan Visiting Card";
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

      final info = _extractCardInfo(extractedText);

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

  VisitingCardInfo _extractCardInfo(String text) {
    final info = VisitingCardInfo(rawText: text);

    // Extract email - any text containing @ is email
    info.email = _extractEmail(text);

    // Extract phone number
    info.phone = _extractPhone(text);

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

  String? _extractPhone(String text) {
    // Search line by line for phone numbers
    // Prefer mobile numbers (starting with 6-9) over landline/STD (starting with 0)
    final lines = text.split('\n');

    String? firstMobile;
    String? firstLandline;

    for (final line in lines) {
      final trimmedLine = line.trim();

      // Skip empty lines
      if (trimmedLine.isEmpty) continue;

      // Skip lines that are clearly not phone numbers
      if (trimmedLine.contains('@')) continue;
      if (trimmedLine.contains('www')) continue;

      // Look for phone pattern in this line
      final phoneRegex = RegExp(r'[\+]?[0-9][\d\s\-\(\)\.]{8,}');

      final matches = phoneRegex.allMatches(trimmedLine);
      for (final match in matches) {
        String phone = match.group(0) ?? '';
        phone = phone.trim();

        // Remove country code +91 or 91 from the beginning
        phone = _removeCountryCode(phone);

        // Count actual digits
        final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');

        // Check if this is a merged number (more than 12 digits)
        if (digitsOnly.length > 12) {
          // Try to find a mobile number (starting with 6-9) in the merged digits
          final mobilePhone = _findMobileInMerged(digitsOnly);
          if (mobilePhone != null && firstMobile == null) {
            firstMobile = _formatPhone(mobilePhone);
          }
        } else if (digitsOnly.length >= 10) {
          // Check if it's a mobile (starts with 6-9) or landline (starts with 0)
          if (RegExp(r'^[6-9]').hasMatch(digitsOnly)) {
            // Mobile number - preferred
            firstMobile ??= phone;
          } else {
            // Landline/STD number (starts with 0 or area code)
            firstLandline ??= phone;
          }
        }
      }
    }

    // Return mobile number if found, otherwise landline
    // Remove all spaces, dashes, and other formatting from the final number
    final result = firstMobile ?? firstLandline;
    if (result != null) {
      return result.replaceAll(RegExp(r'[\s\-\(\)\.]'), '');
    }
    return null;
  }

  String? _findMobileInMerged(String digits) {
    // Find a 10-digit mobile number (starting with 6-9) in merged digits
    for (int i = 0; i <= digits.length - 10; i++) {
      final candidate = digits.substring(i, i + 10);
      if (RegExp(r'^[6-9]').hasMatch(candidate)) {
        return candidate;
      }
    }
    return null;
  }

  String _removeCountryCode(String phone) {
    // Remove leading/trailing spaces
    String cleaned = phone.trim();

    // Remove +91 with optional space/dash after it
    cleaned = cleaned.replaceFirst(RegExp(r'^\+91[\s\-]?'), '');

    // Remove 91 at the start if followed by a 10-digit number
    // Check if starts with 91 and remaining digits are 10
    final digitsOnly = cleaned.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.startsWith('91') && digitsOnly.length == 12) {
      cleaned = cleaned.replaceFirst(RegExp(r'^91[\s\-]?'), '');
    }

    // Remove 0 prefix (some Indian numbers have 0 before area code)
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }

    return cleaned.trim();
  }

  String _formatPhone(String digits) {
    // Return digits only without any spaces
    return digits.replaceAll(RegExp(r'\s+'), '');
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

  Future<void> navigateToAddContact() async {
    //print(cardInfo);
    Get.toNamed(RouteName.addContactPage, arguments: cardInfo.value);
  }

  @override
  void onClose() {
    _scanLineController?.dispose();
    _fadeController?.dispose();
    _floatingIconsController?.dispose();
    super.onClose();
  }
}
