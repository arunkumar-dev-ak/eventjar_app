class TransactionResponse {
  final TransactionData data;
  final TransactionMeta meta;

  TransactionResponse({required this.data, required this.meta});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      data: TransactionData.fromJson(json['data'] as Map<String, dynamic>),
      meta: TransactionMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}

class TransactionData {
  final List<Transaction> transactions;
  final DailyTotal dailyTotal;

  TransactionData({required this.transactions, required this.dailyTotal});

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyTotal:
          DailyTotal.fromJson(json['dailyTotal'] as Map<String, dynamic>),
    );
  }
}

class DailyTotal {
  final double paid;
  final double received;

  DailyTotal({required this.paid, required this.received});

  factory DailyTotal.fromJson(Map<String, dynamic> json) {
    return DailyTotal(
      paid: double.tryParse(json['paid'].toString()) ?? 0,
      received: double.tryParse(json['received'].toString()) ?? 0,
    );
  }
}

class Transaction {
  final String id;
  final String? fromUserId;
  final String? toUserId;
  final String? fromFriendId;
  final String? toFriendId;
  final String recordedByUserId;
  final String tripId;
  final double amount;
  final String currency;
  final String method;
  final String status;
  final String? expenseId;
  final String? notes;
  final DateTime? settledAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TransactionUser? fromUser;
  final TransactionUser? toUser;
  final TransactionFriend? fromFriend;
  final TransactionFriend? toFriend;
  final TransactionTrip trip;
  final TransactionUser? recordedBy;

  Transaction({
    required this.id,
    this.fromUserId,
    this.toUserId,
    this.fromFriendId,
    this.toFriendId,
    required this.recordedByUserId,
    required this.tripId,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    this.expenseId,
    this.notes,
    this.settledAt,
    required this.createdAt,
    required this.updatedAt,
    this.fromUser,
    this.toUser,
    this.fromFriend,
    this.toFriend,
    required this.trip,
    this.recordedBy,
  });

  String get fromName {
    if (fromUser != null) return fromUser!.name;
    if (fromFriend != null) return fromFriend!.invitedName;
    return '';
  }

  String get toName {
    if (toUser != null) return toUser!.name;
    if (toFriend != null) return toFriend!.invitedName;
    return '';
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      fromUserId: json['fromUserId'],
      toUserId: json['toUserId'],
      fromFriendId: json['fromFriendId'],
      toFriendId: json['toFriendId'],
      recordedByUserId: json['recordedByUserId'] ?? '',
      tripId: json['tripId'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      currency: json['currency'] ?? '',
      method: json['method'] ?? '',
      status: json['status'] ?? '',
      expenseId: json['expenseId'],
      notes: json['notes'],
      settledAt: json['settledAt'] != null
          ? DateTime.parse(json['settledAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      fromUser: json['fromUser'] != null
          ? TransactionUser.fromJson(json['fromUser'])
          : null,
      toUser: json['toUser'] != null
          ? TransactionUser.fromJson(json['toUser'])
          : null,
      fromFriend: json['fromFriend'] != null
          ? TransactionFriend.fromJson(json['fromFriend'])
          : null,
      toFriend: json['toFriend'] != null
          ? TransactionFriend.fromJson(json['toFriend'])
          : null,
      trip: TransactionTrip.fromJson(json['trip'] as Map<String, dynamic>),
      recordedBy: json['recordedBy'] != null
          ? TransactionUser.fromJson(json['recordedBy'])
          : null,
    );
  }
}

class TransactionUser {
  final String id;
  final String name;
  final String? email;
  final String? avatarUrl;

  TransactionUser({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
  });

  factory TransactionUser.fromJson(Map<String, dynamic> json) {
    return TransactionUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      avatarUrl: json['avatarUrl'],
    );
  }
}

class TransactionFriend {
  final String id;
  final String invitedName;
  final String? invitedEmail;

  TransactionFriend({
    required this.id,
    required this.invitedName,
    this.invitedEmail,
  });

  factory TransactionFriend.fromJson(Map<String, dynamic> json) {
    return TransactionFriend(
      id: json['id'] ?? '',
      invitedName: json['invitedName'] ?? '',
      invitedEmail: json['invitedEmail'],
    );
  }
}

class TransactionTrip {
  final String id;
  final String name;

  TransactionTrip({required this.id, required this.name});

  factory TransactionTrip.fromJson(Map<String, dynamic> json) {
    return TransactionTrip(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class TransactionMeta {
  final TransactionPaging paging;

  TransactionMeta({required this.paging});

  factory TransactionMeta.fromJson(Map<String, dynamic> json) {
    return TransactionMeta(
      paging:
          TransactionPaging.fromJson(json['paging'] as Map<String, dynamic>),
    );
  }
}

class TransactionPaging {
  final TransactionCursors cursors;
  final bool hasNextPage;

  TransactionPaging({required this.cursors, required this.hasNextPage});

  factory TransactionPaging.fromJson(Map<String, dynamic> json) {
    return TransactionPaging(
      cursors: TransactionCursors.fromJson(
          json['cursors'] as Map<String, dynamic>),
      hasNextPage: json['hasNextPage'] as bool,
    );
  }
}

class TransactionCursors {
  final String? next;

  TransactionCursors({this.next});

  factory TransactionCursors.fromJson(Map<String, dynamic> json) {
    return TransactionCursors(next: json['next']);
  }
}
