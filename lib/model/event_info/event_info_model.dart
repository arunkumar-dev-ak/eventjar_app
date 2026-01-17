import 'package:eventjar/global/utils/helpers.dart';

class EventInfo {
  // Core - Required non-null from Prisma
  final String id;
  final String? slug; // String? in Prisma
  final String organizerId;
  final String title;
  final String? description;

  // Location - address/startTime/endTime non-null in Prisma
  final String? venue;
  final String address;
  final String? location;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final String? placeId;

  // Date & time
  final DateTime startDate;
  final DateTime endDate;
  final String? date;
  final String startTime;
  final String endTime;
  final String? timezone;
  final DateTime? publishDate;

  // Type
  final bool isVirtual;
  final bool isHybrid;
  final String? virtualLink;
  final String? virtualPlatform;

  // Capacity & pricing
  final int maxAttendees;
  final int currentAttendees;
  final int attendeeCount; // Backend computed
  final String? eventCapacityType;
  final bool isPaid;
  final double? ticketPrice;
  final double? earlyBirdPrice;
  final DateTime? earlyBirdEndDate;
  final DateTime? bookingLastDate;
  final bool platformFeeEnabled;
  final double? platformFeePercent;

  // Settings
  final String status; // EventStatus enum as string
  final bool requiresApproval;
  final bool isOneMeetingEnabled;
  final bool allowMultipleTickets;
  final int maxTicketsPerUser;

  // Badges
  final bool badgeRequirementEnabled;
  final List<String> requiredBadgeId;

  // Content
  final List<dynamic> agenda;
  final List<Media> media;
  final String? featuredImageUrl;
  final List<String> galleryImages;
  final List<String> tags;
  final List<String> amenities;

  // Extra info
  final String? eventWebsite;
  final Map<String, dynamic>? socialLinks;
  final String? registrationInstructions;
  final String? cancellationPolicy;
  final String? refundPolicy;
  final Map<String, dynamic>? contactInfo;

  // Details - all optional
  final String? ageRestriction;
  final String? dressCode;
  final String? language;
  final String? parkingInfo;
  final String? accessibilityInfo;
  final String? specialInstructions;
  final String? termsAndConditions;

  // Organizer contact - all optional
  final String? organizerContactName;
  final String? organizerContactEmail;
  final String? organizerContactPhone;
  final String? organizerWebsite;

  // Relations
  final Organizer organizer;
  final List<TicketTier> ticketTiers;
  final List<dynamic> agendaItems;
  final Category? category;
  final EventCount count;
  final UserTicketStatus? userTicketStatus; // Backend optional

  EventInfo({
    required this.id,
    this.slug,
    required this.organizerId,
    required this.title,
    this.description,
    this.venue,
    required this.address,
    this.location,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.placeId,
    required this.startDate,
    required this.endDate,
    this.date,
    required this.startTime,
    required this.endTime,
    this.timezone,
    this.publishDate,
    required this.isVirtual,
    required this.isHybrid,
    this.virtualLink,
    this.virtualPlatform,
    required this.maxAttendees,
    required this.currentAttendees,
    required this.attendeeCount,
    this.eventCapacityType,
    required this.isPaid,
    this.ticketPrice,
    this.earlyBirdPrice,
    this.earlyBirdEndDate,
    this.bookingLastDate,
    required this.platformFeeEnabled,
    this.platformFeePercent,
    required this.status,
    required this.requiresApproval,
    required this.isOneMeetingEnabled,
    required this.allowMultipleTickets,
    required this.maxTicketsPerUser,
    required this.badgeRequirementEnabled,
    required this.requiredBadgeId,
    required this.agenda,
    required this.media,
    this.featuredImageUrl,
    required this.galleryImages,
    required this.tags,
    required this.amenities,
    this.eventWebsite,
    this.socialLinks,
    this.registrationInstructions,
    this.cancellationPolicy,
    this.refundPolicy,
    this.contactInfo,
    this.ageRestriction,
    this.dressCode,
    this.language,
    this.parkingInfo,
    this.accessibilityInfo,
    this.specialInstructions,
    this.termsAndConditions,
    this.organizerContactName,
    this.organizerContactEmail,
    this.organizerContactPhone,
    this.organizerWebsite,
    required this.organizer,
    required this.ticketTiers,
    required this.agendaItems,
    this.category,
    required this.count,
    this.userTicketStatus,
  });

