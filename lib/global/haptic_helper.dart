import 'package:flutter/services.dart';

/// Centralized helper for triggering haptic feedback throughout the app.
///
/// Use [HapticHelper.light] for taps on standard buttons / list items,
/// [HapticHelper.medium] for selection and toggle actions,
/// [HapticHelper.heavy] for confirmations / destructive actions,
/// [HapticHelper.selection] for picker / scroll selection changes,
/// and [HapticHelper.vibrate] for generic short feedback.
class HapticHelper {
  HapticHelper._();

  static Future<void> light() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {}
  }

  static Future<void> medium() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  static Future<void> heavy() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  static Future<void> selection() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {}
  }

  static Future<void> vibrate() async {
    try {
      await HapticFeedback.vibrate();
    } catch (_) {}
  }

  /// Wraps a callback with light haptic feedback. Returns null if the input is null
  /// so the wrapped widget can still be disabled when [callback] is null.
  static VoidCallback? wrap(VoidCallback? callback) {
    if (callback == null) return null;
    return () {
      light();
      callback();
    };
  }

  /// Wraps a callback with medium haptic feedback.
  static VoidCallback? wrapMedium(VoidCallback? callback) {
    if (callback == null) return null;
    return () {
      medium();
      callback();
    };
  }

  /// Wraps a callback with heavy haptic feedback.
  static VoidCallback? wrapHeavy(VoidCallback? callback) {
    if (callback == null) return null;
    return () {
      heavy();
      callback();
    };
  }

  /// Wraps a callback with selection haptic feedback.
  static VoidCallback? wrapSelection(VoidCallback? callback) {
    if (callback == null) return null;
    return () {
      selection();
      callback();
    };
  }
}
