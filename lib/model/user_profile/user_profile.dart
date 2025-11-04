class UserProfileResponse {
  final bool success;
  final UserProfile data;

  UserProfileResponse({required this.success, required this.data});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    try {
      return UserProfileResponse(
        success: json['success'] ?? false,
        data: UserProfile.fromJson(json['data']),
      );
    } catch (e) {
      throw Exception('Error in UserProfileResponse: $e');
    }
  }

  Map<String, dynamic> toJson() => {'success': success, 'data': data.toJson()};
}

class UserProfile {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String role;
  final bool isVerified;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final String? avatarUrl;
  final String? bio;
  final String? company;
  final String? jobTitle;
  final String? location;
  final String? linkedin;
  final String? website;
  final String username;
  final int usernameChangeCount;
  final DateTime? usernameLastChangedAt;
  final ExtendedProfile? extendedProfile;

  UserProfile({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    required this.role,
    required this.isVerified,
    this.lastLoginAt,
    required this.createdAt,
    this.avatarUrl,
    this.bio,
    this.company,
    this.jobTitle,
    this.location,
    this.linkedin,
    this.website,
    required this.username,
    required this.usernameChangeCount,
    this.usernameLastChangedAt,
    this.extendedProfile,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    try {
      return UserProfile(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        phone: json['phone'],
        role: json['role'],
        isVerified: json['isVerified'] ?? false,
        lastLoginAt: json['lastLoginAt'] != null
            ? DateTime.parse(json['lastLoginAt'])
            : null,
        createdAt: DateTime.parse(json['createdAt']),
        avatarUrl: json['avatarUrl'],
        bio: json['bio'],
        company: json['company'],
        jobTitle: json['jobTitle'],
        location: json['location'],
        linkedin: json['linkedin'],
        website: json['website'],
        username: json['username'],
        usernameChangeCount: json['usernameChangeCount'] ?? 0,
        usernameLastChangedAt: json['usernameLastChangedAt'] != null
            ? DateTime.parse(json['usernameLastChangedAt'])
            : null,
        extendedProfile: json['extendedProfile'] != null
            ? ExtendedProfile.fromJson(json['extendedProfile'])
            : null,
      );
    } catch (e) {
      throw Exception('Error in UserProfile: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'phone': phone,
    'role': role,
    'isVerified': isVerified,
    'lastLoginAt': lastLoginAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'avatarUrl': avatarUrl,
    'bio': bio,
    'company': company,
    'jobTitle': jobTitle,
    'location': location,
    'linkedin': linkedin,
    'website': website,
    'username': username,
    'usernameChangeCount': usernameChangeCount,
    'usernameLastChangedAt': usernameLastChangedAt?.toIso8601String(),
    'extendedProfile': extendedProfile?.toJson(),
  };
}

class ExtendedProfile {
  final String id;
  final String userId;
  final String? fullName;
  final String email;
  final String? mobileNumber;
  final String? profilePhoto;
  final String? position;
  final String? businessName;
  final String? businessCategory;
  final String? businessWebsite;
  final String? businessEmail;
  final String? businessPhone;
  final String? businessAddress;
  final String? businessType;
  final String? numberOfEmployees;
  final String? yearsInBusiness;
  final String? networkingGoal;
  final List<String> interestedInConnecting;
  final List<String> helpOfferings;
  final List<String> discussionTopics;
  final String? shortBio;
  final String? availabilitySlots;
  final List<String> preferredLocations;
  final String? linkedinProfile;
  final SocialMediaLinks socialMediaLinks;
  final List<String> eventInterests;
  final String? gstTaxId;
  final String? annualRevenue;
  final String? companyLogo;
  final String? referralCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExtendedProfile({
    required this.id,
    required this.userId,
    this.fullName,
    required this.email,
    this.mobileNumber,
    this.profilePhoto,
    this.position,
    this.businessName,
    this.businessCategory,
    this.businessWebsite,
    this.businessEmail,
    this.businessPhone,
    this.businessAddress,
    this.businessType,
    this.numberOfEmployees,
    this.yearsInBusiness,
    this.networkingGoal,
    required this.interestedInConnecting,
    required this.helpOfferings,
    required this.discussionTopics,
    this.shortBio,
    this.availabilitySlots,
    required this.preferredLocations,
    this.linkedinProfile,
    required this.socialMediaLinks,
    required this.eventInterests,
    this.gstTaxId,
    this.annualRevenue,
    this.companyLogo,
    this.referralCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExtendedProfile.fromJson(Map<String, dynamic> json) {
    try {
      return ExtendedProfile(
        id: json['id'],
        userId: json['userId'],
        fullName: json['fullName'],
        email: json['email'],
        mobileNumber: json['mobileNumber'],
        profilePhoto: json['profilePhoto'],
        position: json['position'],
        businessName: json['businessName'],
        businessCategory: json['businessCategory'],
        businessWebsite: json['businessWebsite'],
        businessEmail: json['businessEmail'],
        businessPhone: json['businessPhone'],
        businessAddress: json['businessAddress'],
        businessType: json['businessType'],
        numberOfEmployees: json['numberOfEmployees'],
        yearsInBusiness: json['yearsInBusiness'],
        networkingGoal: json['networkingGoal'],
        interestedInConnecting:
            (json['interestedInConnecting'] as List?)?.cast<String>() ?? [],
        helpOfferings: (json['helpOfferings'] as List?)?.cast<String>() ?? [],
        discussionTopics:
            (json['discussionTopics'] as List?)?.cast<String>() ?? [],
        shortBio: json['shortBio'],
        availabilitySlots: json['availabilitySlots'],
        preferredLocations:
            (json['preferredLocations'] as List?)?.cast<String>() ?? [],
        linkedinProfile: json['linkedinProfile'],
        socialMediaLinks: json['socialMediaLinks'] != null
            ? SocialMediaLinks.fromJson(json['socialMediaLinks'])
            : SocialMediaLinks.empty(),
        eventInterests: (json['eventInterests'] as List?)?.cast<String>() ?? [],
        gstTaxId: json['gstTaxId'],
        annualRevenue: json['annualRevenue'],
        companyLogo: json['companyLogo'],
        referralCode: json['referralCode'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
    } catch (e) {
      throw Exception('Error in ExtendedProfile: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'fullName': fullName,
    'email': email,
    'mobileNumber': mobileNumber,
    'profilePhoto': profilePhoto,
    'position': position,
    'businessName': businessName,
    'businessCategory': businessCategory,
    'businessWebsite': businessWebsite,
    'businessEmail': businessEmail,
    'businessPhone': businessPhone,
    'businessAddress': businessAddress,
    'businessType': businessType,
    'numberOfEmployees': numberOfEmployees,
    'yearsInBusiness': yearsInBusiness,
    'networkingGoal': networkingGoal,
    'interestedInConnecting': interestedInConnecting,
    'helpOfferings': helpOfferings,
    'discussionTopics': discussionTopics,
    'shortBio': shortBio,
    'availabilitySlots': availabilitySlots,
    'preferredLocations': preferredLocations,
    'linkedinProfile': linkedinProfile,
    'socialMediaLinks': socialMediaLinks.toJson(),
    'eventInterests': eventInterests,
    'gstTaxId': gstTaxId,
    'annualRevenue': annualRevenue,
    'companyLogo': companyLogo,
    'referralCode': referralCode,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class SocialMediaLinks {
  final String twitter;
  final String facebook;
  final String linkedin;
  final String instagram;

  SocialMediaLinks({
    required this.twitter,
    required this.facebook,
    required this.linkedin,
    required this.instagram,
  });

  factory SocialMediaLinks.fromJson(Map<String, dynamic> json) {
    try {
      return SocialMediaLinks(
        twitter: json['twitter'] ?? '',
        facebook: json['facebook'] ?? '',
        linkedin: json['linkedin'] ?? '',
        instagram: json['instagram'] ?? '',
      );
    } catch (e) {
      throw Exception('Error in SocialMediaLinks: $e');
    }
  }

  factory SocialMediaLinks.empty() {
    return SocialMediaLinks(
      twitter: '',
      facebook: '',
      linkedin: '',
      instagram: '',
    );
  }

  Map<String, dynamic> toJson() => {
    'twitter': twitter,
    'facebook': facebook,
    'linkedin': linkedin,
    'instagram': instagram,
  };
}
