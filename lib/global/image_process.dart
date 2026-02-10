import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_selfie_segmentation/google_mlkit_selfie_segmentation.dart';
import 'package:image/image.dart' as img;

/// Result class for background removal operation
class BackgroundRemovalResult {
  final Uint8List? imageBytes;
  final bool success;
  final String? errorMessage;

  BackgroundRemovalResult({
    this.imageBytes,
    required this.success,
    this.errorMessage,
  });

  factory BackgroundRemovalResult.success(Uint8List bytes) {
    return BackgroundRemovalResult(imageBytes: bytes, success: true);
  }

  factory BackgroundRemovalResult.error(String message) {
    return BackgroundRemovalResult(success: false, errorMessage: message);
  }
}

class ProfileImageProcessor {
  /// No API key needed — runs entirely on-device
  static bool get isApiKeyConfigured => true;

  /// Removes background from image bytes using ML Kit Selfie Segmentation.
  /// Runs on-device, completely free, no internet required.
  static Future<BackgroundRemovalResult> processFromBytes(
    Uint8List bytes,
  ) async {
    final segmenter = SelfieSegmenter(
      mode: SegmenterMode.single,
      enableRawSizeMask: true,
    );

    try {
      // Write bytes to a temp file for InputImage
      final tempDir = Directory.systemTemp;
      final tempFile = File(
        '${tempDir.path}/segmentation_input_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await tempFile.writeAsBytes(bytes);

      final inputImage = InputImage.fromFilePath(tempFile.path);
      final mask = await segmenter.processImage(inputImage);

      // Clean up temp file
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      if (mask == null) {
        return BackgroundRemovalResult.error(
          'No person detected in the image.',
        );
      }

      // Extract plain Dart types from ML Kit object before isolate
      final maskData = _MaskData(
        imageBytes: bytes,
        confidences: List<double>.from(mask.confidences),
        maskWidth: mask.width,
        maskHeight: mask.height,
      );

      final result = await compute(_applyMask, maskData);
      return BackgroundRemovalResult.success(result);
    } catch (e) {
      debugPrint('ProfileImageProcessor error: $e');
      return BackgroundRemovalResult.error('Segmentation failed: $e');
    } finally {
      segmenter.close();
    }
  }
}

class _MaskData {
  final Uint8List imageBytes;
  final List<double> confidences;
  final int maskWidth;
  final int maskHeight;

  _MaskData({
    required this.imageBytes,
    required this.confidences,
    required this.maskWidth,
    required this.maskHeight,
  });
}

/// Runs in an isolate to avoid blocking the UI thread.
Uint8List _applyMask(_MaskData data) {
  final original = img.decodeImage(data.imageBytes);
  if (original == null) throw Exception('Failed to decode image');

  final maskWidth = data.maskWidth;
  final maskHeight = data.maskHeight;
  final confidences = data.confidences;

  // Create output image with alpha channel
  final output = img.Image(
    width: original.width,
    height: original.height,
    numChannels: 4,
  );

  for (int y = 0; y < original.height; y++) {
    for (int x = 0; x < original.width; x++) {
      final pixel = original.getPixel(x, y);

      // Map pixel coords to mask coords
      final maskX = (x * maskWidth / original.width).floor().clamp(0, maskWidth - 1);
      final maskY = (y * maskHeight / original.height).floor().clamp(0, maskHeight - 1);

      final confidence = confidences[maskY * maskWidth + maskX];

      // Sharp cutoff: fully visible if person, fully transparent if background
      // Small transition band (0.4–0.6) to avoid harsh jagged edges
      int alpha;
      if (confidence >= 0.6) {
        alpha = 255;
      } else if (confidence <= 0.4) {
        alpha = 0;
      } else {
        // Smooth transition only in the narrow 0.4–0.6 band
        alpha = (((confidence - 0.4) / 0.2) * 255).round().clamp(0, 255);
      }

      output.setPixelRgba(
        x,
        y,
        pixel.r.toInt(),
        pixel.g.toInt(),
        pixel.b.toInt(),
        alpha,
      );
    }
  }

  return Uint8List.fromList(img.encodePng(output));
}
