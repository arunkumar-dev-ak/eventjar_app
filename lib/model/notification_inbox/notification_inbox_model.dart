enum NotificationInboxType {
  meeting,
  connection,
  contact,
  ticket,
  security,
  event,
  reminder,
  system,
}

class NotificationInboxItem {
  List<Datum>? data;
  Meta? meta;

  NotificationInboxItem({this.data, this.meta});

  factory NotificationInboxItem.fromJson(Map<String, dynamic> json) =>
      NotificationInboxItem(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class Datum {
  String? id;
  String? userId;
  String? channel;
  String? triggerKey;
  String? subject;
  dynamic eventId;
  dynamic ticketRegistrationId;
  String? status;
  DateTime? sentAt;
  dynamic deliveredAt;
  dynamic failedAt;
  dynamic errorMessage;
  bool? isRead;
  Metadata? metadata;
  DateTime? createdAt;

  Datum({
    this.id,
    this.userId,
    this.channel,
    this.triggerKey,
    this.subject,
    this.eventId,
    this.ticketRegistrationId,
    this.status,
    this.sentAt,
    this.deliveredAt,
    this.failedAt,
    this.errorMessage,
    this.isRead,
    this.metadata,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["userId"],
    channel: json["channel"],
    triggerKey: json["triggerKey"],
    subject: json["subject"],
    eventId: json["eventId"],
    ticketRegistrationId: json["ticketRegistrationId"],
    status: json["status"],
    sentAt: json["sentAt"] == null ? null : DateTime.parse(json["sentAt"]),
    deliveredAt: json["deliveredAt"],
    failedAt: json["failedAt"],
    errorMessage: json["errorMessage"],
    isRead: json["isRead"],
    metadata: json["metadata"] == null
        ? null
        : Metadata.fromJson(json["metadata"]),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
  );

  NotificationInboxType get notificationType {
    final key = triggerKey ?? '';
    if (key.startsWith('MEETING_') ||
        key.startsWith('CONTACT_LIST_MEETING_')) {
      return NotificationInboxType.meeting;
    }
    if (key.startsWith('CONNECTION_')) {
      return NotificationInboxType.connection;
    }
    if (key.startsWith('CONTACT_LIST')) {
      return NotificationInboxType.contact;
    }
    if (key == 'ATTENDEE_TICKET_CONFIRMED') {
      return NotificationInboxType.ticket;
    }
    if (key.contains('SECURITY') || key.contains('ALERT')) {
      return NotificationInboxType.security;
    }
    if (key.contains('EVENT')) {
      return NotificationInboxType.event;
    }
    if (key.contains('REMINDER')) {
      return NotificationInboxType.reminder;
    }
    return NotificationInboxType.system;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "channel": channel,
    "triggerKey": triggerKey,
    "subject": subject,
    "eventId": eventId,
    "ticketRegistrationId": ticketRegistrationId,
    "status": status,
    "sentAt": sentAt?.toIso8601String(),
    "deliveredAt": deliveredAt,
    "failedAt": failedAt,
    "errorMessage": errorMessage,
    "isRead": isRead,
    "metadata": metadata?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
  };
}

class Metadata {
  String? body;
  String? type;
  String? stage;
  String? screen;
  String? contactId;
  String? contactName;
  int? batchSize;
  String? eventName;

  Metadata({
    this.body,
    this.type,
    this.stage,
    this.screen,
    this.contactId,
    this.contactName,
    this.batchSize,
    this.eventName,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    body: json["body"],
    type: json["type"],
    stage: json["stage"],
    screen: json["screen"],
    contactId: json["contactId"],
    contactName: json["contactName"],
    batchSize: json["batchSize"],
    eventName: json["eventName"],
  );

  Map<String, dynamic> toJson() => {
    "body": body,
    "type": type,
    "stage": stage,
    "screen": screen,
    "contactId": contactId,
    "contactName": contactName,
    "batchSize": batchSize,
    "eventName": eventName,
  };
}

class Meta {
  Paging? paging;

  Meta({this.paging});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    paging: json["paging"] == null ? null : Paging.fromJson(json["paging"]),
  );

  Map<String, dynamic> toJson() => {"paging": paging?.toJson()};
}

class Paging {
  Links? links;
  Pages? pages;
  int? totalCount;

  Paging({this.links, this.pages, this.totalCount});

  factory Paging.fromJson(Map<String, dynamic> json) => Paging(
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    pages: json["pages"] == null ? null : Pages.fromJson(json["pages"]),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "links": links?.toJson(),
    "pages": pages?.toJson(),
    "totalCount": totalCount,
  };
}

class Links {
  dynamic prev;
  dynamic next;
  String? current;

  Links({this.prev, this.next, this.current});

  factory Links.fromJson(Map<String, dynamic> json) =>
      Links(prev: json["prev"], next: json["next"], current: json["current"]);

  Map<String, dynamic> toJson() => {
    "prev": prev,
    "next": next,
    "current": current,
  };
}

class Pages {
  int? total;
  dynamic prev;
  dynamic next;
  int? current;

  Pages({this.total, this.prev, this.next, this.current});

  factory Pages.fromJson(Map<String, dynamic> json) => Pages(
    total: json["total"],
    prev: json["prev"],
    next: json["next"],
    current: json["current"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "prev": prev,
    "next": next,
    "current": current,
  };
}
