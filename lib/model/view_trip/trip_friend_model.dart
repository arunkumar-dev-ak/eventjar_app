import 'package:eventjar/model/meta/mobile_meta_model.dart';

class TripFriendResponse {
  final List<TripFriendModel> data;
  final MobileMeta? meta;

  TripFriendResponse({required this.data, required this.meta});

  factory TripFriendResponse.fromJson(Map<String, dynamic> json) {
    try {
      return TripFriendResponse(
        data: (json['data'] as List<dynamic>)
            .map((e) => TripFriendModel.fromJson(e))
            .toList(),
        meta: json['meta'] != null ? MobileMeta.fromJson(json['meta']) : null,
      );
    } catch (e) {
      throw Exception('Error in TripFriendResponse.fromJson: $e');
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'data': data.map((e) => e.toJson()).toList(),
        if (meta != null) 'meta': meta!.toJson(),
      };
    } catch (e) {
      throw Exception('Error in TripFriendResponse.toJson: $e');
    }
  }
}

class TripFriendModel {
  final String tripId;

  final String memberId;
  final String? memberUserId;
  final String? memberFriendId;
  final String currency;

  final FriendUserModel? user;
  final FriendInfoModel? friend;

  final double myOwe;
  final double myReceive;

  final double balance;
  final String balanceType;
  final bool isAdmin;

  TripFriendModel({
    required this.tripId,
    required this.memberId,
    this.memberUserId,
    this.memberFriendId,
    this.user,
    this.friend,
    required this.myOwe,
    required this.myReceive,
    required this.balance,
    required this.balanceType,
    required this.isAdmin,
    required this.currency,
  });

  factory TripFriendModel.fromJson(Map<String, dynamic> json) {
    try {
      return TripFriendModel(
        tripId: json['tripId'] ?? '',
        memberId: json['memberId'] ?? '',
        memberUserId: json['memberUserId'],
        memberFriendId: json['memberFriendId'],
        user: json['user'] != null
            ? FriendUserModel.fromJson(json['user'])
            : null,
        friend: json['friend'] != null
            ? FriendInfoModel.fromJson(json['friend'])
            : null,
        myOwe: double.tryParse(json['myOwe'].toString()) ?? 0,
        myReceive: double.tryParse(json['myReceive'].toString()) ?? 0,
        balance: double.tryParse(json['balance'].toString()) ?? 0,
        balanceType: json['balanceType'] ?? '',
        isAdmin: json['isAdmin'] ?? false,
        currency: json['currency'] ?? "",
      );
    } catch (e) {
      throw Exception('Error in TripFriendModel.fromJson: $e');
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'tripId': tripId,
        'memberId': memberId,
        'memberUserId': memberUserId,
        'memberFriendId': memberFriendId,
        'user': user?.toJson(),
        'friend': friend?.toJson(),
        'myOwe': myOwe,
        'myReceive': myReceive,
        'balance': balance,
        'balanceType': balanceType,
        'isAdmin': isAdmin,
        'currency': currency,
      };
    } catch (e) {
      throw Exception('Error in TripFriendModel.toJson: $e');
    }
  }

  /// UI helper
  String get displayName {
    return user?.name ??
        friend?.friendUser?.name ??
        friend?.invitedName ??
        'Unknown';
  }

  String? get avatarUrl {
    return user?.avatarUrl ?? friend?.friendUser?.avatarUrl;
  }
}

class FriendUserModel {
  final String id;
  final String name;
  final String? avatarUrl;

  FriendUserModel({required this.id, required this.name, this.avatarUrl});

  factory FriendUserModel.fromJson(Map<String, dynamic> json) {
    try {
      return FriendUserModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        avatarUrl: json['avatarUrl'],
      );
    } catch (e) {
      throw Exception('Error in FriendUserModel.fromJson: $e');
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {'id': id, 'name': name, 'avatarUrl': avatarUrl};
    } catch (e) {
      throw Exception('Error in FriendUserModel.toJson: $e');
    }
  }
}

class FriendInfoModel {
  final String id;
  final String invitedName;
  final String invitedEmail;
  final FriendUserModel? friendUser;

  FriendInfoModel({
    required this.id,
    required this.invitedName,
    required this.invitedEmail,
    this.friendUser,
  });

  factory FriendInfoModel.fromJson(Map<String, dynamic> json) {
    try {
      return FriendInfoModel(
        id: json['id'] ?? '',
        invitedName: json['invitedName'] ?? '',
        invitedEmail: json['invitedEmail'] ?? '',
        friendUser: json['friendUser'] != null
            ? FriendUserModel.fromJson(json['friendUser'])
            : null,
      );
    } catch (e) {
      throw Exception('Error in FriendInfoModel.fromJson: $e');
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'id': id,
        'invitedName': invitedName,
        'invitedEmail': invitedEmail,
        'friendUser': friendUser?.toJson(),
      };
    } catch (e) {
      throw Exception('Error in FriendInfoModel.toJson: $e');
    }
  }
}
