class BioProfile {
  bool? success;
  DataUser? data;

  BioProfile({this.success, this.data});

  factory BioProfile.fromJson(Map<String, dynamic> json) => BioProfile(
    success: json["success"],
    data: json["data"] == null ? null : DataUser.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"success": success, "data": data?.toJson()};
}

class DataUser {
  String? id;
  String? username;
  String? name;
  String? avatarUrl;
  String? bio;
  String? company;
  String? jobTitle;
  String? location;
  dynamic linkedin;
  String? website;
  List<dynamic>? userBadges;
  List<CustomBadgeAssignment>? customBadgeAssignments;
  ExtendedProfile? extendedProfile;
  Stats? stats;

  DataUser({
    this.id,
    this.username,
    this.name,
    this.avatarUrl,
    this.bio,
    this.company,
    this.jobTitle,
    this.location,
    this.linkedin,
    this.website,
    this.userBadges,
    this.customBadgeAssignments,
    this.extendedProfile,
    this.stats,
  });

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
    id: json["id"],
    username: json["username"],
    name: json["name"],
    avatarUrl: json["avatarUrl"],
    bio: json["bio"],
    company: json["company"],
    jobTitle: json["jobTitle"],
    location: json["location"],
    linkedin: json["linkedin"],
    website: json["website"],
    userBadges: json["userBadges"] == null
        ? []
        : List<dynamic>.from(json["userBadges"]!.map((x) => x)),
    customBadgeAssignments: json["customBadgeAssignments"] == null
        ? []
        : List<CustomBadgeAssignment>.from(
            json["customBadgeAssignments"]!.map(
              (x) => CustomBadgeAssignment.fromJson(x),
            ),
          ),
    extendedProfile: json["extendedProfile"] == null
        ? null
        : ExtendedProfile.fromJson(json["extendedProfile"]),
    stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "name": name,
    "avatarUrl": avatarUrl,
    "bio": bio,
    "company": company,
    "jobTitle": jobTitle,
    "location": location,
    "linkedin": linkedin,
    "website": website,
    "userBadges": userBadges == null
        ? []
        : List<dynamic>.from(userBadges!.map((x) => x)),
    "customBadgeAssignments": customBadgeAssignments == null
        ? []
        : List<dynamic>.from(customBadgeAssignments!.map((x) => x.toJson())),
    "extendedProfile": extendedProfile?.toJson(),
    "stats": stats?.toJson(),
  };
}

class CustomBadgeAssignment {
  String? id;
  DateTime? assignedAt;
  CustomBadge? customBadge;

  CustomBadgeAssignment({this.id, this.assignedAt, this.customBadge});

