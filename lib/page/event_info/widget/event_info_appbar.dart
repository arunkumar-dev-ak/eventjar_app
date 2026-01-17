import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:eventjar/model/event_info/event_info_media_extension_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class EventInfoAppBar extends GetView<EventInfoController> {
  const EventInfoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(
        left: 4.wp,
        right: 4.wp,
        top: statusBarHeight + 1.5.hp,
        bottom: 1.5.hp,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.appBarGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientDarkStart.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          SizedBox(width: 3.wp),

          // Title
          Expanded(
            child: Text(
              'Event Info',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Share (Native sheet)
          _buildActionButton(
            icon: Icons.share_rounded,
            onTap: () => _showNativeShareSheet(),
          ),
          SizedBox(width: 2.wp),

          // Favorite
          // _buildActionButton(
          //   icon: Icons.favorite_border_rounded,
          //   onTap: () {
          //     HapticFeedback.lightImpact();
          //     // controller.toggleFavorite();
          //   },
          // ),
        ],
      ),
    );
  }

  // Main share entry point
  Future<void> _showNativeShareSheet() async {
    final eventInfo = controller.state.eventInfo.value;
    if (eventInfo == null) return;

    await _shareWithRichPreview(eventInfo);
  }

  Future<void> _shareWithRichPreview(EventInfo eventInfo) async {
    try {
      final imageUrl =
          eventInfo.featuredImageUrl ??
          (eventInfo.media.isNotEmpty ? eventInfo.media.first.resolvedUrl : '');

      // Generate rich share text
      final shareText = _generateWhatsAppShareText(eventInfo);

      if (imageUrl.isNotEmpty) {
        // Download the image temporarily
        final tempDir = await getTemporaryDirectory();
        final imageFile = File(
          '${tempDir.path}/event_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        final response = await DioClient().dio.get(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        await imageFile.writeAsBytes(response.data);

        // Share with image
        await Share.shareXFiles(
          [XFile(imageFile.path)],
          text: shareText,
          subject: eventInfo.title,
        );
      } else {
        // Share text-only
        await Share.share(shareText, subject: eventInfo.title);
      }
    } catch (e) {
      print('Share error: $e');
      await Share.share(_generateWhatsAppShareText(eventInfo));
    }
  }

  String _generateWhatsAppShareText(EventInfo eventInfo) {
    final title = '🎉 ${eventInfo.title}';

    final dateTimeLocation = _formatEventDateTimeForShare(eventInfo);

    final slug = eventInfo.slug;
    final link =
        'https://myeventjar.com/api/event-preview/$slug?utm_source=whatsapp&utm_medium=social&utm_campaign=event_share&utm_content=$slug';

    return '''$title

$dateTimeLocation

👉 $link''';
  }

  String _formatEventDateTimeForShare(EventInfo eventInfo) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    // Start date
    final start = eventInfo.startDate;
    final startDateStr =
        '${start.day} ${months[start.month - 1]}, ${start.year}';

    // Start time
    String startTimeStr = 'Time TBA';

    startTimeStr = controller.generateDateTimeAndFormatTime(
      eventInfo.startTime,
      Get.context!,
    );

    final timeDisplay = '$startTimeStr IST';

    final location = eventInfo.isVirtual
        ? '📍 Virtual Event'
        : '📍 ${eventInfo.city ?? 'Location'}';

    return '📅 $startDateStr at $timeDisplay | $location';
  }

  // Action button builder
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
