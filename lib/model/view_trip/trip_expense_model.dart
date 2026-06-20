import 'package:eventjar/model/meta/mobile_meta_model.dart';

class TripExpenseResponse {
  final List<TripExpenseModel> data;
  final MobileMeta? meta;

  TripExpenseResponse({required this.data, this.meta});

  factory TripExpenseResponse.fromJson(Map<String, dynamic> json) {
    try {
      return TripExpenseResponse(
        data: (json['data'] as List)
            .map((e) => TripExpenseModel.fromJson(e))
            .toList(),
        meta: json['meta'] != null ? MobileMeta.fromJson(json['meta']) : null,
      );
    } catch (e) {
      throw Exception('Error in TripExpenseResponse: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    if (meta != null) 'meta': meta!.toJson(),
  };
}

class TripExpenseModel {
  final String id;
  final String createdById;
  final String? paidById;

  final String title;
  final String? description;

  final double amount;
  final String currency;

  final DateTime createdAt;

  final TripExpenseCreatedBy? createdBy;
  final TripExpensePaidBy? paidBy;
  final TripExpensePaidByFriend? paidByFriend;

  final TripExpenseCount? count;
  final bool isDeleted;

  final List<TripExpenseParticipant> participants;

  TripExpenseModel({
    required this.id,
    required this.createdById,
    required this.paidById,
    required this.title,
    this.description,
    required this.amount,
    required this.currency,
    required this.createdAt,
    this.createdBy,
    this.paidBy,
    this.paidByFriend,
    this.count,
    required this.isDeleted,
    required this.participants,
  });

  TripExpenseModel copyWith({
    String? id,
    String? createdById,
    String? paidById,
    String? title,
    String? description,
    double? amount,
    String? currency,
    DateTime? createdAt,
    TripExpenseCreatedBy? createdBy,
    TripExpensePaidBy? paidBy,
    TripExpensePaidByFriend? paidByFriend,
    TripExpenseCount? count,
    bool? isDeleted,
    List<TripExpenseParticipant>? participants,
  }) {
    return TripExpenseModel(
      id: id ?? this.id,
      createdById: createdById ?? this.createdById,
      paidById: paidById ?? this.paidById,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      paidBy: paidBy ?? this.paidBy,
      paidByFriend: paidByFriend ?? this.paidByFriend,
      count: count ?? this.count,
      isDeleted: isDeleted ?? this.isDeleted,
      participants: participants ?? this.participants,
    );
  }

  factory TripExpenseModel.fromJson(Map<String, dynamic> json) {
    try {
      return TripExpenseModel(
        id: json['id'] ?? '',
        createdById: json['createdById'] ?? '',
        paidById: json['paidById'],
        title: json['title'] ?? '',
        isDeleted: json['isDeleted'] ?? false,
        description: json['description'],
        amount: double.tryParse(json['amount'].toString()) ?? 0,
        currency: json['currency'] ?? '',
        createdAt: DateTime.parse(json['createdAt']),
        createdBy: json['createdBy'] != null
            ? TripExpenseCreatedBy.fromJson(json['createdBy'])
            : null,
        paidBy: json['paidBy'] != null
            ? TripExpensePaidBy.fromJson(json['paidBy'])
            : null,
        paidByFriend: json['paidByFriend'] != null
            ? TripExpensePaidByFriend.fromJson(json['paidByFriend'])
            : null,
        count: json['_count'] != null
            ? TripExpenseCount.fromJson(json['_count'])
            : null,
        participants: (json['participants'] as List? ?? [])
            .map((e) => TripExpenseParticipant.fromJson(e))
            .toList(),
      );
    } catch (e) {
      throw Exception('Error in TripExpenseModel: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdById': createdById,
    'paidById': paidById,
    'title': title,
    'description': description,
    'amount': amount,
    'isDeleted': isDeleted,
    'currency': currency,
    'createdAt': createdAt.toIso8601String(),
    'createdBy': createdBy?.toJson(),
    'paidBy': paidBy?.toJson(),
    'paidByFriend': paidByFriend?.toJson(),
    '_count': count?.toJson(),
    'participants': participants.map((e) => e.toJson()).toList(),
  };
}

class TripExpenseParticipant {
  final String id;
  final String userId;

  final double shareAmount;
  final double? sharePercent;

  final bool isPaid;
  final DateTime? paidAt;

  TripExpenseParticipant({
    required this.id,
    required this.userId,
    required this.shareAmount,
    this.sharePercent,
    required this.isPaid,
    this.paidAt,
  });

  factory TripExpenseParticipant.fromJson(Map<String, dynamic> json) {
    try {
      return TripExpenseParticipant(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        shareAmount: double.tryParse(json['shareAmount'].toString()) ?? 0,
        sharePercent: json['sharePercent'] != null
            ? double.tryParse(json['sharePercent'].toString())
            : null,
        isPaid: json['isPaid'] ?? false,
        paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      );
    } catch (e) {
      throw Exception('Error in TripExpenseParticipant: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'shareAmount': shareAmount,
    'sharePercent': sharePercent,
    'isPaid': isPaid,
    'paidAt': paidAt?.toIso8601String(),
  };
}

class TripExpenseCreatedBy {
  final String? name;

  TripExpenseCreatedBy({this.name});

  factory TripExpenseCreatedBy.fromJson(Map<String, dynamic> json) {
    try {
      return TripExpenseCreatedBy(name: json['name']);
    } catch (e) {
      throw Exception('Error in TripExpenseCreatedBy: $e');
    }
  }

  Map<String, dynamic> toJson() => {'name': name};
}

class TripExpensePaidBy {
  final String? name;

  TripExpensePaidBy({this.name});

  factory TripExpensePaidBy.fromJson(Map<String, dynamic> json) {
    try {
      return TripExpensePaidBy(name: json['name']);
    } catch (e) {
      throw Exception('Error in TripExpensePaidBy: $e');
    }
  }

  Map<String, dynamic> toJson() => {'name': name};
}

class TripExpensePaidByFriend {
  final String? invitedName;

  TripExpensePaidByFriend({this.invitedName});

  factory TripExpensePaidByFriend.fromJson(Map<String, dynamic> json) {
    try {
      return TripExpensePaidByFriend(invitedName: json['invitedName']);
    } catch (e) {
      throw Exception('Error in TripExpensePaidByFriend: $e');
    }
  }

  Map<String, dynamic> toJson() => {'invitedName': invitedName};
}

class TripExpenseCount {
  final int participants;

  TripExpenseCount({required this.participants});

  factory TripExpenseCount.fromJson(Map<String, dynamic> json) {
    try {
      return TripExpenseCount(participants: json['participants'] ?? 0);
    } catch (e) {
      throw Exception('Error in TripExpenseCount: $e');
    }
  }

  Map<String, dynamic> toJson() => {'participants': participants};
}
