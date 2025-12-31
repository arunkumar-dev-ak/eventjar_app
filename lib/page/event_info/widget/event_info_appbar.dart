import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:eventjar/model/event_info/event_info_media_extension_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          _buildActionButton(
            icon: Icons.favorite_border_rounded,
            onTap: () {
              HapticFeedback.lightImpact();
              // controller.toggleFavorite();
            },
          ),
        ],
      ),
    );
  }

  /// ✅ Main share entry point
  Future<void> _showNativeShareSheet() async {
    final eventInfo = controller.state.eventInfo.value;
    if (eventInfo == null) return;

    await _shareWithRichPreview(eventInfo);
  }

  Future<void> _shareWithRichPreview(EventInfo eventInfo) async {
    try {
      final imageUrl = eventInfo.media.isNotEmpty
          ? eventInfo.media.first.resolvedUrl
          : '';

      // ✅ Perfect Flipkart-style text
      final shareText = _generateShareText(eventInfo);

      if (imageUrl.isNotEmpty) {
        // ✅ Download image
        final tempDir = await getTemporaryDirectory();
        final imageFile = File(
          '${tempDir.path}/event_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        final response = await DioClient().dio.get(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        await imageFile.writeAsBytes(response.data);

        // ✅ FIXED: Use shareXFiles() NOT ShareParams.files
        await Share.shareXFiles(
          [XFile(imageFile.path)],
          text: shareText, // ✅ Text
          subject: eventInfo.title,
        );
      } else {
        // ✅ Text only - NO uri conflict
        await Share.share(shareText);
      }
    } catch (e) {
      print('Share error: $e');
      await Share.share(_generateShareText(eventInfo));
    }
  }

  // Fallback simple text share
  String _generateShareText(EventInfo eventInfo) {
    final title = eventInfo.title;
    final date = _formatDate(eventInfo.startDate);
    final city = eventInfo.city ?? 'Online';
    final price = _formatPrice(eventInfo);
    final attendees = eventInfo.currentAttendees;
    final slug = eventInfo.slug;
    final shortLink = 'https://myeventjar.com/events/$slug';

    return '''🎊 $title

📅 $date
📍 $city
💰 $price

👥 $attendees+ attending ✨
⏰ Limited spots!

Tap "Book Now" → $shortLink''';
  }

  // Format date
  String _formatDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]}';
  }

  // Format price
  String _formatPrice(EventInfo eventInfo) {
    return eventInfo.isPaid ? '\$${eventInfo.ticketPrice ?? 'Paid'}' : 'FREE';
  }

  /// ✅ Action button builder
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
