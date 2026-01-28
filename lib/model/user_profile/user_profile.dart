import 'package:eventjar/model/contact/mobile_contact_model.dart';

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
  final String? avatarUrl;
  final String? bio;
  final String? company;
  final String? jobTitle;
  final String? location;
  final String? linkedin;
  final String? website;
  final String? username;
  final ExtendedProfile? extendedProfile;
  final PhoneParsed? phoneParsed;

  UserProfile({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.phoneParsed,
    required this.role,
    required this.isVerified,
    this.avatarUrl,
    this.bio,
    this.company,
    this.jobTitle,
    this.location,
    this.linkedin,
    this.website,
    this.username,
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
        phoneParsed: json['phoneParsed'] != null
            ? PhoneParsed.fromJson(json['phoneParsed'])
            : null,
        avatarUrl: json['avatarUrl'],
        bio: json['bio'],
        company: json['company'],
        jobTitle: json['jobTitle'],
        location: json['location'],
        linkedin: json['linkedin'],
        website: json['website'],
        username: json['username'],
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
    'avatarUrl': avatarUrl,
    'bio': bio,
    'company': company,
    'phoneParsed': phoneParsed?.toJson(),
    'jobTitle': jobTitle,
    'location': location,
    'linkedin': linkedin,
    'website': website,
    'username': username,
    'extendedProfile': extendedProfile?.toJson(),
  };
}

class ExtendedProfile {
  final String id;
  final String userId;
  final String? fullName;
  final String? email;
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
  final PhoneParsed? businessPhoneParsed;

  ExtendedProfile({
    required this.id,
    required this.userId,
    this.fullName,
    this.email,
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
    this.businessPhoneParsed,
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
        businessPhoneParsed: json['businessPhoneParsed'] != null
            ? PhoneParsed.fromJson(json['businessPhoneParsed'])
            : null,
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
    'businessPhoneParsed': businessPhoneParsed?.toJson(),
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
