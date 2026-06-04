import 'package:eventjar/model/common/common_profile.dart';
import 'package:eventjar/model/meta/mobile_meta_model.dart';

class ExpenseParticipantResponseModel {
  final List<ExpenseParticipantModel> data;
  final MobileMeta? meta;

  ExpenseParticipantResponseModel({required this.data, this.meta});

  factory ExpenseParticipantResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return ExpenseParticipantResponseModel(
        data:
            (json['data'] as List<dynamic>?)
                ?.map(
                  (e) => ExpenseParticipantModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList() ??
            [],
        meta: json['meta'] != null ? MobileMeta.fromJson(json['meta']) : null,
      );
    } catch (e) {
      throw Exception('Error in ExpenseParticipantResponseModel.fromJson: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta?.toJson(),
    };
  }
}

class ExpenseParticipantModel {
  final String id;
  final String expenseId;
  final String? userId;
  final String? friendId;
  final double shareAmount;
  final double? sharePercent;
  final bool isPaid;
  final DateTime? paidAt;
  final CommonUserModel? user;
  final CommonFriendModel? friend;

  ExpenseParticipantModel({
    required this.id,
    required this.expenseId,
    this.userId,
    this.friendId,
    required this.shareAmount,
    this.sharePercent,
    required this.isPaid,
    this.paidAt,
    this.user,
    this.friend,
  });

  factory ExpenseParticipantModel.fromJson(Map<String, dynamic> json) {
    return ExpenseParticipantModel(
      id: json['id'] as String? ?? '',
      expenseId: json['expenseId'] as String? ?? '',
      userId: json['userId'] as String?,
      friendId: json['friendId'] as String?,

      shareAmount:
          double.tryParse(json['shareAmount']?.toString() ?? '0') ?? 0.0,
      sharePercent: json['sharePercent'] != null
          ? double.tryParse(json['sharePercent'].toString())
          : null,

      isPaid: json['isPaid'] as bool? ?? false,
      paidAt: json['paidAt'] != null ? DateTime.tryParse(json['paidAt']) : null,

      user: json['user'] != null
          ? CommonUserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      friend: json['friend'] != null
          ? CommonFriendModel.fromJson(json['friend'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expenseId': expenseId,
      'userId': userId,
      'friendId': friendId,
      'shareAmount': shareAmount.toString(),
      'sharePercent': sharePercent?.toString(),
      'isPaid': isPaid,
      'paidAt': paidAt?.toIso8601String(),
      'user': user?.toJson(),
      'friend': friend?.toJson(),
    };
  }

  /// Helper to get the display name for the UI cleanly using the strongly typed models
  String get displayName {
    if (user != null && user!.name != null && user!.name!.isNotEmpty) {
      return user!.name!;
    }

    if (friend != null) {
      return friend!.invitedName ?? "Unknown";
    }

    return 'Unknown';
  }
}
