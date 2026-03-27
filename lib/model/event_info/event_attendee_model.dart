// class EventAttendeeResponse {
//   final List<EventAttendee> attendees;

//   EventAttendeeResponse({required this.attendees});

//   factory EventAttendeeResponse.fromJson(Map<String, dynamic> json) {
//     try {
//       return EventAttendeeResponse(
//         attendees: (json['attendees'] as List)
//             .map((e) => EventAttendee.fromJson(e as Map<String, dynamic>))
//             .toList(),
//       );
//     } catch (e) {
//       throw Exception('Error parsing EventAttendeeResponse: $e');
//     }
//   }

//   Map<String, dynamic> toJson() => {
//     'attendees': attendees.map((e) => e.toJson()).toList(),
//   };
// }

// class EventAttendee {
//   final String id;
//   final String name;
//   final String? username;
//   final String? email;
//   final String? avatarUrl;
//   final String? company;
//   final String? jobTitle;
//   final String? location;
//   final String? linkedin;
//   final String? website;
//   final String? bio;
//   final ExtendedProfile? extendedProfile;
//   final String? position;
//   final String? businessName;
//   final String? shortBio;
//   final List<dynamic>? badges;
//   final int totalBadges;
//   final bool canRequestMeeting;
//   final bool hasPendingRequest;

//   EventAttendee({
//     required this.id,
//     required this.name,
//     this.username,
//     this.email,
//     this.avatarUrl,
//     this.company,
//     this.jobTitle,
//     this.location,
//     this.linkedin,
//     this.website,
//     this.bio,
//     this.extendedProfile,
//     this.position,
//     this.businessName,
//     this.shortBio,
//     this.badges,
//     required this.totalBadges,
//     required this.canRequestMeeting,
//     required this.hasPendingRequest,
//   });

//   factory EventAttendee.fromJson(Map<String, dynamic> json) {
//     try {
//       return EventAttendee(
//         id: json['id'],
//         name: json['name'] ?? '',
//         username: json['username'],
//         email: json['email'],
//         avatarUrl: json['avatarUrl'],
//         company: json['company'],
//         jobTitle: json['jobTitle'],
//         location: json['location'],
//         linkedin: json['linkedin'],
//         website: json['website'],
//         bio: json['bio'],
//         extendedProfile: json['extendedProfile'] != null
//             ? ExtendedProfile.fromJson(json['extendedProfile'])
//             : null,
//         position: json['position'],
//         businessName: json['businessName'],
//         shortBio: json['shortBio'],
//         badges: json['badges'],
//         totalBadges: json['totalBadges'] ?? 0,
//         canRequestMeeting: json['can_request_meeting'] ?? false,
//         hasPendingRequest: json['has_pending_request'] ?? false,
//       );
//     } catch (e) {
//       throw Exception('Error parsing EventAttendee: $e');
//     }
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'username': username,
//     'email': email,
//     'avatarUrl': avatarUrl,
//     'company': company,
//     'jobTitle': jobTitle,
//     'location': location,
//     'linkedin': linkedin,
//     'website': website,
//     'bio': bio,
//     'extendedProfile': extendedProfile?.toJson(),
//     'position': position,
//     'businessName': businessName,
//     'shortBio': shortBio,
//     'badges': badges,
//     'totalBadges': totalBadges,
//     'can_request_meeting': canRequestMeeting,
//     'has_pending_request': hasPendingRequest,
//   };
// }

// class ExtendedProfile {
//   final String? position;
//   final String? businessName;
//   final String? shortBio;

//   ExtendedProfile({this.position, this.businessName, this.shortBio});

//   factory ExtendedProfile.fromJson(Map<String, dynamic> json) {
//     try {
//       return ExtendedProfile(
//         position: json['position'],
//         businessName: json['businessName'],
//         shortBio: json['shortBio'],
//       );
//     } catch (e) {
//       throw Exception('Error parsing ExtendedProfile: $e');
//     }
//   }

//   Map<String, dynamic> toJson() => {
//     'position': position,
//     'businessName': businessName,
//     'shortBio': shortBio,
//   };
// }

class EventAttendeeResponse {
  List<Attendee>? attendee;
  Meta? meta;

  EventAttendeeResponse({this.attendee, this.meta});

