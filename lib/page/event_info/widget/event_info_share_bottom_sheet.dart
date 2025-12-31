// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
// import 'package:eventjar/api/dio_client.dart';
// import 'package:eventjar/controller/event_info/controller.dart';
// import 'package:eventjar/global/responsive/responsive.dart';
// import 'package:eventjar/model/event_info/event_info_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:eventjar/model/event_info/event_info_media_extension_model.dart';

// class ShareBottomSheet extends StatelessWidget {
//   final EventInfoController controller;

//   const ShareBottomSheet({super.key, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final eventInfo = controller.state.eventInfo.value;
//       if (eventInfo == null) return const SizedBox();

//       return Container(
//         height: 65.hp,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         padding: EdgeInsets.only(
//           left: 5.wp,
//           right: 5.wp,
//           top: 3.wp,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 2.wp,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Handle
//             Container(
//               margin: EdgeInsets.only(top: 1.wp),
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             SizedBox(height: 2.wp),

//             // Title
//             Text(
//               'Share this event',
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.grey.shade900,
//               ),
//             ),
//             SizedBox(height: 2.hp),

//             // Event Preview
//             _buildEventPreview(eventInfo),
//             SizedBox(height: 3.wp),

//             // Share Options
//             Expanded(child: _buildShareOptions(eventInfo)),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildEventPreview(EventInfo eventInfo) {
//     final firstImage = eventInfo.media.isNotEmpty
//         ? eventInfo.media.first.resolvedUrl
//         : null;

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(3.wp),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Event image
//           if (firstImage != null)
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: CachedNetworkImage(
//                 imageUrl: firstImage,
//                 height: 12.hp,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),

//           SizedBox(height: 2.wp),

//           // Event title
//           Text(
//             eventInfo.title,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontSize: 11.sp,
//               fontWeight: FontWeight.w700,
//               color: Colors.grey.shade900,
//             ),
//           ),

//           SizedBox(height: 0.5.wp),

//           // Quick info
//           Text(
//             '${_formatDate(eventInfo.startDate)} • ${eventInfo.city ?? 'TBD'} • ${_formatPrice(eventInfo)}',
//             style: TextStyle(fontSize: 9.sp, color: Colors.grey.shade600),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildShareOptions(EventInfo eventInfo) {
//     final shareData = _generateShareData(eventInfo);

//     return Column(
//       children: [
//         // Main platforms
//         Row(
//           children: [
//             _buildPlatformButton(
//               icon: '📱',
//               label: 'WhatsApp',
//               color: const Color(0xFF25D366),
//               onTap: () => _shareToWhatsApp(shareData),
//             ),
//             SizedBox(width: 3.wp),
//             _buildPlatformButton(
//               icon: '📩',
//               label: 'SMS',
//               color: Colors.blue.shade600,
//               onTap: () => _shareNative(shareData['text']!),
//             ),
//           ],
//         ),
//         SizedBox(height: 2.wp),
//         Row(
//           children: [
//             _buildPlatformButton(
//               icon: '📸',
//               label: 'Instagram',
//               color: const Color(0xFFE4405F),
//               onTap: () => _shareNative(shareData['text']!),
//             ),
//             SizedBox(width: 3.wp),
//             _buildPlatformButton(
//               icon: '📘',
//               label: 'Facebook',
//               color: const Color(0xFF1877F2),
//               onTap: () => _shareNative(shareData['text']!),
//             ),
//           ],
//         ),
//         const Spacer(),

//         // Copy link & More
//         Row(
//           children: [
//             Expanded(
//               child: _buildPlatformButton(
//                 icon: '📋',
//                 label: 'Copy Link',
//                 color: Colors.grey.shade600,
//                 onTap: () => _copyToClipboard(shareData['url']!),
//               ),
//             ),
//             SizedBox(width: 2.wp),
//             Expanded(
//               flex: 2,
//               child: _buildPlatformButton(
//                 icon: '↗️',
//                 label: 'More',
//                 color: Colors.grey.shade500,
//                 onTap: () => _shareNative(shareData['text']!),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 1.wp),
//       ],
//     );
//   }

//   Future<void> _shareNative(String text) async {
//     final params = ShareParams(
//       text: 'Great picture',
//       uri: Uri.parse(
//         'eventjar://event/${controller.state.eventInfo.value?.id}',
//       ),
//     );

//     await SharePlus.instance.share(params);
//   }

//   Widget _buildPlatformButton({
//     required String icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           HapticFeedback.lightImpact();
//           onTap();
//           Get.back();
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 3.wp, horizontal: 2.wp),
//           decoration: BoxDecoration(
//             color: color.withValues(alpha: 0.1),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: color.withValues(alpha: 0.3)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(icon, style: TextStyle(fontSize: 20)),
//               SizedBox(height: 0.5.wp),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 8.sp,
//                   fontWeight: FontWeight.w600,
//                   color: color,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Map<String, String> _generateShareData(EventInfo eventInfo) {
//   //   final deepLink = 'eventjar://event/${eventInfo.id}?ref=share';
//   //   final imageUrl = eventInfo.media.isNotEmpty
//   //       ? eventInfo.media.first.resolvedUrl
//   //       : '';

