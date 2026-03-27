enum NotificationInboxType {
  event,
  contact,
  meeting,
  reminder,
  system,
}

class NotificationInboxItem {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final NotificationInboxType type;
  final String? imageUrl;

  const NotificationInboxItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    required this.type,
    this.imageUrl,
  });

  NotificationInboxItem copyWith({bool? isRead}) {
    return NotificationInboxItem(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      type: type,
      imageUrl: imageUrl,
    );
  }
}
