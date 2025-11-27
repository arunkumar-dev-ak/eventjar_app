class EventAttendeeResponse {
  final List<EventAttendee> attendees;

  EventAttendeeResponse({required this.attendees});

  factory EventAttendeeResponse.fromJson(Map<String, dynamic> json) {
    try {
      return EventAttendeeResponse(
        attendees: (json['attendees'] as List)
            .map((e) => EventAttendee.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      throw Exception('Error parsing EventAttendeeResponse: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'attendees': attendees.map((e) => e.toJson()).toList(),
  };
}

class EventAttendee {
  final String id;
  final String name;
  final String? username;
  final String? email;
  final String? avatarUrl;
  final String? company;
  final String? jobTitle;
  final String? location;
  final String? linkedin;
  final String? website;
  final String? bio;
  final ExtendedProfile? extendedProfile;
  final String? position;
  final String? businessName;
  final String? shortBio;
  final List<dynamic>? badges;
  final int totalBadges;
  final bool canRequestMeeting;
  final bool hasPendingRequest;

  EventAttendee({
    required this.id,
    required this.name,
    this.username,
    this.email,
    this.avatarUrl,
    this.company,
    this.jobTitle,
    this.location,
    this.linkedin,
    this.website,
    this.bio,
    this.extendedProfile,
    this.position,
    this.businessName,
    this.shortBio,
    this.badges,
    required this.totalBadges,
    required this.canRequestMeeting,
    required this.hasPendingRequest,
  });

  factory EventAttendee.fromJson(Map<String, dynamic> json) {
    try {
      return EventAttendee(
        id: json['id'],
        name: json['name'] ?? '',
        username: json['username'],
        email: json['email'],
        avatarUrl: json['avatarUrl'],
        company: json['company'],
        jobTitle: json['jobTitle'],
        location: json['location'],
        linkedin: json['linkedin'],
        website: json['website'],
        bio: json['bio'],
        extendedProfile: json['extendedProfile'] != null
            ? ExtendedProfile.fromJson(json['extendedProfile'])
            : null,
        position: json['position'],
        businessName: json['businessName'],
        shortBio: json['shortBio'],
        badges: json['badges'],
        totalBadges: json['totalBadges'] ?? 0,
        canRequestMeeting: json['can_request_meeting'] ?? false,
        hasPendingRequest: json['has_pending_request'] ?? false,
      );
    } catch (e) {
      throw Exception('Error parsing EventAttendee: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'username': username,
    'email': email,
    'avatarUrl': avatarUrl,
    'company': company,
    'jobTitle': jobTitle,
    'location': location,
    'linkedin': linkedin,
    'website': website,
    'bio': bio,
    'extendedProfile': extendedProfile?.toJson(),
    'position': position,
    'businessName': businessName,
    'shortBio': shortBio,
    'badges': badges,
    'totalBadges': totalBadges,
    'can_request_meeting': canRequestMeeting,
    'has_pending_request': hasPendingRequest,
  };
}

class ExtendedProfile {
  final String? position;
  final String? businessName;
  final String? shortBio;

  ExtendedProfile({this.position, this.businessName, this.shortBio});

  factory ExtendedProfile.fromJson(Map<String, dynamic> json) {
    try {
      return ExtendedProfile(
        position: json['position'],
        businessName: json['businessName'],
        shortBio: json['shortBio'],
      );
    } catch (e) {
      throw Exception('Error parsing ExtendedProfile: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'position': position,
    'businessName': businessName,
    'shortBio': shortBio,
  };
}
