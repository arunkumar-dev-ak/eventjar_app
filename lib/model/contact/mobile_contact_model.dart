import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/model/meta/meta_model.dart';

class MobileContactResponse {
  final MobileContactData data;

  MobileContactResponse({required this.data});

  factory MobileContactResponse.fromJson(Map<String, dynamic> json) {
    try {
      return MobileContactResponse(
        data: MobileContactData.fromJson(json['data']),
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing MobileContactResponse: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {'data': data.toJson()};
}

class MobileContactData {
  final List<MobileContact> contacts;
  final Meta pagination;

  MobileContactData({required this.contacts, required this.pagination});

  factory MobileContactData.fromJson(Map<String, dynamic> json) {
    try {
      return MobileContactData(
        contacts: (json['contacts'] as List<dynamic>)
            .map((e) => MobileContact.fromJson(e as Map<String, dynamic>))
            .toList(),
        pagination: Meta.fromJson(json['pagination']),
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing MobileContactData: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'contacts': contacts.map((e) => e.toJson()).toList(),
    'pagination': pagination.toJson(),
  };
}

class MobileContact {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? user1Id;
  final String? user2Id;
  final Map<String, dynamic>? customAttributes;
  final PhoneParsed? phoneParsed;
  final String? company;
  final String? position;
  final String? industry;
  final ContactStage stage;
  final List<String> tags;
  final String? notes;
  final String? source;
  final String status;
  final DateTime? nextFollowUpDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic linkedUser;
  final dynamic event;

  MobileContact({
    required this.id,
    required this.name,
    required this.email,
    this.user1Id,
    this.user2Id,
    this.phone,
    this.phoneParsed,
    this.customAttributes,
    this.company,
    this.position,
    this.industry,
    required this.stage,
    required this.tags,
    this.notes,
    this.source,
    required this.status,
    required this.nextFollowUpDate,
    required this.createdAt,
    required this.updatedAt,
    this.linkedUser,
    this.event,
  });

  factory MobileContact.fromJson(Map<String, dynamic> json) {
    try {
      return MobileContact(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        user1Id: json['user1Id'],
        customAttributes: json['customAttributes'] != null
            ? Map<String, dynamic>.from(json['customAttributes'])
            : null,
        user2Id: json['user2Id'],
        phoneParsed: json['phoneParsed'] != null
            ? PhoneParsed.fromJson(json['phoneParsed'])
            : null,
        company: json['company'],
        position: json['position'],
        industry: json['industry'],
        stage: contactStageFromString(json['stage']),
        tags: List<String>.from(json['tags'] ?? []),
        notes: json['notes'],
        source: json['source'],
        status: json['status'],
        nextFollowUpDate: json['nextFollowUpDate'] != null
            ? DateTime.parse(json['nextFollowUpDate'])
            : null,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        linkedUser: json['linkedUser'],
        event: json['event'],
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing MobileContact: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'user1Id': user1Id,
    'user2Id': user2Id,
    'customAttributes': customAttributes,
    'phoneParsed': phoneParsed?.toJson(),
    'company': company,
    'position': position,
    'industry': industry,
    'stage': stage,
    'tags': tags,
    'notes': notes,
    'source': source,
    'status': status,
    'nextFollowUpDate': nextFollowUpDate?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'linkedUser': linkedUser,
    'event': event,
  };
}

class PhoneParsed {
  final String fullNumber;
  final String countryCode;
  final String phoneNumber;

  PhoneParsed({
    required this.fullNumber,
    required this.countryCode,
    required this.phoneNumber,
  });

  factory PhoneParsed.fromJson(Map<String, dynamic> json) {
    try {
      return PhoneParsed(
        fullNumber: json['fullNumber'],
        countryCode: json['countryCode'],
        phoneNumber: json['phoneNumber'],
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing PhoneParsed: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'fullNumber': fullNumber,
    'countryCode': countryCode,
    'phoneNumber': phoneNumber,
  };
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    try {
      return Pagination(
        total: json['total'],
        page: json['page'],
        limit: json['limit'],
        totalPages: json['totalPages'],
        hasNext: json['hasNext'],
        hasPrevious: json['hasPrevious'],
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing Pagination: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'page': page,
    'limit': limit,
    'totalPages': totalPages,
    'hasNext': hasNext,
    'hasPrevious': hasPrevious,
  };
}
