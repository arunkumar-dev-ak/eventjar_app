import 'dart:io';

import 'package:eventjar/global/store/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
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
    UserStore.cancelAllRequests();
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

    // Check for different email domains as an indicator of multiple cards.
    // Business cards often have multiple phone numbers (landline, mobile, support, fax)
    // and it's common for a single card to have 2 emails on different domains
    // (e.g. personal yahoo/gmail + company email). Only flag as multiple cards
    // when there are 3+ distinct domains, which strongly suggests multiple cards.
    if (uniqueEmails.length > 2) {
      final domains = uniqueEmails.map((email) {
        final atIndex = email.indexOf('@');
        return atIndex > 0 ? email.substring(atIndex + 1) : '';
      }).toSet();

      if (domains.length > 2) return true;
    }

    return false;
  }

  Future<VisitingCardInfo> _extractCardInfo(String text) async {
    final info = VisitingCardInfo(rawText: text);

    // Extract email - any text containing @ is email
    info.email = _extractEmail(text);

    // Extract up to 2 phone numbers
    final allPhones = await _extractAllPhonesParsed(text);
    if (allPhones.isNotEmpty) {
      info.phoneParsed = allPhones[0];
      info.phone = allPhones[0].phoneNumber;
    }
    if (allPhones.length >= 2) {
      info.phone2Parsed = allPhones[1];
      info.phone2 = allPhones[1].phoneNumber;
    }

    // Extract additional card info
    info.website = _extractWebsite(text);
    info.address = _extractAddress(text);
    info.company = _extractCompany(text);

    // Extract name - usually in top portion of card
    info.name = _extractName(text, info.email, info.phone);

    return info;
  }

  /// Extract up to [limit] distinct valid phone numbers from text.
  Future<List<PhoneParsed>> _extractAllPhonesParsed(
    String text, {
    int limit = 2,
  }) async {
    final potentialNumbers = _extractPotentialNumbers(text);
    if (potentialNumbers.isEmpty) return [];

    final regionsToTry = ScanCardState.fallbackRegions;
    final List<PhoneParsed> result = [];
    final Set<String> seen = {};

    for (final number in potentialNumbers) {
      if (result.length >= limit) break;

      final parsed =
          await _parsePhoneWithLibrary(number, regionsToTry) ??
          _fallbackPhoneParsing(number);

      if (parsed != null && !seen.contains(parsed.fullNumber)) {
        result.add(parsed);
        seen.add(parsed.fullNumber);
      }
    }

    return result;
  }

  /// Extract the first website URL found in the text.
  String? _extractWebsite(String text) {
    final websiteRegex = RegExp(
      r'(?:https?://|www\.)\S+',
      caseSensitive: false,
    );
    final match = websiteRegex.firstMatch(text);
    return match?.group(0)?.trim().replaceAll(RegExp(r'[,;]+$'), '');
  }

  /// Extract address lines from text (lines containing common address keywords).
  String? _extractAddress(String text) {
    final lines = text.split('\n');
    final addressLines = <String>[];
    bool capturing = false;

    // Regex for explicit address section headers
    final sectionHeader = RegExp(
      r'^(?:HEAD\s+OFFICE|OFFICE|BRANCH|ADDRESS|REGD\.?\s+OFFICE)',
      caseSensitive: false,
    );

    // Regex for address-like keywords (extended for international cards)
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

      // Skip lines with email / phone / website content
      if (trimmed.contains('@') || trimmed.toLowerCase().contains('www')) {
        continue;
      }

      // Skip lines that are heavily digit-based (phone numbers)
      final digitCount = trimmed.replaceAll(RegExp(r'[^\d]'), '').length;
      if (digitCount > 4 && trimmed.length < 15) continue;

      // Lines that explicitly start an address section
      if (sectionHeader.hasMatch(trimmed)) {
        capturing = true;
      }

      if (capturing) {
        addressLines.add(trimmed);
        if (addressLines.length >= 3) break;
        continue;
      }

      // Lines containing address indicators
      if (addressKeywords.hasMatch(trimmed)) {
        addressLines.add(trimmed);
        if (addressLines.length >= 3) break;
      }
    }

    if (addressLines.isEmpty) return null;
    return addressLines.join(', ');
  }

  /// Best-effort company extraction: looks for all-caps multi-word lines
  /// that contain known business-type words or suffixes.
  String? _extractCompany(String text) {
    final lines = text.split('\n');
    final companySuffixes = RegExp(
      r'\b(?:Pvt\.?\s*Ltd|Ltd\.?|LLP|Inc\.?|Corp\.?|Group|Industries|Technologies|Solutions|Services|Enterprises|Agriculture|Agri|Construction|Trading|Exports|Imports|Associates|Consultants|Foundation|Institute|Academy|College|Hospital|Clinic|Pharmacy|Retail|Wholesale|International|Global)\b',
      caseSensitive: false,
    );

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      if (trimmed.contains('@') || trimmed.toLowerCase().contains('www')) {
        continue;
      }
      // Skip lines heavy with digits
      final digitCount = trimmed.replaceAll(RegExp(r'[^\d]'), '').length;
      if (digitCount > 3) continue;

      if (companySuffixes.hasMatch(trimmed)) {
        return trimmed;
      }
    }

    return null;
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

  List<String> _extractPotentialNumbers(String text) {
    final List<String> mobileNumbers = []; // Numbers from "M:" lines or mobile-looking
    final List<String> otherNumbers = []; // Landline / unknown numbers
    final Set<String> addedNumbers = {}; // Track to avoid duplicates
    final lines = text.split('\n');

    // Pattern to detect mobile-prefixed lines: "M:", "M :", "Mob:", "Mobile:", "Cell:"
    final mobilePrefixRegex = RegExp(
      r'^\s*(?:M|Mob(?:ile)?|Cell)\s*[:.]',
      caseSensitive: false,
    );
    // Pattern to detect landline-prefixed lines: "T:", "Tel:", "Ph:", "F:", "Fax:", "O:"
    final landlinePrefixRegex = RegExp(
      r'^\s*(?:T|Tel(?:ephone)?|Ph(?:one)?|F(?:ax)?|O(?:ffice)?)\s*[:.]',
      caseSensitive: false,
    );

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

      final isMobileLine = mobilePrefixRegex.hasMatch(trimmedLine);
      final isLandlineLine = landlinePrefixRegex.hasMatch(trimmedLine);

      void addNumber(String potentialNumber) {
        final digitCount = potentialNumber
            .replaceAll(RegExp(r'[^\d]'), '')
            .length;

        if (digitCount >= 7 && digitCount <= 15) {
          final digitsOnly = potentialNumber.replaceAll(RegExp(r'[^\d+]'), '');
          if (!addedNumbers.contains(digitsOnly)) {
            addedNumbers.add(digitsOnly);

            if (isMobileLine) {
              // Explicitly marked as mobile
              mobileNumbers.add(potentialNumber);
            } else if (isLandlineLine) {
              // Explicitly marked as landline — add to other
              otherNumbers.add(potentialNumber);
            } else {
              // No prefix — check if digits look like an Indian mobile (starts with 6-9, 10 digits)
              final digits = potentialNumber.replaceAll(RegExp(r'[^\d]'), '');
              final looksLikeMobile = (digits.length == 10 &&
                  RegExp(r'^[6-9]').hasMatch(digits));
              if (looksLikeMobile) {
                mobileNumbers.add(potentialNumber);
              } else {
                otherNumbers.add(potentialNumber);
              }
            }
          }
        }
      }

      // Extract all digit sequences with common phone number separators
      // Pattern 1: International format with + or 00
      final internationalMatches = RegExp(
        r'(?:\+|00)\s*\d{1,4}[\s\-\(\)\.]*\d[\d\s\-\(\)\.]{6,}',
      ).allMatches(trimmedLine);

      for (final match in internationalMatches) {
        addNumber(match.group(0)?.trim() ?? '');
      }

      // Pattern 2: Phone numbers starting with digits (10 digit mobile, etc.)
      final localMatches = RegExp(
        r'\b\d[\d\s\-\(\)\.]{6,}\b',
      ).allMatches(trimmedLine);

      for (final match in localMatches) {
        addNumber(match.group(0)?.trim() ?? '');
      }

      // Pattern 3: Digits with spaces/dashes (like "98765 43210" or "9876-543-210")
      final spacedMatches = RegExp(
        r'\d{4,5}[\s\-\.]+\d{4,6}',
      ).allMatches(trimmedLine);

      for (final match in spacedMatches) {
        addNumber(match.group(0)?.trim() ?? '');
      }
    }

    // Return mobile numbers first, then other numbers
    return [...mobileNumbers, ...otherNumbers];
  }

  Future<PhoneParsed?> _parsePhoneWithLibrary(
    String phoneNumber,
    List<String> regionsToTry,
  ) async {
    String cleaned = phoneNumber.trim();

    // Remove trunk prefix pattern "(0)" common in international formats.
    // OCR may read "0" as "O" or "o", so match all variants.
    // e.g. "+94 (0) 70 472 5630" → "+94 70 472 5630"
    //       "+44 (O)20 7946 0958" → "+44 20 7946 0958"
    cleaned = cleaned.replaceAll(RegExp(r'\([0Oo]\)\s*'), '');

    // For numbers that already carry a country code (+XX or 00XX),
    // detect the exact region from the dial code so we never call the
    // plugin with the wrong region and get garbage back.
    List<String> regions;
    String? expectedDialCode; // the dial-code we expect from the prefix (+94 etc.)

    if (cleaned.startsWith('+') || cleaned.startsWith('00')) {
      final plusForm = cleaned.startsWith('00')
          ? '+${cleaned.substring(2)}'
          : cleaned;
      final detected = _regionFromDialCode(plusForm);
      expectedDialCode = _dialCodeFrom(plusForm); // e.g. "+94"
      if (detected != null) {
        // Only try the correct region for this number
        regions = [detected];
      } else {
        regions = regionsToTry;
      }
    } else {
      // No country code — try all regions in priority order
      regions = regionsToTry;
    }

    // Build a reverse map: region → expected dial code, so we can verify
    // that the library returns the correct country code for the region we asked.
    final regionToDialCode = <String, String>{};
    for (final entry in ScanCardState.dialCodeToRegion.entries) {
      // Only keep the first (longest/most-specific) dial code per region
      regionToDialCode.putIfAbsent(entry.value, () => entry.key);
    }

    for (final region in regions) {
      try {
        // flutter_libphonenumber parse() returns:
        //   'country_code' → dial code digits, e.g. "60" for Malaysia
        //   'e164'         → "+60166980607"
        //   'national'     → "016-698 0607"
        //   'type'         → "mobile" / "fixed_line" / etc.
        final result = await parse(cleaned, region: region);

        final rawCountryCode = result['country_code']?.toString();
        final e164 = result['e164']?.toString();

        if (rawCountryCode == null || rawCountryCode.isEmpty) continue;

        // Country codes are always 1–3 digits (e.g. 1, 60, 880).
        // Anything longer means the plugin parsed with the wrong region.
        if (rawCountryCode.length > 3) continue;

        // e164 must be present and valid
        if (e164 == null || e164.isEmpty || !e164.startsWith('+')) continue;

        final countryCode = '+$rawCountryCode'; // "+60"

        // Sanity check: for international numbers (+XX...), the library must
        // return the same country code we detected from the prefix.
        if (expectedDialCode != null && countryCode != expectedDialCode) {
          continue;
        }

        // Sanity check: for local numbers (no + prefix), verify that the
        // returned country code matches the region we asked the library to
        // parse for. Without this, the library can return +62 (Indonesia)
        // when asked to parse an Indian number with region "IN".
        if (expectedDialCode == null) {
          final expectedForRegion = regionToDialCode[region];
          if (expectedForRegion != null && countryCode != expectedForRegion) {
            continue;
          }
        }

        // Derive national number from e164, NOT from 'national' field.
        // The 'national' field includes the local trunk prefix 0
        // e.g. "016-698 0607" → "0166980607" (wrong leading 0).
        // e164 "+60166980607" → strip "+60" → "166980607" ✅
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

  /// Returns the ISO region for a number that starts with +.
  String? _regionFromDialCode(String plusNumber) {
    for (final entry in ScanCardState.dialCodeToRegion.entries) {
      if (plusNumber.startsWith(entry.key)) return entry.value;
    }
    return null;
  }

  /// Returns the matching dial-code prefix for a number that starts with +.
  /// e.g. "+60166980607" → "+60"
  String? _dialCodeFrom(String plusNumber) {
    for (final code in ScanCardState.dialCodeToRegion.keys) {
      if (plusNumber.startsWith(code)) return code;
    }
    return null;
  }

  PhoneParsed? _fallbackPhoneParsing(String phoneNumber) {
    // Remove trunk prefix "(0)" / "(O)" before cleaning
    String withoutTrunk = phoneNumber.replaceAll(RegExp(r'\([0Oo]\)\s*'), '');
    // Clean the phone number - keep only digits and +
    String cleaned = withoutTrunk.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleaned.isEmpty) return null;

    String countryCode = '+91'; // Default to India
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
      // OCR sometimes misreads '+' as '0', turning "+94..." into "094...".
      // Try treating the leading 0 as a misread + sign first.
      final possibleIntl = '+${cleaned.substring(1)}';
      final intlCode = _dialCodeFrom(possibleIntl);
      if (intlCode != null) {
        // e.g. "094750596601" → "+94" → Sri Lanka
        countryCode = intlCode;
        nationalNumber = possibleIntl.substring(intlCode.length);
      } else {
        // Genuine local trunk-prefix 0 (e.g. Indian "0XXXXXXXXXX")
        nationalNumber = cleaned.substring(1);
      }
    } else {
      // No known prefix — try to detect an embedded country code
      // e.g. OCR drops '+' from "+94 11 269 9362" → "94112699362"
      final possibleWithPlus = '+$cleaned';
      final embeddedCode = _dialCodeFrom(possibleWithPlus);
      if (embeddedCode != null) {
        countryCode = embeddedCode;
        // embeddedCode includes '+', so strip that many chars from cleaned
        nationalNumber = cleaned.substring(embeddedCode.length - 1);
      }
    }

    String digitsOnly = nationalNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 6 || digitsOnly.length > 15) return null;

    // OCR often duplicates the leading digit (e.g. reads "90033 50323" as
    // "990033 50323"). For India, mobile numbers are exactly 10 digits
    // starting with 6–9. If we got 11 digits, try stripping the first digit.
    if (digitsOnly.length == 11 && countryCode == '+91') {
      final stripped = digitsOnly.substring(1);
      if (RegExp(r'^[6-9]\d{9}$').hasMatch(stripped)) {
        digitsOnly = stripped;
      }
    }

    return PhoneParsed(
      fullNumber: '$countryCode$digitsOnly',
      countryCode: countryCode,
      phoneNumber: digitsOnly,
    );
  }

  String? _extractName(String text, String? email, String? phone) {
    final lines = text
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    // Collect all valid name candidates with their line index (for position scoring)
    final nameCandidates = <MapEntry<int, String>>[];

    for (int lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      final line = lines[lineIndex];
      String trimmedLine = line.trim();

      // Skip lines starting with dash/hyphen (like "-TALLY INSTITUTE")
      if (trimmedLine.startsWith('-') || trimmedLine.startsWith('–')) {
        continue;
      }

      // Skip QR code / label texts that start with "For" (e.g. "For Location",
      // "For New Updates"). OCR may misread these (e.g. "For Locallon") so
      // match the prefix rather than exact text.
      if (RegExp(r'^for\s+', caseSensitive: false).hasMatch(trimmedLine)) {
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

      // Skip common business terms, designations, and educational qualifications
      if (_isCommonBusinessTerm(trimmedLine) ||
          _isDesignation(trimmedLine) ||
          _isEducationalQualification(trimmedLine)) {
        continue;
      }

      // Skip short abbreviations/logos (like BNI, ABC, etc.)
      if (_isAbbreviationOrLogo(trimmedLine)) {
        continue;
      }

      // Strip trailing qualifications (e.g. "Krishnakumar B.E" → "Krishnakumar")
      final cleaned = _stripTrailingQualifications(trimmedLine);

      // Check if it looks like a name
      if (_looksLikeName(cleaned)) {
        nameCandidates.add(MapEntry(lineIndex, cleaned));
      }
    }

    if (nameCandidates.isEmpty) {
      return null;
    }

    // Score candidates and pick the best one
    String? bestCandidate;
    int bestScore = -1;

    for (final candidate in nameCandidates) {
      int score = _scoreNameCandidate(candidate.value, candidate.key, lines.length);
      if (score > bestScore) {
        bestScore = score;
        bestCandidate = candidate.value;
      }
    }

    return bestCandidate;
  }

  int _scoreNameCandidate(String name, int lineIndex, int totalLines) {
    int score = 0;

    final words = name
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();

    // 2-3 words is ideal for a full name
    if (words.length == 2) score += 10;
    if (words.length == 3) score += 8;
    if (words.length == 1) score += 3;

    // Names with initials like "S.THIYAGARAJAN" or "K. RAJ" are common,
    // but only give a bonus if it looks like an initial (single letter before dot).
    // Avoid boosting qualifications like "B.ARCH" or "M.B.A".
    final initialPattern = RegExp(r'^[A-Z]\.');
    if (initialPattern.hasMatch(name) && words.length >= 2) score += 2;

    // All caps names are common on business cards
    if (name == name.toUpperCase()) score += 3;

    // Title case names
    if (_isTitleCase(name)) score += 3;

    // Longer names (but not too long) are more likely to be real names
    if (name.length >= 10 && name.length <= 30) score += 2;

    // Position bonus: name is typically in the top portion of the card.
    // Lines near the top get a higher bonus.
    if (totalLines > 0) {
      final positionRatio = lineIndex / totalLines;
      if (positionRatio < 0.25) {
        score += 6;
      } else if (positionRatio < 0.4) {
        score += 3;
      }
    }

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

  /// Regex matching common educational degree/qualification abbreviations.
  /// Used both for filtering full-qualification lines and stripping trailing
  /// qualifications from name candidates.
  static final _qualificationRegex = RegExp(
    r'\b(?:B\.?\s*ARCH|B\.?\s*E|B\.?\s*TECH|B\.?\s*SC|B\.?\s*COM|B\.?\s*A'
    r'|B\.?\s*B\.?\s*A|B\.?\s*C\.?\s*A|B\.?\s*DES|B\.?\s*ED|B\.?\s*PHARM'
    r'|M\.?\s*ARCH|M\.?\s*E|M\.?\s*TECH|M\.?\s*SC|M\.?\s*COM|M\.?\s*A'
    r'|M\.?\s*B\.?\s*A|M\.?\s*B\.?\s*M|M\.?\s*B\.?\s*B\.?\s*S|M\.?\s*D'
    r'|M\.?\s*S|M\.?\s*C\.?\s*A|M\.?\s*DES|M\.?\s*ED|M\.?\s*PHIL|M\.?\s*PHARM'
    r'|PH\.?\s*D|PHD|D\.?\s*LITT|PGDM|PGDBA|PG|DIP|DME|DCE'
    r'|FRCS|FRCP|MRCP|MRCS|FICS|FACS'
    r'|FCA|ACA|CPA|CMA|CFA|ACCA'
    r'|LLB|LLM|BL|ML'
    r'|MBBS|BDS|BAMS|BHMS|BUMS|BPT|BOT'
    r'|MDS|DM|MCH'
    r'|MSCE|MICS|AMIE|FICE|FIE)\b\.?',
    caseSensitive: false,
  );

  bool _isEducationalQualification(String text) {
    final trimmed = text.trim();
    // If most of the line is qualifications/dots/commas/spaces, it's not a name
    // e.g. "B.ARCH., MBM", "MBBS, MD", "B.E., M.Tech", "Ph.D"
    final matches = _qualificationRegex.allMatches(trimmed);
    if (matches.isEmpty) return false;
    // Calculate how much of the line is covered by qualifications
    int coveredChars = 0;
    for (final match in matches) {
      coveredChars += match.end - match.start;
    }
    // Also count dots, commas, spaces as qualification separators
    final separators = trimmed.replaceAll(RegExp(r'[^.,\s]'), '').length;
    final totalCovered = coveredChars + separators;
    // If qualifications + separators cover 70%+ of the line, it's a qualification line
    return totalCovered >= trimmed.length * 0.7;
  }

  /// Strips trailing educational qualifications from a name candidate.
  /// e.g. "Krishnakumar B.E" → "Krishnakumar", "Dr. Ravi MBBS, MD" → "Dr. Ravi"
  String _stripTrailingQualifications(String name) {
    // Remove trailing qualifications separated by comma/space
    // Repeatedly strip from the end until no more qualifications remain
    String result = name;
    bool changed = true;
    while (changed) {
      changed = false;
      // Try removing a trailing qualification (with optional leading comma/space)
      final trailingMatch = RegExp(
        r'[,\s]+' + _qualificationRegex.pattern + r'\s*$',
        caseSensitive: false,
      ).firstMatch(result);
      if (trailingMatch != null) {
        result = result.substring(0, trailingMatch.start).trim();
        changed = true;
      }
    }
    // Also handle case where the qualification is right after the name without comma
    // e.g. "Sharang Satish B.ARCH."
    final suffixMatch = RegExp(
      r'\s+' + _qualificationRegex.pattern + r'\s*$',
      caseSensitive: false,
    ).firstMatch(result);
    if (suffixMatch != null) {
      result = result.substring(0, suffixMatch.start).trim();
    }
    return result.isEmpty ? name : result;
  }

  bool _isCommonBusinessTerm(String text) {
    final lowerText = text.toLowerCase();
    return ScanCardState.businessTerms.any((term) => lowerText.contains(term));
  }

  bool _isDesignation(String text) {
    final lowerText = text.toLowerCase();
    return ScanCardState.designations.any((term) => lowerText.contains(term));
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
    final result = await Get.toNamed(
      RouteName.addContactPage,
      arguments: {"cardInfo": cardInfo.value, "imageFile": selectedImage.value},
    );
    if (result == "refresh") {
      final ctx = Get.context;
      if (ctx != null && ctx.mounted) {
        Navigator.pop(ctx, "refresh");
      }
    }
  }

  @override
  void onClose() {
    _scanLineController?.dispose();
    _fadeController?.dispose();
    _floatingIconsController?.dispose();
    super.onClose();
  }
}
