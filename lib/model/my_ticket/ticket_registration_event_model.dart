import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';

class TicketRegistrationEventModel {
  final String? id;
  final String? status;
  final EventInfo event;

  TicketRegistrationEventModel({this.id, this.status, required this.event});

  factory TicketRegistrationEventModel.fromJson(Map<String, dynamic> res) {
    try {
      final json = res['data'];

      if (json == null || json is! Map<String, dynamic>) {
        throw Exception("Invalid data format");
      }

      return TicketRegistrationEventModel(
        id: json['id'],
        status: json['status'],
        event: EventInfo.fromJson(json['event']),
      );
    } catch (e) {
      LoggerService.loggerInstance.e(
        'Error parsing TicketRegistrationEventModel: $e',
      );
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'status': status, 'event': event.toJson()};
  }
}