  factory EventAttendeeResponse.fromJson(Map<String, dynamic> json) =>
      EventAttendeeResponse(
        attendee: json["attendee"] == null
            ? []
            : List<Attendee>.from(
                json["attendee"]!.map((x) => Attendee.fromJson(x)),
              ),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
    "attendee": attendee == null
        ? []
        : List<dynamic>.from(attendee!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class Attendee {
  String? id;
  String? name;
  String? phone;
  String? role;
  dynamic avatarUrl;
  dynamic bio;
  dynamic company;
  dynamic jobTitle;
  dynamic location;
  dynamic website;
  Count? count;
  List<SentMeetingRequest>? sentMeetingRequests;
  List<dynamic>? receivedMeetingRequests;
  List<ContactsAsUser1>? contactsAsUser1;
  List<dynamic>? contactsAsUser2;

  Attendee({
    this.id,
    this.name,
    this.phone,
    this.role,
    this.avatarUrl,
    this.bio,
    this.company,
    this.jobTitle,
    this.location,
    this.website,
    this.count,
    this.sentMeetingRequests,
    this.receivedMeetingRequests,
    this.contactsAsUser1,
    this.contactsAsUser2,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) => Attendee(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    role: json["role"],
    avatarUrl: json["avatarUrl"],
    bio: json["bio"],
    company: json["company"],
    jobTitle: json["jobTitle"],
    location: json["location"],
    website: json["website"],
    count: json["_count"] == null ? null : Count.fromJson(json["_count"]),
    sentMeetingRequests: json["sentMeetingRequests"] == null
        ? []
        : List<SentMeetingRequest>.from(
            json["sentMeetingRequests"]!.map(
              (x) => SentMeetingRequest.fromJson(x),
            ),
          ),
    receivedMeetingRequests: json["receivedMeetingRequests"] == null
        ? []
        : List<dynamic>.from(json["receivedMeetingRequests"]!.map((x) => x)),
    contactsAsUser1: json["contactsAsUser1"] == null
        ? []
        : List<ContactsAsUser1>.from(
            json["contactsAsUser1"]!.map((x) => ContactsAsUser1.fromJson(x)),
          ),
    contactsAsUser2: json["contactsAsUser2"] == null
        ? []
        : List<dynamic>.from(json["contactsAsUser2"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "role": role,
    "avatarUrl": avatarUrl,
    "bio": bio,
    "company": company,
    "jobTitle": jobTitle,
    "location": location,
    "website": website,
    "_count": count?.toJson(),
    "sentMeetingRequests": sentMeetingRequests == null
        ? []
        : List<dynamic>.from(sentMeetingRequests!.map((x) => x.toJson())),
    "receivedMeetingRequests": receivedMeetingRequests == null
        ? []
        : List<dynamic>.from(receivedMeetingRequests!.map((x) => x)),
    "contactsAsUser1": contactsAsUser1 == null
        ? []
        : List<dynamic>.from(contactsAsUser1!.map((x) => x.toJson())),
    "contactsAsUser2": contactsAsUser2 == null
        ? []
        : List<dynamic>.from(contactsAsUser2!.map((x) => x)),
  };
}

class ContactsAsUser1 {
  String? id;
  String? user1Id;
  String? user2Id;
  String? name;
  String? email;

  ContactsAsUser1({this.id, this.user1Id, this.user2Id, this.name, this.email});

  factory ContactsAsUser1.fromJson(Map<String, dynamic> json) =>
      ContactsAsUser1(
        id: json["id"],
        user1Id: json["user1Id"],
        user2Id: json["user2Id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user1Id": user1Id,
    "user2Id": user2Id,
    "name": name,
    "email": email,
  };
}

class Count {
  int? contactsAsUser1;
  int? contactsAsUser2;

  Count({this.contactsAsUser1, this.contactsAsUser2});

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    contactsAsUser1: json["contactsAsUser1"],
    contactsAsUser2: json["contactsAsUser2"],
  );

  Map<String, dynamic> toJson() => {
    "contactsAsUser1": contactsAsUser1,
    "contactsAsUser2": contactsAsUser2,
  };
}

class SentMeetingRequest {
  String? id;
  String? fromUserId;
  String? toUserId;
  String? message;
  String? status;
  int? duration;
  String? collaborationNote;

  SentMeetingRequest({
    this.id,
    this.fromUserId,
    this.toUserId,
    this.message,
    this.status,
    this.duration,
    this.collaborationNote,
  });

  factory SentMeetingRequest.fromJson(Map<String, dynamic> json) =>
      SentMeetingRequest(
        id: json["id"],
        fromUserId: json["fromUserId"],
        toUserId: json["toUserId"],
        message: json["message"],
        status: json["status"],
        duration: json["duration"],
        collaborationNote: json["collaborationNote"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fromUserId": fromUserId,
    "toUserId": toUserId,
    "message": message,
    "status": status,
    "duration": duration,
    "collaborationNote": collaborationNote,
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