  factory EventInfo.fromJson(Map<String, dynamic> response) {
    double? d(dynamic v) => v == null ? null : double.tryParse(v.toString());

    dynamic json = response['data'];

    return EventInfo(
      id: json['id'] ?? '',
      slug: json['slug'],
      organizerId: json['organizerId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      venue: json['venue'],
      address: json['address'] ?? '',
      location: json['location'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'],
      latitude: d(json['latitude']),
      longitude: d(json['longitude']),
      placeId: json['placeId'],
      startDate: parseDateSafe(json['startDate']) ?? DateTime.now(),
      endDate: parseDateSafe(json['endDate']) ?? DateTime.now(),
      date: json['date'],
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      timezone: json['timezone'],
      publishDate: parseDateSafe(json['publishDate']),
      isVirtual: json['isVirtual'] ?? false,
      isHybrid: json['isHybrid'] ?? false,
      virtualLink: json['virtualLink'],
      virtualPlatform: json['virtualPlatform'],
      maxAttendees: json['maxAttendees'] ?? 0,
      currentAttendees: json['currentAttendees'] ?? 0,
      attendeeCount: json['attendeeCount'] ?? 0,
      eventCapacityType: json['eventCapacityType'],
      isPaid: json['isPaid'] ?? false,
      ticketPrice: d(json['ticketPrice']),
      earlyBirdPrice: d(json['earlyBirdPrice']),
      earlyBirdEndDate: parseDateSafe(json['earlyBirdEndDate']),
      bookingLastDate: parseDateSafe(json['bookingLastDate']),
      platformFeeEnabled: json['platformFeeEnabled'] ?? false,
      platformFeePercent: d(json['platformFeePercent']),
      status: json['status'] ?? 'draft',
      requiresApproval: json['requiresApproval'] ?? false,
      isOneMeetingEnabled: json['isOneMeetingEnabled'] ?? false,
      allowMultipleTickets: json['allowMultipleTickets'] ?? false,
      maxTicketsPerUser: json['maxTicketsPerUser'] ?? 1,
      badgeRequirementEnabled: json['badgeRequirementEnabled'] ?? false,
      requiredBadgeId: json['requiredBadgeId'] != null
          ? List<String>.from(json['requiredBadgeId'])
          : [],
      agenda: json['agenda'] ?? [],
      media: (json['media'] as List? ?? [])
          .map((e) => Media.fromJson(e))
          .toList(),
      featuredImageUrl: json['featuredImageUrl'],
      galleryImages: List<String>.from(json['galleryImages'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      eventWebsite: json['eventWebsite'],
      socialLinks: json['socialLinks'],
      registrationInstructions: json['registrationInstructions'],
      cancellationPolicy: json['cancellationPolicy'],
      refundPolicy: json['refundPolicy'],
      contactInfo: json['contactInfo'],
      ageRestriction: json['ageRestriction'],
      dressCode: json['dressCode'],
      language: json['language'],
      parkingInfo: json['parkingInfo'],
      accessibilityInfo: json['accessibilityInfo'],
      specialInstructions: json['specialInstructions'],
      termsAndConditions: json['termsAndConditions'],
      organizerContactName: json['organizerContactName'],
      organizerContactEmail: json['organizerContactEmail'],
      organizerContactPhone: json['organizerContactPhone'],
      organizerWebsite: json['organizerWebsite'],
      organizer: Organizer.fromJson(json['organizer'] ?? {}),
      ticketTiers: (json['ticketTiers'] as List? ?? [])
          .map((e) => TicketTier.fromJson(e))
          .toList(),
      agendaItems: json['agendaItems'] ?? [],
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
      count: EventCount.fromJson(json['_count'] ?? {}),
      userTicketStatus: json['userTicketStatus'] != null
          ? UserTicketStatus.fromJson(json['userTicketStatus'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Core
      'id': id,
      'slug': slug,
      'organizerId': organizerId,
      'title': title,
      'description': description,

      // Location
      'venue': venue,
      'address': address,
      'location': location,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'placeId': placeId,

      // Date & time
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'timezone': timezone,
      'publishDate': publishDate?.toIso8601String(),

      // Type
      'isVirtual': isVirtual,
      'isHybrid': isHybrid,
      'virtualLink': virtualLink,
      'virtualPlatform': virtualPlatform,

      // Capacity & pricing
      'maxAttendees': maxAttendees,
      'currentAttendees': currentAttendees,
      'attendeeCount': attendeeCount,
      'eventCapacityType': eventCapacityType,
      'isPaid': isPaid,
      'ticketPrice': ticketPrice,
      'earlyBirdPrice': earlyBirdPrice,
      'earlyBirdEndDate': earlyBirdEndDate?.toIso8601String(),
      'bookingLastDate': bookingLastDate?.toIso8601String(),
      'platformFeeEnabled': platformFeeEnabled,
      'platformFeePercent': platformFeePercent,

      // Settings
      'status': status,
      'requiresApproval': requiresApproval,
      'isOneMeetingEnabled': isOneMeetingEnabled,
      'allowMultipleTickets': allowMultipleTickets,
      'maxTicketsPerUser': maxTicketsPerUser,

      // Badges
      'badgeRequirementEnabled': badgeRequirementEnabled,
      'requiredBadgeId': requiredBadgeId,

      // Content
      'agenda': agenda,
      'media': media.map((m) => m.toJson()).toList(),
      'featuredImageUrl': featuredImageUrl,
      'galleryImages': galleryImages,
      'tags': tags,
      'amenities': amenities,

      // Extra info
      'eventWebsite': eventWebsite,
      'socialLinks': socialLinks,
      'registrationInstructions': registrationInstructions,
      'cancellationPolicy': cancellationPolicy,
      'refundPolicy': refundPolicy,
      'contactInfo': contactInfo,

      // Details
      'ageRestriction': ageRestriction,
      'dressCode': dressCode,
      'language': language,
      'parkingInfo': parkingInfo,
      'accessibilityInfo': accessibilityInfo,
      'specialInstructions': specialInstructions,
      'termsAndConditions': termsAndConditions,

      // Organizer contact
      'organizerContactName': organizerContactName,
      'organizerContactEmail': organizerContactEmail,
      'organizerContactPhone': organizerContactPhone,
      'organizerWebsite': organizerWebsite,

      // Relations
      'organizer': organizer.toJson(),
      'ticketTiers': ticketTiers.map((t) => t.toJson()).toList(),
      'agendaItems': agendaItems,
      'category': category?.toJson(),
      'count': count.toJson(),
      'userTicketStatus': userTicketStatus?.toJson(),
    };
  }
}

class Organizer {
  final String id;
  final String name;
  final String? email;
  final String? role;
  final String? avatarUrl;
  final String? bio;
  final String? company;
  final String? website;
  final String? linkedin;

  Organizer({
    required this.id,
    required this.name,
    this.email,
    this.role,
    this.avatarUrl,
    this.bio,
    this.company,
    this.website,
    this.linkedin,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) {
    try {
      return Organizer(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString(),
        role: json['role']?.toString(),
        avatarUrl: json['avatarUrl']?.toString(),
        bio: json['bio']?.toString(),
        company: json['company']?.toString(),
        website: json['website']?.toString(),
        linkedin: json['linkedin']?.toString(),
      );
    } catch (e) {
      throw Exception('Error parsing Organizer: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'company': company,
      'website': website,
      'linkedin': linkedin,
    };
  }
}

class Media {
  final String id;
  final String url;
  final String name;
  final String? type;
  final String? description;
  final bool? isFeatured;
  final int? orderIndex;

  Media({
    required this.id,
    required this.url,
    required this.name,
    this.type,
    this.description,
    this.isFeatured,
    this.orderIndex,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    try {
      return Media(
        id: json['id']?.toString() ?? '',
        url: json['url']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        type: json['type']?.toString(),
        description: json['description']?.toString(),
        isFeatured: json['is_featured'] ?? false,
        orderIndex: (json['order_index'] ?? 0).toInt(),
      );
    } catch (e) {
      throw Exception('Error parsing Media: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'name': name,
      'type': type,
      'description': description,
      'is_featured': isFeatured,
      'order_index': orderIndex,
    };
  }
}

class TicketTier {
  final String id;
  final String eventId;
  final String name;
  final String? description;
  final String price;
  final double? earlyBirdPrice;
  final int quantity;
  final int sold;
  final String? type;
  final bool isEarlyBird;
  final DateTime? earlyBirdEndDate;
  final DateTime? saleStartDate;
  final DateTime? saleEndDate;

  TicketTier({
    required this.id,
    required this.eventId,
    required this.name,
    this.description,
    required this.price,
    this.earlyBirdPrice,
    required this.quantity,
    required this.sold,
    this.type,
    required this.isEarlyBird,
    this.earlyBirdEndDate,
    this.saleStartDate,
    this.saleEndDate,
  });

  factory TicketTier.fromJson(Map<String, dynamic> json) {
    try {
      double? parseDoubleSafe(dynamic value) {
        if (value == null) return null;
        if (value is num) return value.toDouble();
        if (value is String) return double.tryParse(value);
        return null;
      }

      return TicketTier(
        id: json['id']?.toString() ?? '',
        eventId: json['eventId']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        description: json['description']?.toString(),
        price: json['price']?.toString() ?? '0',
        earlyBirdPrice: parseDoubleSafe(json['earlyBirdPrice']),
        quantity: (json['quantity'] ?? 0).toInt(),
        sold: (json['sold'] ?? 0).toInt(),
        type: json['type']?.toString(),
        isEarlyBird: json['isEarlyBird'] ?? false,
        earlyBirdEndDate: json['earlyBirdEndDate'] != null
            ? parseDateSafe(json['earlyBirdEndDate'].toString())
            : null,
        saleStartDate: json['saleStartDate'] != null
            ? parseDateSafe(json['saleStartDate'].toString())
            : null,
        saleEndDate: json['saleEndDate'] != null
            ? parseDateSafe(json['saleEndDate'].toString())
            : null,
      );
    } catch (e) {
      throw Exception('Error parsing TicketTier: $e');
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'name': name,
      'description': description,
      'price': price,
      'earlyBirdPrice': earlyBirdPrice,
      'quantity': quantity,
      'sold': sold,
      'type': type,
      'isEarlyBird': isEarlyBird,
      'earlyBirdEndDate': earlyBirdEndDate?.toIso8601String(),
      'saleStartDate': saleStartDate?.toIso8601String(),
      'saleEndDate': saleEndDate?.toIso8601String(),
    };
  }
}

class Category {
  final String? id;
  final String? name;
  final String? description;
  final String? icon;
  final String? color;

  Category({this.id, this.name, this.description, this.icon, this.color});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
    };
  }
}

class EventCount {
  final int registrations;
  final int reviews;

  EventCount({required this.registrations, required this.reviews});

  factory EventCount.fromJson(Map<String, dynamic> json) {
    return EventCount(
      registrations: json['registrations'] ?? 0,
      reviews: json['reviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'registrations': registrations, 'reviews': reviews};
  }
}

class RegistrationStats {
  final int totalRegistrations;
  final int availableSpots;
  final String? capacityType;
  final bool requiresApproval;

  RegistrationStats({
    required this.totalRegistrations,
    required this.availableSpots,
    this.capacityType,
    required this.requiresApproval,
  });

  factory RegistrationStats.fromJson(Map<String, dynamic> json) {
    return RegistrationStats(
      totalRegistrations: json['totalRegistrations'] ?? 0,
      availableSpots: json['availableSpots'] ?? 0,
      capacityType: json['capacityType'],
      requiresApproval: json['requiresApproval'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRegistrations': totalRegistrations,
      'availableSpots': availableSpots,
      'capacityType': capacityType,
      'requiresApproval': requiresApproval,
    };
  }
}

class UserTicketStatus {
  final bool isRegistered;
  final String? registrationId;
  final TicketTier? ticketTier;
  final DateTime? registeredAt;
  final String? status;
  final String? qrCode;

  UserTicketStatus({
    required this.isRegistered,
    this.registrationId,
    this.ticketTier,
    this.registeredAt,
    this.status,
    this.qrCode,
  });

  factory UserTicketStatus.fromJson(Map<String, dynamic> json) {
    return UserTicketStatus(
      isRegistered: json['isRegistered'] ?? false,
      registrationId: json['registrationId'],
      ticketTier: json['ticketTier'] != null
          ? TicketTier.fromJson(json['ticketTier'])
          : null,
      registeredAt: parseDateSafe(json['registeredAt']),
      status: json['status'],
      qrCode: json['qrCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isRegistered': isRegistered,
      'registrationId': registrationId,
      'ticketTier': ticketTier?.toJson(),
      'registeredAt': registeredAt?.toIso8601String(),
      'status': status,
      'qrCode': qrCode,
    };
  }
}