//   //   return {
//   //     'text':
//   //         '🎉 Check out this awesome event!\n\n'
//   //         '${eventInfo.title}\n'
//   //         '📅 ${_formatDate(eventInfo.startDate)}\n'
//   //         '📍 ${eventInfo.city ?? 'TBD'}\n'
//   //         '💰 ${_formatPrice(eventInfo)}\n\n'
//   //         'Join me there! $deepLink',
//   //     'url': deepLink,
//   //     'image': imageUrl,
//   //   };
//   // }

//   Future<void> _shareWithRichPreview(EventInfo eventInfo) async {
//     try {
//       final imageUrl = eventInfo.media.isNotEmpty
//           ? eventInfo.media.first.resolvedUrl
//           : '';

//       final eventSlug = eventInfo.slug;
//       final shortLink = 'https://myeventjar.com/events/$eventSlug';

//       // ✅ Flipkart-style share text
//       final shareText =
//           '''🎉 ${eventInfo.title}

//       📅 ${_formatDate(eventInfo.startDate)} | 📍 ${eventInfo.city ?? 'TBD'} | 💰 ${_formatPrice(eventInfo)}

//       👆 Tap to view → $shortLink''';

//       if (imageUrl.isNotEmpty) {
//         // Download image for rich preview
//         final tempDir = await getTemporaryDirectory();
//         final imageFile = File(
//           '${tempDir.path}/event_${DateTime.now().millisecondsSinceEpoch}.jpg',
//         );

//         final response = await DioClient().dio.get(
//           imageUrl,
//           options: Options(responseType: ResponseType.bytes),
//         );
//         await imageFile.writeAsBytes(response.data);

//         final params = ShareParams(
//           text: shareText,
//           files: [XFile(imageFile.path)],
//           subject: eventInfo.title,
//           uri: Uri.parse(shortLink),
//         );

//         await SharePlus.instance.share(params);
//       } else {
//         final params = ShareParams(
//           text: shareText,
//           subject: eventInfo.title,
//           uri: Uri.parse(shortLink),
//         );

//         await SharePlus.instance.share(params);
//       }
//     } catch (e) {
//       // print('Share error: $e');
//       // await Share.share(_generateShareText(eventInfo));
//     }
//   }

//   String _formatDate(DateTime date) {
//     final months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//     return '${date.day} ${months[date.month - 1]}';
//   }

//   String _formatPrice(EventInfo eventInfo) {
//     return eventInfo.isPaid ? '\$${eventInfo.ticketPrice ?? 'Paid'}' : 'FREE';
//   }

//   void _copyToClipboard(String text) {
//     Clipboard.setData(ClipboardData(text: text));
//     Get.rawSnackbar(
//       messageText: const Text('Link copied!'),
//       backgroundColor: Colors.green,
//       duration: const Duration(seconds: 1),
//     );
//   }

//   void _shareToWhatsApp(Map<String, String> shareData) {
//     final whatsappUrl =
//         'whatsapp://send?text=${Uri.encodeComponent(shareData['text']!)}';
//     Share.share(shareData['text']!);
//   }
// }
