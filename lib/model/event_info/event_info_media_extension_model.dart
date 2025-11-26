import 'package:eventjar/global/global_values.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';

final baseUrl = backendBaseUrl();

extension MediaGalleryHelpers on Media {
  // Returns true if media url is YouTube
  bool get isYouTube {
    final youtubeRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)',
    );
    return youtubeRegex.hasMatch(url);
  }

  // Returns full valid url for this media
  String get resolvedUrl {
    if (isYouTube) return url;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    if (url.startsWith('/')) return baseUrl + url;
    if (url.startsWith('./')) return baseUrl + url.substring(1);
    return baseUrl + (url.startsWith('/') ? '' : '/') + url;
  }

  // Extract YouTube video ID and generate thumbnail
  String get youtubeThumbnail {
    if (!isYouTube) return '';
    final idMatch = RegExp(
      r'(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([^\&\n\?#]+)',
    ).firstMatch(url);
    if (idMatch != null) {
      final videoId = idMatch.group(1);
      return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
    }
    return '';
  }

  String get displayThumbnail => isYouTube ? youtubeThumbnail : resolvedUrl;
}
