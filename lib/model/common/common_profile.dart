class CommonUserModel {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;

  CommonUserModel({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
  });

  factory CommonUserModel.fromJson(Map<String, dynamic> json) {
    return CommonUserModel(
      id:
          json['id'] as String? ??
          '', // Fallback just in case, though it's required
      email: json['email'] as String? ?? '',
      name: json['name'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'avatarUrl': avatarUrl};
  }
}

class CommonFriendModel {
  final String id;
  final String userId;
  final String? friendUserId;
  final String? invitedName;
  final String? invitedEmail;
  final CommonUserModel? user;
  final CommonUserModel? friendUser;

  CommonFriendModel({
    required this.id,
    required this.userId,
    this.friendUserId,
    this.invitedName,
    this.invitedEmail,
    this.user,
    this.friendUser,
  });

  factory CommonFriendModel.fromJson(Map<String, dynamic> json) {
    return CommonFriendModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      friendUserId: json['friendUserId'] as String?,
      invitedName: json['invitedName'] as String?,
      invitedEmail: json['invitedEmail'] as String?,
      user: json['user'] != null
          ? CommonUserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      friendUser: json['friendUser'] != null
          ? CommonUserModel.fromJson(json['friendUser'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'friendUserId': friendUserId,
      'invitedName': invitedName,
      'invitedEmail': invitedEmail,
      'user': user?.toJson(),
      'friendUser': friendUser?.toJson(),
    };
  }

  String get displayFriendName {
    if (friendUser?.name != null && friendUser!.name!.isNotEmpty) {
      return friendUser!.name!;
    }
    if (invitedName != null && invitedName!.isNotEmpty) {
      return invitedName!;
    }
    return 'Unknown Friend';
  }
}
