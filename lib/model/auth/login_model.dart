// class LoginResponse {
//   final String accessToken;
//   final String refreshToken;
//   final User user;

//   LoginResponse({
//     required this.accessToken,
//     required this.refreshToken,
//     required this.user,
//   });

//   factory LoginResponse.fromJson(Map<String, dynamic> json) {
//     try {
//       return LoginResponse(
//         accessToken: json['accessToken'],
//         refreshToken: json['refreshToken'],
//         user: User.fromJson(json['user']),
//       );
//     } catch (e) {
//       throw Exception('Error in LoginResponse: $e');
//     }
//   }

//   Map<String, dynamic> toJson() => {
//     'accessToken': accessToken,
//     'refreshToken': refreshToken,
//     'user': user.toJson(),
//   };
// }

// class User {
//   final String id;
//   final String email;
//   final String name;
//   final String phone;
//   final String role;
//   final String status;
//   final bool isVerified;
//   final DateTime? lastLoginAt;
//   final String? avatarUrl;
//   final String? bio;
//   final String? company;
//   final String? jobTitle;
//   final String? location;
//   final String? linkedin;
//   final String? website;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final String username;
//   final int usernameChangeCount;
//   final DateTime? usernameLastChangedAt;
//   final bool twoFactorEnabled;
//   final List<String>? twoFactorBackupCodes;
//   final DateTime? lastPasswordChange;
//   final int failedLoginAttempts;
//   final DateTime? lockedUntil;
//   final bool networkingEnabled;
//   final bool allowMultipleConnections;
//   final int? maxConnectionsPerEvent;

//   User({
//     required this.id,
//     required this.email,
//     required this.name,
//     required this.phone,
//     required this.role,
//     required this.status,
//     required this.isVerified,
//     this.lastLoginAt,
//     this.avatarUrl,
//     this.bio,
//     this.company,
//     this.jobTitle,
//     this.location,
//     this.linkedin,
//     this.website,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.username,
//     required this.usernameChangeCount,
//     this.usernameLastChangedAt,
//     required this.twoFactorEnabled,
//     this.twoFactorBackupCodes,
//     this.lastPasswordChange,
//     required this.failedLoginAttempts,
//     this.lockedUntil,
//     required this.networkingEnabled,
//     required this.allowMultipleConnections,
//     this.maxConnectionsPerEvent,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     try {
//       return User(
//         id: json['id'],
//         email: json['email'],
//         name: json['name'],
//         phone: json['phone'],
//         role: json['role'],
//         status: json['status'],
//         isVerified: json['isVerified'] ?? false,
//         lastLoginAt: json['lastLoginAt'] != null
//             ? DateTime.parse(json['lastLoginAt'])
//             : null,
//         avatarUrl: json['avatarUrl'],
//         bio: json['bio'],
//         company: json['company'],
//         jobTitle: json['jobTitle'],
//         location: json['location'],
//         linkedin: json['linkedin'],
//         website: json['website'],
//         createdAt: DateTime.parse(json['createdAt']),
//         updatedAt: DateTime.parse(json['updatedAt']),
//         username: json['username'],
//         usernameChangeCount: json['usernameChangeCount'] ?? 0,
//         usernameLastChangedAt: json['usernameLastChangedAt'] != null
//             ? DateTime.parse(json['usernameLastChangedAt'])
//             : null,
//         twoFactorEnabled: json['twoFactorEnabled'] ?? false,
//         twoFactorBackupCodes: json['twoFactorBackupCodes'] != null
//             ? List<String>.from(json['twoFactorBackupCodes'])
//             : null,
//         lastPasswordChange: json['lastPasswordChange'] != null
//             ? DateTime.parse(json['lastPasswordChange'])
//             : null,
//         failedLoginAttempts: json['failedLoginAttempts'] ?? 0,
//         lockedUntil: json['lockedUntil'] != null
//             ? DateTime.parse(json['lockedUntil'])
//             : null,
//         networkingEnabled: json['networkingEnabled'] ?? true,
//         allowMultipleConnections: json['allowMultipleConnections'] ?? true,
//         maxConnectionsPerEvent: json['maxConnectionsPerEvent'],
//       );
//     } catch (e) {
//       throw Exception('Error in User: $e');
//     }
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'email': email,
//     'name': name,
//     'phone': phone,
//     'role': role,
//     'status': status,
//     'isVerified': isVerified,
//     'lastLoginAt': lastLoginAt?.toIso8601String(),
//     'avatarUrl': avatarUrl,
//     'bio': bio,
//     'company': company,
//     'jobTitle': jobTitle,
//     'location': location,
//     'linkedin': linkedin,
//     'website': website,
//     'createdAt': createdAt.toIso8601String(),
//     'updatedAt': updatedAt.toIso8601String(),
//     'username': username,
//     'usernameChangeCount': usernameChangeCount,
//     'usernameLastChangedAt': usernameLastChangedAt?.toIso8601String(),
//     'twoFactorEnabled': twoFactorEnabled,
//     'twoFactorBackupCodes': twoFactorBackupCodes,
//     'lastPasswordChange': lastPasswordChange?.toIso8601String(),
//     'failedLoginAttempts': failedLoginAttempts,
//     'lockedUntil': lockedUntil?.toIso8601String(),
//     'networkingEnabled': networkingEnabled,
//     'allowMultipleConnections': allowMultipleConnections,
//     'maxConnectionsPerEvent': maxConnectionsPerEvent,
//   };
// }

class LoginResponse {
  final User user;
  final String accessToken;
  final String refreshToken;

  LoginResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    try {
      // Handle 2FA response case
      // if (json['requires2FA'] == true) {
      //   return LoginApiResponse(
      //     requires2FA: true,
      //     tempToken: json['tempToken'],
      //   );
      // }

      // Handle normal login response (mobile/web)
      return LoginResponse(
        user: User.fromJson(json['user']),
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
      );
    } catch (e) {
      throw Exception('Error parsing LoginApiResponse: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
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

// Helper method for safe date parsing
DateTime? _parseDate(dynamic date) {
  if (date == null) return null;
  try {
    return DateTime.parse(date.toString());
  } catch (e) {
    return null;
  }
}