  factory CustomBadgeAssignment.fromJson(Map<String, dynamic> json) =>
      CustomBadgeAssignment(
        id: json["id"],
        assignedAt: json["assignedAt"] == null
            ? null
            : DateTime.parse(json["assignedAt"]),
        customBadge: json["customBadge"] == null
            ? null
            : CustomBadge.fromJson(json["customBadge"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "assignedAt": assignedAt?.toIso8601String(),
    "customBadge": customBadge?.toJson(),
  };
}

class CustomBadge {
  String? id;
  String? name;
  String? description;
  dynamic imageUrl;
  String? color;

  CustomBadge({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.color,
  });

  factory CustomBadge.fromJson(Map<String, dynamic> json) => CustomBadge(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    imageUrl: json["imageUrl"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "imageUrl": imageUrl,
    "color": color,
  };
}

class ExtendedProfile {
  dynamic businessName;
  String? businessCategory;
  dynamic businessWebsite;
  dynamic businessAddress;
  dynamic businessType;
  dynamic numberOfEmployees;
  String? yearsInBusiness;
  dynamic networkingGoal;
  List<String>? interestedInConnecting;
  List<String>? helpOfferings;
  List<String>? discussionTopics;
  List<String>? knownLanguages;
  List<String>? skills;
  dynamic shortBio;
  String? availabilitySlots;
  List<dynamic>? preferredLocations;
  SocialMediaLinks? socialMediaLinks;
  List<dynamic>? eventInterests;
  List<dynamic>? galleryImages;

  ExtendedProfile({
    this.businessName,
    this.businessCategory,
    this.businessWebsite,
    this.businessAddress,
    this.businessType,
    this.numberOfEmployees,
    this.yearsInBusiness,
    this.networkingGoal,
    this.interestedInConnecting,
    this.helpOfferings,
    this.discussionTopics,
    this.knownLanguages,
    this.skills,
    this.shortBio,
    this.availabilitySlots,
    this.preferredLocations,
    this.socialMediaLinks,
    this.eventInterests,
    this.galleryImages,
  });

  factory ExtendedProfile.fromJson(Map<String, dynamic> json) =>
      ExtendedProfile(
        businessName: json["businessName"],
        businessCategory: json["businessCategory"],
        businessWebsite: json["businessWebsite"],
        businessAddress: json["businessAddress"],
        businessType: json["businessType"],
        numberOfEmployees: json["numberOfEmployees"],
        yearsInBusiness: json["yearsInBusiness"],
        networkingGoal: json["networkingGoal"],
        interestedInConnecting: json["interestedInConnecting"] == null
            ? []
            : List<String>.from(json["interestedInConnecting"]!.map((x) => x)),
        helpOfferings: json["helpOfferings"] == null
            ? []
            : List<String>.from(json["helpOfferings"]!.map((x) => x)),
        discussionTopics: json["discussionTopics"] == null
            ? []
            : List<String>.from(json["discussionTopics"]!.map((x) => x)),
        knownLanguages: json["knownLanguages"] == null
            ? []
            : List<String>.from(json["knownLanguages"]!.map((x) => x)),
        skills: json["skills"] == null
            ? []
            : List<String>.from(json["skills"]!.map((x) => x)),
        shortBio: json["shortBio"],
        availabilitySlots: json["availabilitySlots"],
        preferredLocations: json["preferredLocations"] == null
            ? []
            : List<dynamic>.from(json["preferredLocations"]!.map((x) => x)),
        socialMediaLinks: json["socialMediaLinks"] == null
            ? null
            : SocialMediaLinks.fromJson(json["socialMediaLinks"]),
        eventInterests: json["eventInterests"] == null
            ? []
            : List<dynamic>.from(json["eventInterests"]!.map((x) => x)),
        galleryImages: json["galleryImages"] == null
            ? []
            : List<dynamic>.from(json["galleryImages"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "businessName": businessName,
    "businessCategory": businessCategory,
    "businessWebsite": businessWebsite,
    "businessAddress": businessAddress,
    "businessType": businessType,
    "numberOfEmployees": numberOfEmployees,
    "yearsInBusiness": yearsInBusiness,
    "networkingGoal": networkingGoal,
    "interestedInConnecting": interestedInConnecting == null
        ? []
        : List<dynamic>.from(interestedInConnecting!.map((x) => x)),
    "helpOfferings": helpOfferings == null
        ? []
        : List<dynamic>.from(helpOfferings!.map((x) => x)),
    "discussionTopics": discussionTopics == null
        ? []
        : List<dynamic>.from(discussionTopics!.map((x) => x)),
    "knownLanguages": knownLanguages == null
        ? []
        : List<dynamic>.from(knownLanguages!.map((x) => x)),
    "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
    "shortBio": shortBio,
    "availabilitySlots": availabilitySlots,
    "preferredLocations": preferredLocations == null
        ? []
        : List<dynamic>.from(preferredLocations!.map((x) => x)),
    "socialMediaLinks": socialMediaLinks?.toJson(),
    "eventInterests": eventInterests == null
        ? []
        : List<dynamic>.from(eventInterests!.map((x) => x)),
    "galleryImages": galleryImages == null
        ? []
        : List<dynamic>.from(galleryImages!.map((x) => x)),
  };
}

class SocialMediaLinks {
  String? twitter;
  String? facebook;
  String? linkedin;
  String? instagram;

  SocialMediaLinks({
    this.twitter,
    this.facebook,
    this.linkedin,
    this.instagram,
  });

  factory SocialMediaLinks.fromJson(Map<String, dynamic> json) =>
      SocialMediaLinks(
        twitter: json["twitter"],
        facebook: json["facebook"],
        linkedin: json["linkedin"],
        instagram: json["instagram"],
      );

  Map<String, dynamic> toJson() => {
    "twitter": twitter,
    "facebook": facebook,
    "linkedin": linkedin,
    "instagram": instagram,
  };
}

class Stats {
  int? eventsAttended;
  int? connectionsCount;
  int? profileViews;
  int? rating;

  Stats({
    this.eventsAttended,
    this.connectionsCount,
    this.profileViews,
    this.rating,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    eventsAttended: json["eventsAttended"],
    connectionsCount: json["connectionsCount"],
    profileViews: json["profileViews"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "eventsAttended": eventsAttended,
    "connectionsCount": connectionsCount,
    "profileViews": profileViews,
    "rating": rating,
  };
}
