import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eventjar/helper/date_handler.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:share_plus/share_plus.dart';

enum EventMode { virtual, physical, hybrid }

class ShareEventHelper {
  static Future<void> shareEvent({
    required BuildContext context,
    required String title,
    required String slug,
    required DateTime startDate,
    required String startTimeHHMM,
    required EventMode mode,
    String? city,
    String? imageUrl, // 👈 NEW
  }) async {
    try {
      final shareText = buildShareText(
        title: title,
        slug: slug,
        startDate: startDate,
        startTimeHHMM: startTimeHHMM,
        mode: mode,
        context: context,
        city: city,
      );

      // If image exists → share image + text
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final imageFile = await _downloadImage(imageUrl);

        await SharePlus.instance.share(
          ShareParams(
            text: shareText,
            subject: title,
            files: [XFile(imageFile.path)],
          ),
        );
      } else {
        // Text only fallback
        await SharePlus.instance.share(
          ShareParams(text: shareText, subject: title),
        );
      }
    } catch (e) {
      debugPrint('Share failed: $e');
    }
  }

  static String buildShareText({
    required String title,
    required String slug,
    required DateTime startDate,
    required String startTimeHHMM,
    required EventMode mode,
    required BuildContext context,
    String? city,
  }) {
    final date = formatDate(startDate);
    final time = formatTimeFromHHMM(startTimeHHMM, context);

    final location = switch (mode) {
      EventMode.virtual => '📍 Virtual Event',
      EventMode.physical => '📍 ${city ?? 'Location'}',
      EventMode.hybrid => '📍 Hybrid Event',
    };

    final link =
        'https://myeventjar.com/api/event-preview/$slug'
        '?utm_source=whatsapp&utm_medium=social'
        '&utm_campaign=event_share&utm_content=$slug';

    return '''🎉 $title

📅 $date at $time IST | $location

👉 $link''';
  }

  static Future<File> _downloadImage(String url) async {
    final dio = Dio();

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/event_share.png';

    final response = await dio.get<List<int>>(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    final file = File(filePath);
    await file.writeAsBytes(response.data!);

    return file;
  }
}
