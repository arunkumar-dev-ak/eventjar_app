import 'package:eventjar/model/meta/mobile_meta_model.dart';

class TripResponse {
  final List<TripModel> data;
  final MobileMeta? meta;

  TripResponse({required this.data, this.meta});

  factory TripResponse.fromJson(Map<String, dynamic> json) {
    try {
      return TripResponse(
        data: (json['data'] as List).map((e) => TripModel.fromJson(e)).toList(),
        meta: json['meta'] != null ? MobileMeta.fromJson(json['meta']) : null,
      );
    } catch (e) {
      throw Exception('Error in TripResponse: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    if (meta != null) 'meta': meta!.toJson(),
  };
}

class TripModel {
  final String id;
  final String createdById;

  final String name;
  final String? description;
  final String destination;

  final String status;
  final String? coverImageUrl;

  final double totalBudget;
  final String currency;

  final String joinToken;

  final DateTime createdAt;
  final DateTime updatedAt;

  final int membersCount;
  final int expensesCount;

  final double myShare;
  final double teamShare;

  final double myOwe;
  final double myReceive;

  final int myOweMembersCount;

  TripModel({
    required this.id,
    required this.createdById,
    required this.name,
    this.description,
    required this.destination,
    required this.status,
    this.coverImageUrl,
    required this.totalBudget,
    required this.currency,
    required this.joinToken,
    required this.createdAt,
    required this.updatedAt,
    required this.membersCount,
    required this.expensesCount,
    required this.myShare,
    required this.teamShare,
    required this.myOwe,
    required this.myReceive,
    required this.myOweMembersCount,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    try {
      return TripModel(
        id: json['id'] ?? '',
        createdById: json['createdById'] ?? '',
        name: json['name'] ?? '',
        description: json['description'],
        destination: json['destination'] ?? '',
        status: json['status'] ?? '',
        coverImageUrl: json['coverImageUrl'],
        totalBudget: double.tryParse(json['totalBudget'].toString()) ?? 0,
        currency: json['currency'] ?? '',
        joinToken: json['joinToken'] ?? '',
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        membersCount: json['_count']?['members'] ?? 0,
        expensesCount: json['_count']?['expenses'] ?? 0,
        myShare: double.tryParse(json['myShare'].toString()) ?? 0,
        teamShare: double.tryParse(json['teamShare'].toString()) ?? 0,
        myOwe: double.tryParse(json['myOwe'].toString()) ?? 0,
        myReceive: double.tryParse(json['myReceive'].toString()) ?? 0,
        myOweMembersCount: json['myOweMembersCount'] ?? 0,
      );
    } catch (e) {
      throw Exception('Error in TripModel: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdById': createdById,
    'name': name,
    'description': description,
    'destination': destination,
    'status': status,
    'coverImageUrl': coverImageUrl,
    'totalBudget': totalBudget,
    'currency': currency,
    'joinToken': joinToken,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '_count': {'members': membersCount, 'expenses': expensesCount},
    'myShare': myShare,
    'teamShare': teamShare,
    'myOwe': myOwe,
    'myReceive': myReceive,
    'myOweMembersCount': myOweMembersCount,
  };
}
