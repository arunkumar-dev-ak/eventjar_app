import 'package:eventjar/global/toast/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToastController extends GetxController {
  final List<OverlayEntry> _activeEntries = [];
  final List<_ToastData> _queue = [];

  static const int _maxVisible = 3;

  // ================= BASE ENQUEUE =================

  void _enqueue(_ToastData data) {
    _queue.add(data);
    _showNext();
  }

  void _showNext() {
    if (_activeEntries.length >= _maxVisible) return;
    if (_queue.isEmpty) return;

    final context = Get.overlayContext;
    if (context == null) return;

    final data = _queue.removeAt(0);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) {
        final index = _activeEntries.indexOf(entry);

        return Positioned(
          top: 60 + (index * 30),
          left: 16,
          right: 16,
          child: ToastItem(
            title: data.title,
            message: data.message,
            icon: data.icon,
            gradientColors: data.gradient,
            onDismiss: () => _remove(entry),
          ),
        );
      },
    );

    _activeEntries.add(entry);
    Overlay.of(context).insert(entry);

    Future.delayed(data.duration, () {
      if (_activeEntries.contains(entry)) {
        _remove(entry);
      }
    });
  }

  void _remove(OverlayEntry entry) {
    entry.remove();
    _activeEntries.remove(entry);

    // Rebuild stack positions
    for (var e in _activeEntries) {
      e.markNeedsBuild();
    }

    _showNext();
  }

  // ================= PUBLIC METHODS =================

  void success({
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _enqueue(
      _ToastData(
        title: title,
        message: message,
        icon: Icons.check_circle,
        gradient: const [Color(0xFF16A34A), Color(0xFF22C55E)],
        duration: duration,
      ),
    );
  }

  void warning({
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _enqueue(
      _ToastData(
        title: title,
        message: message,
        icon: Icons.warning_amber_rounded,
        gradient: const [Color(0xFFF59E0B), Color(0xFFFBBF24)],
        duration: duration,
      ),
    );
  }

  void error({
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _enqueue(
      _ToastData(
        title: title,
        message: message,
        icon: Icons.error_outline,
        gradient: const [Color(0xFFDC2626), Color(0xFFEF4444)],
        duration: duration,
      ),
    );
  }
}

// ================= DATA MODEL =================

class _ToastData {
  final String? title;
  final String message;
  final IconData icon;
  final List<Color> gradient;
  final Duration duration;

  _ToastData({
    this.title,
    required this.message,
    required this.icon,
    required this.gradient,
    required this.duration,
  });
}
