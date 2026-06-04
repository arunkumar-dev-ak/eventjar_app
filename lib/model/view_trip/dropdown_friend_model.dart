import 'package:eventjar/model/meta/mobile_meta_model.dart';

class DropdownFriendResponseModel {
  final List<DropDownFriendListModel> data;
  final MobileMeta? meta;

  DropdownFriendResponseModel({required this.data, this.meta});

  factory DropdownFriendResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return DropdownFriendResponseModel(
        data:
            (json['data'] as List<dynamic>?)
                ?.map(
                  (e) => DropDownFriendListModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList() ??
            [],
        meta: json['meta'] != null ? MobileMeta.fromJson(json['meta']) : null,
      );
    } catch (e) {
      throw Exception('Error in DropdownFriendResponseModel.fromJson: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta?.toJson(),
    };
  }
}

class DropDownFriendListModel {
  final String id; // The friend relationship ID
  final String userId;
  final String? friendUserId;
  final String status;
  final String? invitedName;
  final String? invitedEmail;
  final String? invitedPhone;
  final FriendUser? user;
  final FriendUser? friendUser;

  DropDownFriendListModel({
    required this.id,
    required this.userId,
    this.friendUserId,
    required this.status,
    this.invitedName,
    this.invitedEmail,
    this.invitedPhone,
    this.user,
    this.friendUser,
  });

  factory DropDownFriendListModel.fromJson(Map<String, dynamic> json) {
    return DropDownFriendListModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      friendUserId: json['friendUserId'],
      status: json['status'] ?? 'pending',
      invitedName: json['invitedName'],
      invitedEmail: json['invitedEmail'],
      invitedPhone: json['invitedPhone'],
      user: json['user'] != null ? FriendUser.fromJson(json['user']) : null,
      friendUser: json['friendUser'] != null
          ? FriendUser.fromJson(json['friendUser'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'friendUserId': friendUserId,
      'status': status,
      'invitedName': invitedName,
      'invitedEmail': invitedEmail,
      'invitedPhone': invitedPhone,
      'user': user?.toJson(),
      'friendUser': friendUser?.toJson(),
    };
  }

  /// HELPER METHOD:
  /// Because friendships are two-way (Hub and Spoke), this helper figures out
  /// the actual display name of the friend by ignoring the current logged-in user.
  String getFriendDisplayName(String currentUserId) {
    // If the friend is unregistered (invited via email/phone)
    if (friendUserId == null) {
      return invitedName ?? invitedEmail ?? invitedPhone ?? 'Unknown User';
    }

    // If both are registered, figure out which side of the relation is the friend
    if (userId == currentUserId) {
      return friendUser?.name ??
          friendUser?.username ??
          friendUser?.email ??
          'Unknown User';
    } else {
      return user?.name ?? user?.username ?? user?.email ?? 'Unknown User';
    }
  }
}

class FriendUser {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String name;

  FriendUser({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.name,
  });

  factory FriendUser.fromJson(Map<String, dynamic> json) {
    return FriendUser(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'name': name,
    };
  }
}
