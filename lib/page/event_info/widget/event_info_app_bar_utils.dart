import 'package:eventjar/global/global_values.dart';

bool isValidMediaUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  if (url.startsWith('/') || url.startsWith('./')) return true;
  try {
    Uri.parse(url);
    return url.startsWith('http://') || url.startsWith('https://');
  } catch (e) {
    return false;
  }
}

String resolveImageUrl(String imageUrl) {
  final baseUrl = backendBaseUrl();
  if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
    return imageUrl;
  }
  if (imageUrl.startsWith('/')) return baseUrl + imageUrl;
  if (imageUrl.startsWith('./')) return baseUrl + imageUrl.substring(1);
  // Fallback: treat as relative path
  return baseUrl + (imageUrl.startsWith('/') ? '' : '/') + imageUrl;
}

bool isYouTubeUrl(String url) {
  final youtubeRegex = RegExp(
    r'^(https?:\/\/)?(www\.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)',
  );
  return youtubeRegex.hasMatch(url);
}

String getYouTubeThumbnail(String url) {
  final idMatch = RegExp(
    r'(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([^\&\n\?#]+)',
  ).firstMatch(url);
  if (idMatch != null) {
    final videoId = idMatch.group(1);
    return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
  }
  return '';
}
