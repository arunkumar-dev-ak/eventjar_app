abstract class LoginResponse {
  const LoginResponse();

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    try {
      // Handle 2FA response case
      if (json['requires2FA'] == true) {
        return Login2FAResponse(
          requires2FA: true,
          tempToken: json['tempToken'],
        );
      }

      // Handle normal login response
      return NormalLoginResponse(
        loginUser: User.fromJson(json['user']),
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
      );
    } catch (e) {
      throw Exception('Error parsing LoginResponse: $e');
    }
  }

  Map<String, dynamic> toJson();
  bool get requires2FA;
  String? get tempToken;
  User? get user;
  String? get accessToken;
  String? get refreshToken;
}

class NormalLoginResponse implements LoginResponse {
  final User loginUser;

  @override
  final String accessToken;

  @override
  final String refreshToken;

  const NormalLoginResponse({
    required this.loginUser,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  bool get requires2FA => false;

  @override
  String? get tempToken => null;

  @override
  User? get user => loginUser;

  @override
  Map<String, dynamic> toJson() => {
    'user': loginUser.toJson(),
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
}

class Login2FAResponse implements LoginResponse {
  @override
  final bool requires2FA;

  @override
  final String tempToken;

  const Login2FAResponse({required this.requires2FA, required this.tempToken});

  @override
  Map<String, dynamic> toJson() => {
    'requires2FA': requires2FA,
    'tempToken': tempToken,
  };

  @override
  User? get user => null;

  @override
  String? get accessToken => null;

  @override
  String? get refreshToken => null;
}

class User {
  final String? id;
  final String? email;
  final String? name;
  final String? phone;
  final String? role;
  final String? status;
  final bool? isVerified;
  final String? avatarUrl;
  final String? bio;
  final String? company;
  final String? jobTitle;
  final String? location;
  final String? linkedin;
  final String? website;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? username;
  final int? usernameChangeCount;
  final DateTime? usernameLastChangedAt;
  final bool? twoFactorEnabled;

  User({
    this.id,
    this.email,
    this.name,
    this.phone,
    this.role,
    this.status,
    this.isVerified,
    this.avatarUrl,
    this.bio,
    this.company,
    this.jobTitle,
    this.location,
    this.linkedin,
    this.website,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.usernameChangeCount,
    this.usernameLastChangedAt,
    this.twoFactorEnabled,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        phone: json['phone'],
        role: json['role'],
        status: json['status'],
        isVerified: json['isVerified'] ?? false,
        avatarUrl: json['avatarUrl'],
        bio: json['bio'],
        company: json['company'],
        jobTitle: json['jobTitle'],
        location: json['location'],
        linkedin: json['linkedin'],
        website: json['website'],
        createdAt: _parseDate(json['createdAt']),
        updatedAt: _parseDate(json['updatedAt']),
        username: json['username'],
        usernameChangeCount: json['usernameChangeCount'] ?? 0,
        usernameLastChangedAt: _parseDate(json['usernameLastChangedAt']),
        twoFactorEnabled: json['twoFactorEnabled'] ?? false,
      );
    } catch (e) {
      throw Exception('Error parsing User: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'phone': phone,
    'role': role,
    'status': status,
    'isVerified': isVerified,
    'avatarUrl': avatarUrl,
    'bio': bio,
    'company': company,
    'jobTitle': jobTitle,
    'location': location,
    'linkedin': linkedin,
    'website': website,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'username': username,
    'usernameChangeCount': usernameChangeCount,
    'usernameLastChangedAt': usernameLastChangedAt?.toIso8601String(),
    'twoFactorEnabled': twoFactorEnabled,
  };

  // Convenience getters matching common usage patterns
  String get displayName => name ?? username ?? email ?? 'Unknown User';
  bool get isActive => status == 'active';
  bool get isOrganizer => role == 'ORGANIZER';
  bool get has2FA => twoFactorEnabled == true;
}

// // Helper method for safe date parsing
DateTime? _parseDate(dynamic date) {
  if (date == null) return null;
  try {
    return DateTime.parse(date.toString());
  } catch (e) {
    return null;
  }
}
